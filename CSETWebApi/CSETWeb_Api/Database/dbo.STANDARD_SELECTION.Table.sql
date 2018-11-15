USE [CSETWeb]
GO
/****** Object:  Table [dbo].[STANDARD_SELECTION]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STANDARD_SELECTION](
	[Assessment_Id] [int] NOT NULL,
	[Application_Mode] [varchar](50) NOT NULL,
	[Selected_Sal_Level] [varchar](10) NOT NULL,
	[Last_Sal_Determination_Type] [varchar](50) NULL,
	[Sort_Set_Name] [varchar](50) NULL,
	[Is_Advanced] [bit] NOT NULL,
 CONSTRAINT [PK_STANDARD_SELECTION] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
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
ALTER TABLE [dbo].[STANDARD_SELECTION]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_SELECTION_UNIVERSAL_SAL_LEVEL] FOREIGN KEY([Selected_Sal_Level])
REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Full_Name_Sal])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] CHECK CONSTRAINT [FK_STANDARD_SELECTION_UNIVERSAL_SAL_LEVEL]
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
