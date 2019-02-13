USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SETS_CATEGORY]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SETS_CATEGORY](
	[Set_Category_Id] [int] NOT NULL,
	[Set_Category_Name] [varchar](250) NULL,
 CONSTRAINT [PK_Sets_Category] PRIMARY KEY CLUSTERED 
(
	[Set_Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (1, N'Chemical, Oil, and Natural Gas')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (2, N'Electrical')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (3, N'Transportation')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (4, N'Information Technology')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (5, N'Process Control and SCADA')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (6, N'Supply Chain')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (7, N'Health Care')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (8, N'Nuclear')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (9, N'DoDI and CNSSI')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (10, N'General')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (11, N'Questions Only')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (12, N'Custom')
INSERT [dbo].[SETS_CATEGORY] ([Set_Category_Id], [Set_Category_Name]) VALUES (13, N'NIST Framework')
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SETS_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SETS_CATEGORY'
GO
