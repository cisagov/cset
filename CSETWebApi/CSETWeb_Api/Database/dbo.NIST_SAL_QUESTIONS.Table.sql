USE [CSETWeb]
GO
/****** Object:  Table [dbo].[NIST_SAL_QUESTIONS]    Script Date: 6/28/2018 8:21:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIST_SAL_QUESTIONS](
	[Question_Id] [int] NOT NULL,
	[Question_Number] [int] NOT NULL,
	[Question_Text] [varchar](7000) NULL,
 CONSTRAINT [PK_NIST_SAL_QUESTIONS_1] PRIMARY KEY CLUSTERED 
(
	[Question_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16338, 1, N'Does aggregation of information on this system reveal sensitive patterns and plans, or facilitate access to sensitive or critical systems?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16342, 2, N'Does/could access to this system result in some form of access to other more sensitive or critical systems (e.g., over a network)?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16346, 3, N'Are there extenuating circumstances such as: The system provides critical process flow or security capability, the public visibility of the system, the sheer number of other systems reliant on its operation, or the overall cost of the systems replacement?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16350, 4, N'Would unauthorized modification or destruction of information affecting external communications (e.g., web pages, electronic mail) adversely affect operations or seriously damage mission function and/or public confidence?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16354, 5, N'Would either physical or logical destruction of the system result in very large expenditures to restore the system and/or require a long period of time for recovery?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16358, 6, N'Does the mission served by the system, or the information that the system processes, affect the security of critical infrastructures and key resources?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16362, 7, N'Does the system store, communicate, or process any privacy act information?')
INSERT [dbo].[NIST_SAL_QUESTIONS] ([Question_Id], [Question_Number], [Question_Text]) VALUES (16366, 8, N'Does the systems store, communicate, or process any trade secrets information?')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_QUESTIONS', @level2type=N'COLUMN',@level2name=N'Question_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Number is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_QUESTIONS', @level2type=N'COLUMN',@level2name=N'Question_Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Text is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_QUESTIONS', @level2type=N'COLUMN',@level2name=N'Question_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_QUESTIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_QUESTIONS'
GO
