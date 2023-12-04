/*
Run this script on:

(localdb)\MSSQLLocalDB.NCUAWeb120013    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb120014

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 12/5/2022 7:56:34 AM

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

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS from [dbo].[MATURITY_QUESTION_PROPS]')
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_ANSWER_MATURITY_ANSWER_OPTIONS1 from [dbo].[ANSWER]')
ALTER TABLE [dbo].[ANSWER] NOCHECK CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS from [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS2 from [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS2]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION]')
ALTER TABLE [dbo].[NEW_QUESTION] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS]
ALTER TABLE [dbo].[NEW_QUESTION] NOCHECK CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SAL_LEVEL]
ALTER TABLE [dbo].[NEW_QUESTION] NOCHECK CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SUB_CATEGORY_HEADINGS]

PRINT(N'Drop constraint FK_Component_Questions_NEW_QUESTION from [dbo].[COMPONENT_QUESTIONS]')
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] NOCHECK CONSTRAINT [FK_Component_Questions_NEW_QUESTION]

PRINT(N'Drop constraint FK_FINANCIAL_QUESTIONS_NEW_QUESTION from [dbo].[FINANCIAL_QUESTIONS]')
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] NOCHECK CONSTRAINT [FK_FINANCIAL_QUESTIONS_NEW_QUESTION]

PRINT(N'Drop constraint FK_NERC_RISK_RANKING_NEW_QUESTION from [dbo].[NERC_RISK_RANKING]')
ALTER TABLE [dbo].[NERC_RISK_RANKING] NOCHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_QUESTION]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_NEW_QUESTION1 from [dbo].[REQUIREMENT_QUESTIONS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_QUESTION1]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION]

PRINT(N'Drop constraints from [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]')
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] NOCHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] NOCHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] NOCHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_UNIVERSAL_SUB_CATEGORIES]

PRINT(N'Drop constraint FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS from [dbo].[SUB_CATEGORY_ANSWERS]')
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] NOCHECK CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS]

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

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

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

PRINT(N'Drop constraint FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK__AVAILABLE__model__6F6A7CB2 from [dbo].[AVAILABLE_MATURITY_MODELS]')
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] NOCHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]

PRINT(N'Drop constraint FK_MATURITY_LEVELS_MATURITY_MODELS from [dbo].[MATURITY_LEVELS]')
ALTER TABLE [dbo].[MATURITY_LEVELS] NOCHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS from [dbo].[MODES_SETS_MATURITY_MODELS]')
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

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

--Added by Barry
--delete Gallery_item where configuration_setup = '{Sets:["Course_401"],SALLevel:"Low",QuestionMode:"Questions"}'

PRINT(N'Delete rows from [dbo].[MATURITY_REFERENCE_TEXT]')
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7568 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7577 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7582 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7588 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7594 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7602 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7607 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7612 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7619 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7628 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7633 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7639 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7645 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7652 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7655 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7661 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7669 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7674 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7679 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7683 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7687 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7691 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7694 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7699 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7852 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7853 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7868 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7869 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7874 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7875 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7890 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7891 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7901 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7902 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7911 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7912 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7918 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 7919 AND [Sequence] = 1
PRINT(N'Operation applied to 38 rows out of 38')

PRINT(N'Delete rows from [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]')
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 4 AND [Universal_Sub_Category_Id] = 8811 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 10 AND [Universal_Sub_Category_Id] = 8883 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 36 AND [Universal_Sub_Category_Id] = 8811 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 36 AND [Universal_Sub_Category_Id] = 8887 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 48 AND [Universal_Sub_Category_Id] = 8811 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 51 AND [Universal_Sub_Category_Id] = 8885 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 51 AND [Universal_Sub_Category_Id] = 8886 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 72 AND [Universal_Sub_Category_Id] = 8865 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 72 AND [Universal_Sub_Category_Id] = 8884 AND [Set_Name] = N'SET.20221102.184231'
DELETE FROM [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WHERE [Question_Group_Heading_Id] = 72 AND [Universal_Sub_Category_Id] = 8885 AND [Set_Name] = N'SET.20221102.184231'
PRINT(N'Operation applied to 10 rows out of 10')

PRINT(N'Delete rows from [dbo].[MATURITY_GROUPINGS]')
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2405
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2406
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2407
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2419
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2421
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2435
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2442
DELETE FROM [dbo].[MATURITY_GROUPINGS] WHERE [Grouping_Id] = 2519
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Delete row from [dbo].[SETS]')
DELETE FROM [dbo].[SETS] WHERE [Set_Name] = N'SET.20221102.184231'

PRINT(N'Update row in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How often do you review responses to actual cyber incidents to see if they are consistent with the incident response procedures/plan specific to the CCS? (Select one)' WHERE [Mat_Question_Id] = 6558

PRINT(N'Update rows in [dbo].[MATURITY_ANSWER_OPTIONS]')
UPDATE [dbo].[MATURITY_ANSWER_OPTIONS] SET [Option_Text]=N'Documentation of verbal attestation from supplier' WHERE [Mat_Option_Id] = 2395
UPDATE [dbo].[MATURITY_ANSWER_OPTIONS] SET [Option_Text]=N'The organization conducts separate live exercises with the supplier.' WHERE [Mat_Option_Id] = 2409
UPDATE [dbo].[MATURITY_ANSWER_OPTIONS] SET [Option_Text]=N'Network switches' WHERE [Mat_Option_Id] = 3098
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Update rows in [dbo].[NEW_QUESTION_SETS]')
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17635 WHERE [New_Question_Set_Id] = 56875
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17636 WHERE [New_Question_Set_Id] = 56876
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17637 WHERE [New_Question_Set_Id] = 56877
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17638 WHERE [New_Question_Set_Id] = 56878
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17639 WHERE [New_Question_Set_Id] = 56879
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17640 WHERE [New_Question_Set_Id] = 56880
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17641 WHERE [New_Question_Set_Id] = 56881
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17642 WHERE [New_Question_Set_Id] = 56882
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17643 WHERE [New_Question_Set_Id] = 56883
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17644 WHERE [New_Question_Set_Id] = 56884
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17645 WHERE [New_Question_Set_Id] = 56885
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17646 WHERE [New_Question_Set_Id] = 56886
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17647 WHERE [New_Question_Set_Id] = 56887
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17648 WHERE [New_Question_Set_Id] = 56888
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17649 WHERE [New_Question_Set_Id] = 56889
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17650 WHERE [New_Question_Set_Id] = 56890
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17651 WHERE [New_Question_Set_Id] = 56891
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17652 WHERE [New_Question_Set_Id] = 56892
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17653 WHERE [New_Question_Set_Id] = 56893
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17654 WHERE [New_Question_Set_Id] = 56894
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17655 WHERE [New_Question_Set_Id] = 56895
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17656 WHERE [New_Question_Set_Id] = 56896
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17657 WHERE [New_Question_Set_Id] = 56897
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17658 WHERE [New_Question_Set_Id] = 56898
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17659 WHERE [New_Question_Set_Id] = 56899
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17660 WHERE [New_Question_Set_Id] = 56900
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17661 WHERE [New_Question_Set_Id] = 56901
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17662 WHERE [New_Question_Set_Id] = 56902
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17663 WHERE [New_Question_Set_Id] = 56903
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17664 WHERE [New_Question_Set_Id] = 56904
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17665 WHERE [New_Question_Set_Id] = 56905
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17666 WHERE [New_Question_Set_Id] = 56906
UPDATE [dbo].[NEW_QUESTION_SETS] SET [Set_Name]=N'Course_401', [Question_Id]=17667 WHERE [New_Question_Set_Id] = 56907
PRINT(N'Operation applied to 33 rows out of 33')

PRINT(N'Update rows in [dbo].[NEW_QUESTION]')
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is there a way to monitor a user that has administrative or elevated privileges, such as when they log in and what activities they are doing while using the system?' WHERE [Question_Id] = 17565
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Do users have the least amount of privileges on the system or application to perform their job duties?If yes, is there ever an instance where someone has elevated privileges? Please provide a response in the comment field below.' WHERE [Question_Id] = 17568
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is wireless access allowed?If yes, how does one gain access and authorization? Please provide a response in the comment field below.' WHERE [Question_Id] = 17573
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is wireless access password protected?If yes, what is the encryption method? Please provide a response in the comment field below.' WHERE [Question_Id] = 17574
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is your wireless access self-managed and maintained?' WHERE [Question_Id] = 17575
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Are users required to get authorization before connecting mobile devices to the network?If yes, are there any rules or acknowledgements that need to be accepted as part of that authorization? Please provide a response in the comment field below.' WHERE [Question_Id] = 17576
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Do you provide security literacy training to all users?If yes, how often does training need to be taken? Please provide a response in the comment field below.' WHERE [Question_Id] = 17578
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Does your organization have physical access monitoring (key card logs, etc.) that can be aligned with system logs in the event of suspected unusual activity or behavior?' WHERE [Question_Id] = 17583
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Does your Contingency Plan address your relationship and dependence on any external services providers, including their roles and responsibilities in the event of a contingent event?' WHERE [Question_Id] = 17587
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is there a specific training provided for Incident response, to your users and personnel responsible for the Incident Response Plan (if applicable)?' WHERE [Question_Id] = 17594
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Do you have rules or requirements for external service provider personnel that must be met before granting access to your system?If yes, what is the process for external providers to notify your organization of personnel changes and to retrieve access credentials? Please provide a response in the comment field below.' WHERE [Question_Id] = 17601
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Can you access or see your wireless network outside of your facility?If yes, how far away can it be detected? Please provide a response in the comment field below.' WHERE [Question_Id] = 17620
UPDATE [dbo].[NEW_QUESTION] SET [Simple_Question]=N'Is there a regularly scheduled requirement to take refresher role-based training?If yes, how often does role-based training need to be taken? Please provide a response in the comment field below.' WHERE [Question_Id] = 17623
PRINT(N'Operation applied to 13 rows out of 13')

PRINT(N'Update row in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Supplemental_Info]=N'<style type="text/css">* { font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; } table { border-collapse: collapse; margin: 3rem; } table td { border: 1px solid #000; padding: .5rem; vertical-align: top; } .brown { text-align: center; color: #fff; background-color: #653300; font-weight: 700; text-transform: uppercase; } .gold { text-align: center; color: #000; background-color: #cc9a00; font-weight: 700; } .vanilla { text-align: center; color: #000; background-color: #ffde82; font-weight: 700; } .sideways { vertical-align: middle; } .sideways div { display: block; white-space: nowrap; font-style: oblique; transform: rotate(270deg); -webkit-transform: rotate(270deg); -moz-transform: rotate(270deg); -ms-transform: rotate(270deg); -o-transform: rotate(270deg); } .center { text-align: center; }</style><p>&nbsp;</p><table>	<tbody>		<tr class="brown">			<td style="width: 10%">&nbsp;</td>			<td style="width: 45%">Baseline Security Measures</td>			<td style="width: 45%">Enhanced Security Measures</td>		</tr>		<tr>			<td class="sideways vanilla" rowspan="9">			<div>Protect</div>			</td>			<td class="center vanilla" colspan="2">Awareness and Training</td>		</tr>		<tr>			<td>Ensure that all persons requiring access to the organization&#39;s pipeline cyber assets receive cybersecurity awareness training.</td>			<td><mark class="highlight" style="background-color: rgb(255, 255, 0);">Provide role-based security training on recognizing and reporting potential indicators of system compromise prior to obtaining access to the critical pipeline cyber assets.</mark></td>		</tr>		<tr>			<td>Establish and execute a cyber-threat awareness program for employees. This program should include practical exercises/testing.</td>			<td>&nbsp;</td>		</tr>	</tbody></table><!--Table on Page 20--><p>&nbsp;</p>' WHERE [Requirement_Id] = 29748

PRINT(N'Update row in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]=N'' WHERE [Grouping_Id] = 2467

PRINT(N'Update rows in [dbo].[GALLERY_GROUP_DETAILS]')
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=1 WHERE [Group_Detail_Id] = 72
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=3 WHERE [Group_Detail_Id] = 78

UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=4 WHERE [Group_Detail_Id] = 1122
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Update row in [dbo].[MATURITY_MODELS]')
UPDATE [dbo].[MATURITY_MODELS] SET [Answer_Options]=N'Y,I,S,N', [Model_Description]=N'The CPGs are a prioritized subset of IT and OT cybersecurity practices aimed at meaningfully reducing risks to both CI operations and to the American people. These goals are applicable across all CI sectors and are informed by the most common and impactful threats and adversary tactics, techniques, and procedures (TTPs) observed by CISA and its government and industry partners, making them a common set of protections that all CI entities — from large to small — should implement.', [Model_Title]=N'CISA Cross-Sector Cybersecurity Performance Goals (CPG)' WHERE [Maturity_Model_Id] = 11

PRINT(N'Update rows in [dbo].[GEN_FILE]')
UPDATE [dbo].[GEN_FILE] SET [File_Type_Id]=31, [File_Name]=N'12 CFR 701.pdf', [Title]=N'12 CFR 701', [Name]=N'12 CFR 701', [File_Size]=7127754, [Comments]=NULL, [Short_Name]=N'12 CFR 701' WHERE [Gen_File_Id] = 6091
UPDATE [dbo].[GEN_FILE] SET [File_Type_Id]=31, [File_Name]=N'SL_No_07-01_October_2007.pdf', [Title]=N'SL No. 07-01 / October 2007', [Name]=N'Evaluating Third Party Relationships', [File_Size]=412034 WHERE [Gen_File_Id] = 6094
PRINT(N'Operation applied to 2 rows out of 3')

PRINT(N'Update rows in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Title]=N'CISA Minimum Viable Resilience Assessment (MVRA) - DRAFT' WHERE [Gallery_Item_Id] = 112
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'The CPGs are a prioritized subset of IT and operational technology (OT) cybersecurity practices that critical infrastructure owners and operators can implement to meaningfully reduce the likelihood and impact of known risks and adversary techniques. The goals were informed by existing cybersecurity frameworks and guidance, as well as the real-world threats and adversary tactics, techniques, and procedures (TTPs) observed by CISA and its government and industry partners.  This assessment is intended to help organizations determine the extent to which they have implemented the Goals, and to aid in identifying areas for potential future investment.', [Title]=N'CISA Cross-Sector Cybersecurity Performance Goals (CPG)' WHERE [Gallery_Item_Id] = 117
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add row to [dbo].[GALLERY_ITEM]') 
SET IDENTITY_INSERT [dbo].[GALLERY_ITEM] ON 
if not exists (select * from GALLERY_ITEM where gallery_item_id = 118)
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Id], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES (118, NULL, NULL, N'{Sets:["Course_401"],SALLevel:"Low",QuestionMode:"Questions"}', N'Evaluation questions used in the DHS 401 ICS System Evaluation and Analysis Course', NULL, N'DHS 401 ICS System Evaluation and Analysis Course Question Set', 1, '2022-11-29 15:18:01.680') 
SET IDENTITY_INSERT [dbo].[GALLERY_ITEM] OFF 
 
PRINT(N'Add row to [dbo].[SETS]') 
if not exists (select * from SETS where Set_Name = 'Course_401')
INSERT INTO [dbo].[SETS] ([Set_Name], [Full_Name], [Short_Name], [Is_Displayed], [Is_Pass_Fail], [Old_Std_Name], [Set_Category_Id], [Order_In_Category], [Report_Order_Section_Number], [Aggregation_Standard_Number], [Is_Question], [Is_Requirement], [Order_Framework_Standards], [Standard_ToolTip], [Is_Deprecated], [Upgrade_Set_Name], [Is_Custom], [Date], [IsEncryptedModule], [IsEncryptedModuleOpen]) VALUES (N'Course_401', N'CSET 401', N'CSET 401', 1, 0, NULL, 12, NULL, NULL, NULL, 0, 0, 0, N'This set is used in 401 training for CSET', 0, NULL, 0, NULL, 0, 1) 
 



PRINT(N'Add rows to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
if not exists (select * from gen_file where gen_file_id = 6109)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6109, 31, N'12 CFR 704.16.pdf', N'12 CFR 704.16', N'12 CFR 704.16', 16261, N'NONE', NULL, NULL, N'12 CFR 704.16', NULL, NULL, NULL, NULL, NULL, 0)
if not exists (select * from gen_file where gen_file_id = 6110)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6110, 31, N'12 CFR 704.pdf', N'12 CFR 704', N'12 CFR 704', 578796, N'NONE', NULL, NULL, N'12 CFR 704', NULL, NULL, NULL, NULL, NULL, 0)
if not exists (select * from gen_file where gen_file_id = 6111)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6111, 31, N'12 CFR 741.pdf', N'12 CFR 741', N'12 CFR 741', 669525, N'NONE', NULL, NULL, N'12 CFR 741', NULL, NULL, NULL, NULL, NULL, 0)
if not exists (select * from gen_file where gen_file_id = 6112)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6112, 31, N'12 CFR 748.0.pdf', N'12 CFR 748.0', N'12 CFR 748.0', 26874, N'NONE', NULL, NULL, N'12 CFR 748.0', NULL, NULL, NULL, NULL, NULL, 0)
if not exists (select * from gen_file where gen_file_id = 6113)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6113, 31, N'12 CFR 749.0.pdf', N'12 CFR 749.0', N'12 CFR 749.0', 23469, N'NONE', NULL, NULL, N'12 CFR 749.0', NULL, NULL, NULL, NULL, NULL, 0)
if not exists (select * from gen_file where gen_file_id = 6114)
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6114, 31, N'Creating_and_Managing_Strong_Passwords_CISA.pdf', N'Creating and Managing Strong Passwords', N'CISA NCCIC/US-CERT Creating and Managing Strong Passwords', 213547, N'NONE', NULL, NULL, N'Creating and Managing Strong Passwords', NULL, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
if not exists (select * from GALLERY_GROUP_DETAILS where Group_Detail_Id = 2185)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2185, 1, 0, 117, 0)
if not exists (select * from GALLERY_GROUP_DETAILS where Group_Detail_Id = 2186)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2186, 15, 4, 118, 0)
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF
PRINT(N'Operation applied to 2 rows out of 2')
PRINT(N'Add rows to [dbo].[MATURITY_ANSWER_OPTIONS]')
SET IDENTITY_INSERT [dbo].[MATURITY_ANSWER_OPTIONS] ON
if not exists (select * from maturity_answer_options where  Mat_Option_Id = 2410)
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType], [Is_None]) VALUES (2410, N'The organization conducts separate tabletop exercises with the supplier.', 6429, 3, NULL, NULL, N'radio', NULL, 0, NULL, NULL, NULL, NULL, 0)
if not exists (select * from maturity_answer_options where  Mat_Option_Id = 2411)
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType], [Is_None]) VALUES (2411, N'The supplier is discussed in, but does not participate in, organization exercises.', 6429, 4, NULL, NULL, N'radio', NULL, 0, NULL, NULL, NULL, NULL, 0)
if not exists (select * from maturity_answer_options where  Mat_Option_Id = 2412)
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType], [Is_None]) VALUES (2412, N'Suppliers are not included in response and recovery planning.', 6429, 5, NULL, NULL, N'radio', NULL, 0, NULL, NULL, NULL, NULL, 0)
if not exists (select * from maturity_answer_options where  Mat_Option_Id = 2413)
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType], [Is_None]) VALUES (2413, N'The organization does not evaluate supplier cybersecurity.', 6423, 5, NULL, NULL, N'checkbox', NULL, 0, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[MATURITY_ANSWER_OPTIONS] OFF
PRINT(N'Operation applied to 4 rows out of 4')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
if not exists (select * from maturity_references where mat_question_id = 7568)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7568, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7577)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7577, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7582)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7588)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7594)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6112, N'(b)(3)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7602)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6094, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7602)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6109, N'Contracts/written agreements', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7602)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7602)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6112, N'(b)(3)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7602)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6112, N'(b)(5)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7607)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 6113, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7612)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7612)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6114, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7619)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7619, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7628)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7628, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7633)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7633, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7639)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7645)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7652)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7652, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7655)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7661)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6112, N'(b)(3)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7669)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6094, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7669)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6109, N'Contracts/written agreements', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7669)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7669)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6112, N'(b)(3)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7669)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6112, N'(b)(5)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7674)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 6113, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7679)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7679, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7683)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7687)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7691)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7691, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7694)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7699)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7699, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7852)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7852, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7868)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7868, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7874)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7874, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7890)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7890, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7901)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7901, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7911)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7911, 6112, N'(b)(2)', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7918)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7918, 6091, N'', NULL, N'')
if not exists (select * from maturity_references where mat_question_id = 7918)
 INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7918, 6111, N'', NULL, N'')
PRINT(N'Operation applied to 41 rows out of 41')

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[ANSWER] WITH CHECK CHECK CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS2]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION]')
ALTER TABLE [dbo].[NEW_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SAL_LEVEL]
ALTER TABLE [dbo].[NEW_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SUB_CATEGORY_HEADINGS]
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] CHECK CONSTRAINT [FK_Component_Questions_NEW_QUESTION]
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_QUESTIONS_NEW_QUESTION]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_QUESTION]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_QUESTION1]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION]

PRINT(N'Add constraints to [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]')
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_UNIVERSAL_SUB_CATEGORIES]
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] WITH CHECK CHECK CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS]

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Add constraints to [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] WITH CHECK CHECK CONSTRAINT [FK_SETS_Sets_Category]
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] WITH CHECK CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_MATURITY_MODELS_SETS]
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] WITH CHECK CHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] CHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_SETS]
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] CHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_SETS]
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]
ALTER TABLE [dbo].[MATURITY_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
COMMIT TRANSACTION
GO
