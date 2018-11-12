USE [CSETWeb]
GO
/****** Object:  Table [dbo].[UNIVERSAL_AREA]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UNIVERSAL_AREA](
	[Universal_Area_Name] [varchar](60) NOT NULL,
	[Area_Weight] [float] NULL,
	[Comments] [varchar](2000) NULL,
	[Universal_Area_Number] [int] IDENTITY(43,1) NOT NULL,
 CONSTRAINT [UNIVERSAL_AREA_PK] PRIMARY KEY CLUSTERED 
(
	[Universal_Area_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[UNIVERSAL_AREA] ON 

INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Access Control', 1, NULL, 6)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Audit & Accountability', 4, NULL, 7)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Configuration Management', 2, NULL, 8)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Contingency Planning', 4, NULL, 10)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Continuous Assessment', 3, NULL, 39)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Critical Cyber Assets', 1, NULL, 30)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Data Loss', 4, NULL, 42)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Defense in Depth', 1, NULL, 33)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Electronic Security Perimeters', 1, NULL, 23)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Enclave & Computing Environment', 1, NULL, 31)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Encryption', 3, NULL, 21)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Firewall', 2, NULL, 26)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Hardware Inventory', 2, NULL, 36)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Identification & Authentication', 1, NULL, 11)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Incident Response', 4, NULL, 4)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Information & Document Management', 3, NULL, 14)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Maintenance', 2, NULL, 22)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Media Protection', 1, NULL, 16)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Monitoring & Reviewing System', 3, NULL, 19)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Need to Know', 1, NULL, 38)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Network Architecture', 1, NULL, 25)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Organizational Security', 2, NULL, 24)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Personnel Security', 1, NULL, 2)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Physical & Environmental Security', 1, NULL, 3)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Ports, Protocols & Services', 1, NULL, 40)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Program Management Controls', 3, NULL, 28)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Resource Utilization', 4, NULL, 35)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Risk Assessement', 3, NULL, 29)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Risk Mangement & Assessement', 3, NULL, 20)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Security Assessment & Authorization', 4, NULL, 27)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Security Awareness & Trainning', 1, NULL, 15)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Security Management', 3, NULL, 34)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Security Policy & Procedures', 2, NULL, 12)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Security Program Management', 3, NULL, 17)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Software Inventory', 2, NULL, 37)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Strategic Planning', 2, NULL, 9)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'System & Communication Protection', 1, NULL, 5)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'System & Information Integrity', 2, NULL, 1)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'System & Services Acquisition', 3, NULL, 13)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'System Development & Maintenance', 2, NULL, 18)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'System Hardening', 1, NULL, 32)
INSERT [dbo].[UNIVERSAL_AREA] ([Universal_Area_Name], [Area_Weight], [Comments], [Universal_Area_Number]) VALUES (N'Wireless Devices', 2, NULL, 41)
SET IDENTITY_INSERT [dbo].[UNIVERSAL_AREA] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Universal Area Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_AREA', @level2type=N'COLUMN',@level2name=N'Universal_Area_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Area Weight is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_AREA', @level2type=N'COLUMN',@level2name=N'Area_Weight'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Comments is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_AREA', @level2type=N'COLUMN',@level2name=N'Comments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Universal Area Number is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_AREA', @level2type=N'COLUMN',@level2name=N'Universal_Area_Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Universal Area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UNIVERSAL_AREA'
GO
