SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[SearchFAQ]
(
    @user_question NVARCHAR(1000)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @response NVARCHAR(MAX);
    DECLARE @embed_json NVARCHAR(MAX);
    DECLARE @vector_literal NVARCHAR(MAX);
    DECLARE @payload NVARCHAR(MAX);

    -- Build a simple JSON payload (escape double-quotes in the question)
    SET @payload = N'{"input":"' + REPLACE(@user_question, '"', '\"') + N'"}';

    -- REST endpoint configuration: set these variables before deploying
        DECLARE @url NVARCHAR(4000) = N'https://aoaidemogpt4-rhr.openai.azure.com/openai/deployments/text-embedding-3-small/embeddings?api-version=2024-12-01-preview';
        -- Prefer a database-scoped credential containing the key as the secret
        -- CREATE DATABASE SCOPED CREDENTIAL azureopenai_cred WITH IDENTITY = 'apikey', SECRET = '<your_key_here>';
        -- DECLARE @credential_name NVARCHAR(256) = N'azureopenai_cred';
        DECLARE @headers NVARCHAR(MAX) = N'{"api-key": "40b20c3e8bb04f318627ccc64e2e8f1"}';

        -- Call the external REST endpoint using the credential for authentication
        EXEC sp_invoke_external_rest_endpoint
            @method = 'POST',
            @url = @url,
            @headers = @headers,
            -- @credential = @credential_name,
            @payload = @payload,
            @response = @response OUTPUT;

    SET @embed_json = JSON_QUERY(@response, '$.result.data[0].embedding');

    IF @embed_json IS NULL
    BEGIN
        DECLARE @err_msg NVARCHAR(MAX) = N'Failed to obtain embedding from external endpoint. Response: ' + ISNULL(@response, N'NULL');
        THROW 51000, @err_msg, 1;
        RETURN;
    END

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
