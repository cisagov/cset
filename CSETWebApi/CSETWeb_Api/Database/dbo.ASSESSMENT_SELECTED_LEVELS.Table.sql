USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ASSESSMENT_SELECTED_LEVELS]    Script Date: 11/14/2018 3:57:21 PM ******/
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
