/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12150    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12160

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/28/2024 2:18:00 PM

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

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCE_TEXT]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]

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

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Update rows in [dbo].[REQUIREMENT_SETS]')
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=32 WHERE [Requirement_Id] = 36403 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=33 WHERE [Requirement_Id] = 36404 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=34 WHERE [Requirement_Id] = 36405 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=35 WHERE [Requirement_Id] = 36406 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=36 WHERE [Requirement_Id] = 36407 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=37 WHERE [Requirement_Id] = 36408 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=39 WHERE [Requirement_Id] = 36409 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=40 WHERE [Requirement_Id] = 36410 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=41 WHERE [Requirement_Id] = 36411 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=42 WHERE [Requirement_Id] = 36412 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=43 WHERE [Requirement_Id] = 36413 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=44 WHERE [Requirement_Id] = 36414 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=59 WHERE [Requirement_Id] = 36415 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=60 WHERE [Requirement_Id] = 36416 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=61 WHERE [Requirement_Id] = 36417 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=62 WHERE [Requirement_Id] = 36418 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=48 WHERE [Requirement_Id] = 36419 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=80 WHERE [Requirement_Id] = 36420 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=81 WHERE [Requirement_Id] = 36421 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=82 WHERE [Requirement_Id] = 36422 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=83 WHERE [Requirement_Id] = 36423 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=75 WHERE [Requirement_Id] = 36424 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=76 WHERE [Requirement_Id] = 36425 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=77 WHERE [Requirement_Id] = 36426 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=78 WHERE [Requirement_Id] = 36427 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=95 WHERE [Requirement_Id] = 36428 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=96 WHERE [Requirement_Id] = 36429 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=91 WHERE [Requirement_Id] = 36430 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=97 WHERE [Requirement_Id] = 36431 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=98 WHERE [Requirement_Id] = 36432 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=99 WHERE [Requirement_Id] = 36433 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=100 WHERE [Requirement_Id] = 36434 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=101 WHERE [Requirement_Id] = 36435 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=102 WHERE [Requirement_Id] = 36436 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=103 WHERE [Requirement_Id] = 36437 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=105 WHERE [Requirement_Id] = 36438 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=38 WHERE [Requirement_Id] = 36439 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=45 WHERE [Requirement_Id] = 36440 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=46 WHERE [Requirement_Id] = 36441 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=47 WHERE [Requirement_Id] = 36442 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=49 WHERE [Requirement_Id] = 36443 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=50 WHERE [Requirement_Id] = 36444 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=51 WHERE [Requirement_Id] = 36445 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=52 WHERE [Requirement_Id] = 36446 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=53 WHERE [Requirement_Id] = 36447 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=54 WHERE [Requirement_Id] = 36448 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=55 WHERE [Requirement_Id] = 36449 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=56 WHERE [Requirement_Id] = 36450 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=57 WHERE [Requirement_Id] = 36451 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=58 WHERE [Requirement_Id] = 36452 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=63 WHERE [Requirement_Id] = 36453 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=64 WHERE [Requirement_Id] = 36454 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=65 WHERE [Requirement_Id] = 36455 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=66 WHERE [Requirement_Id] = 36456 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=67 WHERE [Requirement_Id] = 36457 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=68 WHERE [Requirement_Id] = 36458 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=69 WHERE [Requirement_Id] = 36459 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=70 WHERE [Requirement_Id] = 36460 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=71 WHERE [Requirement_Id] = 36461 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=72 WHERE [Requirement_Id] = 36462 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=73 WHERE [Requirement_Id] = 36463 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=74 WHERE [Requirement_Id] = 36464 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=84 WHERE [Requirement_Id] = 36465 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=85 WHERE [Requirement_Id] = 36466 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=79 WHERE [Requirement_Id] = 36467 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=86 WHERE [Requirement_Id] = 36468 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=87 WHERE [Requirement_Id] = 36469 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=88 WHERE [Requirement_Id] = 36470 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=89 WHERE [Requirement_Id] = 36471 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=90 WHERE [Requirement_Id] = 36472 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=92 WHERE [Requirement_Id] = 36473 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=93 WHERE [Requirement_Id] = 36474 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=94 WHERE [Requirement_Id] = 36475 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=104 WHERE [Requirement_Id] = 36476 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=106 WHERE [Requirement_Id] = 36477 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=22 WHERE [Requirement_Id] = 36490 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=23 WHERE [Requirement_Id] = 36491 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=24 WHERE [Requirement_Id] = 36492 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=25 WHERE [Requirement_Id] = 36493 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=26 WHERE [Requirement_Id] = 36494 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=27 WHERE [Requirement_Id] = 36495 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=28 WHERE [Requirement_Id] = 36496 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=29 WHERE [Requirement_Id] = 36497 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=30 WHERE [Requirement_Id] = 36498 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=31 WHERE [Requirement_Id] = 36499 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=13 WHERE [Requirement_Id] = 36500 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=14 WHERE [Requirement_Id] = 36501 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=15 WHERE [Requirement_Id] = 36502 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=16 WHERE [Requirement_Id] = 36503 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=17 WHERE [Requirement_Id] = 36504 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=18 WHERE [Requirement_Id] = 36505 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=19 WHERE [Requirement_Id] = 36506 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=20 WHERE [Requirement_Id] = 36507 AND [Set_Name] = N'NCSF_V2'
UPDATE [dbo].[REQUIREMENT_SETS] SET [Requirement_Sequence]=21 WHERE [Requirement_Id] = 36508 AND [Set_Name] = N'NCSF_V2'
PRINT(N'Operation applied to 94 rows out of 94')

PRINT(N'Update rows in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Representations of the organization’s authorized network communication and internal and external network data flows are maintained' WHERE [Requirement_Id] = 36405
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Threats, vulnerabilities, likelihoods, and impacts are used to understand inherent risk and inform risk response prioritization' WHERE [Requirement_Id] = 36413
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Risk responses are chosen, prioritized, planned, tracked, and communicated' WHERE [Requirement_Id] = 36414
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Personnel are provided with awareness and training so that they possess the knowledge and skills to perform general tasks with cybersecurity risks in mind' WHERE [Requirement_Id] = 36415
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Individuals in specialized roles are provided with awareness and training so that they possess the knowledge and skills to perform relevant tasks with cybersecurity risks in mind' WHERE [Requirement_Id] = 36416
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Title]=N'ID.RA-10', [Requirement_Text]=N'Critical suppliers are assessed prior to acquisition', [Supplemental_Info]=NULL, [Standard_Category]=N'Identify', [Standard_Sub_Category]=N'Risk Assessment' WHERE [Requirement_Id] = 36419
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The estimated impact and scope of adverse events are understood' WHERE [Requirement_Id] = 36422
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Analysis is performed to establish what has taken place during an incident and the root cause of the incident' WHERE [Requirement_Id] = 36430
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Recovery actions are selected, scoped, prioritized, and performed' WHERE [Requirement_Id] = 36434
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Critical mission functions and cybersecurity risk management are considered to establish post-incident operational norms' WHERE [Requirement_Id] = 36436
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The integrity of restored assets is verified, systems and services are restored, and normal operating status is confirmed' WHERE [Requirement_Id] = 36437
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Recovery activities and progress in restoring operational capabilities are communicated to designated internal and external stakeholders' WHERE [Requirement_Id] = 36438
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Systems, hardware, software, services, and data are managed throughout their life cycles' WHERE [Requirement_Id] = 36439
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Improvements are identified from evaluations' WHERE [Requirement_Id] = 36443
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Improvements are identified from security tests and exercises, including those done in coordination with suppliers and relevant third parties' WHERE [Requirement_Id] = 36444
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Improvements are identified from execution of operational processes, procedures, and activities' WHERE [Requirement_Id] = 36445
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Incident response plans and other cybersecurity plans that affect operations are established, communicated, maintained, and improved' WHERE [Requirement_Id] = 36446
UPDATE [dbo].[NEW_REQUIREMENT] SET [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36447
UPDATE [dbo].[NEW_REQUIREMENT] SET [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36448
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Users, services, and hardware are authenticated', [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36449
UPDATE [dbo].[NEW_REQUIREMENT] SET [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36450
UPDATE [dbo].[NEW_REQUIREMENT] SET [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36451
UPDATE [dbo].[NEW_REQUIREMENT] SET [Standard_Sub_Category]=N'Identity Management, Authentication, and Access Control' WHERE [Requirement_Id] = 36452
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Configuration management practices are established and applied' WHERE [Requirement_Id] = 36455
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Secure software development practices are integrated, and their performance is monitored throughout the software development life cycle' WHERE [Requirement_Id] = 36460
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The organization’s technology assets are protected from environmental threats' WHERE [Requirement_Id] = 36462
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Computing hardware and software, runtime environments, and their data are monitored to find potentially adverse events' WHERE [Requirement_Id] = 36467
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The incident response plan is executed in coordination with relevant third parties once an incident is declared' WHERE [Requirement_Id] = 36468
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Actions performed during an investigation are recorded, and the records’ integrity and provenance are preserved' WHERE [Requirement_Id] = 36473
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'An incident’s magnitude is estimated and validated' WHERE [Requirement_Id] = 36475
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The end of incident recovery is declared based on criteria, and incident-related documentation is completed' WHERE [Requirement_Id] = 36476
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Public updates on incident recovery are shared using approved methods and messaging' WHERE [Requirement_Id] = 36477
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Internal and external stakeholders are understood, and their needs and expectations regarding cybersecurity risk management are understood and considered' WHERE [Requirement_Id] = 36479
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Legal, regulatory, and contractual requirements regarding cybersecurity — including privacy and civil liberties obligations — are understood and managed' WHERE [Requirement_Id] = 36480
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Critical objectives, capabilities, and services that external stakeholders depend on or expect from the organization are understood and communicated' WHERE [Requirement_Id] = 36481
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Outcomes, capabilities, and services that the organization depends on are understood and communicated' WHERE [Requirement_Id] = 36482
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Risk appetite and risk tolerance statements are established, communicated, and maintained' WHERE [Requirement_Id] = 36484
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Cybersecurity risk management activities and outcomes are included in enterprise risk management processes' WHERE [Requirement_Id] = 36485
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Strategic opportunities (i.e., positive risks) are characterized and are included in organizational cybersecurity risk discussions' WHERE [Requirement_Id] = 36489
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'A cybersecurity supply chain risk management program, strategy, objectives, policies, and processes are established and agreed to by organizational stakeholders' WHERE [Requirement_Id] = 36490
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Cybersecurity roles and responsibilities for suppliers, customers, and partners are established, communicated, and coordinated internally and externally' WHERE [Requirement_Id] = 36491
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Cybersecurity supply chain risk management is integrated into cybersecurity and enterprise risk management, risk assessment, and improvement processes' WHERE [Requirement_Id] = 36492
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Requirements to address cybersecurity risks in supply chains are established, prioritized, and integrated into contracts and other types of agreements with suppliers and other relevant third parties' WHERE [Requirement_Id] = 36494
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Planning and due diligence are performed to reduce risks before entering into formal supplier or other third-party relationships' WHERE [Requirement_Id] = 36495
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The risks posed by a supplier, their products and services, and other third parties are understood, recorded, prioritized, assessed, responded to, and monitored over the course of the relationship' WHERE [Requirement_Id] = 36496
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Relevant suppliers and other third parties are included in incident planning, response, and recovery activities' WHERE [Requirement_Id] = 36497
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Supply chain security practices are integrated into cybersecurity and enterprise risk management programs, and their performance is monitored throughout the technology product and service life cycle' WHERE [Requirement_Id] = 36498
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Cybersecurity supply chain risk management plans include provisions for activities that occur after the conclusion of a partnership or service agreement' WHERE [Requirement_Id] = 36499
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Organizational leadership is responsible and accountable for cybersecurity risk and fosters a culture that is risk-aware, ethical, and continually improving' WHERE [Requirement_Id] = 36500
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Roles, responsibilities, and authorities related to cybersecurity risk management are established, communicated, understood, and enforced' WHERE [Requirement_Id] = 36501
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Adequate resources are allocated commensurate with the cybersecurity risk strategy, roles, responsibilities, and policies' WHERE [Requirement_Id] = 36502
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Policy for managing cybersecurity risks is established based on organizational context, cybersecurity strategy, and priorities and is communicated and enforced', [Standard_Sub_Category]=N'Policy' WHERE [Requirement_Id] = 36504
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Policy for managing cybersecurity risks is reviewed, updated, communicated, and enforced to reflect changes in requirements, threats, technology, and organizational mission', [Standard_Sub_Category]=N'Policy' WHERE [Requirement_Id] = 36505
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'Organizational cybersecurity risk management performance is evaluated and reviewed for adjustments needed' WHERE [Requirement_Id] = 36508
PRINT(N'Operation applied to 54 rows out of 54')

PRINT(N'Update row in [dbo].[GEN_FILE]')
UPDATE [dbo].[GEN_FILE] SET [File_Name]=N'NIST.CSWP.29.pdf', [Title]=N'The NIST Cybersecurity Framework (CSF) 2.0 ', [Name]=N'The NIST Cybersecurity Framework (CSF) 2.0', [Short_Name]=N'The NIST Cybersecurity Framework (CSF) 2.0', [Publish_Date]='2024-02-26 00:00:00.000', [Summary]=N'The NIST Cybersecurity Framework 2.0 provides guidance to industry, government agencies, and other organizations to reduce cybersecurity risks. It offers a taxonomy of high-level cybersecurity outcomes that can be used by any organization — regardless of its size, sector, or maturity — to better understand, assess, prioritize, and communicate its cybersecurity efforts. The Framework does not prescribe how outcomes should be achieved. Rather, it maps to resources that provide additional guidance on practices and controls that could be used to achieve those outcomes. This document explains Cybersecurity Framework 2.0 and its components and describes some of the many ways that it can be used.' WHERE [Gen_File_Id] = 692

PRINT(N'Update row in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'The NIST Cybersecurity Framework 2.0 provides guidance to industry, government agencies, and other organizations to reduce cybersecurity risks. It offers a taxonomy of high-level cybersecurity outcomes that can be used by any organization — regardless of its size, sector, or maturity — to better understand, assess, prioritize, and communicate its cybersecurity efforts. The Framework does not prescribe how outcomes should be achieved. Rather, it maps to resources that provide additional guidance on practices and controls that could be used to achieve those outcomes. This document explains Cybersecurity Framework 2.0 and its components and describes some of the many ways that it can be used.', [Title]=N'The NIST Cybersecurity Framework (CSF) 2.0' WHERE [Gallery_Item_Guid] = '4737748d-c762-4459-bc76-393e816c6a2d'

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
