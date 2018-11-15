USE [CSETWeb]
GO
/****** Object:  Table [dbo].[NCSF_CATEGORY]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NCSF_CATEGORY](
	[NCSF_Function_Id] [varchar](2) NOT NULL,
	[NCSF_Category_Id] [varchar](20) NOT NULL,
	[NCSF_Category_Name] [varchar](50) NOT NULL,
	[NCSF_Category_Description] [varchar](500) NOT NULL,
	[NCSF_Cat_Id] [int] IDENTITY(1,1) NOT NULL,
	[Question_Group_Heading_Id] [int] NOT NULL,
 CONSTRAINT [PK_NCSF_Category] PRIMARY KEY CLUSTERED 
(
	[NCSF_Cat_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[NCSF_CATEGORY] ON 

INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'AM', N'Asset Management', N'The data, personnel, devices, systems, and facilities that enable the organization to achieve business purposes are identified and managed consistent with their relative importance to business objectives and the organization’s risk strategy.', 1, 10)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'BE', N'Business Environment', N'The organization’s mission, objectives, stakeholders, and activities are understood and prioritized; this information is used to inform cybersecurity roles, responsibilities, and risk management decisions.', 2, 41)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'GV', N'Governance', N'The policies, procedures, and processes to manage and monitor the organization’s regulatory, legal, risk, environmental, and operational requirements are understood and inform the management of cybersecurity risk.', 3, 37)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'RA', N'Risk Assessment', N'The organization understands the cybersecurity risk to organizational operations (including mission, functions, image, or reputation), organizational assets, and individuals.', 4, 41)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'RM', N'Risk Management Strategy', N'The organization’s priorities, constraints, risk tolerances, and assumptions are established and used to support operational risk decisions.', 5, 41)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'AC', N'Access Control', N'Access to assets and associated facilities is limited to authorized users, processes, or devices, and to authorized activities and transactions.', 6, 4)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'AT', N'Awareness and Training', N'The organization’s personnel and partners are provided cybersecurity awareness education and are adequately trained to perform their information security-related duties and responsibilities consistent with related policies, procedures, and agreements.', 7, 51)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'DS', N'Data Security', N'Information and records (data) are managed consistent with the organization’s risk strategy to protect the confidentiality, integrity, and availability of information.', 8, 42)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'IP', N'Information Protection Processes and Procedures', N'Security policies (that address purpose, scope, roles, responsibilities, management commitment, and coordination among organizational entities), processes, and procedures are maintained and used to manage protection of information systems and assets.', 9, 49)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'MA', N'Maintenance', N'Maintenance and repairs of industrial control and information system components is performed consistent with policies and procedures.', 10, 10)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'PR', N'PT', N'Protective Technology', N'Technical security solutions are managed to ensure the security and resilience of systems and assets, consistent with related policies, procedures, and agreements.', 11, 9)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'DE', N'AE', N'Anomalies and Events', N'Anomalous activity is detected in a timely manner and the potential impact of events is understood.', 12, 16)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'DE', N'CM', N'Security Continuous Monitoring', N'The information system and assets are monitored at discrete intervals to identify cybersecurity events and verify the effectiveness of protective measures.', 13, 25)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'DE', N'DP', N'Detection Processes', N'Detection processes and procedures are maintained and tested to ensure timely and adequate awareness of anomalous events.', 14, 6)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RS', N'RP', N'Response Planning', N'Response processes and procedures are executed and maintained, to ensure timely response to detected cybersecurity events.', 15, 17)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RS', N'CO', N'Response Communications', N'Response activities are coordinated with internal and external stakeholders, as appropriate, to include external support from law enforcement agencies.', 16, 9)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RS', N'AN', N'Analysis', N'Analysis is conducted to ensure adequate response and support recovery activities.', 17, 41)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RS', N'MI', N'Mitigation', N'Activities are performed to prevent expansion of an event, mitigate its effects, and eradicate the incident.', 18, 17)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RS', N'IM', N'Response Improvements', N'Organizational response activities are improved by incorporating lessons learned from current and previous detection/response activities.', 19, 60)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RC', N'RP', N'Recovery Planning', N'Recovery processes and procedures are executed and maintained to ensure timely restoration of systems or assets affected by cybersecurity events.', 20, 17)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RC', N'IM', N'Recovery Improvements', N'Recovery planning and processes are improved by incorporating lessons learned into future activities.', 21, 34)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'RC', N'CO', N'Recovery Communications', N'Restoration activities are coordinated with internal and external parties, such as coordinating centers, Internet Service Providers, owners of attacking systems, victims, other CSIRTs, and vendors.', 22, 9)
INSERT [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id], [NCSF_Category_Name], [NCSF_Category_Description], [NCSF_Cat_Id], [Question_Group_Heading_Id]) VALUES (N'ID', N'SC', N'Supply Chain', N'Supply Chain', 23, 82)
SET IDENTITY_INSERT [dbo].[NCSF_CATEGORY] OFF
ALTER TABLE [dbo].[NCSF_CATEGORY] ADD  CONSTRAINT [DF_NCSF_CATEGORY_Question_Group_Heading_Id]  DEFAULT ((50)) FOR [Question_Group_Heading_Id]
GO
ALTER TABLE [dbo].[NCSF_CATEGORY]  WITH CHECK ADD  CONSTRAINT [FK_NCSF_Category_NCSF_FUNCTIONS] FOREIGN KEY([NCSF_Function_Id])
REFERENCES [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NCSF_CATEGORY] CHECK CONSTRAINT [FK_NCSF_Category_NCSF_FUNCTIONS]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NCSF_CATEGORY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NCSF_CATEGORY'
GO
