USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SUB_CATEGORY_ANSWERS]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUB_CATEGORY_ANSWERS](
	[Assessement_Id] [int] NOT NULL,
	[Heading_Pair_Id] [int] NOT NULL,
	[Component_Id] [int] NOT NULL,
	[Is_Component] [bit] NOT NULL,
	[Is_Override] [bit] NOT NULL,
	[Answer_Text] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SUB_CATEGORY_ANSWERS] PRIMARY KEY CLUSTERED 
(
	[Assessement_Id] ASC,
	[Heading_Pair_Id] ASC,
	[Component_Id] ASC,
	[Is_Component] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD  CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Component_Id]  DEFAULT ((0)) FOR [Component_Id]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD  CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Is_Component]  DEFAULT ((0)) FOR [Is_Component]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD  CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Is_Override]  DEFAULT ((0)) FOR [Is_Override]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS]  WITH NOCHECK ADD  CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_Answer_Lookup] FOREIGN KEY([Answer_Text])
REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] CHECK CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_Answer_Lookup]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS]  WITH CHECK ADD  CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_ASSESSMENTS] FOREIGN KEY([Assessement_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] CHECK CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_ASSESSMENTS]
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS]  WITH CHECK ADD  CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS] FOREIGN KEY([Heading_Pair_Id])
REFERENCES [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ([Heading_Pair_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] CHECK CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUB_CATEGORY_ANSWERS', @level2type=N'COLUMN',@level2name=N'Component_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Is Component is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUB_CATEGORY_ANSWERS', @level2type=N'COLUMN',@level2name=N'Is_Component'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Answer Text is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUB_CATEGORY_ANSWERS', @level2type=N'COLUMN',@level2name=N'Answer_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUB_CATEGORY_ANSWERS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SUB_CATEGORY_ANSWERS'
GO
