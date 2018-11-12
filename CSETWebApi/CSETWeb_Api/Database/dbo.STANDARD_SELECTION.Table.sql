USE [CSETWeb]
GO
/****** Object:  Table [dbo].[STANDARD_SELECTION]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STANDARD_SELECTION](
	[Assessment_Id] [int] NOT NULL,
	[AssessmentName] [varchar](255) NOT NULL,
	[Application_Mode] [varchar](50) NOT NULL,
	[Selected_Sal_Level] [varchar](50) NOT NULL,
	[Last_Sal_Determination_Type] [varchar](50) NULL,
	[Sort_Set_Name] [varchar](50) NULL,
	[Is_Advanced] [bit] NOT NULL,
 CONSTRAINT [PK_STANDARD_SELECTION] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (2, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (15, N'', N'Questions Based', N'Low', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (16, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (17, N'', N'Questions Based', N'High', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (19, N'', N'Questions Based', N'High', N'NIST', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (21, N'', N'Questions Based', N'High', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (22, N'', N'Questions Based', N'Moderate', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (24, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (25, N'', N'Requirements Based', N'Moderate', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (26, N'', N'Questions Based', N'Low', N'NIST', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (27, N'', N'Questions Based', N'Low', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (28, N'', N'Questions Based', N'Very High', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (29, N'', N'Questions Based', N'Moderate', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (32, N'', N'Questions Based', N'Low', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (33, N'', N'Questions Based', N'Low', N'NIST', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (34, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (35, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (38, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (39, N'', N'Questions Based', N'Moderate', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (43, N'', N'Questions Based', N'High', N'GENERAL', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (44, N'', N'Questions Based', N'Very High', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (47, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (50, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (51, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (52, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (53, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (54, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (96, N'', N'Questions Based', N'Low', N'Simple', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (102, N'', N'Questions Based', N'Low', N'NIST', NULL, 0)
INSERT [dbo].[STANDARD_SELECTION] ([Assessment_Id], [AssessmentName], [Application_Mode], [Selected_Sal_Level], [Last_Sal_Determination_Type], [Sort_Set_Name], [Is_Advanced]) VALUES (103, N'', N'Requirements Based', N'Low', N'Simple', NULL, 0)
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD  CONSTRAINT [DF_STANDARD_SELECTION_Application_Mode]  DEFAULT ('Questions Based') FOR [Application_Mode]
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD  CONSTRAINT [DF_STANDARD_SELECTION_Selected_Sal_Level]  DEFAULT ('Low') FOR [Selected_Sal_Level]
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD  CONSTRAINT [DF_STANDARD_SELECTION_Is_Instructions]  DEFAULT ((0)) FOR [Is_Advanced]
GO
ALTER TABLE [dbo].[STANDARD_SELECTION]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_SELECTION_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] CHECK CONSTRAINT [FK_STANDARD_SELECTION_ASSESSMENTS]
GO
ALTER TABLE [dbo].[STANDARD_SELECTION]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_SELECTION_SAL_DETERMINATION_TYPES] FOREIGN KEY([Last_Sal_Determination_Type])
REFERENCES [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] CHECK CONSTRAINT [FK_STANDARD_SELECTION_SAL_DETERMINATION_TYPES]
GO
ALTER TABLE [dbo].[STANDARD_SELECTION]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_SELECTION_SAL_LEVELS] FOREIGN KEY([Selected_Sal_Level])
REFERENCES [dbo].[SAL_LEVELS] ([Selected_Sal_Level])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] CHECK CONSTRAINT [FK_STANDARD_SELECTION_SAL_LEVELS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SELECTION', @level2type=N'COLUMN',@level2name=N'Assessment_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Application Mode is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SELECTION', @level2type=N'COLUMN',@level2name=N'Application_Mode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Selected Sal Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SELECTION', @level2type=N'COLUMN',@level2name=N'Selected_Sal_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SELECTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SELECTION'
GO
