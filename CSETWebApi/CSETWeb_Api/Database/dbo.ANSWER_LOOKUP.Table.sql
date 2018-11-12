USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ANSWER_LOOKUP]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANSWER_LOOKUP](
	[Answer_Text] [varchar](50) NOT NULL,
	[Answer_Full_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Answer_Lookup] PRIMARY KEY CLUSTERED 
(
	[Answer_Text] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ANSWER_LOOKUP] ([Answer_Text], [Answer_Full_Name]) VALUES (N'A', N'Alternate')
INSERT [dbo].[ANSWER_LOOKUP] ([Answer_Text], [Answer_Full_Name]) VALUES (N'N', N'No')
INSERT [dbo].[ANSWER_LOOKUP] ([Answer_Text], [Answer_Full_Name]) VALUES (N'NA', N'Not Applicable')
INSERT [dbo].[ANSWER_LOOKUP] ([Answer_Text], [Answer_Full_Name]) VALUES (N'U', N'Unanswered')
INSERT [dbo].[ANSWER_LOOKUP] ([Answer_Text], [Answer_Full_Name]) VALUES (N'Y', N'Yes')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Answer Text is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER_LOOKUP', @level2type=N'COLUMN',@level2name=N'Answer_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Answer Full Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER_LOOKUP', @level2type=N'COLUMN',@level2name=N'Answer_Full_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER_LOOKUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER_LOOKUP'
GO
