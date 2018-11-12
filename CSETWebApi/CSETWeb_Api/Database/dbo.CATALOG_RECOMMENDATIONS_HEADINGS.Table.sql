USE [CSETWeb]
GO
/****** Object:  Table [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS]    Script Date: 6/28/2018 8:21:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Heading_Num] [int] NOT NULL,
	[Heading_Name] [varchar](200) NOT NULL,
 CONSTRAINT [PK_CATALOG_RECOMMENDATIONS_HEADINGS] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ON 

INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (1, 1, N'Security Policy')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (2, 2, N'Organizational Security')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (3, 3, N'Personnel Security')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (4, 4, N'Physical and Eviromental Security')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (5, 5, N'System and Services Acquisition')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (6, 6, N'Configuration Management')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (7, 7, N'Strategic Planning')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (8, 8, N'System and Communication Protection')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (9, 9, N'Information and Document Management')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (10, 10, N'System Development and Maintenance')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (11, 11, N'Secuirty Awareness and Training')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (12, 12, N'Incident Response')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (13, 13, N'Media Protection')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (14, 14, N'System and Information Integrity')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (15, 15, N'Access Control')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (16, 16, N'Audit and Accountability')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (17, 17, N'Monitoring and Reviewing Control System Security Policy')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (18, 18, N'Risk Management and Assessment')
INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (19, 19, N'Security Program Management')
SET IDENTITY_INSERT [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CATALOG_RECOMMENDATIONS_HEADINGS', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Heading Num is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CATALOG_RECOMMENDATIONS_HEADINGS', @level2type=N'COLUMN',@level2name=N'Heading_Num'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Heading Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CATALOG_RECOMMENDATIONS_HEADINGS', @level2type=N'COLUMN',@level2name=N'Heading_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CATALOG_RECOMMENDATIONS_HEADINGS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CATALOG_RECOMMENDATIONS_HEADINGS'
GO
