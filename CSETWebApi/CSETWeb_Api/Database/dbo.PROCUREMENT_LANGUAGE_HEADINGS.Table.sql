USE [CSETWeb]
GO
/****** Object:  Table [dbo].[PROCUREMENT_LANGUAGE_HEADINGS]    Script Date: 6/28/2018 8:21:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROCUREMENT_LANGUAGE_HEADINGS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Heading_Num] [int] NULL,
	[Heading_Name] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PROCUREMENT_LANGUAGE_HEADINGS] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ON 

INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (1, 2, N'System Hardening')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (2, 3, N'Perimeter Protection')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (3, 4, N'Account Management')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (4, 5, N'Coding Practices')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (5, 6, N'Flaw Remediation')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (6, 7, N'Malware Detection and Protection')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (7, 8, N'Host Name Resolution')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (8, 9, N'End Devices')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (9, 10, N'Remote Access')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (10, 11, N'Physical Security')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (11, 12, N'Network Partitioning')
INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id], [Heading_Num], [Heading_Name]) VALUES (12, 13, N'Wireless Technologies')
SET IDENTITY_INSERT [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PROCUREMENT_LANGUAGE_HEADINGS', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Heading Num is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PROCUREMENT_LANGUAGE_HEADINGS', @level2type=N'COLUMN',@level2name=N'Heading_Num'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Heading Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PROCUREMENT_LANGUAGE_HEADINGS', @level2type=N'COLUMN',@level2name=N'Heading_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PROCUREMENT_LANGUAGE_HEADINGS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PROCUREMENT_LANGUAGE_HEADINGS'
GO
