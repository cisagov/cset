/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb12013    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb12014

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 2/20/2023 10:01:28 AM

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

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_LEVELS]')
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS]
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL]

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

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_STANDARD_CATEGORY_SEQUENCE_STANDARD_CATEGORY from [dbo].[STANDARD_CATEGORY_SEQUENCE]')
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] NOCHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_STANDARD_CATEGORY]

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

PRINT(N'Drop constraint FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK__AVAILABLE__model__6F6A7CB2 from [dbo].[AVAILABLE_MATURITY_MODELS]')
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] NOCHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]

PRINT(N'Drop constraint FK_MATURITY_LEVELS_MATURITY_MODELS from [dbo].[MATURITY_LEVELS]')
ALTER TABLE [dbo].[MATURITY_LEVELS] NOCHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MATURITY_MODELS from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS from [dbo].[MODES_SETS_MATURITY_MODELS]')
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_GALLERY_ROWS_GALLERY_GROUP from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]

PRINT(N'Update rows in [dbo].[GALLERY_GROUP_DETAILS]')
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=6 WHERE [Group_Detail_Id] = 23
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=5 WHERE [Group_Detail_Id] = 24
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=4 WHERE [Group_Detail_Id] = 25
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=2 WHERE [Group_Detail_Id] = 27
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=3 WHERE [Group_Detail_Id] = 101
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Update rows in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'These basic guidelines are applicable to operational natural gas and hazardous liquid transmission pipeline systems, natural gas distribution pipeline systems, and liquefied natural gas facility operators. Additionally, they apply to operational pipeline systems that transport materials categorized as toxic inhalation hazards (TIH). TIH materials are gases or liquids that are known or presumed on the basis of tests to be so toxic to humans as to pose a health hazard in the event of a release during transportation.

This standard includes the replacement of section 5 (Criticality)' WHERE [Gallery_Item_Guid] = '7cf3a4a1-56b6-40ad-ac66-1b1ac936a356'
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'<p>This assessment covers basic recommended practices for securing control and communication systems in rail transit environments. This assessment<ul>
<li>addresses Defense-In-Depth as a recommended approach for securing rail communications and control systems,</li>
<li>defines security zone classifications, and</li>
<li>defines a minimum set of security controls for the most critical zones: the “SAFETY CRITICAL SECURITY ZONE (SCSZ)” and the “FIRE, LIFE-SAFETY SECURITY ZONE (FLSZ).”</li></ul></p>' WHERE [Gallery_Item_Guid] = '3edb25dd-a1ff-4a0a-9762-33e4a0887ef5'
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'This document is part of a multipart standard that addresses the issue of security for industrial automation and control systems (IACS). It has been developed by working group 04, task group 06 of the ISA99 committee in cooperation with IEC TC65/WG10.
This document prescribes the activities required to perform security risk assessments on a new or existing IACS and the design activities required to mitigate the risk to tolerable levels.' WHERE [Gallery_Item_Guid] = 'b9dca07b-887d-4aaa-aba6-806172581636'
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'These guidelines are applicable to operational natural gas and hazardous liquid transmission pipeline systems, natural gas distribution pipeline systems, and liquefied natural gas facility operators. Additionally, they apply to operational pipeline systems that transport materials categorized as toxic inhalation hazards (TIH). TIH materials are gases or liquids that are known or presumed on the basis of tests to be so toxic to humans as to pose a health hazard in the event of a release during transportation.

This standard includes the replacement of section 5 (Criticality)' WHERE [Gallery_Item_Guid] = '8f3f4431-3482-44c0-92c2-dccbb14dd8aa'
PRINT(N'Operation applied to 4 rows out of 4')

PRINT(N'Add row to [dbo].[GALLERY_GROUP]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] ON
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (75, N'Temporary for C2M2')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] OFF

PRINT(N'Add row to [dbo].[GALLERY_ITEM]')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('d752a1b1-9afe-44cb-b114-e7517339d776', N'C2M2_V11.png', N'C2M2_V11.png', N'{Model:{ModelName:"C2M2"}}', N'The C2M2 focuses on the implementation and management of cybersecurity practices associated with the information technology (IT) and operations technology (OT) assets and the environments in which they operate.', NULL, N'Cybersecurity Capability Maturity Model (C2M2)', 0, '2023-02-14 16:49:32.617')

PRINT(N'Add row to [dbo].[MATURITY_GROUPING_TYPES]')
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPING_TYPES] ON
INSERT INTO [dbo].[MATURITY_GROUPING_TYPES] ([Type_Id], [Grouping_Type_Name]) VALUES (10, N'Objective')
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPING_TYPES] OFF

PRINT(N'Add row to [dbo].[MATURITY_MODELS]')
SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] ON
INSERT INTO [dbo].[MATURITY_MODELS] ([Maturity_Model_Id], [Model_Name], [Questions_Alias], [Answer_Options], [Analytics_Rollup_Level], [Model_Title]) VALUES (12, N'C2M2', N'Practices', N'Y,I,S,N', 1, N'Cybersecurity Capability Maturity Model (C2M2) 2.1')
SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] OFF

PRINT(N'Add row to [dbo].[SETS]')
INSERT INTO [dbo].[SETS] ([Set_Name], [Full_Name], [Short_Name], [Is_Displayed], [Is_Pass_Fail], [Old_Std_Name], [Set_Category_Id], [Order_In_Category], [Report_Order_Section_Number], [Aggregation_Standard_Number], [Is_Question], [Is_Requirement], [Order_Framework_Standards], [Standard_ToolTip], [Is_Deprecated], [Upgrade_Set_Name], [Is_Custom], [Date], [IsEncryptedModule], [IsEncryptedModuleOpen]) VALUES (N'Wind_CERT', N'Wind Cybersecurity Evaluation Risk Tool', N'Wind CERT', 1, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, 0, NULL, 0, NULL, 0, 1)

PRINT(N'Add rows to [dbo].[STANDARD_CATEGORY]')
INSERT INTO [dbo].[STANDARD_CATEGORY] ([Standard_Category]) VALUES (N'Inventory and Control of PV System Technology Assets')
INSERT INTO [dbo].[STANDARD_CATEGORY] ([Standard_Category]) VALUES (N'Inventory and Control of Software and Firmware Assets')
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add row to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (2193, 75, 0, 0, 'd752a1b1-9afe-44cb-b114-e7517339d776')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF

PRINT(N'Add rows to [dbo].[MATURITY_GROUPINGS]')
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPINGS] ON
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (500, N'Asset, Change, and Configuration Management', NULL, 12, 1, NULL, NULL, 1, N'1', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (501, N'Threat and Vulnerability Management', NULL, 12, 2, NULL, NULL, 1, N'2', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (502, N'Risk Management', NULL, 12, 3, NULL, NULL, 1, N'3', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (503, N'Identity and Access Management', NULL, 12, 4, NULL, NULL, 1, N'4', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (504, N'Situation Awareness', NULL, 12, 5, NULL, NULL, 1, N'5', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (505, N'Event and Incident Response, Continuity of Operations', NULL, 12, 6, NULL, NULL, 1, N'6', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (506, N'Third-Party Risk Management', NULL, 12, 7, NULL, NULL, 1, N'7', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (507, N'Workforce Management', NULL, 12, 8, NULL, NULL, 1, N'8', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (508, N'Cybersecurity Architecture', NULL, 12, 9, NULL, NULL, 1, N'9', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (509, N'Cybersecurity Program Management', NULL, 12, 10, NULL, NULL, 1, N'10', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (510, N'Manage IT and OT Asset Inventory', NULL, 12, 1, 500, NULL, 10, N'11', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (511, N'Manage Information Asset Inventory', NULL, 12, 2, 500, NULL, 10, N'12', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (512, N'Manage IT and OT Asset Configurations', NULL, 12, 3, 500, NULL, 10, N'13', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (513, N'Manage Changes to IT and OT Assets', NULL, 12, 4, 500, NULL, 10, N'14', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (514, N'Management Activities for the ASSET domain', NULL, 12, 5, 500, NULL, 10, N'15', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (515, N'Reduce Cybersecurity Vulnerabilities', NULL, 12, 1, 501, NULL, 10, N'16', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (516, N'Respond to Threats and Share Threat Information', NULL, 12, 2, 501, NULL, 10, N'17', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (517, N'Management Activities for the THREAT domain', NULL, 12, 3, 501, NULL, 10, N'18', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (518, N'Establish and Maintain Cyber Risk Management Strategy and Program', NULL, 12, 1, 502, NULL, 10, N'19', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (519, N'Identify Cyber Risk', NULL, 12, 2, 502, NULL, 10, N'20', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (520, N'Analyze Cyber Risk', NULL, 12, 3, 502, NULL, 10, N'21', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (521, N'Respond to Cyber Risk', NULL, 12, 4, 502, NULL, 10, N'22', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (522, N'Management Activities for the RISK domain', NULL, 12, 5, 502, NULL, 10, N'23', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (523, N'Establish Identities and Manage Authentication', NULL, 12, 1, 503, NULL, 10, N'24', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (524, N'Control Logical Access', NULL, 12, 2, 503, NULL, 10, N'25', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (525, N'Control Physical Access', NULL, 12, 3, 503, NULL, 10, N'26', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (526, N'Management Activities for the ACCESS domain', NULL, 12, 4, 503, NULL, 10, N'27', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (527, N'Perform Logging', NULL, 12, 1, 504, NULL, 10, N'28', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (528, N'Perform Monitoring', NULL, 12, 2, 504, NULL, 10, N'29', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (529, N'Establish and Maintain Situational Awareness', NULL, 12, 3, 504, NULL, 10, N'30', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (530, N'Management Activities for the SITUATION domain', NULL, 12, 4, 504, NULL, 10, N'31', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (531, N'Detect Cybersecurity Events', NULL, 12, 1, 505, NULL, 10, N'32', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (532, N'Analyze Cybersecurity Events and Declare Incidents', NULL, 12, 2, 505, NULL, 10, N'33', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (533, N'Respond to Cybersecurity Incidents', NULL, 12, 3, 505, NULL, 10, N'34', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (534, N'Address Cybersecurity in Continuity of Operations', NULL, 12, 4, 505, NULL, 10, N'35', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (535, N'Management Activities for the RESPONSE domain', NULL, 12, 5, 505, NULL, 10, N'36', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (536, N'Identify and Prioritize Third Parties', NULL, 12, 1, 506, NULL, 10, N'37', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (537, N'Manage Third-Party Risk', NULL, 12, 2, 506, NULL, 10, N'38', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (538, N'Management Activities for the THIRD-PARTIES domain', NULL, 12, 3, 506, NULL, 10, N'39', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (539, N'Implement Workforce Controls', NULL, 12, 1, 507, NULL, 10, N'40', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (540, N'Increase Cybersecurity Awareness', NULL, 12, 2, 507, NULL, 10, N'41', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (541, N'Assign Cybersecurity Responsibilities', NULL, 12, 3, 507, NULL, 10, N'42', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (542, N'Develop Cybersecurity Workforce', NULL, 12, 4, 507, NULL, 10, N'43', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (543, N'Management Activities for the WORKFORCE domain', NULL, 12, 5, 507, NULL, 10, N'44', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (544, N'Establish and Maintain Cybersecurity Architecture Strategy and Program', NULL, 12, 1, 508, NULL, 10, N'45', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (545, N'Implement Network Protections as an Element of the Cybersecurity Architecture', NULL, 12, 2, 508, NULL, 10, N'46', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (546, N'Implement IT and OT Asset Security as an Element of the Cybersecurity Architecture', NULL, 12, 3, 508, NULL, 10, N'47', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (547, N'Implement Software Security as an Element of the Cybersecurity Architecture', NULL, 12, 4, 508, NULL, 10, N'48', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (548, N'Implement Data Security as an Element of the Cybersecurity Architecture', NULL, 12, 5, 508, NULL, 10, N'49', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (549, N'Management Activities for the ARCHITECTURE domain', NULL, 12, 6, 508, NULL, 10, N'50', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (550, N'Establish Cybersecurity Program Strategy', NULL, 12, 1, 509, NULL, 10, N'51', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (551, N'Establish and Maintain Cybersecurity Program', NULL, 12, 2, 509, NULL, 10, N'52', NULL, NULL)
INSERT INTO [dbo].[MATURITY_GROUPINGS] ([Grouping_Id], [Title], [Description], [Maturity_Model_Id], [Sequence], [Parent_Id], [Group_Level], [Type_Id], [Title_Id], [Abbreviation], [Title_Prefix]) VALUES (552, N'Management Activities for the PROGRAM domain', NULL, 12, 3, 509, NULL, 10, N'53', NULL, NULL)
SET IDENTITY_INSERT [dbo].[MATURITY_GROUPINGS] OFF
PRINT(N'Operation applied to 53 rows out of 53')

PRINT(N'Add rows to [dbo].[NEW_QUESTION_SETS]')
SET IDENTITY_INSERT [dbo].[NEW_QUESTION_SETS] ON
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19468, N'Wind_CERT', 69)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19469, N'Wind_CERT', 1235)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19470, N'Wind_CERT', 1875)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19471, N'Wind_CERT', 3591)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19472, N'Wind_CERT', 5007)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19473, N'Wind_CERT', 5008)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19474, N'Wind_CERT', 5010)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19475, N'Wind_CERT', 5062)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19476, N'Wind_CERT', 5132)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19477, N'Wind_CERT', 5146)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19478, N'Wind_CERT', 5149)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19479, N'Wind_CERT', 5162)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19480, N'Wind_CERT', 5205)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19481, N'Wind_CERT', 5206)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19482, N'Wind_CERT', 5207)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19483, N'Wind_CERT', 5212)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19484, N'Wind_CERT', 5213)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19485, N'Wind_CERT', 9723)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19486, N'Wind_CERT', 9791)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19487, N'Wind_CERT', 10057)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19488, N'Wind_CERT', 10132)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19489, N'Wind_CERT', 11022)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19490, N'Wind_CERT', 12279)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19491, N'Wind_CERT', 15916)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19492, N'Wind_CERT', 17401)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19493, N'Wind_CERT', 17402)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19494, N'Wind_CERT', 17403)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19495, N'Wind_CERT', 17405)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19496, N'Wind_CERT', 17406)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19497, N'Wind_CERT', 17407)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19498, N'Wind_CERT', 17412)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19499, N'Wind_CERT', 17413)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19500, N'Wind_CERT', 17414)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19501, N'Wind_CERT', 17415)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19502, N'Wind_CERT', 17422)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19503, N'Wind_CERT', 17423)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19504, N'Wind_CERT', 17424)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19505, N'Wind_CERT', 17425)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19506, N'Wind_CERT', 17426)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19507, N'Wind_CERT', 17427)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19508, N'Wind_CERT', 17428)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19509, N'Wind_CERT', 17429)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19510, N'Wind_CERT', 17430)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19511, N'Wind_CERT', 17431)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19512, N'Wind_CERT', 17432)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19513, N'Wind_CERT', 17433)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19514, N'Wind_CERT', 17434)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19515, N'Wind_CERT', 17435)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19516, N'Wind_CERT', 17436)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19517, N'Wind_CERT', 17437)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19518, N'Wind_CERT', 17438)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19519, N'Wind_CERT', 17439)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19520, N'Wind_CERT', 17443)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19521, N'Wind_CERT', 17451)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19522, N'Wind_CERT', 17452)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19523, N'Wind_CERT', 17453)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19524, N'Wind_CERT', 17454)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19525, N'Wind_CERT', 17458)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19526, N'Wind_CERT', 17459)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19527, N'Wind_CERT', 17460)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19528, N'Wind_CERT', 17461)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19529, N'Wind_CERT', 17462)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19530, N'Wind_CERT', 17463)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19531, N'Wind_CERT', 17464)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19532, N'Wind_CERT', 17465)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19533, N'Wind_CERT', 17466)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19534, N'Wind_CERT', 17470)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19535, N'Wind_CERT', 17471)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19536, N'Wind_CERT', 17488)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19537, N'Wind_CERT', 17489)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19538, N'Wind_CERT', 17490)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19539, N'Wind_CERT', 17496)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19540, N'Wind_CERT', 17497)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19541, N'Wind_CERT', 17518)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19542, N'Wind_CERT', 17519)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19543, N'Wind_CERT', 17520)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19544, N'Wind_CERT', 17541)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19545, N'Wind_CERT', 17542)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (19546, N'Wind_CERT', 17549)
SET IDENTITY_INSERT [dbo].[NEW_QUESTION_SETS] OFF
PRINT(N'Operation applied to 79 rows out of 79')

PRINT(N'Add rows to [dbo].[NEW_REQUIREMENT]')
SET IDENTITY_INSERT [dbo].[NEW_REQUIREMENT] ON
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31605, N'1.1', N'Establish and maintain an Asset Inventory of all technology assets (IT and OT assets) including: (a) enterprise; (b) operational technology; (c) assets with the potentital to store or process data; and (d) any other technology / cyber assets used to operate, manage, protect or secure all entity owned assets and perimeters. Include classification designations to effectively distinguish critical and high-risk assets. Should ensure review/integration of assets connected physically, virtually, remotely and within the cloud environement (even where not owned by the asset owner as specific remediation measures may be needed to ensure strong security). Ensure continuous update controls including periodic reviews of the inventory and inventory cross-check and update requirements within any change management processes.  Refer to 2.1 below and consider integrating approach/controls.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Ensure inclusion of ALL assets.  See below for asset identification/discovery tools that can be used to support the development and management of asset inventories).  <br><br>2. The inventory should include some classification capability to be able to more easily assess and distinguish between critical, priority and lower-risk assets. This may require designing an initial /more mature classification guidance control as well. How you define and classify specific assets will inform how all other controls are prioritized and applied. For PV Sites this will include as a priority all assets with the potential to communicate and store/process data and critical operating assets. Examples such as PV System end devices including (e.g., network devices, OT devices, SCADA devices, servers, and mobile devices); remote interactive access capabilities; cloud based technologies (e.g., software, security support tools like for patching programs); other owner assets that may impact your assets. <br><br>3. Ensure processes to monitor for accuracy and updates to the inventory and for inclusion within any change management controls of a requirement to review/update inventory. <br><br>4. Consider inclusion of monitoring controls or other program controls to timely identify unauthorized assets (e.g., SIEM) and immediate response capability to assess risk, update inventory and take other necessary action.</div><div><br/></div></div>', N'Inventory and Control of Enterprise Assets', N'Inventory and Control of Enterprise Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'1.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31606, N'1.2', N'Define processes and controls to respond to and resolve the identification of assets not included in the Asset Inventory. These may be new assets added to the system not properly included for an update; previously unidentified assets; and/or unauthorized asset introduced to the system without permission. To reduce risk of unauthorized asset issues, close/lock-down unused ports and services (see also 4.1 below)', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Process should allow for frequent and real-time response to discovery of unauthorized assets. <br><br>2. Process should include an immediate risk-assessment to allow for prioritization of response activities.<br><br>3. Processes may include removal of the asset from the network, deny the asset from connecting remotely to the network, or quarantine the asset (in many cases these actions may be taken as default actions until more investigation or other action can be taken).</div><div><br/></div></div>', N'Inventory and Control of Enterprise Assets', N'Inventory and Control of Enterprise Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'1.2', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31607, N'1.3', N'Utilize a technology asset discovery tool and/or process to identify and monitor for assets on and within your network. This includes enterprise IT and OT; networks, perimeters and access points; internal networks and assets; and remote assets. This may be a combination of a tool and physical walk-down or other processes as well.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Ensure the tool is utilized to scan and monitor all assets. Be sure to consider how it will be used for enterprise IT and OT; networks, perimeters and access points; internal networks and assets; and remote assets The tool may need to be configured/deployed differently if OT assets have been segregated from the IT network but should be used for both.  <br><br>2. The tool should be configured for real-time continuous monitoring capability to better identify and escalate potential threat0s or unusual activity (e.g., internal assets communicating externally in an unusual way). <br><br>3. Ensure processes/controls for assessing and responding to escalated issues, including potential threats, identification of unauthorized assets and potential vulnerabilities.</div><div><br/></div></div>', N'Inventory and Control of Enterprise Assets', N'Inventory and Control of Enterprise Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'1.3', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31608, N'1.4', N'Establish a process and/or use a tool to develop a log of IP Addresses and Firewall Rule Sets for the technology assets and updates/management of the Asset Inventory. Review and use logs to update the enterprise’s asset inventory on a periodic basis, preferaably at least weekly.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Periodic review is critical, recommended frequency is weekly but where not possible or where there are less risks and/or complex/mature assets and configurations this may be less frequent. <br><br>2. Where able and for more mature configurations, use Dynamic Host Configuration Protocol (DHCP) logging on all DHCP servers or Internet Protocol (IP) address management tools to update the technology asset inventory.<br><br>3. Where a tool is not used, manual logging and management may be required (e.g., spreadsheet). If so, this data should be managed as confidential requiring protection, limited access and included as part of critical backup activities.</div><div><br/></div></div>', N'Inventory and Control of Enterprise Assets', N'Inventory and Control of Enterprise Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'1.4', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31609, N'2.1', N'Establish and maintain a detailed inventory all licensed software and firmware installed on all technology assets (IT and OT assets) including: (a) enterprise; (b) operational technology; (c) PV System end devices; and (d) any other technology / cyber assets used to operate, manage, protect or secure all entity owned assets and perimeters. The software inventory must include all key data related to the purchase, installation, management (including patches) of that software and firmware. The inventory should be reviewed and updated on a periodic basis, not less than annually.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Refer also to 1.1 above and consider integrating Software/Firmware Inventory with Asset Inventory and related process/controls. For each cyber asset identified list all associated solfware firm ware operation system versions, installed date and purpose<br><br>2. The software inventory must document the title, publisher, initial install/use date, and business purpose for each entry; where appropriate, include the Uniform Resource Locator (URL), app store(s), version(s), deployment mechanism, and decommission date. <br><br><br>Refer to 1.1 above for additional guidance</div><div><br/></div></div>', N'Inventory and Control of Software Assets', N'Inventory and Control of Software Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'2.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31610, N'2.3', N'Refer also to 1.2 above. Ensure that a process exists to address unauthorized software and firmware. Process should provide for identification, assessment and ability to immediately remediate where applicable. For PV system end devices, communications systems, workstations and similar critical assets or assets used for communication and data management, unauthorized software/firmware should either be removed or an exception documented with identified remediation measures for any risks. Reviews for unauthorized software/firmware should be conducted on a periodic basis not less than monthly.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Consider integrating controls for the identification, inventory, tracking and management of assets (Asset Inventory, 1.1 above) with these processes and controls. <br><br>2. Processes should provide guidance on how to assess criticality, escalation, review and decision protocols and rules for approval of removal or exception procedures. Documented exceptions should include an assessment of any risk, summary of remediation measures and any periodic or future review cycles required to ensure continued applicability. <br><br>3. Reviews to identify and assess unauthorized software/firmware should occur with reasonable frequency. Reviews of the processes and controls to implement this recommendation should be conducted at least annually.</div><div><br/></div></div>', N'Inventory and Control of Software Assets', N'Inventory and Control of Software Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'2.3', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31611, N'2.4', N'Where possible, use automated tools to scan for, identify, monitor and manage software and firmware inventory.This may include tools that support other activities but include reports and notifications on softare and firmware risks (e.g., patch management and other general guidance notifications about identified vulnerabilities).  Refer to 1.1 above for additional guidance.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Where automated tools cannot be used or configured to support this capability on-site, the inventory may need to be managed through more manual processes (e.g., spreadsheet).  Consider leveraging available resources to obtain regular reports and information about assets/hardware/firmware/software to understand potential risks with the existing Asset Inventory and better identify priority reviews.</div><div><br/></div></div>', N'Inventory and Control of Software Assets', N'Inventory and Control of Software Assets', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'2.4', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31612, N'2.5', N'Develop "Allowed" lists or Whitelists for Authorized software, libraries and scripts to ensure exceuting activities and access is approved and secure. Review the Asset and Software/Firmware Inventory to ensure all assets have been evaluated for application of allowed activities/lists. Ensure controls for periodic review of lists to identify unauthorized changes and implement critical updates due to patch or other vulnerability alerts.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Allowed lists used with PV Asset communications and data systems, especially those that are remotely accessed or connected directly to third-party assets (e.g., direct connection to an IOU), should be reviewed on a frequent basis, not less than monthly. Ensure processes for strict control to changes or updates to lists. Limit the personnel who have the authority to define, change, update, remove lists/rules.</div><div><br/></div></div>', N'Inventory and Control of Software and Firmware Assets', N'Develop Allow Lists for Software, Libraries, Scripts', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'2.5', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31613, N'3.1', N'Establish a data management process that includes: (a) classification categories for high-risk and sensitive data (3.7), including power systems data, Personally Identifable Information (PII), Critical Energy Infrastructure Information (CEII), high-risk operating, market and asset security data (e.g., for systems with remote operability); (b) guidance for labeling or otherwise flagging for identification data requiring protection or enhanced security controls; (c) data management and retention processes including creation, storage (see 3.4), transmisison and destruction (see 3.5) protocols; (d) access requirements to ensure access to data is restricted according to the sensitivity designation (see 3.3).', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Assets prioritized as high-risk typically also include high-risk data (e.g., PV System end devices, communications systems, workstations). Leverage the Asset Inventory as a tool to support analysis for identifying, inventorying, classification and protection of data. <br><br>2. Protection of high-risk and sensitive data includes both Access Controls (3.3) and encryption (see 3.6-3.10)<br><br>3. For organizations with more mature capabilities, process should be integrated with existing Records Management and Access Control programs. <br><br>4.For smaller organizations, critical data requiring protection may be more limited. Ensure this includes IP addresses, passwords, critical operating and controls data for remote operable assets and assets connected directly to external third-party assets.</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31614, N'3.2', N'Establish processes and controls to assess, identify and inventory sensitive data to support management of controls in accordance with the Data Classification and Management Process (3.1). Ensure periodic review for missing or misclassified data requiring protection. Refer to 1.2 and 2.2 above', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Refer to 3.8 "Document Data Flows" and review documented data flows to better inventory, identify, classify and protect sensitive and high-risk data.</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.2', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31615, N'3.3', N'Define information access controls for protected or sensitive data, including local and remote file systems, databases, and applications. Access controls will need to be applied to logical and physical access (directly to data or to assets used to store or transmit the data). Access should be limited to "need to know" and require review and approval prior to grant of access.  Lists of any personnel with access, the type of access, reason access is required, any approver(s) and date of approval should be maintained, reviewed and verified periodically. Define a control for logging and review of logs of access (3.14) Refer also to 6 Access Control Management.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1.   Information/Data access controls should be integrated with and aligned to processes and controls for cyber asset and physical access management. <br><br>2. Access lists and approved credentials should be reviewed periodically, but not less than quarterly.<br><br>3. Prioritize access controls for assets storing and communicating sensitive data that are directly connected to external third-party assets/remotely operable/defined critical assets (e.g., PV System end devices, communications systems, workstations)</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.3', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31616, N'3.4', N'Data retention requirements should be defined and must consider both business need and any regulatory/legal/contractual obligations. Third-party agreements may include requirements for the manner and minimum length of retention. Any data retention processes should be aligned to the company program where one exists.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>IOU interconnection agreements may include specific requirements for data retention, storage and management.</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.4', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31617, N'3.5', N'Data disposal and destruction requirements should be defined and prioritized according to risk and must effectively permanently remove/clear/destroy the relevant data from the asset and any other systems (e.g., backups).', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Hardware should be destroyed in accordance with common security standards to ensure inability to retreive or recreate data. Ensure any requirements are coordinated with and aligned to any relevant Records Management Program(s).</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.5', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31618, N'3.6', N'Encrypt removable media and other data-at-rest on all devices containing sensitive information. DER and gateway devices should be encrypted to protect vendor intellectual property; DERMS data should be protected because it contains PII and financial information. Encryption tool example implementations include: Windows BitLocker®, Apple FileVault®, Linux® dm-crypt.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Encrypt data on end-user devices containing sensitive data. Assets prioritized as high-risk typically also include high-risk data (e.g., PV System end devices, communications systems, workstations). Leverage the Asset Inventory as a tool to support analysis for identifying data encryption priorities. <br><br>2. Communications protocols with third-parties may include specific encryption requirements. Interconnection rules/regulations may also include specific encryption requirements. Review these to ensure alignment.  <br><br>3.  Encrypt dat on DER, DERMS, Gateways. <br><br>4. Example implementations can include: Windows BitLocker®, Apple FileVault®, Linux® dm-crypt.</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.6', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31619, N'3.1', N'Encrypt sensitive data in transit including communications specific to operations and with external third-party assets and across external networks. See also 3.6 for priority considerations.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Communications protocols with third-parties may include specific encryption requirements. Interconnection rules/regulations may also include specific encryption requirements. Review these to ensure alignment.  <br><br>2. Example implementations can include: Transport Layer Security (TLS) and Open Secure Shell (OpenSSH).</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31620, N'3.7', N'Establish and maintain an overall data classification scheme to ensure identification and labeling of sensitive and high-risk data. Review and update the classification scheme annually, or when significant regulatory or organizational changes occur to mitigate gaps in classification and protection controls.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. General Classifications may include “Sensitive,” “Confidential” "Attorney-Client Privileged"// Specifically Regulated Data Classifications may include: Critical Energy Infrastructure Information (CEII); Personally Identifiable Information (PII); Bulk Electric Cyber System Information (BCSI). <br><br>2. Classifications are critical to the ability of the organization to effectively protect and encrypt sensitive and high-risk data. Implementation efforts should focus on prioritizing classification and protection of this data. <br><br>3. DER may contain PII, or other sensitive data associated with homeowners or owner/operator for utility/commercial systems. Financial information could be determined from production data.</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.7', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31621, N'3.8', N'Document data flows to inform data classification, management, protection/encryption priorities. Ensure review and inclusion of PV System end devices, communications systems, work stations, remote operable devices and assets that communicate directly with external third-party assets/across external networks. Data flow documentation may include service provider data flows. All data flows should be classified and managed as sensitive data.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Review and update documentation annually, or when significant regulatory or organizational changes occur to mitigate gaps</div><div><br/></div></div>', N'Data Protection', N'Data Protection', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.8', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31622, N'3.12', N'Sensitive and high-risk data and assets used to process and store it (e.g., OT) should be segmented and proper access controls applied (See 3.3). Do not use general enterprise and IT assets for data processing and storage of sensitive OT data, ensure enterprise assets that are used for sensitive and high-risk data have also been segmented.', N'', N'Data Security', N'Implement Data Processing and Storage Segmentation', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.12', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31623, N'3.14', N'Define and implement controls to log access to sensitive data, monitor activity (including modification and disposal) and assess/escalate potential unauthorized access or activities for investigation and remediation.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Assets prioritized as high-risk typically also include high-risk data (e.g., PV System end devices, communications systems, workstations). Leverage the Asset Inventory as a tool to support analysis for identifying access logging and monitoring priorities.</div><div><br/></div></div>', N'Data Security', N'Define Data Access Logging and Monitoring Controls', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 86, N'3.14', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31624, N'4.1', N'Establish and maintain processes for designing and implementing secure configurations for your technology (IT and OT) assets and software. Leverage your Asset, Software/Firmware Inventory to identify high-risk and priority assets.  Prioritize high-risk, Controllers/workstations/SCADA assets, PV end systems, communications systems, assets connected directly to external networks and third-party assets. Layer your controls to create "defense-in-depth" by appling several controls for prioritized assets. Key activities and controls supporting secure configuration include: 

1. Review any pre-configured settings to identify required changes (pre-configured and default controls are typically insecure), this includes default passwords, default accounts on assets and software, such as root, administrator, and other pre-configured vendor accounts, which should be disabled or made unusable. Uninstall or disable unnecessary services on assets and software. 

2. Implement and manage firewalls on servers and to manage access to perimeters. Where PV sytem assets are directly connected to an external network and/or third-party asset, firewalls should be used to support appropriate access control and management. Implement and manage a host-based firewall or port-filtering tool on PV system end devices, with a default-deny rule that drops all traffic except those services and ports that are explicitly allowed.Lock down/disable all unused ports and services. 

3. Configure assets to use trusted DNS (internal/entity owned and controlled DNS servers) or known/verified externally accessible DNS servers. 

4. Apply automatic lockout rules for repeat failed login/access attempts.  

5. Implement automatic session locking on assets after a defined period of inactivity (typically 15 minutes or 2 minutes for mobile end-user devices). Where lockout on OT or similar assets would cause potential asset/operation impact this may not be possible, secure these assets with additional layers of physical and access controls.

6. Where mobile devices are used, ensure ability to wipe organizational data from these portable end-user devices in the event of loss, theft or termination. Separate enterprise applications and data from personal applications and data.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Leverage standardized reference architecture for solar plant designs. <br><br>Securely manage enterprise assets and software. Example implementations include managing configuration through version-controlled-infrastructure-as-code and accessing administrative interfaces over secure network protocols, such as Secure Shell (SSH) and Hypertext Transfer Protocol Secure (HTTPS). Do not use insecure management protocols, such as Telnet (Teletype Network) and HTTP, unless operationally essential.</div><div><br/></div></div>', N'Secure Configuration of Enterprise Assets and Software', N'Secure Configuration of Enterprise Assets and Software', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'4.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31625, N'5.1', N'Establish and maintain an inventory of all accounts for IT and OT assets (e.g., Service, use, management, control accounts).  The inventory must include both user and administrator accounts. Account Inventories should be reviewed at least quarterly to verify continued validity of all authorizations. Controls should be implemented to monitor for transfers, terminations and new-hires and updates to the account user information. Refer also to 1.1, 2.1, 3.2 and Section 6 below and ensure Account Inventory processes are aligned to Asset, Software/Firmware, Data Inventory management.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. The inventory, at a minimum, should contain the person’s name, username, purpose/justification, start/stop dates, department and approver for the user. <br><br>2. Strict controls should be applied for the use of Administrator accounts (see 5.4) and users with credentials/access should be limited. Administrator Account inventories should list every user with access to the administrator credentials, justification for that access, approver for that administrator credential and to ensure role-based and appropriate the other general user information.<br><br>2. OT and high-risk assets should be verified monthly if possible.  <br><br>3. Ensure system scanning tools are configured to support the identification of accounts and processes are in place to review and manage any unauthorized or unknown accounts (see below).<br><br>4. Account Inventories should be reviewed and validated at least quarterly, processes for managing Account Inventories should be reviewed annually.</div><div><br/></div></div>', N'Account Management', N'Account Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 5, N'5.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31626, N'5.2', N'Use unique passwords for all technology assets. Best practice implementation includes, at a minimum, an 8-character password for accounts and the use of MFA. Where MFA is not possible,  a 14-character password requirement is recommended.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Avoid use of shared corporate accounts where possible, prohibit the sharing of password credentials where not authorized, and limit administrative accounts (refer to 5.1)<br><br>2. Heightened requirements should be applied to high-risk and remote accessible/operable assets, this may be mandatory MFA, complex password requirements and periodic verification of compliance to the control.</div><div><br/></div></div>', N'Account Management', N'Account Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 5, N'5.2', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31627, N'5.3', N'Establish a control to identify and determine the existence of dormant accounts (may be part of the Account Inventory process). Once a dormant account is identified, confirmed as dormant, delete or disable the account. Where supported.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Define a period of inactivity that aligns to business operations and risk profile for determining an account is "dormant" - typically 45 days of inactivity.</div><div><br/></div></div>', N'Account Management', N'Account Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 5, N'5.3', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31628, N'5.4', N'Restrict administrator privileges to dedicated administrator accounts on enterprise assets. Strict controls should be applied for the use of Administrator accounts (see 5.1), including: (a) Users with credentials/access should be limited; (b) privileges for user/administrator account should leverage "least-privilege" principles; and (c) general computing activities, such as internet browsing, email, and productivity suite use, should be conducted from the user’s primary, non-privileged account.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. (Refer to 5.1) - Administrator Account Inventories should list every user with access to the administrator credentials, justification for that access, approver for that administrator credential and to ensure role-based and appropriate the other general user information.<br><br>2. OT and high-risk assets should be assessed for Administrator accounts and privileges and the strictest controls possible should be applied to mitigate risk to those assets.  <br><br>3. Use account and asset scanning tools to identify unauthorized privileges. Ensure processes to assess and remediate identified issues.</div><div><br/></div></div>', N'Account Management', N'Account Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 5, N'5.4', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31629, N'5.6', N'Centralize Account Management for all technology assets through a directory or identity service. Centralized account management can be used for OT assets as well, consideration should be given to whether segregation or additional security controls are needed to mitigate risks to the OT assets.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Where a centralized system for account management is not possible, ensure strong manual controls and processes and more frequent assessment and validation of Account Inventory and privileges.</div><div><br/></div></div>', N'Account Management', N'Centralize Account Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 5, N'5.6', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31630, N'6.1', N'Establish and follow an Access Management process that includes requirements and controls for granting, revoking (6.2) and managing access rights for users. The process should account for new-hire, transfers and role changes and terminations. Where possible leverage automated controls.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Consider developing additional security measures for high-risk, remote accessible/operable and assets located at remote/unmanned sites to monitor for unauthorized access. Examples of additional security controls may include alarms, camera, key card or hard keys for use with physical security perimeters.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31631, N'6.2', N'Establish and follow an Access Management process, preferably automated, that includes controls for revoking access to technology assets. High-risk, remote accessible/operable and assets on remote sites should be prioritized for revocation controls where rights are being removed due to termination. Revocation should be disabled rather than "deleted" to preserve data that may be needed for audit, assessment or other account management activities.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. For terminations, access should be removed immediately, within no more than 24 hours if possible. <br><br>2. Where access removal at an enterprise or other domain level will effectively revoke access for assets within that domain, revocation at that level may be sufficient until asset specific privileges can be removed.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.2', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31632, N'6.3', N'Identify and implement a Multi-Factor Authentication Requirement for all externally facing, remote access/operable and assets located at remote unmanned locations wherever supported. Prioritize application of MFA to PV System and other communications assets with established connections to external networks or third-party assets.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Enforcing MFA through a directory services or SSO provider may be sufficient.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.3', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31633, N'6.4', N'Identify and implement a Multi-Factor Authentication Requirement for all externally facing, remote access/operable and assets located at remote unmanned locations wherever supported.', N'', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.4', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31634, N'6.5', N'Identify and implement a Multi-Factor Authentication Requirement for all Administrative Access accounts.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Control should be applied whether managed on-site or through a third-party provider.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.5', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31635, N'6.6', N'Ensure organization''s authentication and authorization systems, including those hosted on-site or at a remote service provider, are included in Assets/Software/Firmware inventory..', N'', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.6', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31636, N'6.7', N'Centralize access control for all technology assets through a directory service or SSO provider, where supported.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Where a centralized system for account access control is not possible, ensure strong manual controls and processes and more frequent assessment and validation of accesses with a focus on high-risk and remote accessible assets, inlcluding assets connected directly to external networks and third-party assets.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.7', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31637, N'6.8', N'Define and maintain role-based access control, through determining and documenting the access rights necessary for each role within the organization to ensure privileges are aligned to need relative to assigned duties. Perform periodic Access control reviews for all technology assets to validate that all privileges are authorized.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Validation of Acces and priviliges should occr at least quarterly for high-risk assets, PV system end devices, communications systems, workstations and similar critical assets or assets used for communication and data management.</div><div><br/></div></div>', N'Access Control Management', N'Access Control Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 4, N'6.8', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31638, N'7.1', N'Establish and maintain a vulnerability and patch management process for all technology assets (including networking infrastructure) that includes controls for assessing and risk-based remediation of vulnerabilities, including applying patches to ensure critical vulnerabilities are mitigated. Where possible, automate vulnerability scanning and patch management activities.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Controllers/workstations/SCADA assets, PV end systems, communications systems, assets connected directly to external networks and third-party assets should be prioritized. Application of scans and patches may require special controls/tools or actions for OT and high-risk assets to prevent operational, reliability or asset failures. <br><br>2. Vulnerability scans should be completed using a SCAP-compliant vulnerability scanning tool. Where automated tools are available, scans should be completed at least monthly, otherwise at least quarterly. Patches should be identified and assessed at least monthly. <br><br>3. Assessment determinations should be documented with determination of applicability, implementation plan, reasoning for determinations. Implementation of patches or other vulnerability remediation may depend on applicability, risk to the asset requiring the patch/remediation and risk of business or operational disruptions related to implementation.  OT and workstations/controllers or other high-risk assets may require a longer planning cycle to implement updates. <br><br>4. Review and update documentation annually, or when significant enterprise changes occur that could impact this Safeguard.</div><div><br/></div></div>', N'Continuous Vulnerability Management', N'Continuous Vulnerability Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'7.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31639, N'8.1', N'Establish and maintain an audit log management process that defines logging requirements for IT and OT technology assets. Process should address the collection, review, and retention of audit logs. Prioritize the following activities: 

1. Where appropriate and supported, collect DNS query, URL request, command-line (e.g., remote terminals), service provider logs and audit logs for workstations/controllers and critical assets communicating and storing operating and sensitive data. 

2. Conduct reviews of audit logs to identify anomolies or abnormal events that may indicate a threat and ensure controls for escalation of any identified concerns. The frequency of reviews will depend on the risk and priority of security for the asset. 

3. Establish processes for assessment and remediation of identified events and/or to ensure timely reaction to identified threats to mitigate or recover from an attack.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>1. Where possible, configure SIEM and CTM tools for automated logging and monitoring capabilities to improve security and reduce level of effort for manual controls. (Refer to Section 13)<br><br>2. Define data to be logged for critical assets and sensitive data (e.g., event source, date, username, timestamp, source address, destination address and any other useful information relevant to security posture). <br><br>3. Log reviews should be done frequently for high-risk assets, controllers/workstations/SCADA assets, PV end systems, communications systems, assets connected directly to external networks and third-party assets. <br><br>4. Standardize time synchronization and use at least two synchronized sources across assets where applicable. <br><br>5. Ensure adequate storage space for the defined collection activites, define minimum retention periods.<br><br>6. Example implementations for service provider logs include collecting authentication and authorization events, data creation and disposal events, and user management events.</div><div><br/></div></div>', N'Audit Log Management', N'Audit Log Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'8.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31640, N'10.1', N'Deploy and maintain anti-malware software on all assets. Centrally manage anti-malware software where possible. For IT and OT assets that are seperated this may require dual approach. Configure automatic updates for anti-malware signature files on assets where appropriate - automating updates for OT assets and operating assets such as controllers/workstations/SCADA systems may risk instability or operational impact to these assets, manual review and specifically defined deployment plans may be required. 

Disable auto-run/play/execute functionality and ensure automatic scanning capability for removable media. Where this is not possible, consider restricting or prohibiting the use of removable media (e.g., removable media must be used only on assets that have been segregated from high-risk/critical assets, systems, sensitive data, preferably on assets completely disconnected and separated from other assets).', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>This is a key control for preventing intrusion and manipulation of data on PV System / communications system assets. Failure to identify and detect malware could result in power system failures and impact to third-parties. <br><br>Ensure processes and controls for managing vendors and supply chain risks to prevent the introduction of malware by external parties who may be accessing your systems/assets. It is generally recommended that external personnel and vendors should be strictly prohibited from using removable media with any of your organization IT/OT assets. <br><br>Anti-malware sofware may impact controls and or monitoring programs so these programs and patches should be provided or tested by the OEM before deploymnent</div><div><br/></div></div>', N'Data Recovery', N'Data Recovery', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'10.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31641, N'11.1', N'Establish and maintain an asset/data recovery process and include requirements for defining the scope of data recovery activities, recovery prioritization (including restoration priorities), and the security of backup data. 
Define minimum requirements for automated backups of in-scope assets. Ensure at least weekly backups for high priority assets critical to the operations of the system and organization. Protect the backup assets and recovery data with same security controls as the primary asset. Test backup data and recovery capabilities at least twice annually or more frequently depending on the risk profile for the organization. All assets and recovery capabilties should be tested at least annually, for more frequent testing sampling may be used.', N'', N'Network Infrastructure Management', N'Network Infrastructure Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'11.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31642, N'12.2', N'Establish and maintain a secure network architecture. A secure network architecture must address segmentation, least privilege, and availability, at a minimum.  Where applicable isolate and/or segregate high-risk assets, security systems, meterological, and operational systems. This includes PV System end devices, workstations, critical communications systems. 

Develop, manage and maintain accurate network architecture diagrams and other network system documentation. Review and update these periodically and ensure configuration and change management processes include requirements to update this documentation whenever asset additions, removals, reconfigurations occur. 

Implement network infrastructure security controls such as: 

- require Multi-Factor Authentication wherever possible
- version-controlled-infrastructure-as-code, and the use of secure network protocols, such as SSH and HTTPS. 
- network management and communication protocols (e.g., 802.1X, Wi-Fi Protected Access 2 (WPA2) Enterprise or greater)
- requre use of VPN and authentication services prior to accessing enterprise or remote access OT assets from end-user devices', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Separation of enterprise/IT and OT, high-risk, critical operating assets examples may include the use of a DMZ, additional perimeters and firewalls, use of dedicated resources that are logically separated for all administrative tasks or assets requiring administrative access. These assets should also be segregated from direct access to any external networks and third-party assets.</div><div><br/></div></div>', N'Network Infrastructure Management', N'Establish and Maintain a Secure Network Architecture', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'12.2', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31643, N'13.1', N'Implement cyber threat monitoring/ management (CTM) and defense tools/capabilities to mitigate threats. 

1. Establish a centralized mechanism for cyber threat monitoring, event alerting and logging for all IT and OT assets within the organization. Leading practice is use of a SIEM tool, which includes vendor threat and event tracking services and vendor-defined correlation alerts. Ensure processes provide adequate guidance on what is considered an event, classifications, alert, assessment, remediation process flows.   

2. Deploy a host-based Intrusion Detection System for all assets. Prioritize PV System end devices, controllers, workstations, critical communications systems. The IDS should be configured to ensure monitoring of internal device activity for anomolies or unusual behavior and communication with assets to better identify potential threats posed by existing supply chain risks not yet identified or remediated. 

3. Incorporate access controls in design, configuration and alerting controls to ensure alignment to defined access authorizations and requirements. Prioritize remote connections and assets connected to and/or communicating with external networks and third-party assets. 

4. Ensure alignment with logging processes and controls (refer to 8.1) and use of tool to support logging, auditing processes.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>If using SIEM and IDS tools consider organization risks, asset risks, data risks and other relevant risks when defining monitoring and alerting requirements. Define thresholds for alerting where there are changes in the environment to software, hardware, access controls, configuration of assets under certain circumstances. Collect network traffic flow logs and/or network traffic to review and alert upon from network devices. Perform traffic filtering between network segments, where appropriate.<br><br>For organizations not able to implement a SIEM tool, log analytics platform or processes may be used but will need to be correlated to security-relevant threat tracking to ensure accurate analysis and identification of events. <br><br>A host-based IDS should be used for these and other critical assets to ensure the ability to monitor asset/device activity as well as networks. <br><br>Leverage cyber threat monitoring, alerting tools as a key resource for Incident Identification informing initiation of Incident Response Procedures (Refer to Section 18)</div><div><br/></div></div>', N'Security Awareness and Skills Training', N'Security Awareness and Skills Training', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'13.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31644, N'14.1', N'Establish and maintain a security awareness program to educate employees, contractors and vendors and support a strong security culture. Leverage an appropriate mix of training, communications and awareness campaigns tailored to the size and scope of risks for the organization. Key considerations include:

1. Basic security awareness training and commitment to a culture of security should be deployed for all personnel and vendors with significant responsibilities. Training should include major security threat topics such as social engineering, phishing, pre-texting, tailgating and common required controls used within the organization (along with purpose) such as MFA, password and access management requirements. 

2. Data protection requirements should be part of the security and/or records management program training and awareness program and should provide clear guidance on data classification, storage, retention, transmittal and disposal requirements as well as a point of contact to resolve questions. 

3. Training on Incident Response program/processes should be conducted separately from general awareness training and as part of the Incident Response program implementation. This includes training / awareness on identification of incidents and escalation protocols to ensure timely assessment as well as communications requirements (e.g., careful communications, avoid assumptions, no legal conclusions). 

5. Targeted security training and awareness campaigns should be defined for personnel with responsibilites for implementation of critical controls (e.g., patch management, secure system administration, threat monitoring and management).', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Employees and other personnel with significant day-to-day responsibilites should be included in required trainings. Communications and awareness campaigns may be sufficient for other personnel and vendors and may include general awareness and/or tailored communications relevant to the specific role or support services. Signs and on-site posters or materials should be designed so as not to direct a threat to a specific asset or vulnerability (e.g., do not physically label critical assets "critical asset")</div><div><br/></div></div>', N'Service Provider Management', N'Service Provider Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'14.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31645, N'15.1', N'Establish and maintain third-party supplier processes and controls to ensure effective management of potential security risks that may be posed by vendors and third-party service providers. This may be part of a general Procurement program. Key considerations include: 

1. Develop and maintain an inventory of service providers that includes enterprise contact/manager responsible for the service provider and a designated classification. Define role-based classifications that easily support application of specific security controls and access management processes.  

2. Ensure processes for onboarding, management, removal of service providers including specifically addressing access controls and restrictions for organizational assets and applications. 

3. Update service provider contracts and general terms and conditions to incorporate obligations to comply with organizational security requirements and all relevant processes and controls; to have in place some security program/protocols relative to the risk posed by that vendor; incident and/or breach notification requirements for both an  identified issue with their assets/organization. Provide for the ability to require certification to compliance with contract terms and security policies and authority to audit or assess. 

4. Determine appropriate monitoring and periodic assessment of compliance to requirements, which may be role-based and should be tied to the classifications.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Examples of applicable removal considerations include: user and service account deactivation, termination of data flows, and secure disposal of enterprise data within service provider systems.</div><div><br/></div></div>', N'Incident Response Management', N'Incident Response Management', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'15.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31646, N'17.1', N'Develop an Incident Response Program to provide guidance on the identification, escalation, assessment, management and mitigation of Security Incidents. The program should include the following minimum requirements: 

1. Definition and classification of an Security Incident (distinguish between an "event" and a security incident) to allow for proper response based on risk and priority of the Incident. 

2. Clearly defined roles and responsibilites for personnel that will be critical to implementation of the program such as: IT, security teams (where applicable), relevant operations staff, legal, communications/regulatory affairs, and leadership. A designated Program owner and backup should also be designated. 

3. Processes for reporting and escalation of Security Incidents to ensure timely assessment and response. Defined assessment requirements and thresholds when informal assessment or use of formal investigation tools is recommended, defining remediation / formal mitigation action and the tracking and management of implementation of remediation. Process flows with guidance on expected timing for each activity to support prioritization and handling of critical and high-priority Incidents. Post-Incident lessons-learned should be completed for any major events and included as part of any formally documented mitigation plan to ensure updates to processes and controls that may prevent future similar Incidents. 

5. Designated personnel responsible for communications, internal and external and protocols for the development, review, approval and distribution of communications related to the Incident; coordination with leadership, regulators (where applicable) and external parties. Should also include preferred or prohibited communications formats (phone calls, emails) with consideration for potential impact to communications capabilities. Key contact information for all relevant possible communications chains, including local and federal law enforcement agencies, should be maintained and reviewed and verified at least quarterly.  

6. Guidance for engagement of legal to review potential contractual and legal obligations to report Incidents and to assess potential liability. 

7. Communications and awareness materials to ensure personnel throughout the organization understand the basic obligations to report Security Incidents, designated points of contact for reporting, preferred mechanism for reporting and type of information to include (including restricting to fact-based reporting).', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Program may need to include guidance and controls to ensure ability to manage operating issues with PV system assets, communicate systems, and/or escalate for immediate communication with IOUs or other operators information that may be relevant to possible impacts to connected power system assets in the event of a major Incident.  <br><br>Contacts may include internal staff, third-party vendors, law enforcement, cyber insurance providers, relevant government agencies, Information Sharing and Analysis Center (ISAC) partners, or other stakeholders. Verify contacts annually or as needed to ensure that information is up-to-date.</div><div><br/></div></div>', N'Incident Response', N'Develop and Implement Incident Response Program', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 17, N'17.1', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31647, N'17.7', N'Plan and conduct routine incident response exercises and scenarios for key personnel involved in the incident response process to prepare for responding to real-world incidents. Exercises need to test communication channels, decision making, and workflows. Conduct testing on an annual basis or as needed. Include vendors and contractors with significant responsibilities or who may otherwise be critical to the execution of the Program.', N'', N'Incident Response', N'Engage in Periodic Incident Response Exercises', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 17, N'17.7', NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (31648, N'18.1', N'Establish and maintain a risk-based penetration testing program appropriate to the size, complexity, and maturity of the enterprise. Prioritize networks and assets identified as high-risk and critical to operations (enterprise and power system). Testing of OT assets may require additional planning to prevent disruption of operations / mitigate risk to the assets. Pen testing should be performed on a periodic basis in accordance with the risk and by qualified Pen Test professionals. A Pen Testing report will typically be provided with identified vulnerabilities, priority designation (for addressing) and recommended actions. Review report and resolve any discrepancies, define a remediation or mitigation plan to implement recommendations and  other mitigation/improvement measures defined by the organization and that includes a "lessons-learned" assessment to ensure updates to relevant processes and controls to mitigate future risk and support continuos improvement.', N'<div class="renewable-guidance"><div><span><b>Renewable-Specific Guidance</b></span></div><div><br/></div><div>Penetration testing program characteristics include scope, such as network, web application, Application Programming Interface (API), hosted services, and physical premise controls; frequency; limitations, such as acceptable hours, and excluded attack types; point of contact information; remediation, such as how findings will be routed internally; and retrospective requirements.</div><div><br/></div></div>', N'Penetration Testing', N'Establish and Maintain Penetration Testing Processes', NULL, NULL, N'Wind_CERT', NULL, NULL, NULL, 1, N'18.1', NULL)
SET IDENTITY_INSERT [dbo].[NEW_REQUIREMENT] OFF
PRINT(N'Operation applied to 44 rows out of 44')

PRINT(N'Add rows to [dbo].[NEW_QUESTION_LEVELS]')
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19506, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19519, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19520, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19544, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'H', 19546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19506, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19544, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'L', 19545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19506, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19519, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19520, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19544, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'M', 19546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19506, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19519, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19520, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19544, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES (N'VH', 19546, NULL)
PRINT(N'Operation applied to 287 rows out of 287')

PRINT(N'Add rows to [dbo].[REQUIREMENT_LEVELS]')
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31605, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31605, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31605, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31605, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31606, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31606, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31606, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31606, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31607, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31607, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31607, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31607, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31608, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31608, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31608, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31608, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31609, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31609, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31609, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31609, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31610, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31610, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31610, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31610, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31611, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31611, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31611, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31611, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31612, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31612, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31612, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31612, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31613, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31613, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31613, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31613, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31614, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31614, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31614, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31614, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31615, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31615, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31615, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31615, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31616, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31616, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31616, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31616, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31617, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31617, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31617, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31617, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31618, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31618, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31618, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31618, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31619, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31619, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31619, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31619, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31620, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31620, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31620, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31620, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31621, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31621, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31621, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31621, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31622, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31622, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31622, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31622, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31623, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31623, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31623, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31623, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31624, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31624, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31624, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31624, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31625, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31625, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31625, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31625, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31626, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31626, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31626, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31626, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31627, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31627, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31627, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31627, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31628, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31628, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31628, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31628, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31629, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31629, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31629, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31629, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31630, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31630, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31630, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31630, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31631, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31631, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31631, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31631, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31632, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31632, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31632, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31632, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31633, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31633, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31633, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31633, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31634, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31634, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31634, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31634, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31635, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31635, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31635, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31635, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31636, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31636, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31636, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31636, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31637, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31637, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31637, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31637, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31638, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31638, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31638, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31638, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31639, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31639, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31639, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31639, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31640, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31640, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31640, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31640, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31641, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31641, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31641, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31641, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31642, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31642, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31642, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31642, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31643, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31643, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31643, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31643, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31644, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31644, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31644, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31644, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31645, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31645, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31645, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31645, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31646, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31646, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31646, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31646, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31647, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31647, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31647, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31647, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31648, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31648, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31648, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (31648, N'VH', N'NST', NULL)
PRINT(N'Operation applied to 176 rows out of 176')

PRINT(N'Add rows to [dbo].[REQUIREMENT_SETS]')
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31605, N'Wind_CERT', 1)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31606, N'Wind_CERT', 2)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31607, N'Wind_CERT', 3)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31608, N'Wind_CERT', 4)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31609, N'Wind_CERT', 5)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31610, N'Wind_CERT', 6)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31611, N'Wind_CERT', 7)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31612, N'Wind_CERT', 8)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31613, N'Wind_CERT', 9)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31614, N'Wind_CERT', 10)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31615, N'Wind_CERT', 11)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31616, N'Wind_CERT', 12)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31617, N'Wind_CERT', 13)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31618, N'Wind_CERT', 14)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31619, N'Wind_CERT', 15)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31620, N'Wind_CERT', 16)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31621, N'Wind_CERT', 17)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31622, N'Wind_CERT', 18)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31623, N'Wind_CERT', 19)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31624, N'Wind_CERT', 20)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31625, N'Wind_CERT', 21)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31626, N'Wind_CERT', 22)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31627, N'Wind_CERT', 23)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31628, N'Wind_CERT', 24)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31629, N'Wind_CERT', 25)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31630, N'Wind_CERT', 26)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31631, N'Wind_CERT', 27)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31632, N'Wind_CERT', 28)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31633, N'Wind_CERT', 29)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31634, N'Wind_CERT', 30)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31635, N'Wind_CERT', 31)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31636, N'Wind_CERT', 32)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31637, N'Wind_CERT', 33)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31638, N'Wind_CERT', 34)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31639, N'Wind_CERT', 35)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31640, N'Wind_CERT', 36)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31641, N'Wind_CERT', 37)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31642, N'Wind_CERT', 38)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31643, N'Wind_CERT', 39)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31644, N'Wind_CERT', 40)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31645, N'Wind_CERT', 41)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31646, N'Wind_CERT', 42)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31647, N'Wind_CERT', 43)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (31648, N'Wind_CERT', 44)
PRINT(N'Operation applied to 44 rows out of 44')

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_LEVELS]')

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] WITH CHECK CHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_STANDARD_CATEGORY]

PRINT(N'Add constraints to [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] WITH CHECK CHECK CONSTRAINT [FK_SETS_Sets_Category]
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] WITH CHECK CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_MATURITY_MODELS_SETS]
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] WITH CHECK CHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] CHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_SETS]
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] CHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_SETS]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]
ALTER TABLE [dbo].[MATURITY_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
COMMIT TRANSACTION
GO
