USE [CSETWeb]
GO
/****** Object:  Table [dbo].[STANDARD_SPECIFIC_LEVEL]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STANDARD_SPECIFIC_LEVEL](
	[Standard_Level] [varchar](50) NOT NULL,
	[Level_Order] [int] NOT NULL,
	[Full_Name] [varchar](50) NOT NULL,
	[Standard] [varchar](50) NOT NULL,
	[Display_Name] [varchar](50) NOT NULL,
	[Display_Order] [int] NULL,
	[Is_Default_Value] [bit] NOT NULL,
	[Is_Mapping_Link] [bit] NOT NULL,
 CONSTRAINT [PK_STANDARD_SPECIFIC_LEVEL] PRIMARY KEY CLUSTERED 
(
	[Standard_Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'C', 3, N'Classified', N'DOD_Conf', N'Classified', 1, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'H', 3, N'High', N'UNIV', N'High', NULL, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'L', 1, N'Low', N'UNIV', N'Low', NULL, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'M', 2, N'Moderate', N'UNIV', N'Moderate', NULL, 1, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MAC I', 3, N'Mission Assurance Category I', N'DOD_Mis', N'MAC I', 3, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MAC II', 2, N'Mission Assurance Category II', N'DOD_Mis', N'MAC II', 2, 1, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MAC III', 1, N'Mission Assurance Category III', N'DOD_Mis', N'MAC III', 1, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MIL1', 2, N'MIL 1', N'C2M2_V11', N'MIL 1', 3, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MIL2', 1, N'MIL 2', N'C2M2_V11', N'MIL 2', 2, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'MIL3', 0, N'MIL 3', N'C2M2_V11', N'MIL 3', 1, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'none', 0, N'None', N'UNIV', N'None', NULL, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'P', 1, N'Public', N'DOD_Conf', N'Public', 3, 0, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'S', 2, N'Sensitive', N'DOD_Conf', N'Sensitive', 2, 1, 0)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'Tier I', 0, N'Tier I', N'Cfats', N'Tier I', 1, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'Tier II', 1, N'Tier II', N'Cfats', N'Tier II', 2, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'Tier III', 2, N'Tier III', N'Cfats', N'Tier III', 3, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'Tier IV', 3, N'Tier IV', N'Cfats', N'Tier IV', 4, 0, 1)
INSERT [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level], [Level_Order], [Full_Name], [Standard], [Display_Name], [Display_Order], [Is_Default_Value], [Is_Mapping_Link]) VALUES (N'VH', 4, N'Very High', N'UNIV', N'Very High', NULL, 0, 0)
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD  CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Level_Order]  DEFAULT ((0)) FOR [Level_Order]
GO
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD  CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Standard]  DEFAULT ('No Standard') FOR [Standard]
GO
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD  CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Display_Name]  DEFAULT ('No Display Name') FOR [Display_Name]
GO
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD  CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Is_Default_Value]  DEFAULT ((0)) FOR [Is_Default_Value]
GO
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD  CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Is_Mapping_Link]  DEFAULT ((0)) FOR [Is_Mapping_Link]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Standard Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL', @level2type=N'COLUMN',@level2name=N'Standard_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Level Order is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL', @level2type=N'COLUMN',@level2name=N'Level_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Full Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL', @level2type=N'COLUMN',@level2name=N'Full_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Standard is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL', @level2type=N'COLUMN',@level2name=N'Standard'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SPECIFIC_LEVEL'
GO
