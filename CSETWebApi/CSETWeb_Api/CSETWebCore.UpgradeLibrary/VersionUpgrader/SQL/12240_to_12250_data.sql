/*
Run this script on:

(localdb)\INLLocalDB2022.CIEWeb12240    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.NCUAWeb12250

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 7/25/2024 11:25:59 AM

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

PRINT(N'Drop constraint FK_mq_bonus_mat_q from [dbo].[MQ_BONUS]')
ALTER TABLE [dbo].[MQ_BONUS] NOCHECK CONSTRAINT [FK_mq_bonus_mat_q]

PRINT(N'Drop constraint FK_mq_bonus_mat_q1 from [dbo].[MQ_BONUS]')
ALTER TABLE [dbo].[MQ_BONUS] NOCHECK CONSTRAINT [FK_mq_bonus_mat_q1]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<div class="sub-header-1">Answer Criteria</div><p><strong>Implemented</strong> - Organization has implemented a documented System Lifecycle management process for applications and assets throughout the facility networks.  The process is enforced, reviewed, and updated at least annually.  As part of this process, any applications or assets that are no longer supported have been removed from the system.</p>
<p><strong>In Progress</strong> - Organization has began drafting the required documented System Lifecycle management process for applications and assets throughout the facility networks.  Unsupported applications and assets have been identified and the removal process has started</p>
<p><strong>Scoped</strong> - Organization has identified the required documented System Lifecycle management process for applications and assets throughout the facility networks.  Unsupported applications and assets have been identified</p>
<p><strong>Not Implemented</strong> - Organization does not have a documented System Lifecycle management process for applications and assets throughout the facility networks.  Unsupported applications and assets have not been identified or removed.</p>', [Grouping_Id]=561 WHERE [Mat_Question_Id] = 8500
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<div class="sub-header-1">Answer Criteria</div>
<p><strong>Implemented</strong> - Organization has implemented an ongoing program to identify and inventory unused IT/OT services and devices on the networks, and then disable and/or remove them within a specified amount of time not to exceed 180 days.</p>
<p><strong>In Progress</strong> - Facility has documented all systems, applications, and services running on their network and has started to disable all unnecessary systems, applications, and services.</p>
<p><strong>Scoped</strong> - Facility has documented all systems, applications, and services running on their network and has not disables all unnecessary systems, applications, and services.</p>
<p><strong>Not Implemented</strong> - Organization does not have a program to detect unused IT/OT services and devices on the networks.  Unused services and devices have not been removed.</p>', [Grouping_Id]=560 WHERE [Mat_Question_Id] = 8501
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<div class="sub-header-1">Answer Criteria</div>
<p><strong>Implemented</strong> - Organization has established a Mobile Device Management program that is enforced, documented, and reviewed and updated at least annually.  The MDM program requires asset and application inventory of any mobile device on the the network.  The program should also clearly define and publish an acceptable use policy for mobile devices. The program should also include policies about Bring Your Own Device (BYOD) requirements.</p>
<p><strong>In Progress</strong> - Organization has  a Mobile Device Management program that enforcement has started. It is documented, and has a requirement to be reviewed and updated at least annually.  The MDM program requires asset and application inventory of any mobile device on the the network.  The program should also clearly define and publish an acceptable use policy for mobile devices. The program should also include policies about Bring Your Own Device (BYOD) requirements.</p>
<p><strong>Scoped</strong> - Organization has documented  a Mobile Device Management program. It is currently unforced.   The MDM program requires asset and application inventory of any mobile device on the the network.  The program should also clearly define and publish an acceptable use policy for mobile devices. The program should also include policies about Bring Your Own Device (BYOD) requirements.</p>
<p><strong>Not Implemented</strong> - Organization does not have a mobile device management program.  The organization doesn''t track either assets or applications, and has no insight into what devices may be present on their network.</p>', [Sequence]=2, [Grouping_Id]=560 WHERE [Mat_Question_Id] = 8502
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Update rows in [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]')
UPDATE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] SET [OptionText]=N'Industry peers (informal exchanges)' WHERE [Option_Id] = 45
UPDATE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] SET [OptionText]=N'Anti-trust regulation' WHERE [Option_Id] = 55
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add rows to [dbo].[GEN_FILE_LIB_PATH_CORL]')
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (668, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (669, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (674, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2067, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2092, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2099, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2100, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2104, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2105, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2106, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2108, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2109, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2148, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2151, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2248, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2271, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2272, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2330, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2331, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2342, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2361, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2474, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2597, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2598, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2603, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2605, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2606, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2610, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2611, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2612, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2613, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2614, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2615, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2616, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2620, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2627, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2634, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2635, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2686, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2688, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2689, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (2720, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3753, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3755, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3783, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3784, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3785, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3786, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3788, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3790, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3825, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3937, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (4992, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5036, 509)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5048, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (5065, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6069, 508)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (6070, 508)
PRINT(N'Operation applied to 58 rows out of 58')

PRINT(N'Add rows to [dbo].[MATURITY_GROUPINGS]')
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPINGS] ON
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix], [Description_Extended]) VALUES (560, N'Identify', N'', 18, 1, NULL, 1, 1, N'', N'', N'1.0', NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix], [Description_Extended]) VALUES (561, N'Protect', N'', 18, 2, NULL, 1, 1, N'', N'', N'2.0', NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix], [Description_Extended]) VALUES (562, N'Detect', N'', 18, 3, NULL, 1, 1, N'', N'', N'3.0', NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix], [Description_Extended]) VALUES (563, N'Respond', N'', 18, 4, NULL, 1, 1, N'', N'', N'4.0', NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix], [Description_Extended]) VALUES (564, N'Recover', N'', 18, 5, NULL, 1, 1, N'', N'', N'5.0', NULL)
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPINGS] OFF
PRINT(N'Operation applied to 5 rows out of 5')

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
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MQ_BONUS] WITH CHECK CHECK CONSTRAINT [FK_mq_bonus_mat_q]
ALTER TABLE [dbo].[MQ_BONUS] WITH CHECK CHECK CONSTRAINT [FK_mq_bonus_mat_q1]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Add DML triggers to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ENABLE TRIGGER [trg_update_maturity_groupings]
COMMIT TRANSACTION
GO
