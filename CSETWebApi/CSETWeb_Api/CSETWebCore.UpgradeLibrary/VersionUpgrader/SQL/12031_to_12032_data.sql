/*
Run this script on:

(localdb)\INLLocalDb2022.CSETWeb12031    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDb2022.CSETWeb12032

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 9/20/2023 3:28:31 PM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION

PRINT(N'Disable DML triggers on [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] DISABLE TRIGGER [trg_update_maturity_groupings]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_GEN_FILE from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Delete rows from [dbo].[MATURITY_REFERENCES]')
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1352 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-2'
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1352 AND [Gen_File_Id] = 5014 AND [Section_Ref] = N'PE'
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1359 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-11'
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1359 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-3'
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1359 AND [Gen_File_Id] = 5014 AND [Section_Ref] = N'AC-2'
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 1371 AND [Gen_File_Id] = 5014 AND [Section_Ref] = N'2.4.4'
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Update rows in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Event Detection and Handling (EH)' WHERE [Grouping_Id] = 206
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Incident Declaration, Handling, and Response (IR)' WHERE [Grouping_Id] = 210
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Post-Incident Analysis and Testing (PI)' WHERE [Grouping_Id] = 215
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Integrate Organizational Capabilities (OC)' WHERE [Grouping_Id] = 218
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Protect and Sustain the Incident Management Function (PS)' WHERE [Grouping_Id] = 223
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Goal 1 - The Incident Management Function''s assets are protected and sustained.' WHERE [Grouping_Id] = 224
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Prepare for Incident Response (PR)' WHERE [Grouping_Id] = 226
PRINT(N'Operation applied to 7 rows out of 7')

PRINT(N'Add rows to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5073, 31, NULL, N'FIPS 200', NULL, NULL, N'NONE', NULL, NULL, N'FIPS 200', NULL, NULL, NULL, NULL, NULL, 1)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5074, 31, NULL, N'FIPS 199', NULL, NULL, N'NONE', NULL, NULL, N'FIPS 199', NULL, NULL, NULL, NULL, NULL, 1)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5075, 31, N'IMR-NIST-CSF-Crosswalk 20230915.pdf', N'IMR | NIST Cybersecurity Framework Crosswalks', NULL, NULL, N'NONE', NULL, NULL, N'IMR | NIST Cyber Security Framework Crosswalks', '2023-09-18 00:00:00.000', NULL, N'NIST Cybersecurity Framework (CSF) to Incident Management Review (IMR) Crosswalk', NULL, NULL, 1)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5076, 31, NULL, N'NIST SP 800-144', NULL, NULL, N'NONE', NULL, NULL, N'NIST SP 800-144', NULL, NULL, NULL, NULL, NULL, 1)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5077, 31, NULL, N'NIST SP 800-146', NULL, NULL, N'NONE', NULL, NULL, N'NIST SP 800-146', NULL, NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1291, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1292, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1298, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1299, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1301, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1302, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1304, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1305, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1306, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1308, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1309, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1310, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1311, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1313, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1314, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1316, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1318, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1319, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1323, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 3866, N'ID.GV-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1326, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 2602, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'RS.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'RS.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'RS.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1336, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1338, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1339, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1340, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1341, 3866, N'ID.RA-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1341, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1342, 2602, N'SI-5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1342, 3866, N'RS.AN-5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1342, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 2602, N'IR-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 5031, N'2.2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 2208, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 2602, N'CP-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 3866, N'PR.IP-9', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 5021, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 5031, N'2.4.4', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1344, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1345, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1346, 3866, N'RS.CO-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1346, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1348, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1350, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1351, 2602, N'SA-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1351, 3866, N'PR.IP-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1351, 5031, N'3.1.1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1351, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 2208, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 3866, N'ID.SC-5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 3866, N'PR.IP-9', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 5021, N'PE', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1353, 5073, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1353, 5074, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1353, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1355, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1358, 2602, N'CP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1358, 3866, N'PR.IP-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1358, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 2602, N'CP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 2602, N'CP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 3866, N'PR.IP-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1360, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1362, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1363, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1364, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1367, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1372, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 2424, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 2426, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 5073, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 5076, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 5077, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1374, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1375, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1377, 5075, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1378, 3866, N'PR.AT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1378, 5075, N'', NULL, NULL)
PRINT(N'Operation applied to 129 rows out of 129')

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Add DML triggers to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ENABLE TRIGGER [trg_update_maturity_groupings]
COMMIT TRANSACTION
GO
