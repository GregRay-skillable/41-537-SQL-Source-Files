SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FAQ_Embeddings]'))
BEGIN
	CREATE TABLE [dbo].[FAQ_Embeddings](
		[faq_id] [int] NOT NULL,
		[question_embedding] [vector](1536, float32) NOT NULL
	) ON [PRIMARY]
	GO
	ALTER TABLE [dbo].[FAQ_Embeddings] ADD PRIMARY KEY CLUSTERED 
	(
		[faq_id] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	GO
	ALTER TABLE [dbo].[FAQ_Embeddings]  WITH CHECK ADD  CONSTRAINT [FK_FAQ_Embeddings_Content] FOREIGN KEY([faq_id])
	REFERENCES [dbo].[FAQ_Content] ([faq_id])
	GO
	ALTER TABLE [dbo].[FAQ_Embeddings] CHECK CONSTRAINT [FK_FAQ_Embeddings_Content]
	GO
	SET ANSI_PADDING ON
	GO
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FAQ_Embedding' AND object_id = OBJECT_ID(N'[dbo].[FAQ_Embeddings]'))
BEGIN
	CREATE VECTOR INDEX [IX_FAQ_Embedding] ON [dbo].[FAQ_Embeddings]
	(
		[question_embedding]
	)WITH (METRIC = 'COSINE', TYPE = 'DiskANN') ON [PRIMARY]
	GO
END
GO
