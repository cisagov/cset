USE [CSETWeb]
GO
/****** Object:  Table [dbo].[STANDARD_TO_UNIVERSAL_MAP]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP](
	[Universal_Sal_Level] [varchar](10) NOT NULL,
	[Standard_Level] [varchar](50) NOT NULL,
 CONSTRAINT [PK_STANDARD_TO_UNIVERSAL_MAP] PRIMARY KEY CLUSTERED 
(
	[Universal_Sal_Level] ASC,
	[Standard_Level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'H', N'C')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'H', N'H')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'H', N'MAC I')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'H', N'MIL3')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'H', N'Tier II')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'L', N'L')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'L', N'MAC III')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'L', N'MIL1')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'L', N'P')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'L', N'Tier IV')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'M', N'M')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'M', N'MAC II')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'M', N'MIL2')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'M', N'S')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'M', N'Tier III')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'VH', N'Tier I')
INSERT [dbo].[STANDARD_TO_UNIVERSAL_MAP] ([Universal_Sal_Level], [Standard_Level]) VALUES (N'VH', N'VH')
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_STANDARD_SPECIFIC_LEVEL] FOREIGN KEY([Standard_Level])
REFERENCES [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP] CHECK CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_STANDARD_SPECIFIC_LEVEL]
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP]  WITH CHECK ADD  CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_UNIVERSAL_SAL_LEVEL] FOREIGN KEY([Universal_Sal_Level])
REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP] CHECK CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_UNIVERSAL_SAL_LEVEL]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Universal Sal Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_TO_UNIVERSAL_MAP', @level2type=N'COLUMN',@level2name=N'Universal_Sal_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Standard Level is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_TO_UNIVERSAL_MAP', @level2type=N'COLUMN',@level2name=N'Standard_Level'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_TO_UNIVERSAL_MAP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_TO_UNIVERSAL_MAP'
GO
