USE [CSETWeb]
GO
/****** Object:  Table [dbo].[LEVEL_NAMES]    Script Date: 6/28/2018 8:21:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LEVEL_NAMES](
	[Level_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Level_Names] PRIMARY KEY CLUSTERED 
(
	[Level_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Availability_Level')
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Confidence_Level')
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Dod_Conf_Level')
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Dod_Mac_Level')
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Integrity_Level')
INSERT [dbo].[LEVEL_NAMES] ([Level_Name]) VALUES (N'Selected_Sal_Level')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Level Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LEVEL_NAMES', @level2type=N'COLUMN',@level2name=N'Level_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LEVEL_NAMES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LEVEL_NAMES'
GO
