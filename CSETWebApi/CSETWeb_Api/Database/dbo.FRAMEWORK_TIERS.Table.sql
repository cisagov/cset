USE [CSETWeb]
GO
/****** Object:  Table [dbo].[FRAMEWORK_TIERS]    Script Date: 11/14/2018 3:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FRAMEWORK_TIERS](
	[Tier] [varchar](50) NOT NULL,
	[FullName] [varchar](50) NOT NULL,
	[TierOrder] [int] NOT NULL,
 CONSTRAINT [PK_FRAMEWORK_TIERS] PRIMARY KEY CLUSTERED 
(
	[Tier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[FRAMEWORK_TIERS] ([Tier], [FullName], [TierOrder]) VALUES (N'Tier 1', N'Tier 1: Partial', 1)
INSERT [dbo].[FRAMEWORK_TIERS] ([Tier], [FullName], [TierOrder]) VALUES (N'Tier 2', N'Tier 2: Risk Informed', 2)
INSERT [dbo].[FRAMEWORK_TIERS] ([Tier], [FullName], [TierOrder]) VALUES (N'Tier 3', N'Tier 3: Repeatable', 3)
INSERT [dbo].[FRAMEWORK_TIERS] ([Tier], [FullName], [TierOrder]) VALUES (N'Tier 4', N'Tier 4: Adaptive', 4)
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIERS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIERS'
GO
