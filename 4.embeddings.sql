-- =============================================
-- Script  : 04.embeddings.sql
-- Purpose : Generate embeddings for every question in dbo.FAQ_Content
--           by calling the Azure OpenAI Embeddings REST API via
--           sp_invoke_external_rest_endpoint, then upsert each
--           result into dbo.FAQ_Embeddings.
-- =============================================

DECLARE @openai_url NVARCHAR(500) = N'__AOAI_ENDPOINT__/openai/deployments/__AOAI_EMBEDDING_DEPLOYMENT__/embeddings?api-version=2024-12-01-preview';
DECLARE @headers NVARCHAR(MAX) = N'{"api-key":"__AOAI_API_KEY__"}';

DECLARE @faq_id INT;
DECLARE @question NVARCHAR(1000);
DECLARE @payload NVARCHAR(MAX);
DECLARE @response NVARCHAR(MAX);
DECLARE @embed_json NVARCHAR(MAX);
DECLARE @status_code INT;
DECLARE @sql NVARCHAR(MAX);
DECLARE @processed INT = 0;

DECLARE faq_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT faq_id, question
    FROM dbo.FAQ_Content
    ORDER BY faq_id;

OPEN faq_cursor;
FETCH NEXT FROM faq_cursor INTO @faq_id, @question;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @payload = N'{"input":"' + REPLACE(@question, '"', '\"') + N'"}';

    EXEC sp_invoke_external_rest_endpoint
        @method   = 'POST',
        @url      = @openai_url,
        @headers  = @headers,
        @payload  = @payload,
        @response = @response OUTPUT;

    SET @status_code = TRY_CAST(JSON_VALUE(@response, '$.response.status.http.code') AS INT);

    IF @status_code <> 200
    BEGIN
        DECLARE @err NVARCHAR(MAX) =
            N'Azure OpenAI call failed for faq_id '
            + CAST(@faq_id AS NVARCHAR(10))
            + N'. HTTP '
            + ISNULL(CAST(@status_code AS NVARCHAR(10)), N'NULL')
            + N': '
            + ISNULL(@response, N'NULL');

        THROW 51000, @err, 1;
    END;

    SET @embed_json = JSON_QUERY(@response, '$.result.data[0].embedding');

    IF @embed_json IS NULL
    BEGIN
        DECLARE @err2 NVARCHAR(MAX) =
            N'No embedding returned for faq_id '
            + CAST(@faq_id AS NVARCHAR(10))
            + N'. Response: '
            + ISNULL(@response, N'NULL');

        THROW 51001, @err2, 1;
    END;

    IF EXISTS (SELECT 1 FROM dbo.FAQ_Embeddings WHERE faq_id = @faq_id)
    BEGIN
        SET @sql =
            N'UPDATE dbo.FAQ_Embeddings
              SET question_embedding = CAST('''
            + REPLACE(@embed_json, N'''', N'''''')
            + N''' AS VECTOR(1536))
              WHERE faq_id = '
            + CAST(@faq_id AS NVARCHAR(10));
    END
    ELSE
    BEGIN
        SET @sql =
            N'INSERT INTO dbo.FAQ_Embeddings (faq_id, question_embedding)
              VALUES ('
            + CAST(@faq_id AS NVARCHAR(10))
            + N', CAST('''
            + REPLACE(@embed_json, N'''', N'''''')
            + N''' AS VECTOR(1536)))';
    END;

    EXEC sp_executesql @sql;

    SET @processed += 1;
    RAISERROR('Processed faq_id %d (%d rows done)', 0, 1, @faq_id, @processed) WITH NOWAIT;

    FETCH NEXT FROM faq_cursor INTO @faq_id, @question;
END;

CLOSE faq_cursor;
DEALLOCATE faq_cursor;

SELECT COUNT(*) AS FAQ_Embeddings_Count
FROM dbo.FAQ_Embeddings;
GO
