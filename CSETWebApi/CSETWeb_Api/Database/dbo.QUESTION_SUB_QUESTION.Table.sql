USE [CSETWeb]
GO
/****** Object:  Table [dbo].[QUESTION_SUB_QUESTION]    Script Date: 6/28/2018 8:21:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUESTION_SUB_QUESTION](
	[Question_Id] [int] NOT NULL,
	[Sub_Question_Id] [int] NOT NULL,
	[Question_Group_Id] [int] NOT NULL,
	[List_Order] [int] NOT NULL,
 CONSTRAINT [PK_Question_Sub_Question_1] PRIMARY KEY CLUSTERED 
(
	[Question_Id] ASC,
	[Sub_Question_Id] ASC,
	[Question_Group_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION] ADD  CONSTRAINT [DF_Question_Sub_Question_List_Order]  DEFAULT ((0)) FOR [List_Order]
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION]  WITH NOCHECK ADD  CONSTRAINT [FK_QUESTION_SUB_QUESTION_NEW_QUESTION] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[NEW_QUESTION] ([Question_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION] CHECK CONSTRAINT [FK_QUESTION_SUB_QUESTION_NEW_QUESTION]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION', @level2type=N'COLUMN',@level2name=N'Question_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sub Question Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION', @level2type=N'COLUMN',@level2name=N'Sub_Question_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Group Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION', @level2type=N'COLUMN',@level2name=N'Question_Group_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The List Order is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION', @level2type=N'COLUMN',@level2name=N'List_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_SUB_QUESTION'
GO
