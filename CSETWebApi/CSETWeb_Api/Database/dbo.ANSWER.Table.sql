USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ANSWER]    Script Date: 11/14/2018 3:57:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANSWER](
	[Assessment_Id] [int] NOT NULL,
	[Answer_Id] [int] IDENTITY(1,1) NOT NULL,
	[Is_Requirement] [bit] NOT NULL,
	[Question_Or_Requirement_Id] [int] NOT NULL,
	[Component_Id] [int] NOT NULL,
	[Mark_For_Review] [bit] NULL,
	[Comment] [ntext] NULL,
	[Alternate_Justification] [ntext] NULL,
	[Question_Number] [int] NULL,
	[Answer_Text] [varchar](50) NOT NULL,
	[Component_Guid] [char](36) NULL,
	[Is_Component] [bit] NOT NULL,
	[Custom_Question_Guid] [varchar](50) NULL,
	[Is_Framework] [bit] NOT NULL,
	[Old_Answer_Id] [int] NULL,
 CONSTRAINT [PK_ANSWER_1] PRIMARY KEY CLUSTERED 
(
	[Answer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Requirement]  DEFAULT ((0)) FOR [Is_Requirement]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Component_Id]  DEFAULT ((0)) FOR [Component_Id]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Answer_Text]  DEFAULT ('U') FOR [Answer_Text]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Component]  DEFAULT ((0)) FOR [Is_Component]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Framework]  DEFAULT ((0)) FOR [Is_Framework]
GO
ALTER TABLE [dbo].[ANSWER]  WITH NOCHECK ADD  CONSTRAINT [FK_ANSWER_Answer_Lookup] FOREIGN KEY([Answer_Text])
REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] CHECK CONSTRAINT [FK_ANSWER_Answer_Lookup]
GO
ALTER TABLE [dbo].[ANSWER]  WITH NOCHECK ADD  CONSTRAINT [FK_ANSWER_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] CHECK CONSTRAINT [FK_ANSWER_ASSESSMENTS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Is Requirement is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Is_Requirement'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Or Requirement Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Question_Or_Requirement_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Component_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Mark For Review is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Mark_For_Review'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Comment is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Alternate Justification is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Alternate_Justification'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Number is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Question_Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Answer Text is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Answer_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Guid is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Component_Guid'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER'
GO
