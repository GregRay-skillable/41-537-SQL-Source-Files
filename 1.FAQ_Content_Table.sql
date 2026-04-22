IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FAQ_Content]'))
BEGIN
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;

    CREATE TABLE [dbo].[FAQ_Content](
        [faq_id] [int] IDENTITY(1,1) NOT NULL,
        [category]  NOT NULL,
        [question]  NOT NULL,
        [answer] [nvarchar](max) NOT NULL,
        [keywords]  NULL,
        [is_active] [bit] NOT NULL,
        [created_at]  NOT NULL,
        [updated_at]  NOT NULL,
        CONSTRAINT [PK_FAQ_Content] PRIMARY KEY CLUSTERED
        (
            [faq_id] ASC
        )
    );

    ALTER TABLE [dbo].[FAQ_Content] ADD DEFAULT ((1)) FOR [is_active];
    ALTER TABLE [dbo].[FAQ_Content] ADD DEFAULT (sysutcdatetime()) FOR [created_at];
    ALTER TABLE [dbo].[FAQ_Content] ADD DEFAULT (sysutcdatetime()) FOR [updated_at];
END;
