USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DOCUMENT_FILE]    Script Date: 11/14/2018 3:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DOCUMENT_FILE](
	[Assessment_Id] [int] NOT NULL,
	[Document_Id] [int] IDENTITY(1,1) NOT NULL,
	[Path] [varchar](3990) NULL,
	[Title] [varchar](3990) NULL,
	[FileMd5] [varchar](32) NULL,
	[ContentType] [varchar](200) NULL,
	[CreatedTimestamp] [datetime] NULL,
	[UpdatedTimestamp] [datetime] NULL,
	[Name] [varchar](500) NULL,
	[Data] [varbinary](max) NULL,
 CONSTRAINT [PK__document_file__00000000000001C8] PRIMARY KEY CLUSTERED 
(
	[Document_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DOCUMENT_FILE]  WITH CHECK ADD  CONSTRAINT [FK_DOCUMENT_FILE_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] CHECK CONSTRAINT [FK_DOCUMENT_FILE_ASSESSMENTS]
GO
ALTER TABLE [dbo].[DOCUMENT_FILE]  WITH NOCHECK ADD  CONSTRAINT [FK_DOCUMENT_FILE_DEMOGRAPHICS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[DEMOGRAPHICS] ([Assessment_Id])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] NOCHECK CONSTRAINT [FK_DOCUMENT_FILE_DEMOGRAPHICS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Document Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_FILE', @level2type=N'COLUMN',@level2name=N'Document_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Path is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_FILE', @level2type=N'COLUMN',@level2name=N'Path'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Title is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_FILE', @level2type=N'COLUMN',@level2name=N'Title'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_FILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DOCUMENT_FILE'
GO
