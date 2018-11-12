USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SAL_LEVELS]    Script Date: 6/28/2018 8:21:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_LEVELS](
	[Selected_Sal_Level] [varchar](50) NOT NULL,
	[Sal_Level_Order] [int] NOT NULL,
 CONSTRAINT [PK_Sal_Levels] PRIMARY KEY CLUSTERED 
(
	[Selected_Sal_Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SAL_LEVELS] ([Selected_Sal_Level], [Sal_Level_Order]) VALUES (N'High', 3)
INSERT [dbo].[SAL_LEVELS] ([Selected_Sal_Level], [Sal_Level_Order]) VALUES (N'Low', 1)
INSERT [dbo].[SAL_LEVELS] ([Selected_Sal_Level], [Sal_Level_Order]) VALUES (N'Moderate', 2)
INSERT [dbo].[SAL_LEVELS] ([Selected_Sal_Level], [Sal_Level_Order]) VALUES (N'None', 0)
INSERT [dbo].[SAL_LEVELS] ([Selected_Sal_Level], [Sal_Level_Order]) VALUES (N'Very High', 4)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Selected Sal Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_LEVELS', @level2type=N'COLUMN',@level2name=N'Selected_Sal_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Level Order is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_LEVELS', @level2type=N'COLUMN',@level2name=N'Sal_Level_Order'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_LEVELS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_LEVELS'
GO
