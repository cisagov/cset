USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ASSESSMENT_SELECTED_LEVELS]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS](
	[Assessment_Id] [int] NOT NULL,
	[Level_Name] [varchar](50) NOT NULL,
	[Standard_Specific_Sal_Level] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ASSESSMENT_SELECTED_LEVELS] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Level_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (25, N'Availability_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (25, N'Confidence_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (25, N'Integrity_Level', N'Moderate')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (26, N'Availability_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (26, N'Confidence_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (26, N'Integrity_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (28, N'Availability_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (28, N'Confidence_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (28, N'Integrity_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (29, N'Availability_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (29, N'Confidence_Level', N'Moderate')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (29, N'Integrity_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (32, N'Availability_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (32, N'Confidence_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (32, N'Integrity_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (33, N'Availability_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (33, N'Confidence_Level', N'Moderate')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (33, N'Integrity_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (34, N'Availability_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (34, N'Confidence_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (34, N'Integrity_Level', N'Very High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (38, N'Availability_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (38, N'Confidence_Level', N'Moderate')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (38, N'Integrity_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (39, N'Availability_Level', N'Moderate')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (39, N'Confidence_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (39, N'Integrity_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (43, N'Availability_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (43, N'Confidence_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (43, N'Integrity_Level', N'High')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (44, N'Availability_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (44, N'Confidence_Level', N'Low')
INSERT [dbo].[ASSESSMENT_SELECTED_LEVELS] ([Assessment_Id], [Level_Name], [Standard_Specific_Sal_Level]) VALUES (44, N'Integrity_Level', N'Low')
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS]  WITH CHECK ADD  CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_LEVEL_NAMES] FOREIGN KEY([Level_Name])
REFERENCES [dbo].[LEVEL_NAMES] ([Level_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS] CHECK CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_LEVEL_NAMES]
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS]  WITH CHECK ADD  CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_STANDARD_SELECTION] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS] CHECK CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_STANDARD_SELECTION]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENT_SELECTED_LEVELS', @level2type=N'COLUMN',@level2name=N'Assessment_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Level Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENT_SELECTED_LEVELS', @level2type=N'COLUMN',@level2name=N'Level_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Standard Specific Sal Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENT_SELECTED_LEVELS', @level2type=N'COLUMN',@level2name=N'Standard_Specific_Sal_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENT_SELECTED_LEVELS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENT_SELECTED_LEVELS'
GO
