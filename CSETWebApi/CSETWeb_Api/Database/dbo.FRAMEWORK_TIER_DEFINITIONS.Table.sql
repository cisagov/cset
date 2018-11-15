USE [CSETWeb]
GO
/****** Object:  Table [dbo].[FRAMEWORK_TIER_DEFINITIONS]    Script Date: 11/14/2018 3:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS](
	[Tier] [varchar](50) NOT NULL,
	[TierType] [varchar](50) NOT NULL,
	[TierQuestion] [varchar](1024) NOT NULL,
 CONSTRAINT [PK_FRAMEWORK_TIER_DEFINITIONS] PRIMARY KEY CLUSTERED 
(
	[Tier] ASC,
	[TierType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 1', N'External Participation', N'An organization may not have the processes in place to participate in coordination or collaboration with other entities.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 1', N'Integrated Risk Management Program', N'There is limited awareness of cybersecurity risk at the organizational level and an organization-wide approach to managing cybersecurity risk has not been established. The organization implements cybersecurity risk management on an irregular, case-by-case basis due to varied experience or information gained from outside sources. The organization may not have processes that enable cybersecurity information to be shared within the organization.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 1', N'Risk Management Process', N'Organizational cybersecurity risk management practices are not formalized, and risk is managed in an ad hoc and sometimes reactive manner. Prioritization of cybersecurity activities may not be directly informed by organizational risk objectives, the threat environment, or business/mission requirements.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 2', N'External Participation', N'The organization knows its role in the larger ecosystem, but has not formalized its capabilities to interact and share information externally.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 2', N'Integrated Risk Management Program', N'There is an awareness of cybersecurity risk at the organizational level but an organization-wide approach to managing cybersecurity risk has not been established. Risk-informed, management-approved processes and procedures are defined and implemented, and staff has adequate resources to perform their cybersecurity duties. Cybersecurity information is shared within the organization on an informal basis.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 2', N'Risk Management Process', N'Risk management practices are approved by management but may not be established as organizational-wide policy. Prioritization of cybersecurity activities is directly informed by organizational risk objectives, the threat environment, or business/mission requirements.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 3', N'External Participation', N'The organization understands its dependencies and partners and receives information from these partners that enables collaboration and risk-based management decisions within the organization in response to events.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 3', N'Integrated Risk Management Program', N'There is an organization-wide approach to manage cybersecurity risk. Risk-informed policies, processes, and procedures are defined, implemented as intended, and reviewed. Consistent methods are in place to respond effectively to changes in risk. Personnel possess the knowledge and skills to perform their appointed roles and responsibilities.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 3', N'Risk Management Process', N'The organization’s risk management practices are formally approved and expressed as policy. Organizational cybersecurity practices are regularly updated based on the application of risk management processes to changes in business/mission requirements and a changing threat and technology landscape.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 4', N'External Participation', N'The organization manages risk and actively shares information with partners to ensure that accurate, current information is being distributed and consumed to improve cybersecurity before a cybersecurity event occurs.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 4', N'Integrated Risk Management Program', N'There is an organization-wide approach to managing cybersecurity risk that uses risk-informed policies, processes, and procedures to address potential cybersecurity events. Cybersecurity risk management is part of the organizational culture and evolves from an awareness of previous activities, information shared by other sources, and continuous awareness of activities on their systems and networks.')
INSERT [dbo].[FRAMEWORK_TIER_DEFINITIONS] ([Tier], [TierType], [TierQuestion]) VALUES (N'Tier 4', N'Risk Management Process', N'The organization adapts its cybersecurity practices based on lessons learned and predictive indicators derived from previous and current cybersecurity activities. Through a process of continuous improvement incorporating advanced cybersecurity technologies and practices, the organization actively adapts to a changing cybersecurity landscape and responds to evolving and sophisticated threats in a timely manner.')
ALTER TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS]  WITH CHECK ADD  CONSTRAINT [FK_FRAMEWORK_TIER_DEFINITIONS_FRAMEWORK_TIERS] FOREIGN KEY([Tier])
REFERENCES [dbo].[FRAMEWORK_TIERS] ([Tier])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS] CHECK CONSTRAINT [FK_FRAMEWORK_TIER_DEFINITIONS_FRAMEWORK_TIERS]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIER_DEFINITIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FRAMEWORK_TIER_DEFINITIONS'
GO
