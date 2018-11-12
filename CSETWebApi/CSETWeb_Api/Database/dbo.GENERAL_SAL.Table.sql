USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GENERAL_SAL]    Script Date: 6/28/2018 8:21:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GENERAL_SAL](
	[Assessment_Id] [int] NOT NULL,
	[Sal_Name] [varchar](50) NOT NULL,
	[Slider_Value] [int] NOT NULL,
 CONSTRAINT [PK_GENERAL_SAL_1] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Sal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (2, N'Off_Site_Death', 6)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (2, N'Off_Site_Physical_Injury', 1)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (2, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (15, N'Off_Site_Physical_Injury', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (15, N'On_Site_Hospital_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (15, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (17, N'Off_Site_Hospital_Injury', 5)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (17, N'Off_Site_Physical_Injury', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (17, N'On_Site_Death', 1)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (17, N'On_Site_Hospital_Injury', 5)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (17, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'Off_Site_Death', 8)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'Off_Site_Hospital_Injury', 8)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'Off_Site_Physical_Injury', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'On_Site_Death', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'On_Site_Hospital_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (19, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (21, N'Off_Site_Physical_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (21, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (22, N'Off_Site_Physical_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (22, N'On_Site_Environmental_Cleanup', 5)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (22, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (25, N'Off_Site_Hospital_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (25, N'Off_Site_Physical_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (25, N'On_Site_Hospital_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (25, N'On_Site_Physical_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (26, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'Off_Site_Capital_Assets', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'Off_Site_Death', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'Off_Site_Economic_Impact', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'Off_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Capital_Assets', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Death', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Economic_Impact', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Environmental_Cleanup', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Hospital_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (27, N'On_Site_Physical_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (28, N'On_Site_Physical_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'Off_Site_Death', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'Off_Site_Hospital_Injury', 5)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'Off_Site_Physical_Injury', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'On_Site_Death', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'On_Site_Hospital_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (29, N'On_Site_Physical_Injury', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'Off_Site_Economic_Impact', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'Off_Site_Environmental_Cleanup', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'Off_Site_Physical_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'On_Site_Environmental_Cleanup', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'On_Site_Hospital_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (32, N'On_Site_Physical_Injury', 1)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Capital_Assets', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Death', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Economic_Impact', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Environmental_Cleanup', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Hospital_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'Off_Site_Physical_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'On_Site_Capital_Assets', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'On_Site_Death', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'On_Site_Environmental_Cleanup', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'On_Site_Hospital_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (33, N'On_Site_Physical_Injury', 0)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (39, N'On_Site_Physical_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'Off_Site_Capital_Assets', 1)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'Off_Site_Death', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'Off_Site_Economic_Impact', 1)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'Off_Site_Environmental_Cleanup', 6)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'Off_Site_Physical_Injury', 2)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'On_Site_Capital_Assets', 4)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'On_Site_Economic_Impact', 6)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'On_Site_Environmental_Cleanup', 6)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'On_Site_Hospital_Injury', 3)
INSERT [dbo].[GENERAL_SAL] ([Assessment_Id], [Sal_Name], [Slider_Value]) VALUES (43, N'On_Site_Physical_Injury', 3)
ALTER TABLE [dbo].[GENERAL_SAL]  WITH CHECK ADD  CONSTRAINT [FK_GENERAL_SAL_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GENERAL_SAL] CHECK CONSTRAINT [FK_GENERAL_SAL_ASSESSMENTS]
GO
ALTER TABLE [dbo].[GENERAL_SAL]  WITH CHECK ADD  CONSTRAINT [FK_GENERAL_SAL_GEN_SAL_NAMES] FOREIGN KEY([Sal_Name])
REFERENCES [dbo].[GEN_SAL_NAMES] ([Sal_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GENERAL_SAL] CHECK CONSTRAINT [FK_GENERAL_SAL_GEN_SAL_NAMES]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL', @level2type=N'COLUMN',@level2name=N'Assessment_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Weight Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL', @level2type=N'COLUMN',@level2name=N'Sal_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL'
GO
