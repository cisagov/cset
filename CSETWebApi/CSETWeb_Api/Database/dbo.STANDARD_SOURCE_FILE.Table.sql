USE [CSETWeb]
GO
/****** Object:  Table [dbo].[STANDARD_SOURCE_FILE]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STANDARD_SOURCE_FILE](
	[Set_Name] [varchar](50) NOT NULL,
	[Doc_Num] [varchar](40) NOT NULL,
 CONSTRAINT [PK_Standard_Source_File] PRIMARY KEY CLUSTERED 
(
	[Set_Name] ASC,
	[Doc_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'C800_53_R3', N'NIST SP800-53 R3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'C800_53_R3_App_I', N'NIST SP800-53 R3 App I')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'C800_82', N'SP800-82')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Cfats', N'CFATS')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Key', N'COR 7')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-002-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-003-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-004-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-005-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-006-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-007-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-008-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R3', N'Standard CIP-009-3')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP002-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP003-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP004-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP005-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP006-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP007-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP008-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nerc_Cip_R4', N'NERC CIP009-4')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Nrc_571', N'NRC RG 5.71')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Tsa', N'TSA')
INSERT [dbo].[STANDARD_SOURCE_FILE] ([Set_Name], [Doc_Num]) VALUES (N'Universal', N'COR 7')
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE]  WITH NOCHECK ADD  CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS] FOREIGN KEY([Doc_Num])
REFERENCES [dbo].[FILE_REF_KEYS] ([Doc_Num])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS]
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE]  WITH NOCHECK ADD  CONSTRAINT [FK_Standard_Source_File_SETS] FOREIGN KEY([Set_Name])
REFERENCES [dbo].[SETS] ([Set_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_SETS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Set Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SOURCE_FILE', @level2type=N'COLUMN',@level2name=N'Set_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Doc Num is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SOURCE_FILE', @level2type=N'COLUMN',@level2name=N'Doc_Num'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SOURCE_FILE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'STANDARD_SOURCE_FILE'
GO
