USE [CSETWeb]
GO
/****** Object:  Table [dbo].[QUESTION_GROUP_HEADING]    Script Date: 11/14/2018 3:57:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUESTION_GROUP_HEADING](
	[Question_Group_Heading] [nvarchar](250) NOT NULL,
	[Std_Ref] [varchar](10) NOT NULL,
	[Universal_Weight] [int] NOT NULL,
	[Question_Group_Heading_Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_QUESTION_GROUP_HEADING] PRIMARY KEY CLUSTERED 
(
	[Question_Group_Heading] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[QUESTION_GROUP_HEADING] ON 

INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'800-53 R3', N'53', 0, 1)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'800-53 R3 App I', N'53I', 0, 2)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'800-82', N'82', 0, 3)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Access Control', N'J', 1, 4)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Account Management', N'I', 1, 5)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Audit and Accountability', N'ZZ', 4, 6)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Awareness and Training', N'A1', 2, 63)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Boundary Protection', N'C2', 1, 7)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'CFATS', N'CFAT', 0, 8)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Communication Protection', N'O', 1, 9)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Configuration Management', N'S', 2, 10)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Contingency Planning', N'A2', 2, 64)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Continuity', N'V', 4, 11)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Defense in Depth', N'Defense in', 1, 12)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Detect', N'FDE', 1, 58)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Disaster Recovery', N'FRC', 1, 61)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Encryption', N'Encryption', 3, 13)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Environmental Security', N'R', 1, 14)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Firewall', N'Firewall', 2, 15)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'HIPAA', N'HIPAA', 0, 76)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Host Intrusion Detection', N'C15', 1, 16)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Identification and Authentication', N'A3', 2, 65)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Identify', N'FID', 1, 59)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Incident Response', N'T', 4, 17)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Information and Document Management', N'X', 3, 19)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Information Protection', N'W', 1, 18)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'INGAA', N'INGAA', 0, 56)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Intrusion Detection', N'C4', 3, 20)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Logging', N'C5', 4, 21)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Maintenance', N'Z', 2, 22)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Management', N'C6', 2, 23)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Management Practices', N'C7', 1, 24)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Media Protection', N'A4', 2, 66)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Mobile Device Management MDM ', N'Mob', 4, 79)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Monitoring & Malware', N'U', 3, 25)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NEI 0809 R6', N'NEI0809', 0, 57)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NERC Rev 3', N'NERC3', 0, 26)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NERC5', N'NERC5', 0, 74)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NIST_SAL', N'NS', 0, 27)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NISTIR', N'NISTIR', 0, 55)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'NRC 5.71', N'NRC', 0, 28)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Organizational', N'F', 2, 29)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Password', N'C8', 1, 30)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Personnel', N'G', 1, 31)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Personnel Security', N'A5', 2, 67)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Physical Access', N'C9', 1, 32)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Physical and Environmental Protection', N'A6', 2, 68)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Physical Security', N'Q', 1, 33)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Planning', N'Planning', 3, 34)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Plans', N'D', 3, 35)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Policies', N'B', 2, 36)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Policies & Procedures General', N'A', 2, 37)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Portable/Mobile/Wireless', N'L', 2, 38)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Privacy', N'Pv', 3, 54)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Procedures', N'C', 2, 39)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Program Management', N'A7', 2, 69)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Protect', N'FPR', 1, 60)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Provenance', N'PROV', 7, 75)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Recover', N'Rec', 4, 80)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Recovery', N'Rec', 4, 81)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Remote Access Control', N'K', 1, 40)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Respond', N'FRS', 1, 62)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Risk Assessment', N'A8', 2, 70)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Risk Management and Assessment', N'E', 3, 41)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Safety Instrumented System (SIS)', N'SIS', 1, 46)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Securing Content', N'C10', 1, 42)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Securing the Component', N'C11', 2, 43)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Securing the Router', N'C12', 1, 44)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Securing the System', N'C13', 3, 45)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Security Assessment and Authorization', N'A9', 2, 71)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Software', N'N', 3, 47)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Supply Chain', N'Sup', 4, 82)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'System and Communications Protection', N'A10', 2, 72)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'System and Information Integrity', N'A11', 2, 73)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'System and Services Acquisition', N'Y', 3, 48)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'System Integrity', N'P', 2, 49)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'System Protection', N'M', 1, 50)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Training', N'H', 1, 51)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'User Authentication', N'C14', 1, 52)
INSERT [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading], [Std_Ref], [Universal_Weight], [Question_Group_Heading_Id]) VALUES (N'Vulnerability Assessment and Management', N'VA', 1, 78)
SET IDENTITY_INSERT [dbo].[QUESTION_GROUP_HEADING] OFF
/****** Object:  Index [IX_QUESTION_GROUP_HEADING_1]    Script Date: 11/14/2018 3:57:31 PM ******/
ALTER TABLE [dbo].[QUESTION_GROUP_HEADING] ADD  CONSTRAINT [IX_QUESTION_GROUP_HEADING_1] UNIQUE NONCLUSTERED 
(
	[Question_Group_Heading_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Group Heading is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING', @level2type=N'COLUMN',@level2name=N'Question_Group_Heading'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Std Ref is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING', @level2type=N'COLUMN',@level2name=N'Std_Ref'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Universal Weight is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING', @level2type=N'COLUMN',@level2name=N'Universal_Weight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Group Heading Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING', @level2type=N'COLUMN',@level2name=N'Question_Group_Heading_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QUESTION_GROUP_HEADING'
GO
