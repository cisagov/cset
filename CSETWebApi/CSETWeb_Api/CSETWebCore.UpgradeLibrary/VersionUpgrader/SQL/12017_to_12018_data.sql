/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb12017    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb12018

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 4/26/2023 3:43:00 PM

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

PRINT(N'Drop constraints from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]

PRINT(N'Drop constraint FK_GALLERY_ROWS_GALLERY_LAYOUT from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_GALLERY_ROWS_GALLERY_GROUP from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]

PRINT(N'Drop constraint FK_Standard_Source_File_FILE_REF_KEYS from [dbo].[STANDARD_SOURCE_FILE]')
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] NOCHECK CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS]

PRINT(N'Delete rows from [dbo].[MATURITY_SOURCE_FILES]')
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9880 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-7'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9881 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9882 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-7'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9883 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9884 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9885 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9886 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9887 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9888 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9888 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9889 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.AM-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9890 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9891 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9892 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9893 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9894 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9894 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9895 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9895 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9895 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-5'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9896 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9896 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9897 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9897 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9898 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AT-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9899 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AT-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9899 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AT-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9899 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AT-5'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9900 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9901 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'DE.CM-8'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9901 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.RA-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9901 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-12'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9901 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'RS.MI-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9902 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'RS.AN-5'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9903 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'RS.AN-5'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9904 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9905 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9906 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.RA-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9906 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.RA-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9907 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.SC-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9908 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.SC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9908 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.SC-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9909 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.SC-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9909 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.SC-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9910 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'RS.CO-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9910 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'RS.CO-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9911 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-10'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9911 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-9'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9912 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9913 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.IP-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9914 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'DE.CM-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9914 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AC-5'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9914 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.PT-4'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9915 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'DE.CM-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9915 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.RA-3'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9916 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-1'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9916 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-2'
DELETE FROM [dbo].[MATURITY_SOURCE_FILES] WHERE [Mat_Question_Id] = 9916 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.DS-5'
PRINT(N'Operation applied to 58 rows out of 58')

PRINT(N'Update rows in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Nerc_Cip_R3"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '7481093d-eefa-423c-8479-025bb74d0d63'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["SP800-82 V2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '1d673e6f-ad89-41b3-a264-02b463139030'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["HLCIA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'a8c5b590-dee3-4851-8ec0-09f8898954ab'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CSC_V8_IG1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '22ae54d0-94a7-4c49-a2e4-0c9a3df0d312'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Standards"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'faab0432-6285-49f2-a837-0fe66fef4ffa'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R5"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'e4d8c03b-3a33-4f2d-bd72-160040aed1ba'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["TSA2018"],"SALLevel":"Low","QuestionMode":"Questions","HiddenScreens":["sal"]}' WHERE [Gallery_Item_Guid] = '7cf3a4a1-56b6-40ad-ac66-1b1ac936a356'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"ACET"}}' WHERE [Gallery_Item_Guid] = 'f8fa1cdc-63ac-4076-b00d-1f5dcb34e3a9'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["HIPAA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3218f866-7f61-4851-97c5-21e213a26b97'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"CPG"}}' WHERE [Gallery_Item_Guid] = 'edf05bdf-ed10-42c5-a147-2260a4ae5c16'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Dod"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '4fb4efe3-b792-4dfc-b20f-2406b06717f2'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Key"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'e7b895a9-a268-4baa-aa46-273319f2a730'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["PCIDSS"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'f4509fb7-1729-437b-a486-27d7df8c85a8'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NISTIR_7628"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '4ae6aedf-d3bc-4238-b0ee-285f00d55e02'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Nerc_Cip_R5"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '251080d8-9858-40fc-80e7-2e32c64c70a1'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["APTA_Rail_V1"],"SALLevel":"Low","QuestionMode":"Questions","HiddenScreens":["sal"]}' WHERE [Gallery_Item_Guid] = '3edb25dd-a1ff-4a0a-9762-33e4a0887ef5'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["RA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '5d692bd4-87d0-4a8c-ae77-3432f304a6e6'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R4_App_J"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'dcfcd4a1-5515-48fd-9789-36fb36d46806'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CSC_V8_IG2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'ca12d2be-11bb-40d6-bd4f-3def3db34f11'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cag"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'c67b4152-4083-48e7-9f8c-3f4baeb8e503'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CSC_V8_IG3"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '99935f8f-8216-43ae-8a14-40f7e2420ca5'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["DonvY2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '4c6c47f4-c649-4e84-b7d4-42dc77b17630'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"CMMC", "Level":1}}' WHERE [Gallery_Item_Guid] = '588b16e5-ae9a-435e-a6e3-441a7578d64a'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Wind_CERT"], "QuestionMode": "Requirements"}' WHERE [Gallery_Item_Guid] = 'a3b6d634-b149-41cf-a16f-4bb19db5e6c0'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["TSA2018"],"SALLevel":"Low","QuestionMode":"Questions","Model":{"ModelName":"VADR"}}' WHERE [Gallery_Item_Guid] = '2962cbbd-740a-4600-9262-4c3cf80eaa5a'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cnssi_Ics_Pit"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3cc7b809-207c-423b-b1b3-4f04cd586999'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CSC_V8"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '7ba9f3e0-825f-481a-af3b-50b12638eec5'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["FAA_MAINT"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '4ee4c330-5a4c-42f0-8584-5188edda4e95'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cfats"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '9ad60648-45c4-49a6-aff4-53230008e816'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"CIS"}}' WHERE [Gallery_Item_Guid] = '6580c6bb-d01f-4c05-97fa-53566d35e385'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"ISE"}}' WHERE [Gallery_Item_Guid] = '2f25c878-09ce-4c2b-b186-54d5ff2385c1'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["ISA_62443_4_1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '53699862-9ce4-415f-95d8-56246f69d4d1'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["RAC"]}' WHERE [Gallery_Item_Guid] = 'e528befe-348e-4b83-83e9-61d6d723214d'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CSC_V6"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '317a8213-7656-4d51-9031-6dd3b6d08135'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R4_71"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'ab9f36f9-b3c2-4c6c-ba60-6e82501d0b3c'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["ISA-62443"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'b9dca07b-887d-4aaa-aba6-806172581636'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_161"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3fe5f3fb-8a6b-48fd-9bcf-815eccae94cd'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NCSF_V1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '6ef7d8e3-cf6e-4a25-9f16-83b3ac569a53'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"ISE"}}' WHERE [Gallery_Item_Guid] = 'f2407ff1-9f0f-420b-8f86-8528b60fcbc1'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Nerc_Cip_R4"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'b1e9b990-7388-4d07-8113-8707a9ec729b'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cnssi_Ics_V1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '996aec03-0706-4087-bc80-873f2d6cbb11'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R3_App_I_old"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'b1abc503-08db-4110-b45b-8874ea090527'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R3_old"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '16a06476-1c35-42be-acbf-898e8e7e94ed'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NERC_CIP_R6"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '1991731e-26fc-4b99-a793-8d3dfe875383'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["APTA_Rail_V1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '8046f780-a288-45dd-9c77-92c20e3ae324'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R3"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '17ddca62-8e52-4f5c-8071-939349cea116'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Solar_CERT"], "QuestionMode": "Requirements"}' WHERE [Gallery_Item_Guid] = 'a013ce92-ffeb-4526-b5bc-93c6d74d9ce4'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Diagram":true,"SALLevel":"Low"}' WHERE [Gallery_Item_Guid] = '19913f37-44e2-4388-9754-9bc2eaa74d1b'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"VADR"}}' WHERE [Gallery_Item_Guid] = '1788b0d3-59c0-4b9d-aa0e-9f285876a16e'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["AWWA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3a17f36a-ec9c-4795-9c3f-9ff78c713466'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"CMMC2", "Level": 1}}' WHERE [Gallery_Item_Guid] = '6a463c71-fe29-4189-bd7d-a0b1712b582c'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["DonvY1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'e4ae8b43-37ad-47c9-8f65-a7abc3eb774e'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["FAA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '58ae1682-53b0-44d3-af02-a8bbc75af802'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NISTIR_7628_R1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'b03d1aee-9247-4160-8bd7-aa27682d1366'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Nrc_571"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '125811a5-004c-4020-925a-adf95351d3f7'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Universal"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'b81f1451-4138-4af4-b624-b130c2c9cea3'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cnssi_1253"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '2d38023d-c610-48ca-85c6-b21bbf53fd25'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C2M2_V11"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'fc53c0d6-881d-41b8-a49e-b375b36709ff'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"EDM"}}' WHERE [Gallery_Item_Guid] = '2f58295a-07f7-4a60-9a7b-b6c7f5b3c6c5'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CJIS_V5.8"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '98d5ecc2-01ba-4bba-a72b-be4b9f1c0dad'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"RRA"}}' WHERE [Gallery_Item_Guid] = '7d7bbb7b-14b5-4d20-8735-c667a9c99da7'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["CCI_V2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '5bd71393-883f-4546-8caa-c7535de9b167'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NCSF_V1"], "QuestionMode": "Requirements Only", "Model":{"ModelName":"RRA"}, "Origin":"CF"}' WHERE [Gallery_Item_Guid] = 'd0c19648-00f5-4215-af2d-c7ebd75fc578'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["DonvY3"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3b9f2073-7209-48d5-920b-c85c4b5fd0b5'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_82_V1"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'd002d9c0-949d-4446-a8e4-cb8fc1679944'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"MVRA"}}' WHERE [Gallery_Item_Guid] = 'fda63fec-80b9-4c97-8e07-ccd2f1dc58a6'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["FAA_PED_V2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '4929452f-a737-4afc-9778-ce8d550df305'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"CRR"}}' WHERE [Gallery_Item_Guid] = '33ee6e8e-f317-45c2-9a09-cff50226ca8d'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cor_7"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '6d705a92-5d8e-4865-aaea-d090570485c1'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R3_App_I"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '37e3c5ae-ff95-4dd7-a1da-d25c814abd74'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Tsa"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '7e650e05-b3c2-4b55-8830-d335ca41eeef'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Cnssi_1253_V2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '1766a7c4-0e16-491b-8580-d3f0641aa33c'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R5_V2"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'd7314c82-83b4-443c-a275-d5215a73220e'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["DODI_8510"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '446b8d52-16ba-4d18-afd4-d7431d501617'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["TSA2018"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '8f3f4431-3482-44c0-92c2-dccbb14dd8aa'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["Course_401"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'c4dcba19-9465-4a8e-b8c8-decd64092372'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["NEI_0809"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '62ecb9d1-d825-4b0e-85a9-e53823b468c2'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_171"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '5e48de28-156e-47df-9380-e72b482509e2'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Model":{"ModelName":"C2M2"}}' WHERE [Gallery_Item_Guid] = 'd752a1b1-9afe-44cb-b114-e7517339d776'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["DonvEY"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '3238a34e-e53d-4bf5-bcdd-ea17f0043e1f'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_53_R4"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'f7cf9b71-d8ef-4fd5-934f-ec94a0666b3c'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["C800_82"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = '2f798ad3-24ef-4329-9032-ef65faf0579a'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["HHS405d"]}' WHERE [Gallery_Item_Guid] = '9596a8ec-1ea5-4d7c-b303-f0fe419cc533'
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{"Sets":["INGAA"],"SALLevel":"Low","QuestionMode":"Questions"}' WHERE [Gallery_Item_Guid] = 'f1fe7bf3-ceb3-4b76-a684-f429abb8f1ae'
PRINT(N'Operation applied to 84 rows out of 84')

PRINT(N'Add row to [dbo].[FILE_REF_KEYS]')
INSERT INTO [dbo].[FILE_REF_KEYS] ([Doc_Num]) VALUES (N'CPG 1.0.1')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] ON
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (77, N'Popular Assessments')
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (78, N'Cyber SHIELD Assessments')
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (79, N'Diagram Architecture Based Assessments')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] OFF
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add rows to [dbo].[GALLERY_ITEM]')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('8b81d3b0-41a6-497e-aafa-144d4a722008', NULL, NULL, N'{"Sets": ["Wind_CERT"], "QuestionMode": "Requirements", "Diagram": true}', N'This assessment includes Wind-CERT questions and a network diagram.', NULL, N'Wind-CERT + Diagram', 1, '2023-04-12 12:00:00.000')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('79bb6d0b-b8bf-4610-9a76-8f1930d3881a', NULL, NULL, N'{"Model":{"ModelName":"HYDRO"}, "Diagram": true}', N'This assessment includes Hydropower Evaluation questions and a network diagram.', NULL, N'Hydropower Evaluation + Diagram', 1, '2023-04-12 12:00:00.000')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('73092076-db92-44f1-9967-93f602e94425', NULL, NULL, N'{"Sets":["Solar_CERT"], "QuestionMode": "Requirements", "Diagram": true}', N'This assessment includes Solar-CERT questions and a network diagram.', NULL, N'SCERT + Diagram', 1, '2023-04-12 12:00:00.000')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('31664fcc-60a4-4fa6-aadc-c81110740c12', NULL, NULL, N'{"Model":{"ModelName":"HYDRO"}}', N'Guidelines and best practices tailored for Utility Scale Hydroelectric plants. This cybersecurity evaluation is tuned to the Operational Technology systems, average cybersecurity program maturity level, and business practices typically supported by Utility connected Hydroelectric plant systems and is geared to help identify and understand the cyber risks for this type of user.', NULL, N'Hydropower Evaluation', 1, '2023-04-12 12:00:00.000')
PRINT(N'Operation applied to 4 rows out of 4')

PRINT(N'Add row to [dbo].[GALLERY_LAYOUT]')
INSERT INTO [dbo].[GALLERY_LAYOUT] ([Layout_Name]) VALUES (N'RENEW')

PRINT(N'Add rows to [dbo].[REQUIREMENT_QUESTIONS_SETS]')
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (69, N'CSC_V8_IG1', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (69, N'CSC_V8_IG2', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (69, N'CSC_V8_IG3', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (1235, N'CSC_V8_IG1', 31271)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (1235, N'CSC_V8_IG2', 31271)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (1235, N'CSC_V8_IG3', 31271)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (1875, N'CSC_V8_IG2', 31341)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (1875, N'CSC_V8_IG3', 31341)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3244, N'CSC_V8_IG2', 31336)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3244, N'CSC_V8_IG3', 31336)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3591, N'CSC_V8_IG1', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3591, N'CSC_V8_IG2', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3591, N'CSC_V8_IG3', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3832, N'CSC_V8_IG2', 31320)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (3832, N'CSC_V8_IG3', 31320)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5006, N'CSC_V8_IG3', 31197)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5007, N'CSC_V8_IG2', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5007, N'CSC_V8_IG3', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5008, N'CSC_V8_IG2', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5008, N'CSC_V8_IG3', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5010, N'CSC_V8_IG1', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5010, N'CSC_V8_IG2', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5010, N'CSC_V8_IG3', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5012, N'CSC_V8_IG3', 31299)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5039, N'CSC_V8_IG1', 31247)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5039, N'CSC_V8_IG2', 31247)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5039, N'CSC_V8_IG3', 31247)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5053, N'CSC_V8_IG3', 31290)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5055, N'CSC_V8_IG2', 31255)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5055, N'CSC_V8_IG3', 31255)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5062, N'CSC_V8_IG2', 31291)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5062, N'CSC_V8_IG3', 31291)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5063, N'CSC_V8_IG1', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5063, N'CSC_V8_IG2', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5063, N'CSC_V8_IG3', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5064, N'CSC_V8_IG2', 31267)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5064, N'CSC_V8_IG3', 31267)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5069, N'CSC_V8_IG2', 31266)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5069, N'CSC_V8_IG3', 31266)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5072, N'CSC_V8_IG2', 31268)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5072, N'CSC_V8_IG3', 31268)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5073, N'CSC_V8_IG2', 31269)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5073, N'CSC_V8_IG3', 31269)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5078, N'CSC_V8_IG1', 31273)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5078, N'CSC_V8_IG2', 31273)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5078, N'CSC_V8_IG3', 31273)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5079, N'CSC_V8_IG2', 31274)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5079, N'CSC_V8_IG3', 31274)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5080, N'CSC_V8_IG2', 31275)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5080, N'CSC_V8_IG3', 31275)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5084, N'CSC_V8_IG1', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5084, N'CSC_V8_IG2', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5084, N'CSC_V8_IG3', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5089, N'CSC_V8_IG1', 31222)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5089, N'CSC_V8_IG2', 31222)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5089, N'CSC_V8_IG3', 31222)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5091, N'CSC_V8_IG1', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5091, N'CSC_V8_IG2', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5091, N'CSC_V8_IG3', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5111, N'CSC_V8_IG3', 31300)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5123, N'CSC_V8_IG3', 31217)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5132, N'CSC_V8_IG3', 31218)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5146, N'CSC_V8_IG1', 31238)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5146, N'CSC_V8_IG2', 31238)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5146, N'CSC_V8_IG3', 31238)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5149, N'CSC_V8_IG1', 31233)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5149, N'CSC_V8_IG2', 31233)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5149, N'CSC_V8_IG3', 31233)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5151, N'CSC_V8_IG2', 31228)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5151, N'CSC_V8_IG3', 31228)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5162, N'CSC_V8_IG1', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5162, N'CSC_V8_IG2', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5162, N'CSC_V8_IG3', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5174, N'CSC_V8_IG2', 31325)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5174, N'CSC_V8_IG3', 31325)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5175, N'CSC_V8_IG2', 31324)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5175, N'CSC_V8_IG3', 31324)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5176, N'CSC_V8_IG2', 31318)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5176, N'CSC_V8_IG3', 31318)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5205, N'CSC_V8_IG1', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5205, N'CSC_V8_IG2', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5205, N'CSC_V8_IG3', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5206, N'CSC_V8_IG1', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5206, N'CSC_V8_IG2', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5206, N'CSC_V8_IG3', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5207, N'CSC_V8_IG1', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5207, N'CSC_V8_IG2', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5207, N'CSC_V8_IG3', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5212, N'CSC_V8_IG1', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5212, N'CSC_V8_IG2', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5212, N'CSC_V8_IG3', 31302)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5213, N'CSC_V8_IG1', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5213, N'CSC_V8_IG2', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (5213, N'CSC_V8_IG3', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9723, N'CSC_V8_IG3', 31244)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9791, N'CSC_V8_IG1', 31234)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9791, N'CSC_V8_IG2', 31234)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9791, N'CSC_V8_IG3', 31234)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9879, N'CSC_V8_IG2', 31310)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9879, N'CSC_V8_IG3', 31310)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9958, N'CSC_V8_IG2', 31255)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (9958, N'CSC_V8_IG3', 31255)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10057, N'CSC_V8_IG1', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10057, N'CSC_V8_IG2', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10057, N'CSC_V8_IG3', 31219)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10132, N'CSC_V8_IG1', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10132, N'CSC_V8_IG2', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10132, N'CSC_V8_IG3', 31193)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10330, N'CSC_V8_IG2', 31335)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10330, N'CSC_V8_IG3', 31335)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10722, N'CSC_V8_IG2', 31251)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10722, N'CSC_V8_IG3', 31251)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10783, N'CSC_V8_IG2', 31327)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (10783, N'CSC_V8_IG3', 31327)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11011, N'CSC_V8_IG2', 31276)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11011, N'CSC_V8_IG3', 31276)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11022, N'CSC_V8_IG1', 31194)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11022, N'CSC_V8_IG2', 31194)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11022, N'CSC_V8_IG3', 31194)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11138, N'CSC_V8_IG3', 31331)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11218, N'CSC_V8_IG1', 31221)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11218, N'CSC_V8_IG2', 31221)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (11218, N'CSC_V8_IG3', 31221)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12279, N'CSC_V8_IG3', 31244)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12373, N'CSC_V8_IG2', 31314)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12373, N'CSC_V8_IG3', 31314)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12490, N'CSC_V8_IG3', 31330)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12493, N'CSC_V8_IG2', 31342)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (12493, N'CSC_V8_IG3', 31342)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15747, N'CSC_V8_IG2', 31229)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15747, N'CSC_V8_IG3', 31229)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15916, N'CSC_V8_IG2', 31338)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15916, N'CSC_V8_IG3', 31338)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15995, N'CSC_V8_IG1', 31303)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15995, N'CSC_V8_IG2', 31303)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (15995, N'CSC_V8_IG3', 31303)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (16504, N'CSC_V8_IG1', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (16504, N'CSC_V8_IG2', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (16504, N'CSC_V8_IG3', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17401, N'CSC_V8_IG2', 31195)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17401, N'CSC_V8_IG3', 31195)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17402, N'CSC_V8_IG2', 31195)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17402, N'CSC_V8_IG3', 31195)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17403, N'CSC_V8_IG2', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17403, N'CSC_V8_IG3', 31196)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17404, N'CSC_V8_IG3', 31197)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17405, N'CSC_V8_IG1', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17405, N'CSC_V8_IG2', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17405, N'CSC_V8_IG3', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17406, N'CSC_V8_IG1', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17406, N'CSC_V8_IG2', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17406, N'CSC_V8_IG3', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17407, N'CSC_V8_IG1', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17407, N'CSC_V8_IG2', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17407, N'CSC_V8_IG3', 31198)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17408, N'CSC_V8_IG1', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17408, N'CSC_V8_IG2', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17408, N'CSC_V8_IG3', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17409, N'CSC_V8_IG1', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17409, N'CSC_V8_IG2', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17409, N'CSC_V8_IG3', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17410, N'CSC_V8_IG1', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17410, N'CSC_V8_IG2', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17410, N'CSC_V8_IG3', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17411, N'CSC_V8_IG1', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17411, N'CSC_V8_IG2', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17411, N'CSC_V8_IG3', 31199)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17412, N'CSC_V8_IG1', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17412, N'CSC_V8_IG2', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17412, N'CSC_V8_IG3', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17413, N'CSC_V8_IG1', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17413, N'CSC_V8_IG2', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17413, N'CSC_V8_IG3', 31200)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17414, N'CSC_V8_IG2', 31201)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17414, N'CSC_V8_IG3', 31201)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17415, N'CSC_V8_IG2', 31202)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17415, N'CSC_V8_IG3', 31202)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17416, N'CSC_V8_IG2', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17416, N'CSC_V8_IG3', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17417, N'CSC_V8_IG2', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17417, N'CSC_V8_IG3', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17418, N'CSC_V8_IG2', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17418, N'CSC_V8_IG3', 31203)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17419, N'CSC_V8_IG3', 31204)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17420, N'CSC_V8_IG3', 31204)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17421, N'CSC_V8_IG3', 31204)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17422, N'CSC_V8_IG1', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17422, N'CSC_V8_IG2', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17422, N'CSC_V8_IG3', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17423, N'CSC_V8_IG1', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17423, N'CSC_V8_IG2', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17423, N'CSC_V8_IG3', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17424, N'CSC_V8_IG1', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17424, N'CSC_V8_IG2', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17424, N'CSC_V8_IG3', 31205)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17425, N'CSC_V8_IG1', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17425, N'CSC_V8_IG2', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17425, N'CSC_V8_IG3', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17426, N'CSC_V8_IG1', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17426, N'CSC_V8_IG2', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17426, N'CSC_V8_IG3', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17427, N'CSC_V8_IG1', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17427, N'CSC_V8_IG2', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17427, N'CSC_V8_IG3', 31206)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17428, N'CSC_V8_IG1', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17428, N'CSC_V8_IG2', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17428, N'CSC_V8_IG3', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17429, N'CSC_V8_IG1', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17429, N'CSC_V8_IG2', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17429, N'CSC_V8_IG3', 31207)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17430, N'CSC_V8_IG1', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17430, N'CSC_V8_IG2', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17430, N'CSC_V8_IG3', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17431, N'CSC_V8_IG1', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17431, N'CSC_V8_IG2', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17431, N'CSC_V8_IG3', 31208)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17432, N'CSC_V8_IG1', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17432, N'CSC_V8_IG2', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17432, N'CSC_V8_IG3', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17433, N'CSC_V8_IG1', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17433, N'CSC_V8_IG2', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17433, N'CSC_V8_IG3', 31209)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17434, N'CSC_V8_IG1', 31210)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17434, N'CSC_V8_IG2', 31210)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17434, N'CSC_V8_IG3', 31210)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17435, N'CSC_V8_IG2', 31211)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17435, N'CSC_V8_IG3', 31211)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17436, N'CSC_V8_IG2', 31211)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17436, N'CSC_V8_IG3', 31211)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17437, N'CSC_V8_IG2', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17437, N'CSC_V8_IG3', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17438, N'CSC_V8_IG2', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17438, N'CSC_V8_IG3', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17439, N'CSC_V8_IG2', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17439, N'CSC_V8_IG3', 31212)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17440, N'CSC_V8_IG2', 31213)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17440, N'CSC_V8_IG3', 31213)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17441, N'CSC_V8_IG2', 31214)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17441, N'CSC_V8_IG3', 31214)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17442, N'CSC_V8_IG2', 31215)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17442, N'CSC_V8_IG3', 31215)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17443, N'CSC_V8_IG2', 31216)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17443, N'CSC_V8_IG3', 31216)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17444, N'CSC_V8_IG1', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17444, N'CSC_V8_IG2', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17444, N'CSC_V8_IG3', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17445, N'CSC_V8_IG1', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17445, N'CSC_V8_IG2', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17445, N'CSC_V8_IG3', 31220)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17446, N'CSC_V8_IG1', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17446, N'CSC_V8_IG2', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17446, N'CSC_V8_IG3', 31223)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17447, N'CSC_V8_IG1', 31225)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17447, N'CSC_V8_IG2', 31225)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17447, N'CSC_V8_IG3', 31225)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17448, N'CSC_V8_IG2', 31226)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17448, N'CSC_V8_IG3', 31226)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17449, N'CSC_V8_IG2', 31227)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17449, N'CSC_V8_IG3', 31227)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17450, N'CSC_V8_IG3', 31230)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17451, N'CSC_V8_IG1', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17451, N'CSC_V8_IG2', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17451, N'CSC_V8_IG3', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17452, N'CSC_V8_IG1', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17452, N'CSC_V8_IG2', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17452, N'CSC_V8_IG3', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17453, N'CSC_V8_IG1', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17453, N'CSC_V8_IG2', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17453, N'CSC_V8_IG3', 31231)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17454, N'CSC_V8_IG1', 31232)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17454, N'CSC_V8_IG2', 31232)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17454, N'CSC_V8_IG3', 31232)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17455, N'CSC_V8_IG2', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17455, N'CSC_V8_IG3', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17456, N'CSC_V8_IG2', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17456, N'CSC_V8_IG3', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17457, N'CSC_V8_IG2', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17457, N'CSC_V8_IG3', 31235)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17458, N'CSC_V8_IG2', 31236)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17458, N'CSC_V8_IG3', 31236)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17459, N'CSC_V8_IG1', 31237)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17459, N'CSC_V8_IG2', 31237)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17459, N'CSC_V8_IG3', 31237)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17460, N'CSC_V8_IG1', 31239)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17460, N'CSC_V8_IG2', 31239)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17460, N'CSC_V8_IG3', 31239)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17461, N'CSC_V8_IG1', 31240)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17461, N'CSC_V8_IG2', 31240)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17461, N'CSC_V8_IG3', 31240)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17462, N'CSC_V8_IG1', 31241)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17462, N'CSC_V8_IG2', 31241)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17462, N'CSC_V8_IG3', 31241)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17463, N'CSC_V8_IG2', 31242)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17463, N'CSC_V8_IG3', 31242)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17464, N'CSC_V8_IG2', 31242)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17464, N'CSC_V8_IG3', 31242)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17465, N'CSC_V8_IG2', 31243)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17465, N'CSC_V8_IG3', 31243)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17466, N'CSC_V8_IG1', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17466, N'CSC_V8_IG2', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17466, N'CSC_V8_IG3', 31245)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17467, N'CSC_V8_IG1', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17467, N'CSC_V8_IG2', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17467, N'CSC_V8_IG3', 31246)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17468, N'CSC_V8_IG2', 31249)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17468, N'CSC_V8_IG3', 31249)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17469, N'CSC_V8_IG2', 31250)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17469, N'CSC_V8_IG3', 31250)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17470, N'CSC_V8_IG1', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17470, N'CSC_V8_IG2', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17470, N'CSC_V8_IG3', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17471, N'CSC_V8_IG1', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17471, N'CSC_V8_IG2', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17471, N'CSC_V8_IG3', 31252)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17472, N'CSC_V8_IG1', 31253)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17472, N'CSC_V8_IG2', 31253)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17472, N'CSC_V8_IG3', 31253)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17473, N'CSC_V8_IG1', 31254)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17473, N'CSC_V8_IG2', 31254)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17473, N'CSC_V8_IG3', 31254)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17474, N'CSC_V8_IG2', 31256)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17474, N'CSC_V8_IG3', 31256)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17475, N'CSC_V8_IG2', 31256)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17475, N'CSC_V8_IG3', 31256)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17476, N'CSC_V8_IG2', 31257)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17476, N'CSC_V8_IG3', 31257)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17477, N'CSC_V8_IG2', 31258)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17477, N'CSC_V8_IG3', 31258)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17478, N'CSC_V8_IG2', 31259)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17478, N'CSC_V8_IG3', 31259)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17479, N'CSC_V8_IG2', 31260)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17479, N'CSC_V8_IG3', 31260)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17480, N'CSC_V8_IG2', 31261)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17480, N'CSC_V8_IG3', 31261)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17481, N'CSC_V8_IG2', 31262)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17481, N'CSC_V8_IG3', 31262)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17482, N'CSC_V8_IG3', 31263)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17483, N'CSC_V8_IG1', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17483, N'CSC_V8_IG2', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17483, N'CSC_V8_IG3', 31264)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17484, N'CSC_V8_IG1', 31265)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17484, N'CSC_V8_IG2', 31265)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17484, N'CSC_V8_IG3', 31265)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17485, N'CSC_V8_IG3', 31270)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17486, N'CSC_V8_IG1', 31272)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17486, N'CSC_V8_IG2', 31272)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17486, N'CSC_V8_IG3', 31272)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17487, N'CSC_V8_IG2', 31277)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17487, N'CSC_V8_IG3', 31277)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17488, N'CSC_V8_IG1', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17488, N'CSC_V8_IG2', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17488, N'CSC_V8_IG3', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17489, N'CSC_V8_IG1', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17489, N'CSC_V8_IG2', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17489, N'CSC_V8_IG3', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17490, N'CSC_V8_IG1', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17490, N'CSC_V8_IG2', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17490, N'CSC_V8_IG3', 31278)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17491, N'CSC_V8_IG1', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17491, N'CSC_V8_IG2', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17491, N'CSC_V8_IG3', 31279)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17492, N'CSC_V8_IG1', 31280)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17492, N'CSC_V8_IG2', 31280)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17492, N'CSC_V8_IG3', 31280)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17493, N'CSC_V8_IG1', 31281)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17493, N'CSC_V8_IG2', 31281)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17493, N'CSC_V8_IG3', 31281)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17494, N'CSC_V8_IG2', 31282)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17494, N'CSC_V8_IG3', 31282)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17495, N'CSC_V8_IG1', 31283)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17495, N'CSC_V8_IG2', 31283)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17495, N'CSC_V8_IG3', 31283)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17496, N'CSC_V8_IG2', 31284)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17496, N'CSC_V8_IG3', 31284)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17497, N'CSC_V8_IG2', 31284)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17497, N'CSC_V8_IG3', 31284)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17498, N'CSC_V8_IG2', 31285)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17498, N'CSC_V8_IG3', 31285)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17499, N'CSC_V8_IG2', 31286)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17499, N'CSC_V8_IG3', 31286)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17500, N'CSC_V8_IG2', 31286)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17500, N'CSC_V8_IG3', 31286)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17501, N'CSC_V8_IG2', 31287)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17501, N'CSC_V8_IG3', 31287)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17502, N'CSC_V8_IG2', 31288)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17502, N'CSC_V8_IG3', 31288)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17503, N'CSC_V8_IG2', 31289)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17503, N'CSC_V8_IG3', 31289)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17504, N'CSC_V8_IG3', 31290)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17505, N'CSC_V8_IG2', 31294)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17505, N'CSC_V8_IG3', 31294)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17506, N'CSC_V8_IG2', 31295)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17506, N'CSC_V8_IG3', 31295)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17507, N'CSC_V8_IG2', 31295)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17507, N'CSC_V8_IG3', 31295)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17508, N'CSC_V8_IG2', 31296)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17508, N'CSC_V8_IG3', 31296)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17509, N'CSC_V8_IG3', 31297)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17510, N'CSC_V8_IG3', 31301)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17511, N'CSC_V8_IG1', 31304)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17511, N'CSC_V8_IG2', 31304)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17511, N'CSC_V8_IG3', 31304)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17512, N'CSC_V8_IG1', 31305)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17512, N'CSC_V8_IG2', 31305)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17512, N'CSC_V8_IG3', 31305)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17513, N'CSC_V8_IG1', 31306)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17513, N'CSC_V8_IG2', 31306)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17513, N'CSC_V8_IG3', 31306)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17514, N'CSC_V8_IG1', 31307)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17514, N'CSC_V8_IG2', 31307)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17514, N'CSC_V8_IG3', 31307)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17515, N'CSC_V8_IG1', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17515, N'CSC_V8_IG2', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17515, N'CSC_V8_IG3', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17516, N'CSC_V8_IG1', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17516, N'CSC_V8_IG2', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17516, N'CSC_V8_IG3', 31308)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17517, N'CSC_V8_IG1', 31309)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17517, N'CSC_V8_IG2', 31309)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17517, N'CSC_V8_IG3', 31309)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17518, N'CSC_V8_IG1', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17518, N'CSC_V8_IG2', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17518, N'CSC_V8_IG3', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17519, N'CSC_V8_IG1', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17519, N'CSC_V8_IG2', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17519, N'CSC_V8_IG3', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17520, N'CSC_V8_IG1', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17520, N'CSC_V8_IG2', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17520, N'CSC_V8_IG3', 31311)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17521, N'CSC_V8_IG2', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17521, N'CSC_V8_IG3', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17522, N'CSC_V8_IG2', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17522, N'CSC_V8_IG3', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17523, N'CSC_V8_IG2', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17523, N'CSC_V8_IG3', 31312)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17524, N'CSC_V8_IG2', 31313)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17524, N'CSC_V8_IG3', 31313)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17525, N'CSC_V8_IG2', 31313)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17525, N'CSC_V8_IG3', 31313)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17526, N'CSC_V8_IG3', 31315)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17527, N'CSC_V8_IG3', 31315)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17528, N'CSC_V8_IG3', 31316)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17529, N'CSC_V8_IG3', 31317)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17530, N'CSC_V8_IG2', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17530, N'CSC_V8_IG3', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17531, N'CSC_V8_IG2', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17531, N'CSC_V8_IG3', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17532, N'CSC_V8_IG2', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17532, N'CSC_V8_IG3', 31319)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17533, N'CSC_V8_IG2', 31321)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17533, N'CSC_V8_IG3', 31321)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17534, N'CSC_V8_IG2', 31321)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17534, N'CSC_V8_IG3', 31321)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17535, N'CSC_V8_IG2', 31322)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17535, N'CSC_V8_IG3', 31322)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17536, N'CSC_V8_IG2', 31322)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17536, N'CSC_V8_IG3', 31322)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17537, N'CSC_V8_IG2', 31323)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17537, N'CSC_V8_IG3', 31323)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17538, N'CSC_V8_IG2', 31323)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17538, N'CSC_V8_IG3', 31323)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17539, N'CSC_V8_IG2', 31328)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17539, N'CSC_V8_IG3', 31328)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17540, N'CSC_V8_IG3', 31329)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17541, N'CSC_V8_IG1', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17541, N'CSC_V8_IG2', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17541, N'CSC_V8_IG3', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17542, N'CSC_V8_IG1', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17542, N'CSC_V8_IG2', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17542, N'CSC_V8_IG3', 31332)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17543, N'CSC_V8_IG1', 31333)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17543, N'CSC_V8_IG2', 31333)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17543, N'CSC_V8_IG3', 31333)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17544, N'CSC_V8_IG1', 31334)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17544, N'CSC_V8_IG2', 31334)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17544, N'CSC_V8_IG3', 31334)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17545, N'CSC_V8_IG2', 31335)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17545, N'CSC_V8_IG3', 31335)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17546, N'CSC_V8_IG2', 31336)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17546, N'CSC_V8_IG3', 31336)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17547, N'CSC_V8_IG2', 31337)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17547, N'CSC_V8_IG3', 31337)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17548, N'CSC_V8_IG2', 31337)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17548, N'CSC_V8_IG3', 31337)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17549, N'CSC_V8_IG2', 31338)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17549, N'CSC_V8_IG3', 31338)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17550, N'CSC_V8_IG2', 31339)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17550, N'CSC_V8_IG3', 31339)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17551, N'CSC_V8_IG3', 31340)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17552, N'CSC_V8_IG3', 31340)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17553, N'CSC_V8_IG2', 31343)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17553, N'CSC_V8_IG3', 31343)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17554, N'CSC_V8_IG3', 31344)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17555, N'CSC_V8_IG3', 31345)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17556, N'CSC_V8_IG1', 31224)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17556, N'CSC_V8_IG2', 31224)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17556, N'CSC_V8_IG3', 31224)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17557, N'CSC_V8_IG2', 31292)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17557, N'CSC_V8_IG3', 31292)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17558, N'CSC_V8_IG2', 31293)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17558, N'CSC_V8_IG3', 31293)
INSERT INTO [dbo].[REQUIREMENT_QUESTIONS_SETS] ([Question_Id], [Set_Name], [Requirement_Id]) VALUES (17559, N'CSC_V8_IG3', 31298)
PRINT(N'Operation applied to 502 rows out of 502')

PRINT(N'Add rows to [dbo].[REQUIREMENT_SETS]')
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31193, N'CSC_V8_IG1', 1)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31193, N'CSC_V8_IG2', 1)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31193, N'CSC_V8_IG3', 1)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31194, N'CSC_V8_IG1', 2)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31194, N'CSC_V8_IG2', 2)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31194, N'CSC_V8_IG3', 2)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31195, N'CSC_V8_IG2', 3)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31195, N'CSC_V8_IG3', 3)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31196, N'CSC_V8_IG2', 4)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31196, N'CSC_V8_IG3', 4)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31197, N'CSC_V8_IG3', 5)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31198, N'CSC_V8_IG1', 3)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31198, N'CSC_V8_IG2', 5)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31198, N'CSC_V8_IG3', 6)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31199, N'CSC_V8_IG1', 4)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31199, N'CSC_V8_IG2', 6)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31199, N'CSC_V8_IG3', 7)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31200, N'CSC_V8_IG1', 5)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31200, N'CSC_V8_IG2', 7)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31200, N'CSC_V8_IG3', 8)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31201, N'CSC_V8_IG2', 8)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31201, N'CSC_V8_IG3', 9)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31202, N'CSC_V8_IG2', 9)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31202, N'CSC_V8_IG3', 10)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31203, N'CSC_V8_IG2', 10)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31203, N'CSC_V8_IG3', 11)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31204, N'CSC_V8_IG3', 12)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31205, N'CSC_V8_IG1', 6)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31205, N'CSC_V8_IG2', 11)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31205, N'CSC_V8_IG3', 13)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31206, N'CSC_V8_IG1', 7)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31206, N'CSC_V8_IG2', 12)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31206, N'CSC_V8_IG3', 14)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31207, N'CSC_V8_IG1', 8)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31207, N'CSC_V8_IG2', 13)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31207, N'CSC_V8_IG3', 15)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31208, N'CSC_V8_IG1', 9)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31208, N'CSC_V8_IG2', 14)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31208, N'CSC_V8_IG3', 16)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31209, N'CSC_V8_IG1', 10)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31209, N'CSC_V8_IG2', 15)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31209, N'CSC_V8_IG3', 17)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31210, N'CSC_V8_IG1', 11)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31210, N'CSC_V8_IG2', 16)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31210, N'CSC_V8_IG3', 18)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31211, N'CSC_V8_IG2', 17)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31211, N'CSC_V8_IG3', 19)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31212, N'CSC_V8_IG2', 18)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31212, N'CSC_V8_IG3', 20)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31213, N'CSC_V8_IG2', 19)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31213, N'CSC_V8_IG3', 21)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31214, N'CSC_V8_IG2', 20)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31214, N'CSC_V8_IG3', 22)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31215, N'CSC_V8_IG2', 21)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31215, N'CSC_V8_IG3', 23)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31216, N'CSC_V8_IG2', 22)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31216, N'CSC_V8_IG3', 24)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31217, N'CSC_V8_IG3', 25)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31218, N'CSC_V8_IG3', 26)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31219, N'CSC_V8_IG1', 12)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31219, N'CSC_V8_IG2', 23)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31219, N'CSC_V8_IG3', 27)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31220, N'CSC_V8_IG1', 13)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31220, N'CSC_V8_IG2', 24)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31220, N'CSC_V8_IG3', 28)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31221, N'CSC_V8_IG1', 14)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31221, N'CSC_V8_IG2', 25)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31221, N'CSC_V8_IG3', 29)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31222, N'CSC_V8_IG1', 15)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31222, N'CSC_V8_IG2', 26)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31222, N'CSC_V8_IG3', 30)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31223, N'CSC_V8_IG1', 16)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31223, N'CSC_V8_IG2', 27)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31223, N'CSC_V8_IG3', 31)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31224, N'CSC_V8_IG1', 17)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31224, N'CSC_V8_IG2', 28)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31224, N'CSC_V8_IG3', 32)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31225, N'CSC_V8_IG1', 18)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31225, N'CSC_V8_IG2', 29)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31225, N'CSC_V8_IG3', 33)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31226, N'CSC_V8_IG2', 30)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31226, N'CSC_V8_IG3', 34)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31227, N'CSC_V8_IG2', 31)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31227, N'CSC_V8_IG3', 35)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31228, N'CSC_V8_IG2', 32)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31228, N'CSC_V8_IG3', 36)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31229, N'CSC_V8_IG2', 33)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31229, N'CSC_V8_IG3', 37)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31230, N'CSC_V8_IG3', 38)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31231, N'CSC_V8_IG1', 19)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31231, N'CSC_V8_IG2', 34)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31231, N'CSC_V8_IG3', 39)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31232, N'CSC_V8_IG1', 20)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31232, N'CSC_V8_IG2', 35)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31232, N'CSC_V8_IG3', 40)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31233, N'CSC_V8_IG1', 21)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31233, N'CSC_V8_IG2', 36)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31233, N'CSC_V8_IG3', 41)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31234, N'CSC_V8_IG1', 22)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31234, N'CSC_V8_IG2', 37)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31234, N'CSC_V8_IG3', 42)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31235, N'CSC_V8_IG2', 38)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31235, N'CSC_V8_IG3', 43)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31236, N'CSC_V8_IG2', 39)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31236, N'CSC_V8_IG3', 44)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31237, N'CSC_V8_IG1', 23)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31237, N'CSC_V8_IG2', 40)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31237, N'CSC_V8_IG3', 45)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31238, N'CSC_V8_IG1', 24)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31238, N'CSC_V8_IG2', 41)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31238, N'CSC_V8_IG3', 46)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31239, N'CSC_V8_IG1', 25)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31239, N'CSC_V8_IG2', 42)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31239, N'CSC_V8_IG3', 47)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31240, N'CSC_V8_IG1', 26)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31240, N'CSC_V8_IG2', 43)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31240, N'CSC_V8_IG3', 48)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31241, N'CSC_V8_IG1', 27)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31241, N'CSC_V8_IG2', 44)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31241, N'CSC_V8_IG3', 49)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31242, N'CSC_V8_IG2', 45)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31242, N'CSC_V8_IG3', 50)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31243, N'CSC_V8_IG2', 46)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31243, N'CSC_V8_IG3', 51)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31244, N'CSC_V8_IG3', 52)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31245, N'CSC_V8_IG1', 28)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31245, N'CSC_V8_IG2', 47)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31245, N'CSC_V8_IG3', 53)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31246, N'CSC_V8_IG1', 29)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31246, N'CSC_V8_IG2', 48)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31246, N'CSC_V8_IG3', 54)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31247, N'CSC_V8_IG1', 30)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31247, N'CSC_V8_IG2', 49)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31247, N'CSC_V8_IG3', 55)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31248, N'CSC_V8_IG1', 31)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31248, N'CSC_V8_IG2', 50)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31248, N'CSC_V8_IG3', 56)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31249, N'CSC_V8_IG2', 51)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31249, N'CSC_V8_IG3', 57)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31250, N'CSC_V8_IG2', 52)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31250, N'CSC_V8_IG3', 58)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31251, N'CSC_V8_IG2', 53)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31251, N'CSC_V8_IG3', 59)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31252, N'CSC_V8_IG1', 32)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31252, N'CSC_V8_IG2', 54)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31252, N'CSC_V8_IG3', 60)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31253, N'CSC_V8_IG1', 33)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31253, N'CSC_V8_IG2', 55)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31253, N'CSC_V8_IG3', 61)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31254, N'CSC_V8_IG1', 34)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31254, N'CSC_V8_IG2', 56)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31254, N'CSC_V8_IG3', 62)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31255, N'CSC_V8_IG2', 57)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31255, N'CSC_V8_IG3', 63)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31256, N'CSC_V8_IG2', 58)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31256, N'CSC_V8_IG3', 64)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31257, N'CSC_V8_IG2', 59)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31257, N'CSC_V8_IG3', 65)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31258, N'CSC_V8_IG2', 60)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31258, N'CSC_V8_IG3', 66)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31259, N'CSC_V8_IG2', 61)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31259, N'CSC_V8_IG3', 67)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31260, N'CSC_V8_IG2', 62)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31260, N'CSC_V8_IG3', 68)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31261, N'CSC_V8_IG2', 63)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31261, N'CSC_V8_IG3', 69)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31262, N'CSC_V8_IG2', 64)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31262, N'CSC_V8_IG3', 70)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31263, N'CSC_V8_IG3', 71)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31264, N'CSC_V8_IG1', 35)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31264, N'CSC_V8_IG2', 65)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31264, N'CSC_V8_IG3', 72)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31265, N'CSC_V8_IG1', 36)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31265, N'CSC_V8_IG2', 66)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31265, N'CSC_V8_IG3', 73)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31266, N'CSC_V8_IG2', 67)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31266, N'CSC_V8_IG3', 74)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31267, N'CSC_V8_IG2', 68)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31267, N'CSC_V8_IG3', 75)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31268, N'CSC_V8_IG2', 69)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31268, N'CSC_V8_IG3', 76)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31269, N'CSC_V8_IG2', 70)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31269, N'CSC_V8_IG3', 77)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31270, N'CSC_V8_IG3', 78)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31271, N'CSC_V8_IG1', 37)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31271, N'CSC_V8_IG2', 71)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31271, N'CSC_V8_IG3', 79)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31272, N'CSC_V8_IG1', 38)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31272, N'CSC_V8_IG2', 72)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31272, N'CSC_V8_IG3', 80)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31273, N'CSC_V8_IG1', 39)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31273, N'CSC_V8_IG2', 73)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31273, N'CSC_V8_IG3', 81)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31274, N'CSC_V8_IG2', 74)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31274, N'CSC_V8_IG3', 82)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31275, N'CSC_V8_IG2', 75)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31275, N'CSC_V8_IG3', 83)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31276, N'CSC_V8_IG2', 76)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31276, N'CSC_V8_IG3', 84)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31277, N'CSC_V8_IG2', 77)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31277, N'CSC_V8_IG3', 85)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31278, N'CSC_V8_IG1', 40)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31278, N'CSC_V8_IG2', 78)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31278, N'CSC_V8_IG3', 86)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31279, N'CSC_V8_IG1', 41)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31279, N'CSC_V8_IG2', 79)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31279, N'CSC_V8_IG3', 87)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31280, N'CSC_V8_IG1', 42)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31280, N'CSC_V8_IG2', 80)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31280, N'CSC_V8_IG3', 88)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31281, N'CSC_V8_IG1', 43)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31281, N'CSC_V8_IG2', 81)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31281, N'CSC_V8_IG3', 89)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31282, N'CSC_V8_IG2', 82)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31282, N'CSC_V8_IG3', 90)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31283, N'CSC_V8_IG1', 44)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31283, N'CSC_V8_IG2', 83)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31283, N'CSC_V8_IG3', 91)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31284, N'CSC_V8_IG2', 84)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31284, N'CSC_V8_IG3', 92)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31285, N'CSC_V8_IG2', 85)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31285, N'CSC_V8_IG3', 93)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31286, N'CSC_V8_IG2', 86)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31286, N'CSC_V8_IG3', 94)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31287, N'CSC_V8_IG2', 87)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31287, N'CSC_V8_IG3', 95)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31288, N'CSC_V8_IG2', 88)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31288, N'CSC_V8_IG3', 96)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31289, N'CSC_V8_IG2', 89)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31289, N'CSC_V8_IG3', 97)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31290, N'CSC_V8_IG3', 98)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31291, N'CSC_V8_IG2', 90)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31291, N'CSC_V8_IG3', 99)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31292, N'CSC_V8_IG2', 91)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31292, N'CSC_V8_IG3', 100)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31293, N'CSC_V8_IG2', 92)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31293, N'CSC_V8_IG3', 101)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31294, N'CSC_V8_IG2', 93)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31294, N'CSC_V8_IG3', 102)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31295, N'CSC_V8_IG2', 94)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31295, N'CSC_V8_IG3', 103)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31296, N'CSC_V8_IG2', 95)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31296, N'CSC_V8_IG3', 104)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31297, N'CSC_V8_IG3', 105)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31298, N'CSC_V8_IG3', 106)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31299, N'CSC_V8_IG3', 107)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31300, N'CSC_V8_IG3', 108)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31301, N'CSC_V8_IG3', 109)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31302, N'CSC_V8_IG1', 45)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31302, N'CSC_V8_IG2', 96)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31302, N'CSC_V8_IG3', 110)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31303, N'CSC_V8_IG1', 46)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31303, N'CSC_V8_IG2', 97)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31303, N'CSC_V8_IG3', 111)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31304, N'CSC_V8_IG1', 47)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31304, N'CSC_V8_IG2', 98)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31304, N'CSC_V8_IG3', 112)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31305, N'CSC_V8_IG1', 48)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31305, N'CSC_V8_IG2', 99)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31305, N'CSC_V8_IG3', 113)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31306, N'CSC_V8_IG1', 49)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31306, N'CSC_V8_IG2', 100)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31306, N'CSC_V8_IG3', 114)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31307, N'CSC_V8_IG1', 50)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31307, N'CSC_V8_IG2', 101)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31307, N'CSC_V8_IG3', 115)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31308, N'CSC_V8_IG1', 51)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31308, N'CSC_V8_IG2', 102)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31308, N'CSC_V8_IG3', 116)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31309, N'CSC_V8_IG1', 52)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31309, N'CSC_V8_IG2', 103)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31309, N'CSC_V8_IG3', 117)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31310, N'CSC_V8_IG2', 104)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31310, N'CSC_V8_IG3', 118)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31311, N'CSC_V8_IG1', 53)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31311, N'CSC_V8_IG2', 105)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31311, N'CSC_V8_IG3', 119)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31312, N'CSC_V8_IG2', 106)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31312, N'CSC_V8_IG3', 120)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31313, N'CSC_V8_IG2', 107)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31313, N'CSC_V8_IG3', 121)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31314, N'CSC_V8_IG2', 108)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31314, N'CSC_V8_IG3', 122)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31315, N'CSC_V8_IG3', 123)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31316, N'CSC_V8_IG3', 124)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31317, N'CSC_V8_IG3', 125)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31318, N'CSC_V8_IG2', 109)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31318, N'CSC_V8_IG3', 126)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31319, N'CSC_V8_IG2', 110)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31319, N'CSC_V8_IG3', 127)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31320, N'CSC_V8_IG2', 111)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31320, N'CSC_V8_IG3', 128)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31321, N'CSC_V8_IG2', 112)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31321, N'CSC_V8_IG3', 129)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31322, N'CSC_V8_IG2', 113)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31322, N'CSC_V8_IG3', 130)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31323, N'CSC_V8_IG2', 114)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31323, N'CSC_V8_IG3', 131)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31324, N'CSC_V8_IG2', 115)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31324, N'CSC_V8_IG3', 132)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31325, N'CSC_V8_IG2', 116)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31325, N'CSC_V8_IG3', 133)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31326, N'CSC_V8_IG2', 117)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31326, N'CSC_V8_IG3', 134)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31327, N'CSC_V8_IG2', 118)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31327, N'CSC_V8_IG3', 135)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31328, N'CSC_V8_IG2', 119)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31328, N'CSC_V8_IG3', 136)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31329, N'CSC_V8_IG3', 137)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31330, N'CSC_V8_IG3', 138)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31331, N'CSC_V8_IG3', 139)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31332, N'CSC_V8_IG1', 54)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31332, N'CSC_V8_IG2', 120)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31332, N'CSC_V8_IG3', 140)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31333, N'CSC_V8_IG1', 55)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31333, N'CSC_V8_IG2', 121)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31333, N'CSC_V8_IG3', 141)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31334, N'CSC_V8_IG1', 56)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31334, N'CSC_V8_IG2', 122)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31334, N'CSC_V8_IG3', 142)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31335, N'CSC_V8_IG2', 123)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31335, N'CSC_V8_IG3', 143)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31336, N'CSC_V8_IG2', 124)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31336, N'CSC_V8_IG3', 144)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31337, N'CSC_V8_IG2', 125)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31337, N'CSC_V8_IG3', 145)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31338, N'CSC_V8_IG2', 126)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31338, N'CSC_V8_IG3', 146)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31339, N'CSC_V8_IG2', 127)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31339, N'CSC_V8_IG3', 147)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31340, N'CSC_V8_IG3', 148)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31341, N'CSC_V8_IG2', 128)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31341, N'CSC_V8_IG3', 149)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31342, N'CSC_V8_IG2', 129)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31342, N'CSC_V8_IG3', 150)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31343, N'CSC_V8_IG2', 130)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31343, N'CSC_V8_IG3', 151)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31344, N'CSC_V8_IG3', 152)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31345, N'CSC_V8_IG3', 153)
PRINT(N'Operation applied to 339 rows out of 339')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (119, 79, 2, 0, '73092076-db92-44f1-9967-93f602e94425')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (120, 79, 3, 0, '8b81d3b0-41a6-497e-aafa-144d4a722008')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (121, 79, 4, 0, '79bb6d0b-b8bf-4610-9a76-8f1930d3881a')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (122, 78, 1, 0, 'a013ce92-ffeb-4526-b5bc-93c6d74d9ce4')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (123, 78, 2, 0, 'a3b6d634-b149-41cf-a16f-4bb19db5e6c0')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (124, 78, 3, 0, '31664fcc-60a4-4fa6-aadc-c81110740c12')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (2195, 77, 1, 0, '1991731e-26fc-4b99-a793-8d3dfe875383')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (2196, 77, 2, 0, 'd752a1b1-9afe-44cb-b114-e7517339d776')
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (2198, 79, 1, 0, '19913f37-44e2-4388-9754-9bc2eaa74d1b')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF
PRINT(N'Operation applied to 9 rows out of 9')

PRINT(N'Add row to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (256, 31, N'CISA_CPG_REPORT_v1.0.1_FINAL.pdf', N'CISA Cross-Sector Cybersecurity Performance Goals (CPG)', N'CISA CPGs v1.0.1', 0, N'CPG 1.0.1', N'', N'CISA CPGs v1.0.1', N'CISA CPGs v1.0.1', '2023-03-17 00:00:00.000', N'1', N'The CPGs are a prioritized subset of IT and OT cybersecurity
practices aimed at meaningfully reducing risks to both critical
infrastructure operations and the American people. These goals are
applicable across all critical infrastructure sectors and are informed by the
most common and impactful threats and adversary tactics, techniques,
and procedures (TTPs) observed by CISA and its government and industry
partners, making them a common set of protections that all critical
infrastructure entities — from large to small — should implement.', N'CISA', NULL, 0)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF

PRINT(N'Add rows to [dbo].[GEN_FILE_LIB_PATH_CORL]')
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (256, 421)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (256, 499)
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9880, 3866, N'PR.DS-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9880, 3866, N'PR.DS-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9881, 3866, N'PR.AC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9881, 3866, N'PR.PT-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9882, 3866, N'PR.AC-7', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9882, 3866, N'PR.DS-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9883, 3866, N'PR.AC-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9884, 3866, N'PR.AT-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9884, 3866, N'PR.AT-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9884, 3866, N'PR.AT-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9885, 3866, N'PR.AC-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9885, 3866, N'PR.AC-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9886, 3866, N'PR.AT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9887, 3866, N'PR.IP-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9888, 3866, N'PR.IP-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9888, 3866, N'PR.IP-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 3866, N'DE.CM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 3866, N'DE.CM-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 3866, N'ID.AM-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 3866, N'ID.AM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 3866, N'ID.AM-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9890, 3866, N'PR.PT-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9891, 3866, N'PR.IP-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9892, 3866, N'PR.PT-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9893, 3866, N'PR.PT-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9894, 3866, N'PR.DS-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9894, 3866, N'PR.DS-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9895, 3866, N'PR.AC-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9895, 3866, N'PR.IP-11', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9896, 3866, N'ID.GV-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9896, 3866, N'ID.GV-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9897, 3866, N'ID.GV-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9897, 3866, N'ID.GV-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9898, 3866, N'PR.AT-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9899, 3866, N'PR.AT-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9899, 3866, N'PR.AT-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9899, 3866, N'PR.AT-5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9900, 3866, N'ID.GV-2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9900, 3866, N'PR.AT-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'DE.CM-8', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'ID.RA-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'ID.RA-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'PR.IP-12', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'RS.AN-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 3866, N'RS.MI-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9902, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9902, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9903, 3866, N'RS.AN-5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9904, 3866, N'PR.AC-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9905, 3866, N'PR.AC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9905, 3866, N'PR.PT-4', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 3866, N'ID.RA-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 3866, N'ID.RA-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 3866, N'ID.RA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 3866, N'ID.RA-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 3866, N'ID.RA-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9907, 3866, N'ID.SC-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9908, 3866, N'ID.SC-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9908, 3866, N'ID.SC-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9909, 3866, N'ID.SC-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9909, 3866, N'ID.SC-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9910, 3866, N'RS.AN-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9911, 3866, N'PR.IP-10', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9911, 3866, N'PR.IP-9', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9912, 3866, N'PR.IP-4', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9913, 3866, N'ID.AM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9913, 3866, N'PR.IP-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9914, 3866, N'PR.DS-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9915, 3866, N'DE.CM-1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9915, 3866, N'ID.RA-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9915, 3866, N'ID.RA-3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9916, 3866, N'PR.AC-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9917, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9917, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9917, 3866, N'RC.RP-1', NULL, N'')
PRINT(N'Operation applied to 75 rows out of 75')

PRINT(N'Add rows to [dbo].[MATURITY_SOURCE_FILES]')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9880, 256, N'2.L', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9881, 256, N'2.F', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9882, 256, N'2.M', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9883, 256, N'2.G', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9884, 256, N'2.J', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9885, 256, N'2.H', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9886, 256, N'2.I', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9887, 256, N'2.Q', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9888, 256, N'2.N', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9889, 256, N'1.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9890, 256, N'2.V', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9891, 256, N'2.O', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9892, 256, N'2.T', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9893, 256, N'2.U', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9894, 256, N'2.C', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9895, 256, N'2.D', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9896, 256, N'1.B', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9897, 256, N'1.C', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9898, 256, N'2.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9899, 256, N'2.B', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9900, 256, N'1.D', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9901, 256, N'1.E', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9902, 256, N'4.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9903, 256, N'4.B', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9904, 256, N'2.W', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9905, 256, N'2.X', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9906, 256, N'1.F', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9907, 256, N'1.I', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9908, 256, N'1.G', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9909, 256, N'1.H', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9910, 256, N'4.C', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9911, 256, N'2.S', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9912, 256, N'2.R', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9913, 256, N'2.P', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9914, 256, N'2.K', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9915, 256, N'3.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9916, 256, N'2.E', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (9917, 256, N'5.A', NULL, N'')
PRINT(N'Operation applied to 38 rows out of 38')

PRINT(N'Add constraints to [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS]
COMMIT TRANSACTION
GO
