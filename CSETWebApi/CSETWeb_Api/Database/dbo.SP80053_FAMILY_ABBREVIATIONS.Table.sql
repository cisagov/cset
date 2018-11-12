USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SP80053_FAMILY_ABBREVIATIONS]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SP80053_FAMILY_ABBREVIATIONS](
	[ID] [varchar](2) NOT NULL,
	[Standard_Category] [nvarchar](250) NOT NULL,
	[Standard_Order] [int] NOT NULL,
 CONSTRAINT [PK_NEW_53_FAMILY_ABBREVIATIONS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'AC', N'Access Control', 1)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'AP', N'Authority and Purpose', 19)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'AR', N'Accountability, Audit, and Risk Management', 20)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'AT', N'Awareness and Training', 2)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'AU', N'Audit and Accountability', 3)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'CA', N'Security Assessment and Authorization', 4)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'CM', N'Configuration Management', 5)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'CP', N'Contingency Planning', 6)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'DI', N'Data Quality and Integrity', 21)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'DM', N'Data Minimization and Retention', 22)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'IA', N'Identification and Authentication', 7)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'IP', N'Individual Participation and Redress', 23)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'IR', N'Incident Response', 8)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'MA', N'Maintenance', 9)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'MP', N'Media Protection', 10)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'PE', N'Physical and Environmental Protection', 11)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'PL', N'Planning', 12)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'PM', N'Program Management', 18)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'PS', N'Personnel Security', 13)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'RA', N'Risk Assessment', 14)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'SA', N'System and Services Acquisition', 15)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'SC', N'System and Communications Protection', 16)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'SE', N'Security', 24)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'SI', N'System and Information Integrity', 17)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'TR', N'Transparency', 25)
INSERT [dbo].[SP80053_FAMILY_ABBREVIATIONS] ([ID], [Standard_Category], [Standard_Order]) VALUES (N'UL', N'Use Limitation', 26)
