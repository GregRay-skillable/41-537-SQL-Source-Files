IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'dbo.FAQ_Content'))
BEGIN
    CREATE TABLE dbo.FAQ_Content
    (
        faq_id INT IDENTITY(1,1) NOT NULL,
        category NVARCHAR(100) NOT NULL,
        question NVARCHAR(1000) NOT NULL,
        answer NVARCHAR(MAX) NOT NULL,
        keywords NVARCHAR(500) NULL,
        is_active BIT NOT NULL CONSTRAINT DF_FAQ_Content_is_active DEFAULT (1),
        created_at DATETIME2(6) NOT NULL CONSTRAINT DF_FAQ_Content_created_at DEFAULT (sysutcdatetime()),
        updated_at DATETIME2(6) NOT NULL CONSTRAINT DF_FAQ_Content_updated_at DEFAULT (sysutcdatetime()),
        CONSTRAINT PK_FAQ_Content PRIMARY KEY CLUSTERED (faq_id ASC)
    );
END;
