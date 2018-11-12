USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GEN_SAL_NAMES]    Script Date: 6/28/2018 8:21:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GEN_SAL_NAMES](
	[Sal_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GEN_SAL_NAMES] PRIMARY KEY CLUSTERED 
(
	[Sal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Capital_Assets')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Death')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Economic_Impact')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Environmental_Cleanup')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Hospital_Injury')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'Off_Site_Physical_Injury')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Capital_Assets')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Death')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Economic_Impact')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Environmental_Cleanup')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Hospital_Injury')
INSERT [dbo].[GEN_SAL_NAMES] ([Sal_Name]) VALUES (N'On_Site_Physical_Injury')
