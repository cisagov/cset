USE [CSETWeb]
GO
/****** Object:  Table [dbo].[UNIVERSAL_SAL_LEVEL]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UNIVERSAL_SAL_LEVEL](
	[Universal_Sal_Level] [varchar](10) NOT NULL,
	[Sal_Level_Order] [int] NOT NULL,
	[Full_Name_Sal] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UNIVERSAL_SAL_LEVEL] PRIMARY KEY CLUSTERED 
(
	[Universal_Sal_Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level], [Sal_Level_Order], [Full_Name_Sal]) VALUES (N'H', 3, N'High')
INSERT [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level], [Sal_Level_Order], [Full_Name_Sal]) VALUES (N'L', 1, N'Low')
INSERT [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level], [Sal_Level_Order], [Full_Name_Sal]) VALUES (N'M', 2, N'Moderate')
INSERT [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level], [Sal_Level_Order], [Full_Name_Sal]) VALUES (N'none', 0, N'None')
INSERT [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level], [Sal_Level_Order], [Full_Name_Sal]) VALUES (N'VH', 4, N'Very High')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Universal Sal Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_SAL_LEVEL', @level2type=N'COLUMN',@level2name=N'Universal_Sal_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Level Order is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_SAL_LEVEL', @level2type=N'COLUMN',@level2name=N'Sal_Level_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Full Name Sal is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_SAL_LEVEL', @level2type=N'COLUMN',@level2name=N'Full_Name_Sal'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_SAL_LEVEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_SAL_LEVEL'
GO
