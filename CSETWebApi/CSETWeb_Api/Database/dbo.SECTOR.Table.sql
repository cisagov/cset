USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SECTOR]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SECTOR](
	[SectorId] [int] IDENTITY(1,1) NOT NULL,
	[SectorName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SECTOR_1] PRIMARY KEY CLUSTERED 
(
	[SectorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SECTOR] ON 

INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (1, N'Chemical Sector (Not Oil and Gas)')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (2, N'Commercial Facilities Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (3, N'Communications Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (4, N'Critical Manufacturing Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (5, N'Dams Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (6, N'Defense Industrial Base Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (7, N'Emergency Services Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (8, N'Energy Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (9, N'Financial Services Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (10, N'Food and Agriculture Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (11, N'Government Facilities Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (12, N'Healthcare and Public Health Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (13, N'Information Technology Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (14, N'Nuclear Reactors, Materials, and Waste Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (15, N'Transportation Systems Sector')
INSERT [dbo].[SECTOR] ([SectorId], [SectorName]) VALUES (16, N'Water and Wastewater Systems Sector')
SET IDENTITY_INSERT [dbo].[SECTOR] OFF
