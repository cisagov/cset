USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GEN_SAL_WEIGHTS]    Script Date: 11/14/2018 3:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GEN_SAL_WEIGHTS](
	[Sal_Weight_Id] [int] NOT NULL,
	[Sal_Name] [varchar](50) NOT NULL,
	[Slider_Value] [int] NOT NULL,
	[Weight] [decimal](18, 0) NOT NULL,
	[Display] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GEN_SAL_WEIGHTS] PRIMARY KEY CLUSTERED 
(
	[Sal_Name] ASC,
	[Slider_Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (0, N'Off_Site_Capital_Assets', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (1, N'Off_Site_Capital_Assets', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (2, N'Off_Site_Capital_Assets', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (3, N'Off_Site_Capital_Assets', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (4, N'Off_Site_Capital_Assets', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (5, N'Off_Site_Capital_Assets', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (6, N'Off_Site_Capital_Assets', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (7, N'Off_Site_Capital_Assets', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (8, N'Off_Site_Death', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (9, N'Off_Site_Death', 1, CAST(250 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (10, N'Off_Site_Death', 2, CAST(1750 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (11, N'Off_Site_Death', 3, CAST(5000 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (12, N'Off_Site_Death', 4, CAST(10000 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (13, N'Off_Site_Death', 5, CAST(40000 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (14, N'Off_Site_Death', 6, CAST(40001 AS Decimal(18, 0)), N'501-750')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (15, N'Off_Site_Death', 7, CAST(40002 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (16, N'Off_Site_Death', 8, CAST(40003 AS Decimal(18, 0)), N'> 1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (17, N'Off_Site_Economic_Impact', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (18, N'Off_Site_Economic_Impact', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (19, N'Off_Site_Economic_Impact', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (20, N'Off_Site_Economic_Impact', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (21, N'Off_Site_Economic_Impact', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (22, N'Off_Site_Economic_Impact', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (23, N'Off_Site_Economic_Impact', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (24, N'Off_Site_Economic_Impact', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (25, N'Off_Site_Environmental_Cleanup', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (26, N'Off_Site_Environmental_Cleanup', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (27, N'Off_Site_Environmental_Cleanup', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (28, N'Off_Site_Environmental_Cleanup', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (29, N'Off_Site_Environmental_Cleanup', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (30, N'Off_Site_Environmental_Cleanup', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (31, N'Off_Site_Environmental_Cleanup', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (32, N'Off_Site_Environmental_Cleanup', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (33, N'Off_Site_Hospital_Injury', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (34, N'Off_Site_Hospital_Injury', 1, CAST(50 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (35, N'Off_Site_Hospital_Injury', 2, CAST(100 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (36, N'Off_Site_Hospital_Injury', 3, CAST(150 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (37, N'Off_Site_Hospital_Injury', 4, CAST(200 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (38, N'Off_Site_Hospital_Injury', 5, CAST(250 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (39, N'Off_Site_Hospital_Injury', 6, CAST(1500 AS Decimal(18, 0)), N'501-750')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (40, N'Off_Site_Hospital_Injury', 7, CAST(1501 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (41, N'Off_Site_Hospital_Injury', 8, CAST(3000 AS Decimal(18, 0)), N'> 1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (42, N'Off_Site_Physical_Injury', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (43, N'Off_Site_Physical_Injury', 1, CAST(10 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (44, N'Off_Site_Physical_Injury', 2, CAST(11 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (45, N'Off_Site_Physical_Injury', 3, CAST(30 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (46, N'Off_Site_Physical_Injury', 4, CAST(31 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (47, N'Off_Site_Physical_Injury', 5, CAST(50 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (48, N'Off_Site_Physical_Injury', 6, CAST(150 AS Decimal(18, 0)), N'501-750')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (49, N'Off_Site_Physical_Injury', 7, CAST(250 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (50, N'Off_Site_Physical_Injury', 8, CAST(1000 AS Decimal(18, 0)), N'> 1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (51, N'On_Site_Capital_Assets', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (52, N'On_Site_Capital_Assets', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (53, N'On_Site_Capital_Assets', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (54, N'On_Site_Capital_Assets', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (55, N'On_Site_Capital_Assets', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (56, N'On_Site_Capital_Assets', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (57, N'On_Site_Capital_Assets', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (58, N'On_Site_Capital_Assets', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (59, N'On_Site_Death', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (60, N'On_Site_Death', 1, CAST(250 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (61, N'On_Site_Death', 2, CAST(1500 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (62, N'On_Site_Death', 3, CAST(4000 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (63, N'On_Site_Death', 4, CAST(10000 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (64, N'On_Site_Death', 5, CAST(30000 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (65, N'On_Site_Death', 6, CAST(30001 AS Decimal(18, 0)), N'501-750')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (66, N'On_Site_Death', 7, CAST(30002 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (67, N'On_Site_Death', 8, CAST(30003 AS Decimal(18, 0)), N'> 1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (68, N'On_Site_Economic_Impact', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (69, N'On_Site_Economic_Impact', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (70, N'On_Site_Economic_Impact', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (71, N'On_Site_Economic_Impact', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (72, N'On_Site_Economic_Impact', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (73, N'On_Site_Economic_Impact', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (74, N'On_Site_Economic_Impact', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (75, N'On_Site_Economic_Impact', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (76, N'On_Site_Environmental_Cleanup', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (77, N'On_Site_Environmental_Cleanup', 1, CAST(5 AS Decimal(18, 0)), N'< $100K')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (78, N'On_Site_Environmental_Cleanup', 2, CAST(10 AS Decimal(18, 0)), N'$100K - $1M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (79, N'On_Site_Environmental_Cleanup', 3, CAST(50 AS Decimal(18, 0)), N'$1M - $10M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (80, N'On_Site_Environmental_Cleanup', 4, CAST(500 AS Decimal(18, 0)), N'$10M - $100M')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (81, N'On_Site_Environmental_Cleanup', 5, CAST(5000 AS Decimal(18, 0)), N'$100M - $1B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (82, N'On_Site_Environmental_Cleanup', 6, CAST(10000 AS Decimal(18, 0)), N'$1B - $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (83, N'On_Site_Environmental_Cleanup', 7, CAST(20000 AS Decimal(18, 0)), N'> $10B')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (84, N'On_Site_Hospital_Injury', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (85, N'On_Site_Hospital_Injury', 1, CAST(25 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (86, N'On_Site_Hospital_Injury', 2, CAST(75 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (87, N'On_Site_Hospital_Injury', 3, CAST(150 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (88, N'On_Site_Hospital_Injury', 4, CAST(200 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (89, N'On_Site_Hospital_Injury', 5, CAST(250 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (90, N'On_Site_Hospital_Injury', 6, CAST(875 AS Decimal(18, 0)), N'501-750')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (91, N'On_Site_Hospital_Injury', 7, CAST(1500 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (92, N'On_Site_Hospital_Injury', 8, CAST(3000 AS Decimal(18, 0)), N'> 1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (93, N'On_Site_Physical_Injury', 0, CAST(0 AS Decimal(18, 0)), N'None')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (94, N'On_Site_Physical_Injury', 1, CAST(5 AS Decimal(18, 0)), N'1-10')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (95, N'On_Site_Physical_Injury', 2, CAST(6 AS Decimal(18, 0)), N'11-50')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (96, N'On_Site_Physical_Injury', 3, CAST(25 AS Decimal(18, 0)), N'51-100')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (97, N'On_Site_Physical_Injury', 4, CAST(26 AS Decimal(18, 0)), N'101-250')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (98, N'On_Site_Physical_Injury', 5, CAST(50 AS Decimal(18, 0)), N'251-500')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (99, N'On_Site_Physical_Injury', 6, CAST(100 AS Decimal(18, 0)), N'501-750')
GO
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (100, N'On_Site_Physical_Injury', 7, CAST(250 AS Decimal(18, 0)), N'751-1000')
INSERT [dbo].[GEN_SAL_WEIGHTS] ([Sal_Weight_Id], [Sal_Name], [Slider_Value], [Weight], [Display]) VALUES (101, N'On_Site_Physical_Injury', 8, CAST(1000 AS Decimal(18, 0)), N'> 1000')
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS]  WITH CHECK ADD  CONSTRAINT [FK_GEN_SAL_WEIGHTS_GEN_SAL_NAMES] FOREIGN KEY([Sal_Name])
REFERENCES [dbo].[GEN_SAL_NAMES] ([Sal_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS] CHECK CONSTRAINT [FK_GEN_SAL_WEIGHTS_GEN_SAL_NAMES]
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS]  WITH CHECK ADD  CONSTRAINT [FK_GEN_SAL_WEIGHTS_GENERAL_SAL_DESCRIPTIONS] FOREIGN KEY([Sal_Name])
REFERENCES [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS] CHECK CONSTRAINT [FK_GEN_SAL_WEIGHTS_GENERAL_SAL_DESCRIPTIONS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Weight Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS', @level2type=N'COLUMN',@level2name=N'Sal_Weight_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS', @level2type=N'COLUMN',@level2name=N'Sal_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Slider Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS', @level2type=N'COLUMN',@level2name=N'Slider_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Weight is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS', @level2type=N'COLUMN',@level2name=N'Weight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Display is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS', @level2type=N'COLUMN',@level2name=N'Display'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GEN_SAL_WEIGHTS'
GO
