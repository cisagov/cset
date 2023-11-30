/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12100    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12110

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 11/30/2023 1:24:08 PM

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

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Drop constraints from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK__HYDRO_DAT__Mat_Q__38652BE2 from [dbo].[HYDRO_DATA]')
ALTER TABLE [dbo].[HYDRO_DATA] NOCHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS from [dbo].[MATURITY_QUESTION_PROPS]')
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS from [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS from [dbo].[TTP_MAT_QUESTION]')
ALTER TABLE [dbo].[TTP_MAT_QUESTION] NOCHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_GEN_FILE from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_GEN_FILE from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'Operationally sensitive - HIPAA, PII, network diagrams, Critical Services inventories, etc.' WHERE [Mat_Question_Id] = 6004
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'<p>Are there mitigation measures in place for accounts that do not comply with the above requirement (AC-3C.Q3)? Mitigation measures may include:</p> <ul><li>Physical security measures</li><li>Increased monitoring of accounts</li></ul> <p>The above measures should be clearly defined in the CIP.</p>' WHERE [Mat_Question_Id] = 6836
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Update rows in [dbo].[GEN_FILE]')
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'The NCUA Board (Board) is amending its regulations regarding loans to members and lines of credit to members to reduce regulatory burden, improve clarity, and make compliance easier. The amendments make the NCUA’s regulations more user friendly by: (1) identifying in one section all of the various maturity limits applicable to federal credit union (FCU) loans; (2) stating that the maturity date for a new loan under generally accepted accounting principles (GAAP) is calculated from the origination date of the new loan; and (3) more clearly expressing the limits for loans to a single borrower or group of associated borrowers.' WHERE [Gen_File_Id] = 6091
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'Services, facilities, personnel, or equipment shared with any party shall be supported by a written contract, with the duties and responsibilities of each party specified and the allocation of service fee/expenses fully supported and documented.' WHERE [Gen_File_Id] = 6109
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'NCUA is issuing a final rule governing corporate credit unions. The rule strengthens capital requirements, establishes parameters to ensure that the risk on corporate credit union balance sheets is adequately managed, provides for corporate credit unions with more developed systems and infrastructures to take more planned and controlled risk, and sets forth special rules for wholesale corporate credit unions.' WHERE [Gen_File_Id] = 6110
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'The provisions of this part apply to federal credit unions, federally insured state-chartered credit unions, and credit unions making application for insurance of accounts pursuant to title II of the Act, unless the context of a provision indicates its application is otherwise limited. This part prescribes various requirements for obtaining and maintaining federal insurance and the payment of insurance premiums and capitalization deposit. Subpart A of this part contains substantive requirements that are not codified elsewhere in this chapter. Subpart B of this part lists additional regulations, set forth elsewhere in this chapter as applying to federal credit unions, that also apply to federally insured state-chartered credit unions. As used in this part, “insured credit union” means a credit union whose accounts are insured by the National Credit Union Share Insurance Fund (NCUSIF).' WHERE [Gen_File_Id] = 6111
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'12 CFR 748.0 is a section of the National Credit Union Administration (NCUA) regulations. It outlines the requirements for a federally insured credit union to develop a written security program within 90 days of the effective date of insurance. The security program should be designed to protect each credit union office from robberies, burglaries, larcenies, and embezzlement.' WHERE [Gen_File_Id] = 6112
UPDATE [dbo].[GEN_FILE] SET [Summary]=N'This part describes the obligations of all federally insured credit unions to maintain a records preservation program to identify, store and reconstruct vital records in the event that the credit union''s records are destroyed and provides recommendations for restoring vital member services. All credit unions must have a written program that includes plans for safeguarding records and reconstructing vital records. To complement these plans, it is recommended a credit union develop a method for restoring vital member services in the event of a catastrophic act as defined in § 748.1(b) of this chapter. Additionally, the regulation establishes flexibility in the format credit unions may use for maintaining writings, records or information required by other NCUA regulations.' WHERE [Gen_File_Id] = 6113
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Add rows to [dbo].[FILE_KEYWORDS]')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6091, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6091, N'12 CFR 701')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6091, N'701')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6091, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6109, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6109, N'12 CFR 704.16')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6109, N'704.16')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6109, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6110, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6110, N'12 CFR 704')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6110, N'704')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6110, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6111, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6111, N'12 CFR 741')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6111, N'741')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6111, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6112, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6112, N'12 CFR 748')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6112, N'748')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6112, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6113, N'12')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6113, N'12 CFR 749')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6113, N'749')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6113, N'cfr')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'Diligence')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'Due')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'due diligence')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'Due Diligence over Third Party Service Providers')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'party')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'providers')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'service')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'third')
INSERT INTO [dbo].[FILE_KEYWORDS] ([Gen_File_Id], [Keyword]) VALUES (6118, N'third-party')
PRINT(N'Operation applied to 33 rows out of 33')

PRINT(N'Add rows to [dbo].[GEN_FILE_LIB_PATH_CORL]')
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6088, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6089, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6091, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6092, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6094, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6095, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6097, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6098, 500)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6099, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6106, 500)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6109, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6110, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6111, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6112, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6113, 496)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (7069, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (7070, 516)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (7071, 516)
PRINT(N'Operation applied to 18 rows out of 18')

PRINT(N'Add rows to [dbo].[REQUIREMENT_REFERENCES]')
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36403, 691, N'ID.AM-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36404, 691, N'ID.AM-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36405, 691, N'ID.AM-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36406, 691, N'ID.AM-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36407, 691, N'ID.AM-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36408, 691, N'ID.AM-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36409, 691, N'ID.RA-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36410, 691, N'ID.RA-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36411, 691, N'ID.RA-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36412, 691, N'ID.RA-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36413, 691, N'ID.RA-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36414, 691, N'ID.RA-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36415, 691, N'PR.AT-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36416, 691, N'PR.AT-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36417, 691, N'PR.DS-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36418, 691, N'PR.DS-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36419, 691, N'PR.DS-09', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36420, 691, N'DE.AE-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36421, 691, N'DE.AE-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36422, 691, N'DE.AE-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36423, 691, N'DE.AE-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36424, 691, N'DE.CM-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36425, 691, N'DE.CM-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36426, 691, N'DE.CM-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36427, 691, N'DE.CM-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36428, 691, N'RS.CO-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36429, 691, N'RS.CO-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36430, 691, N'RS.AN-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36431, 691, N'RS.MI-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36432, 691, N'RS.MI-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36433, 691, N'RC.RP-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36434, 691, N'RC.RP-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36435, 691, N'RC.RP-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36436, 691, N'RC.RP-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36437, 691, N'RC.RP-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36438, 691, N'RC.CO-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36439, 691, N'ID.AM-08', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36440, 691, N'ID.RA-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36441, 691, N'ID.RA-08', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36442, 691, N'ID.RA-09', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36443, 691, N'ID.IM-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36444, 691, N'ID.IM-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36445, 691, N'ID.IM-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36446, 691, N'ID.IM-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36447, 691, N'PR.AA-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36448, 691, N'PR.AA-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36449, 691, N'PR.AA-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36450, 691, N'PR.AA-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36451, 691, N'PR.AA-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36452, 691, N'PR.AA-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36453, 691, N'PR.DS-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36454, 691, N'PR.DS-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36455, 691, N'PR.PS-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36456, 691, N'PR.PS-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36457, 691, N'PR.PS-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36458, 691, N'PR.PS-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36459, 691, N'PR.PS-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36460, 691, N'PR.PS-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36461, 691, N'PR.IR-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36462, 691, N'PR.IR-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36463, 691, N'PR.IR-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36464, 691, N'PR.IR-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36465, 691, N'DE.AE-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36466, 691, N'DE.AE-08', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36467, 691, N'DE.CM-09', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36468, 691, N'RS.MA-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36469, 691, N'RS.MA-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36470, 691, N'RS.MA-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36471, 691, N'RS.MA-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36472, 691, N'RS.MA-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36473, 691, N'RS.AN-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36474, 691, N'RS.AN-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36475, 691, N'RS.AN-08', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36476, 691, N'RC.RP-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36477, 691, N'RC.CO-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36478, 691, N'GV.OC-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36479, 691, N'GV.OC-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36480, 691, N'GV.OC-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36481, 691, N'GV.OC-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36482, 691, N'GV.OC-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36483, 691, N'GV.RM-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36484, 691, N'GV.RM-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36485, 691, N'GV.RM-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36486, 691, N'GV.RM-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36487, 691, N'GV.RM-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36488, 691, N'GV.RM-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36489, 691, N'GV.RM-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36490, 691, N'GV.SC-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36491, 691, N'GV.SC-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36492, 691, N'GV.SC-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36493, 691, N'GV.SC-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36494, 691, N'GV.SC-05', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36495, 691, N'GV.SC-06', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36496, 691, N'GV.SC-07', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36497, 691, N'GV.SC-08', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36498, 691, N'GV.SC-09', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36499, 691, N'GV.SC-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36500, 691, N'GV.RR-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36501, 691, N'GV.RR-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36502, 691, N'GV.RR-03', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36503, 691, N'GV.RR-04', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36504, 691, N'GV.PO-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36505, 691, N'GV.PO-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36506, 691, N'GV.OV-01', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36507, 691, N'GV.OV-02', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36508, 691, N'GV.OV-03', NULL, NULL, NULL)
PRINT(N'Operation applied to 106 rows out of 106')

PRINT(N'Add rows to [dbo].[REQUIREMENT_SOURCE_FILES]')
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36403, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36404, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36405, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36406, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36407, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36408, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36409, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36410, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36411, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36412, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36413, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36414, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36415, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36416, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36417, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36418, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36419, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36420, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36421, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36422, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36423, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36424, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36425, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36426, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36427, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36428, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36429, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36430, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36431, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36432, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36433, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36434, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36435, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36436, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36437, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36438, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36439, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36440, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36441, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36442, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36443, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36444, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36445, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36446, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36447, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36448, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36449, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36450, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36451, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36452, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36453, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36454, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36455, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36456, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36457, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36458, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36459, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36460, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36461, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36462, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36463, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36464, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36465, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36466, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36467, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36468, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36469, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36470, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36471, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36472, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36473, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36474, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36475, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36476, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36477, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36478, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36479, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36480, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36481, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36482, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36483, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36484, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36485, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36486, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36487, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36488, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36489, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36490, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36491, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36492, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36493, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36494, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36495, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36496, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36497, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36498, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36499, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36500, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36501, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36502, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36503, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36504, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36505, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36506, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36507, 692, N'', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_SOURCE_FILES] ([Requirement_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (36508, 692, N'', NULL, NULL, NULL)
PRINT(N'Operation applied to 106 rows out of 106')

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Add constraints to [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[HYDRO_DATA] WITH CHECK CHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
COMMIT TRANSACTION
GO
