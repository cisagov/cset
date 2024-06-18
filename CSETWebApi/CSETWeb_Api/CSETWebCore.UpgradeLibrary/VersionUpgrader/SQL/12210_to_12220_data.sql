/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12210    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12220

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/17/2024 2:15:18 PM

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

PRINT(N'Drop constraints from [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]

PRINT(N'Drop constraint FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT from [dbo].[FINANCIAL_REQUIREMENTS]')
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] NOCHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_NERC_RISK_RANKING_NEW_REQUIREMENT from [dbo].[NERC_RISK_RANKING]')
ALTER TABLE [dbo].[NERC_RISK_RANKING] NOCHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_Parameter_Requirements_NEW_REQUIREMENT from [dbo].[PARAMETER_REQUIREMENTS]')
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] NOCHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCE_TEXT]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Drop constraints from [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] NOCHECK CONSTRAINT [FK_SETS_Sets_Category]

PRINT(N'Drop constraint FK_AVAILABLE_STANDARDS_SETS from [dbo].[AVAILABLE_STANDARDS]')
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] NOCHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]

PRINT(N'Drop constraint FK_CUSTOM_STANDARD_BASE_STANDARD_SETS from [dbo].[CUSTOM_STANDARD_BASE_STANDARD]')
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] NOCHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]

PRINT(N'Drop constraint FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1 from [dbo].[CUSTOM_STANDARD_BASE_STANDARD]')
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] NOCHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]

PRINT(N'Drop constraint FK_MODES_MATURITY_MODELS_SETS from [dbo].[MODES_SETS_MATURITY_MODELS]')
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MODES_MATURITY_MODELS_SETS]

PRINT(N'Drop constraint FK_NEW_QUESTION_SETS_SETS from [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Drop constraint FK_REPORT_STANDARDS_SELECTION_SETS from [dbo].[REPORT_STANDARDS_SELECTION]')
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] NOCHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_SETS from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]

PRINT(N'Drop constraint FK_QUESTION_SETS_SETS from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_QUESTION_SETS_SETS]

PRINT(N'Drop constraint FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS from [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]')
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] NOCHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]

PRINT(N'Drop constraint FK_SET_FILES_SETS from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_SETS]

PRINT(N'Drop constraint FK_STANDARD_CATEGORY_SEQUENCE_SETS from [dbo].[STANDARD_CATEGORY_SEQUENCE]')
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] NOCHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]

PRINT(N'Drop constraint FK_Standard_Source_File_SETS from [dbo].[STANDARD_SOURCE_FILE]')
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] NOCHECK CONSTRAINT [FK_Standard_Source_File_SETS]

PRINT(N'Drop constraint FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS from [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]')
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] NOCHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]

PRINT(N'Drop constraints from [dbo].[REF_LIBRARY_PATH]')
ALTER TABLE [dbo].[REF_LIBRARY_PATH] NOCHECK CONSTRAINT [FK_REF_LIBRARY_PATH_REF_LIBRARY_PATH]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_GEN_FILE from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_GEN_FILE from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Delete rows from [dbo].[GEN_FILE_LIB_PATH_CORL]')
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 668 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 669 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 674 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2067 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2092 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2099 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2100 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2104 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2105 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2106 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2108 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2109 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2148 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2151 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2248 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2271 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2272 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2330 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2331 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2342 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2361 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2474 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2597 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2598 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2603 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2605 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2606 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2610 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2611 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2612 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2613 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2614 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2615 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2616 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2620 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2627 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2634 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2635 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2686 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2688 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2689 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 2720 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3753 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3755 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3783 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3784 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3785 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3786 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3788 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3790 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3825 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 3937 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 4992 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 5036 AND [Lib_Path_Id] = 509
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 5048 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 5065 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 6069 AND [Lib_Path_Id] = 508
DELETE FROM [dbo].[GEN_FILE_LIB_PATH_CORL] WHERE [Gen_File_Id] = 6070 AND [Lib_Path_Id] = 508
PRINT(N'Operation applied to 58 rows out of 58')

PRINT(N'Update rows in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.1', [Ranking]=1 WHERE [Requirement_Id] = 37238
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.2', [Ranking]=2 WHERE [Requirement_Id] = 37239
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.3', [Ranking]=3 WHERE [Requirement_Id] = 37240
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.4', [Ranking]=4 WHERE [Requirement_Id] = 37241
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.5', [Ranking]=5 WHERE [Requirement_Id] = 37242
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.6', [Ranking]=6 WHERE [Requirement_Id] = 37243
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.7', [Ranking]=7 WHERE [Requirement_Id] = 37244
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.8', [Ranking]=8 WHERE [Requirement_Id] = 37245
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.9', [Ranking]=9 WHERE [Requirement_Id] = 37246
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.10', [Ranking]=10 WHERE [Requirement_Id] = 37247
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.11', [Ranking]=11 WHERE [Requirement_Id] = 37248
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.12', [Ranking]=12 WHERE [Requirement_Id] = 37249
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.13', [Ranking]=13 WHERE [Requirement_Id] = 37250
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.14', [Ranking]=14 WHERE [Requirement_Id] = 37251
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.15', [Ranking]=15 WHERE [Requirement_Id] = 37252
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.16', [Ranking]=16 WHERE [Requirement_Id] = 37253
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.17', [Ranking]=17 WHERE [Requirement_Id] = 37254
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.18', [Ranking]=18 WHERE [Requirement_Id] = 37255
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.19', [Ranking]=19 WHERE [Requirement_Id] = 37256
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.1.20', [Ranking]=20 WHERE [Requirement_Id] = 37257
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.1', [Ranking]=21 WHERE [Requirement_Id] = 37258
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.2', [Ranking]=22 WHERE [Requirement_Id] = 37259
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.3', [Ranking]=23 WHERE [Requirement_Id] = 37260
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.4', [Ranking]=24 WHERE [Requirement_Id] = 37261
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.5', [Ranking]=25 WHERE [Requirement_Id] = 37262
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.2.6', [Ranking]=26 WHERE [Requirement_Id] = 37263
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.1', [Ranking]=27 WHERE [Requirement_Id] = 37264
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.2', [Ranking]=28 WHERE [Requirement_Id] = 37265
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.3', [Ranking]=29 WHERE [Requirement_Id] = 37266
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.4', [Ranking]=30 WHERE [Requirement_Id] = 37267
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.5', [Ranking]=31 WHERE [Requirement_Id] = 37268
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.6', [Ranking]=32 WHERE [Requirement_Id] = 37269
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.7', [Ranking]=33 WHERE [Requirement_Id] = 37270
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.3.8', [Ranking]=34 WHERE [Requirement_Id] = 37271
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.1', [Ranking]=35 WHERE [Requirement_Id] = 37272
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.2', [Ranking]=36 WHERE [Requirement_Id] = 37273
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.3', [Ranking]=37 WHERE [Requirement_Id] = 37274
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.4', [Ranking]=38 WHERE [Requirement_Id] = 37275
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.5', [Ranking]=39 WHERE [Requirement_Id] = 37276
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.6', [Ranking]=40 WHERE [Requirement_Id] = 37277
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.7', [Ranking]=41 WHERE [Requirement_Id] = 37278
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.8', [Ranking]=42 WHERE [Requirement_Id] = 37279
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.4.9', [Ranking]=43 WHERE [Requirement_Id] = 37280
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.1', [Ranking]=44 WHERE [Requirement_Id] = 37281
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.2', [Ranking]=45 WHERE [Requirement_Id] = 37282
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.3', [Ranking]=46 WHERE [Requirement_Id] = 37283
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.4', [Ranking]=47 WHERE [Requirement_Id] = 37284
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.5', [Ranking]=48 WHERE [Requirement_Id] = 37285
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.6', [Ranking]=49 WHERE [Requirement_Id] = 37286
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.7', [Ranking]=50 WHERE [Requirement_Id] = 37287
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.8', [Ranking]=51 WHERE [Requirement_Id] = 37288
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.9', [Ranking]=52 WHERE [Requirement_Id] = 37289
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.10', [Ranking]=53 WHERE [Requirement_Id] = 37290
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.11', [Ranking]=54 WHERE [Requirement_Id] = 37291
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.12', [Ranking]=55 WHERE [Requirement_Id] = 37292
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.13', [Ranking]=56 WHERE [Requirement_Id] = 37293
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.14', [Ranking]=57 WHERE [Requirement_Id] = 37294
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.15', [Ranking]=58 WHERE [Requirement_Id] = 37295
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.16', [Ranking]=59 WHERE [Requirement_Id] = 37296
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.17', [Ranking]=60 WHERE [Requirement_Id] = 37297
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.18', [Ranking]=61 WHERE [Requirement_Id] = 37298
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.19', [Ranking]=62 WHERE [Requirement_Id] = 37299
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.20', [Ranking]=63 WHERE [Requirement_Id] = 37300
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.21', [Ranking]=64 WHERE [Requirement_Id] = 37301
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.22', [Ranking]=65 WHERE [Requirement_Id] = 37302
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.23', [Ranking]=66 WHERE [Requirement_Id] = 37303
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.24', [Ranking]=67 WHERE [Requirement_Id] = 37304
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.25', [Ranking]=68 WHERE [Requirement_Id] = 37305
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.26', [Ranking]=69 WHERE [Requirement_Id] = 37306
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.5.27', [Ranking]=70 WHERE [Requirement_Id] = 37307
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.1', [Ranking]=71 WHERE [Requirement_Id] = 37308
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.2', [Ranking]=72 WHERE [Requirement_Id] = 37309
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.3', [Ranking]=73 WHERE [Requirement_Id] = 37310
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.4', [Ranking]=74 WHERE [Requirement_Id] = 37311
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.5', [Ranking]=75 WHERE [Requirement_Id] = 37312
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.6', [Ranking]=76 WHERE [Requirement_Id] = 37313
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.7', [Ranking]=77 WHERE [Requirement_Id] = 37314
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.6.8', [Ranking]=78 WHERE [Requirement_Id] = 37315
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.7.1', [Ranking]=79 WHERE [Requirement_Id] = 37316
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.7.2', [Ranking]=80 WHERE [Requirement_Id] = 37317
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.7.3', [Ranking]=81 WHERE [Requirement_Id] = 37318
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.1', [Ranking]=82 WHERE [Requirement_Id] = 37319
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.2', [Ranking]=83 WHERE [Requirement_Id] = 37320
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.3', [Ranking]=84 WHERE [Requirement_Id] = 37321
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.4', [Ranking]=85 WHERE [Requirement_Id] = 37322
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.5', [Ranking]=86 WHERE [Requirement_Id] = 37323
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.6', [Ranking]=87 WHERE [Requirement_Id] = 37324
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.7', [Ranking]=88 WHERE [Requirement_Id] = 37325
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.8', [Ranking]=89 WHERE [Requirement_Id] = 37326
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.9', [Ranking]=90 WHERE [Requirement_Id] = 37327
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.10', [Ranking]=91 WHERE [Requirement_Id] = 37328
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.11', [Ranking]=92 WHERE [Requirement_Id] = 37329
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.12', [Ranking]=93 WHERE [Requirement_Id] = 37330
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.13', [Ranking]=94 WHERE [Requirement_Id] = 37331
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.14', [Ranking]=95 WHERE [Requirement_Id] = 37332
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.15', [Ranking]=96 WHERE [Requirement_Id] = 37333
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.16', [Ranking]=97 WHERE [Requirement_Id] = 37334
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.17', [Ranking]=98 WHERE [Requirement_Id] = 37335
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.18', [Ranking]=99 WHERE [Requirement_Id] = 37336
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.19', [Ranking]=100 WHERE [Requirement_Id] = 37337
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.20', [Ranking]=101 WHERE [Requirement_Id] = 37338
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.21', [Ranking]=102 WHERE [Requirement_Id] = 37339
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.22', [Ranking]=103 WHERE [Requirement_Id] = 37340
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.8.23', [Ranking]=104 WHERE [Requirement_Id] = 37341
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.1', [Ranking]=105 WHERE [Requirement_Id] = 37342
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.2', [Ranking]=106 WHERE [Requirement_Id] = 37343
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.3', [Ranking]=107 WHERE [Requirement_Id] = 37344
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.4', [Ranking]=108 WHERE [Requirement_Id] = 37345
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.5', [Ranking]=109 WHERE [Requirement_Id] = 37346
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.6', [Ranking]=110 WHERE [Requirement_Id] = 37347
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.7', [Ranking]=111 WHERE [Requirement_Id] = 37348
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.8', [Ranking]=112 WHERE [Requirement_Id] = 37349
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.9.10', [Ranking]=113 WHERE [Requirement_Id] = 37350
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.10.1', [Ranking]=114 WHERE [Requirement_Id] = 37351
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.10.2', [Ranking]=115 WHERE [Requirement_Id] = 37352
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.10.3', [Ranking]=116 WHERE [Requirement_Id] = 37353
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.10.4', [Ranking]=117 WHERE [Requirement_Id] = 37354
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.1', [Ranking]=118 WHERE [Requirement_Id] = 37355
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.2', [Ranking]=119 WHERE [Requirement_Id] = 37356
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.3', [Ranking]=120 WHERE [Requirement_Id] = 37357
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.4', [Ranking]=121 WHERE [Requirement_Id] = 37358
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.5', [Ranking]=122 WHERE [Requirement_Id] = 37359
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.6', [Ranking]=123 WHERE [Requirement_Id] = 37360
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.11.7', [Ranking]=124 WHERE [Requirement_Id] = 37361
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.12.1', [Ranking]=125 WHERE [Requirement_Id] = 37362
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.12.2', [Ranking]=126 WHERE [Requirement_Id] = 37363
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.12.3', [Ranking]=127 WHERE [Requirement_Id] = 37364
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.12.4', [Ranking]=128 WHERE [Requirement_Id] = 37365
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.1', [Ranking]=129 WHERE [Requirement_Id] = 37366
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.2', [Ranking]=130 WHERE [Requirement_Id] = 37367
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.3', [Ranking]=131 WHERE [Requirement_Id] = 37368
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.4', [Ranking]=132 WHERE [Requirement_Id] = 37369
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.5', [Ranking]=133 WHERE [Requirement_Id] = 37370
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.14.1', [Ranking]=134 WHERE [Requirement_Id] = 37371
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.2', [Ranking]=135 WHERE [Requirement_Id] = 37372
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.3', [Ranking]=136 WHERE [Requirement_Id] = 37373
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.4', [Ranking]=137 WHERE [Requirement_Id] = 37374
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.5', [Ranking]=138 WHERE [Requirement_Id] = 37375
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.13.6', [Ranking]=139 WHERE [Requirement_Id] = 37376
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.14.1', [Ranking]=140 WHERE [Requirement_Id] = 37377
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.14.2', [Ranking]=141 WHERE [Requirement_Id] = 37378
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.14.3', [Ranking]=142 WHERE [Requirement_Id] = 37379
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.15.1', [Ranking]=143 WHERE [Requirement_Id] = 37380
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.15.2', [Ranking]=144 WHERE [Requirement_Id] = 37381
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.15.3', [Ranking]=145 WHERE [Requirement_Id] = 37382
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.15.4', [Ranking]=146 WHERE [Requirement_Id] = 37383
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.15.5', [Ranking]=147 WHERE [Requirement_Id] = 37384
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.16.1', [Ranking]=148 WHERE [Requirement_Id] = 37385
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.16.2', [Ranking]=149 WHERE [Requirement_Id] = 37386
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.17.1', [Ranking]=150 WHERE [Requirement_Id] = 37387
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.17.2', [Ranking]=151 WHERE [Requirement_Id] = 37388
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.17.3', [Ranking]=152 WHERE [Requirement_Id] = 37389
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.18.1', [Ranking]=153 WHERE [Requirement_Id] = 37390
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.18.2', [Ranking]=154 WHERE [Requirement_Id] = 37391
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.18.3', [Ranking]=155 WHERE [Requirement_Id] = 37392
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.18.4', [Ranking]=156 WHERE [Requirement_Id] = 37393
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.19.1', [Ranking]=157 WHERE [Requirement_Id] = 37394
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.19.2', [Ranking]=158 WHERE [Requirement_Id] = 37395
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.20.1', [Ranking]=159 WHERE [Requirement_Id] = 37396
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.20.2', [Ranking]=160 WHERE [Requirement_Id] = 37397
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.20.3', [Ranking]=161 WHERE [Requirement_Id] = 37398
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.20.4', [Ranking]=162 WHERE [Requirement_Id] = 37399
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.20.5', [Ranking]=163 WHERE [Requirement_Id] = 37400
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.21.1', [Ranking]=164 WHERE [Requirement_Id] = 37401
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.21.2', [Ranking]=165 WHERE [Requirement_Id] = 37402
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.1', [Ranking]=166 WHERE [Requirement_Id] = 37403
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.2', [Ranking]=167 WHERE [Requirement_Id] = 37404
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.3', [Ranking]=168 WHERE [Requirement_Id] = 37405
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.4', [Ranking]=169 WHERE [Requirement_Id] = 37406
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.5', [Ranking]=170 WHERE [Requirement_Id] = 37407
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.6', [Ranking]=171 WHERE [Requirement_Id] = 37408
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.7', [Ranking]=172 WHERE [Requirement_Id] = 37409
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.8', [Ranking]=173 WHERE [Requirement_Id] = 37410
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.9', [Ranking]=174 WHERE [Requirement_Id] = 37411
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.10', [Ranking]=175 WHERE [Requirement_Id] = 37412
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.11', [Ranking]=176 WHERE [Requirement_Id] = 37413
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.12', [Ranking]=177 WHERE [Requirement_Id] = 37414
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.13', [Ranking]=178 WHERE [Requirement_Id] = 37415
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.14', [Ranking]=179 WHERE [Requirement_Id] = 37416
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.15', [Ranking]=180 WHERE [Requirement_Id] = 37417
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.16', [Ranking]=181 WHERE [Requirement_Id] = 37418
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.17', [Ranking]=182 WHERE [Requirement_Id] = 37419
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.18', [Ranking]=183 WHERE [Requirement_Id] = 37420
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.19', [Ranking]=184 WHERE [Requirement_Id] = 37421
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.20', [Ranking]=185 WHERE [Requirement_Id] = 37422
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.21', [Ranking]=186 WHERE [Requirement_Id] = 37423
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.22', [Ranking]=187 WHERE [Requirement_Id] = 37424
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.23', [Ranking]=188 WHERE [Requirement_Id] = 37425
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.24', [Ranking]=189 WHERE [Requirement_Id] = 37426
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.22.25', [Ranking]=190 WHERE [Requirement_Id] = 37427
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.1', [Ranking]=191 WHERE [Requirement_Id] = 37428
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.2', [Ranking]=192 WHERE [Requirement_Id] = 37429
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.3', [Ranking]=193 WHERE [Requirement_Id] = 37430
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.4', [Ranking]=194 WHERE [Requirement_Id] = 37431
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.5', [Ranking]=195 WHERE [Requirement_Id] = 37432
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.6', [Ranking]=196 WHERE [Requirement_Id] = 37433
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.7', [Ranking]=197 WHERE [Requirement_Id] = 37434
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.8', [Ranking]=198 WHERE [Requirement_Id] = 37435
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.9', [Ranking]=199 WHERE [Requirement_Id] = 37436
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.23.10', [Ranking]=200 WHERE [Requirement_Id] = 37437
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.1', [Ranking]=201 WHERE [Requirement_Id] = 37438
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.2', [Ranking]=202 WHERE [Requirement_Id] = 37439
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.3', [Ranking]=203 WHERE [Requirement_Id] = 37440
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.4', [Ranking]=204 WHERE [Requirement_Id] = 37441
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.5', [Ranking]=205 WHERE [Requirement_Id] = 37442
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.6', [Ranking]=206 WHERE [Requirement_Id] = 37443
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.7', [Ranking]=207 WHERE [Requirement_Id] = 37444
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.8', [Ranking]=208 WHERE [Requirement_Id] = 37445
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.9', [Ranking]=209 WHERE [Requirement_Id] = 37446
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.10', [Ranking]=210 WHERE [Requirement_Id] = 37447
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.11', [Ranking]=211 WHERE [Requirement_Id] = 37448
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.12', [Ranking]=212 WHERE [Requirement_Id] = 37449
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.13', [Ranking]=213 WHERE [Requirement_Id] = 37450
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.14', [Ranking]=214 WHERE [Requirement_Id] = 37451
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.15', [Ranking]=215 WHERE [Requirement_Id] = 37452
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.16', [Ranking]=216 WHERE [Requirement_Id] = 37453
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.17', [Ranking]=217 WHERE [Requirement_Id] = 37454
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.18', [Ranking]=218 WHERE [Requirement_Id] = 37455
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.19', [Ranking]=219 WHERE [Requirement_Id] = 37456
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.20', [Ranking]=220 WHERE [Requirement_Id] = 37457
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.21', [Ranking]=221 WHERE [Requirement_Id] = 37458
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.22', [Ranking]=222 WHERE [Requirement_Id] = 37459
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.23', [Ranking]=223 WHERE [Requirement_Id] = 37460
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.24', [Ranking]=224 WHERE [Requirement_Id] = 37461
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.25', [Ranking]=225 WHERE [Requirement_Id] = 37462
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.26', [Ranking]=226 WHERE [Requirement_Id] = 37463
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.27', [Ranking]=227 WHERE [Requirement_Id] = 37464
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.28', [Ranking]=228 WHERE [Requirement_Id] = 37465
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.29', [Ranking]=229 WHERE [Requirement_Id] = 37466
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.30', [Ranking]=230 WHERE [Requirement_Id] = 37467
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.31', [Ranking]=231 WHERE [Requirement_Id] = 37468
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.32', [Ranking]=232 WHERE [Requirement_Id] = 37469
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.33', [Ranking]=233 WHERE [Requirement_Id] = 37470
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.34', [Ranking]=234 WHERE [Requirement_Id] = 37471
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.35', [Ranking]=235 WHERE [Requirement_Id] = 37472
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.36', [Ranking]=236 WHERE [Requirement_Id] = 37473
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.37', [Ranking]=237 WHERE [Requirement_Id] = 37474
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.38', [Ranking]=238 WHERE [Requirement_Id] = 37475
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.39', [Ranking]=239 WHERE [Requirement_Id] = 37476
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.40', [Ranking]=240 WHERE [Requirement_Id] = 37477
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.41', [Ranking]=241 WHERE [Requirement_Id] = 37478
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.42', [Ranking]=242 WHERE [Requirement_Id] = 37479
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.43', [Ranking]=243 WHERE [Requirement_Id] = 37480
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.44', [Ranking]=244 WHERE [Requirement_Id] = 37481
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.45', [Ranking]=245 WHERE [Requirement_Id] = 37482
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.46', [Ranking]=246 WHERE [Requirement_Id] = 37483
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.47', [Ranking]=247 WHERE [Requirement_Id] = 37484
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.48', [Ranking]=248 WHERE [Requirement_Id] = 37485
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.49', [Ranking]=249 WHERE [Requirement_Id] = 37486
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.50', [Ranking]=250 WHERE [Requirement_Id] = 37487
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.51', [Ranking]=251 WHERE [Requirement_Id] = 37488
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.52', [Ranking]=252 WHERE [Requirement_Id] = 37489
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.53', [Ranking]=253 WHERE [Requirement_Id] = 37490
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.54', [Ranking]=254 WHERE [Requirement_Id] = 37491
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.55', [Ranking]=255 WHERE [Requirement_Id] = 37492
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.24.56', [Ranking]=256 WHERE [Requirement_Id] = 37493
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.1', [Ranking]=257 WHERE [Requirement_Id] = 37494
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.2', [Ranking]=258 WHERE [Requirement_Id] = 37495
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.3', [Ranking]=259 WHERE [Requirement_Id] = 37496
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.4', [Ranking]=260 WHERE [Requirement_Id] = 37497
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.5', [Ranking]=261 WHERE [Requirement_Id] = 37498
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.6', [Ranking]=262 WHERE [Requirement_Id] = 37499
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.7', [Ranking]=263 WHERE [Requirement_Id] = 37500
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.8', [Ranking]=264 WHERE [Requirement_Id] = 37501
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.9', [Ranking]=265 WHERE [Requirement_Id] = 37502
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.10', [Ranking]=266 WHERE [Requirement_Id] = 37503
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.11', [Ranking]=267 WHERE [Requirement_Id] = 37504
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.12', [Ranking]=268 WHERE [Requirement_Id] = 37505
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.13', [Ranking]=269 WHERE [Requirement_Id] = 37506
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.14', [Ranking]=270 WHERE [Requirement_Id] = 37507
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.15', [Ranking]=271 WHERE [Requirement_Id] = 37508
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.16', [Ranking]=272 WHERE [Requirement_Id] = 37509
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.17', [Ranking]=273 WHERE [Requirement_Id] = 37510
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.18', [Ranking]=274 WHERE [Requirement_Id] = 37511
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.19', [Ranking]=275 WHERE [Requirement_Id] = 37512
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.20', [Ranking]=276 WHERE [Requirement_Id] = 37513
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.21', [Ranking]=277 WHERE [Requirement_Id] = 37514
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.22', [Ranking]=278 WHERE [Requirement_Id] = 37515
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.23', [Ranking]=279 WHERE [Requirement_Id] = 37516
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.24', [Ranking]=280 WHERE [Requirement_Id] = 37517
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.25', [Ranking]=281 WHERE [Requirement_Id] = 37518
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.26', [Ranking]=282 WHERE [Requirement_Id] = 37519
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.27', [Ranking]=283 WHERE [Requirement_Id] = 37520
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.28', [Ranking]=284 WHERE [Requirement_Id] = 37521
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'MO.25.29', [Ranking]=285 WHERE [Requirement_Id] = 37522
PRINT(N'Operation applied to 285 rows out of 285')

PRINT(N'Update row in [dbo].[SETS]')
UPDATE [dbo].[SETS] SET [Short_Name]=N'CSF V2.0' WHERE [Set_Name] = N'Florida_NCSF_V2'

PRINT(N'Update rows in [dbo].[REF_LIBRARY_PATH]')
UPDATE [dbo].[REF_LIBRARY_PATH] SET [Path_Name]=N'Transportation Security Administration (TSA)' WHERE [Lib_Path_Id] = 508
UPDATE [dbo].[REF_LIBRARY_PATH] SET [Path_Name]=N'US Government Other' WHERE [Lib_Path_Id] = 509
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add rows to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (7076, 31, N'NIST.SP.800-82r3.pdf', N'NIST SP 800-82r3: Guide to Operational Technology (OT) Security', N'NIST SP800-82 R3', NULL, N'SP800-82R3', N'computer security; distributed control systems (DCS); industrial control systems (ICS); information security; network security; operational technology (OT); programmable logic controllers (PLC); risk management; security controls; supervisory control and data acquisition (SCADA) systems', NULL, N'NIST SP 800-82r3', '2023-09-28 18:00:00.000', N'Rev3', N'This document provides guidance on how to secure operational technology (OT) while
addressing their unique performance, reliability, and safety requirements. OT encompasses a
broad range of programmable systems and devices that interact with the physical environment
(or manage devices that interact with the physical environment). These systems and devices
detect or cause a direct change through the monitoring and/or control of devices, processes, and
events. Examples include industrial control systems, building automation systems, transportation
systems, physical access control systems, physical environment monitoring systems, and
physical environment measurement systems. The document provides an overview of OT and
typical system topologies, identifies common threats and vulnerabilities to these systems, and
provides recommended security countermeasures to mitigate the associated risks.', NULL, NULL, 0)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (7077, 31, N'sd-1580_1582-2022-01a-rail-cybersecurity-mitigation-actions-and-testing.pdf', N'Security Directive 1580/82-2022-01A', NULL, NULL, N'NONE', NULL, NULL, N'TSA SD Rail-2022-01A', '2023-10-23 16:00:00.000', NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add row to [dbo].[REF_LIBRARY_PATH]')
INSERT INTO [dbo].[REF_LIBRARY_PATH] ([Lib_Path_Id], [Parent_Path_Id], [Path_Name]) VALUES (510, 1, N'US-CERT')

PRINT(N'Add rows to [dbo].[GEN_FILE_LIB_PATH_CORL]')
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (668, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (669, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (674, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2067, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2092, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2099, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2100, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2104, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2105, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2106, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2108, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2109, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2148, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2151, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2248, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2271, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2272, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2330, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2331, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2342, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2361, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2474, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2597, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2598, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2603, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2605, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2606, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2610, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2611, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2612, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2613, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2614, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2615, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2616, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2620, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2627, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2634, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2635, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2686, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2688, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2689, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2720, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3753, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3755, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3783, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3784, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3785, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3786, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3788, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3790, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3825, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3937, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (4992, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5036, 510)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5048, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5065, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5070, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5071, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5072, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6069, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6070, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (7076, 569)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (7077, 508)
PRINT(N'Operation applied to 63 rows out of 63')

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Add constraints to [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] WITH CHECK CHECK CONSTRAINT [FK_SETS_Sets_Category]
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] WITH CHECK CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_MATURITY_MODELS_SETS]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] WITH CHECK CHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] CHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_SETS]
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] CHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_SETS]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]

PRINT(N'Add constraints to [dbo].[REF_LIBRARY_PATH]')
ALTER TABLE [dbo].[REF_LIBRARY_PATH] WITH CHECK CHECK CONSTRAINT [FK_REF_LIBRARY_PATH_REF_LIBRARY_PATH]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
COMMIT TRANSACTION
GO
