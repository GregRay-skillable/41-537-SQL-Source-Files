SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'dbo.FAQ_Embeddings'))
BEGIN
    CREATE TABLE dbo.FAQ_Embeddings
    (
        faq_id INT NOT NULL,
        question_embedding VECTOR(1536) NOT NULL,
        CONSTRAINT PK_FAQ_Embeddings PRIMARY KEY CLUSTERED (faq_id ASC),
        CONSTRAINT FK_FAQ_Embeddings_Content FOREIGN KEY (faq_id)
            REFERENCES dbo.FAQ_Content (faq_id)
    );
END;
