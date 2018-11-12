USE [CSETWeb]
GO
/****** Object:  Table [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]    Script Date: 6/28/2018 8:21:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER](
	[Assessment_Id] [int] NOT NULL,
	[TierType] [varchar](50) NOT NULL,
	[Tier] [varchar](50) NOT NULL,
 CONSTRAINT [PK_FRAMEWORK_TIER_TYPE_ANSWER] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[TierType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (25, N'External Participation', N'Tier 2')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (25, N'Integrated Risk Management Program', N'Tier 2')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (25, N'Risk Management Process', N'Tier 2')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (27, N'External Participation', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (27, N'Integrated Risk Management Program', N'Tier 2')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (27, N'Risk Management Process', N'Tier 3')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (28, N'External Participation', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (28, N'Integrated Risk Management Program', N'Tier 2')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (28, N'Risk Management Process', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (29, N'External Participation', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (29, N'Integrated Risk Management Program', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (29, N'Risk Management Process', N'Tier 1')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (33, N'External Participation', N'Tier 4')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (33, N'Integrated Risk Management Program', N'Tier 4')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (33, N'Risk Management Process', N'Tier 3')
INSERT [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ([Assessment_Id], [TierType], [Tier]) VALUES (34, N'External Participation', N'Tier 4')
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]  WITH CHECK ADD  CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] CHECK CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_ASSESSMENTS]
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]  WITH CHECK ADD  CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIER_TYPE] FOREIGN KEY([TierType])
REFERENCES [dbo].[FRAMEWORK_TIER_TYPE] ([TierType])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] CHECK CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIER_TYPE]
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]  WITH CHECK ADD  CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIERS] FOREIGN KEY([Tier])
REFERENCES [dbo].[FRAMEWORK_TIERS] ([Tier])
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] CHECK CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIERS]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIER_TYPE_ANSWER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIER_TYPE_ANSWER'
GO
