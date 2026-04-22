IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FAQ_Content]'))
BEGIN
	SET ANSI_NULLS ON
	GO
	SET QUOTED_IDENTIFIER ON
	GO
	CREATE TABLE [dbo].[FAQ_Content](
		[faq_id] [int] IDENTITY(1,1) NOT NULL,
		[category] [nvarchar](100) NOT NULL,
		[question] [nvarchar](1000) NOT NULL,
		[answer] [nvarchar](max) NOT NULL,
		[keywords] [nvarchar](500) NULL,
		[is_active] [bit] NOT NULL,
		[created_at] [datetime2](6) NOT NULL,
		[updated_at] [datetime2](6) NOT NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO
	ALTER TABLE [dbo].[FAQ_Content] ADD PRIMARY KEY CLUSTERED 
	(
		[faq_id] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	GO
	ALTER TABLE [dbo].[FAQ_Content] ADD  DEFAULT ((1)) FOR [is_active]
	GO
	ALTER TABLE [dbo].[FAQ_Content] ADD  DEFAULT (sysutcdatetime()) FOR [created_at]
	GO
	ALTER TABLE [dbo].[FAQ_Content] ADD  DEFAULT (sysutcdatetime()) FOR [updated_at]
	GO
END
GO
