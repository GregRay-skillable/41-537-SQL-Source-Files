SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE [dbo].[SearchFAQ]
(
    @user_question NVARCHAR(1000)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @response NVARCHAR(MAX);
    DECLARE @embed_json NVARCHAR(MAX);
    DECLARE @payload NVARCHAR(MAX);
    DECLARE @status_code INT;

    SET @payload = N'{"input":"' + REPLACE(@user_question, '"', '\"') + N'"}';

    DECLARE @url NVARCHAR(4000) = N'__AOAI_ENDPOINT__/openai/deployments/__AOAI_EMBEDDING_DEPLOYMENT__/embeddings?api-version=2024-12-01-preview';
    DECLARE @headers NVARCHAR(MAX) = N'{"api-key":"__AOAI_API_KEY__"}';

    EXEC sp_invoke_external_rest_endpoint
        @method = 'POST',
        @url = @url,
        @headers = @headers,
        @payload = @payload,
        @response = @response OUTPUT;

    SET @status_code = TRY_CAST(JSON_VALUE(@response, '$.response.status.http.code') AS INT);

    IF @status_code <> 200
    BEGIN
        DECLARE @err_msg NVARCHAR(MAX) =
            N'Failed to obtain embedding from external endpoint. HTTP '
            + ISNULL(CAST(@status_code AS NVARCHAR(10)), N'NULL')
            + N'. Response: '
            + ISNULL(@response, N'NULL');

        THROW 51000, @err_msg, 1;
    END;

    SET @embed_json = JSON_QUERY(@response, '$.result.data[0].embedding');

    IF @embed_json IS NULL
    BEGIN
        DECLARE @err_msg2 NVARCHAR(MAX) =
            N'Failed to obtain embedding from external endpoint. Response: '
            + ISNULL(@response, N'NULL');

        THROW 51001, @err_msg2, 1;
    END;

    SELECT TOP 3
        c.faq_id,
        c.category,
        c.question,
        c.answer
    FROM dbo.FAQ_Embeddings e
    JOIN dbo.FAQ_Content c
        ON e.faq_id = c.faq_id
    ORDER BY VECTOR_DISTANCE(
        'cosine',
        e.question_embedding,
        CAST(@embed_json AS VECTOR(1536))
    );
END;
GO
