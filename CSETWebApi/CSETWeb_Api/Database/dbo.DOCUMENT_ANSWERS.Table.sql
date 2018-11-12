USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DOCUMENT_ANSWERS]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DOCUMENT_ANSWERS](
	[Document_Id] [int] NOT NULL,
	[Answer_Id] [int] NOT NULL,
 CONSTRAINT [PK_DOCUMENT_ANSWERS] PRIMARY KEY CLUSTERED 
(
	[Document_Id] ASC,
	[Answer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENT_ANSWERS_ANSWER] FOREIGN KEY([Answer_Id])
REFERENCES [dbo].[ANSWER] ([Answer_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS] CHECK CONSTRAINT [FK_DOCUMENT_ANSWERS_ANSWER]
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS]  WITH NOCHECK ADD  CONSTRAINT [FK_Document_Answers_DOCUMENT_FILE] FOREIGN KEY([Document_Id])
REFERENCES [dbo].[DOCUMENT_FILE] ([Document_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS] CHECK CONSTRAINT [FK_Document_Answers_DOCUMENT_FILE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Document Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_ANSWERS', @level2type=N'COLUMN',@level2name=N'Document_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_ANSWERS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_ANSWERS'
GO
