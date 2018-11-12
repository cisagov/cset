USE [CSETWeb]
GO
/****** Object:  Table [dbo].[QUESTION_GROUP_TYPE]    Script Date: 6/28/2018 8:21:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUESTION_GROUP_TYPE](
	[Question_Group_Id] [int] IDENTITY(1,1) NOT NULL,
	[Group_Name] [varchar](10) NOT NULL,
	[Scoring_Group] [varchar](10) NOT NULL,
	[Scoring_Type] [varchar](10) NOT NULL,
	[Group_Header] [varchar](2000) NULL,
 CONSTRAINT [PK_Question_Group_Type] PRIMARY KEY CLUSTERED 
(
	[Question_Group_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[QUESTION_GROUP_TYPE] ON 

INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (6, N'Pro', N'Pro-1', N'H', N'Does the organization develop, disseminate, periodically review, and update formal documented procedures that address the roles, responsibilities, coordination among organizational entities, and management accountability? Check all that apply.')
INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (7, N'Pln', N'Pln-1', N'H', N'Have the following plans been developed and implemented that address roles, responsibilities, processes and procedures? Check all that apply.')
INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (8, N'4', N'4-1', N'XOR', N'Are there mechanisms implemented to detect unauthorized command execution by an escorted individual?')
INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (9, N'5', N'5-1', N'XOR', N'Are electronic physical access logs produced?')
INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (10, N'6', N'6-1', N'XOR', N'Do all cyber assets within an electronic security perimeter also reside in a physical security perimeter?')
INSERT [dbo].[QUESTION_GROUP_TYPE] ([Question_Group_Id], [Group_Name], [Scoring_Group], [Scoring_Type], [Group_Header]) VALUES (11, N'Pol', N'Pol-1', N'H', N'Does the organization develop, disseminate, periodically review, and update formal documented policies that address the roles, responsibilities, coordination among organizational entities, and management accountability? Check all that apply.')
SET IDENTITY_INSERT [dbo].[QUESTION_GROUP_TYPE] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Group Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE', @level2type=N'COLUMN',@level2name=N'Question_Group_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Group Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE', @level2type=N'COLUMN',@level2name=N'Group_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Scoring Group is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE', @level2type=N'COLUMN',@level2name=N'Scoring_Group'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Scoring Type is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE', @level2type=N'COLUMN',@level2name=N'Scoring_Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Group Header is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE', @level2type=N'COLUMN',@level2name=N'Group_Header'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_TYPE'
GO
