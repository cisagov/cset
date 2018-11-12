USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DEMOGRAPHICS]    Script Date: 6/28/2018 8:21:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEMOGRAPHICS](
	[Assessment_Id] [int] NOT NULL,
	[SectorId] [int] NULL,
	[IndustryId] [int] NULL,
	[Size] [varchar](50) NULL,
	[AssetValue] [varchar](50) NULL,
	[NeedsPrivacy] [bit] NOT NULL,
	[NeedsSupplyChain] [bit] NOT NULL,
	[NeedsICS] [bit] NOT NULL,
 CONSTRAINT [PK_DEMOGRAPHICS] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (17, 2, 2, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (19, 2, 2, NULL, N'< $1,000,000', 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (21, 2, 2, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (22, 8, 44, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (25, 3, 84, N'Large', N'< $10,000,000', 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (26, 1, 80, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (27, 8, 45, N'Medium', N'< $1,000,000', 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (28, 1, 1, N'Large', N'> $10,000,000', 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (29, 1, 82, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (32, 1, 82, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (33, 1, 82, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (34, NULL, NULL, N'Large', NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (39, 3, 84, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (43, 2, 3, N'Medium', N'< $1,000,000', 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (47, 7, 43, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (50, 7, 43, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (51, 7, 43, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (52, 7, 43, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (53, 7, 43, NULL, NULL, 0, 0, 0)
INSERT [dbo].[DEMOGRAPHICS] ([Assessment_Id], [SectorId], [IndustryId], [Size], [AssetValue], [NeedsPrivacy], [NeedsSupplyChain], [NeedsICS]) VALUES (54, 7, 43, NULL, NULL, 0, 0, 0)
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD  CONSTRAINT [DF_DEMOGRAPHICS_NeedsPrivacy]  DEFAULT ((0)) FOR [NeedsPrivacy]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD  CONSTRAINT [DF_DEMOGRAPHICS_NeedsSupplyChain]  DEFAULT ((0)) FOR [NeedsSupplyChain]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD  CONSTRAINT [DF_DEMOGRAPHICS_NeedsICS]  DEFAULT ((0)) FOR [NeedsICS]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS]  WITH CHECK ADD  CONSTRAINT [FK_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] CHECK CONSTRAINT [FK_DEMOGRAPHICS_ASSESSMENTS]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS]  WITH CHECK ADD  CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_ASSET_VALUES] FOREIGN KEY([AssetValue])
REFERENCES [dbo].[DEMOGRAPHICS_ASSET_VALUES] ([AssetValue])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] CHECK CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_ASSET_VALUES]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS]  WITH CHECK ADD  CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_SIZE] FOREIGN KEY([Size])
REFERENCES [dbo].[DEMOGRAPHICS_SIZE] ([Size])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] CHECK CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_SIZE]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS]  WITH CHECK ADD  CONSTRAINT [FK_DEMOGRAPHICS_SECTOR] FOREIGN KEY([SectorId])
REFERENCES [dbo].[SECTOR] ([SectorId])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] CHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR]
GO
ALTER TABLE [dbo].[DEMOGRAPHICS]  WITH CHECK ADD  CONSTRAINT [FK_DEMOGRAPHICS_SECTOR_INDUSTRY] FOREIGN KEY([IndustryId])
REFERENCES [dbo].[SECTOR_INDUSTRY] ([IndustryId])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] CHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR_INDUSTRY]
GO
