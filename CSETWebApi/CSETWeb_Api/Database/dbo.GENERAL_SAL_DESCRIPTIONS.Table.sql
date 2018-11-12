USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GENERAL_SAL_DESCRIPTIONS]    Script Date: 6/28/2018 8:21:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GENERAL_SAL_DESCRIPTIONS](
	[Sal_Name] [varchar](50) NOT NULL,
	[Sal_Description] [varchar](1024) NOT NULL,
	[Sal_Order] [int] NOT NULL,
	[min] [int] NULL,
	[max] [int] NULL,
	[step] [int] NULL,
	[prefix] [varchar](50) NULL,
	[postfix] [varchar](50) NULL,
 CONSTRAINT [PK_GENERAL_SAL_DESCRIPTIONS] PRIMARY KEY CLUSTERED 
(
	[Sal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Capital_Assets', N'For a worst-case scenario, estimate the potential cost of losing capital assets or the overall economic impact.(Consider the cost of site buildings, facilities, equipment, etc.)', 8, 0, 7, 1, N'off site', N'capital loss')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Death', N'If control systems are maliciously accessed and manipulated to cause harm, how many people could be killed in a worst-case scenario?(Consider injuries caused due to any reason.)', 6, 0, 8, 1, N'off site', N'deaths')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Economic_Impact', N'For a worst-case scenario, estimate the potential cost in terms of economic impact to both the site and surrounding communities.(Consider any losses to community structures and use and any costs associated with displacement.)', 10, 0, 7, 1, N'off site', N'economic impact')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Environmental_Cleanup', N'For a worst-case scenario, estimate the potential cost of environmental cleanup to the site and surrounding communities.(Consider the cost for cleanup, fines, litigation, long-term monitoring, etc.)', 12, 0, 7, 1, N'off site', N'environmental')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Hospital_Injury', N'If control systems were maliciously accessed and manipulated to cause harm, how many people could sustain injuries requiring hospital stay in a worst-case scenario?(Consider injuries caused due to any reason.)', 4, 0, 8, 1, N'off site', N'hospitalizations')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'Off_Site_Physical_Injury', N'If control systems were maliciously accessed and manipulated to cause harm, how many people could sustain injuries not requiring hospital stay in a worst-case scenario?(Consider injuries caused due to any reason.)', 2, 0, 8, 1, N'off site', N'injuries')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Capital_Assets', N'For a worst-case scenario, estimate the potential cost of losing capital assets or the overall economic impact.(Consider the cost of site buildings, facilities, equipment, etc.)', 7, 0, 7, 1, N'on site', N'capital loss')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Death', N'If control systems are maliciously accessed and manipulated to cause harm, how many people could be killed in a worst-case scenario?(Consider injuries caused due to any reason.)', 5, 0, 8, 1, N'on site', N'deaths')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Economic_Impact', N'For a worst-case scenario, estimate the potential cost in terms of economic impact to both the site and surrounding communities.(Consider any losses to community structures and use and any costs associated with displacement.)', 9, 0, 7, 1, N'on site', N'economic impact')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Environmental_Cleanup', N'For a worst-case scenario, estimate the potential cost of environmental cleanup to the site and surrounding communities.(Consider the cost for cleanup, fines, litigation, long-term monitoring, etc.)', 11, 0, 7, 1, N'on site', N'environmental')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Hospital_Injury', N'If control systems were maliciously accessed and manipulated to cause harm, how many people could sustain injuries requiring hospital stay in a worst-case scenario?(Consider injuries caused due to any reason.)', 3, 0, 8, 1, N'on site', N'hospitalizations')
INSERT [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name], [Sal_Description], [Sal_Order], [min], [max], [step], [prefix], [postfix]) VALUES (N'On_Site_Physical_Injury', N'If control systems were maliciously accessed and manipulated to cause harm, how many people could sustain injuries not requiring hospital stay in a worst-case scenario? (Consider injuries caused due to any reason.)', 1, 0, 8, 1, N'on site', N'injuries')
