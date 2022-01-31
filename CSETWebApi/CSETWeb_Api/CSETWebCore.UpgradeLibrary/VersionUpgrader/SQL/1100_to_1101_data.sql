/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb11000    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb11010

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.5.22.19589 from Red Gate Software Ltd at 1/31/2022 1:34:00 PM

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

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_LEVELS]')
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS]
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Delete rows from [dbo].[REQUIREMENT_LEVELS]')
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30045 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30047 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30047 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30048 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30048 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30049 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30049 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30050 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30050 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30051 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30051 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30051 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30052 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30052 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30052 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30053 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30053 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30053 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30054 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30054 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30054 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30055 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30055 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30055 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30056 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30057 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30058 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30058 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30058 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30060 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30060 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30060 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30061 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30061 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30061 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30062 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30062 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30062 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30063 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30063 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30063 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30064 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30064 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30064 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30065 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30065 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30065 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30066 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30066 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30066 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30067 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30067 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30067 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30068 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30068 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30068 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30069 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30069 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30069 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30070 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30070 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30070 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30071 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30071 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30071 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30072 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30072 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30072 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30073 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30074 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30075 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30076 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30077 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30078 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30079 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30080 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30081 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30082 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30083 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30084 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30085 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30086 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30087 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30088 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30089 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30090 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30091 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30092 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30093 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30094 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30095 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30096 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30097 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30098 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30099 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30100 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30101 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30102 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30103 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30104 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30104 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30105 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30105 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30105 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30106 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30106 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30107 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30107 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30108 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30108 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30108 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30109 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30109 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30110 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30110 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30111 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30111 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30111 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30112 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30112 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30113 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30113 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30113 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30114 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30114 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30115 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30115 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30116 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30117 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30117 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30117 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30118 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30118 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30118 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30119 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30119 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30119 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30120 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30121 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30121 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30121 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30122 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30122 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30122 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30123 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30123 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30123 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30124 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30124 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30124 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30125 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30125 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30125 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30126 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30126 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30126 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30127 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30127 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30127 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30128 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30128 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30129 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30129 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30130 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30130 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30130 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30131 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30131 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30131 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30132 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30132 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30132 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30133 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30134 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30134 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30134 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30135 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30135 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30135 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30136 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30136 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30136 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30137 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30137 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30137 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30138 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30138 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30138 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30139 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30139 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30139 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30140 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30140 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30140 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30141 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30141 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30141 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30142 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30142 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30142 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30143 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30143 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30143 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30144 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30144 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30144 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30145 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30145 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30145 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30146 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30146 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30147 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30147 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30148 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30148 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30149 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30149 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30150 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30150 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30150 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30151 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30151 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30151 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30152 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30152 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30152 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30153 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30153 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30153 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30154 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30154 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30155 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30155 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30156 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30156 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30156 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30157 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30157 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30157 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30158 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30158 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30158 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30159 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30159 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30159 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30160 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30160 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30161 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30161 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30161 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30162 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30162 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30163 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30163 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30163 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30164 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30164 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30164 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30165 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30165 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30165 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30166 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30166 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30166 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30167 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30167 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30168 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30168 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30168 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30169 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30169 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30169 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30170 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30171 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30171 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30171 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30172 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30172 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30172 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30173 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30173 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30173 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30174 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30174 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30174 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30175 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30175 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30175 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30176 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30177 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30177 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30177 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30178 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30178 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30178 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30179 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30180 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30180 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30181 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30181 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30181 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30182 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30182 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30182 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30183 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30183 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30183 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30184 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30185 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30185 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30185 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30186 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30186 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30186 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30187 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30187 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30187 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30188 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30188 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30188 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30189 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30190 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30190 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30190 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30191 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30192 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30193 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30193 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30193 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30194 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30194 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30195 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30195 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30195 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30196 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30197 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30197 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30197 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30198 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30198 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30199 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30199 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30199 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30200 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30200 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30200 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30201 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30201 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30201 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30202 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30202 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30202 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30203 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30203 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30203 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30204 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30204 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30204 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30205 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30205 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30206 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30206 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30207 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30207 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30207 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30208 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30208 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30208 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30209 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30209 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30209 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30210 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30210 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30210 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30211 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30211 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30211 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30212 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30212 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30212 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30213 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30213 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30213 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30214 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30214 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30215 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30216 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30216 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30216 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30217 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30217 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30217 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30218 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30218 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30218 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30219 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30219 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30219 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30220 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30220 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30221 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30221 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30221 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30222 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30222 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30222 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30223 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30223 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30223 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30224 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30224 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30224 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30225 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30225 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30225 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30226 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30226 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30226 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30227 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30227 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30227 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30228 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30228 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30228 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30229 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30230 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30230 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30230 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30231 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30232 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30232 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30232 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30233 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30233 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30233 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30234 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30234 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30234 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30235 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30235 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30235 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30236 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30236 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30236 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30237 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30237 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30237 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30238 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30238 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30238 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30239 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30239 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30239 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30240 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30240 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30240 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30241 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30241 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30241 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30242 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30242 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30242 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30243 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30243 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30243 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30244 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30244 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30244 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30245 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30245 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30245 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30246 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30246 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30246 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30247 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30248 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30248 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30248 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30249 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30249 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30250 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30250 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30250 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30251 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30251 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30251 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30252 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30252 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30253 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30253 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30253 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30254 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30254 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30254 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30255 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30256 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30256 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30256 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30257 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30258 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30258 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30258 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30259 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30259 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30259 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30260 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30260 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30260 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30261 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30261 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30262 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30262 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30262 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30263 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30264 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30264 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30264 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30265 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30265 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30265 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30266 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30266 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30266 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30267 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30267 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30267 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30268 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30268 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30268 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30269 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30269 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30269 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30270 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30271 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30271 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30271 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30272 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30273 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30273 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30273 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30274 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30274 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30275 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30275 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30276 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30276 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30276 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30277 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30277 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30278 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30278 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30278 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30279 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30279 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30279 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30280 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30280 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30280 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30281 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30281 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30281 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30282 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30282 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30283 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30283 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30283 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30284 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30284 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30284 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30285 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30285 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30285 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30286 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30286 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30286 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30287 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30287 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30287 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30288 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30288 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30288 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30289 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30289 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30290 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30290 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30291 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30291 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30291 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30292 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30292 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30292 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30293 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30293 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30293 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30294 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30294 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30294 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30295 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30295 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30296 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30296 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30296 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30297 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30297 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30297 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30298 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30298 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30298 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30299 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30299 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30300 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30300 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30301 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30301 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30301 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30302 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30302 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30302 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30303 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30303 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30304 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30304 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30304 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30305 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30305 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30305 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30306 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30306 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30306 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30307 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30307 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30307 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30308 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30308 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30308 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30309 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30309 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30310 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30310 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30310 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30311 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30311 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30312 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30312 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30312 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30313 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30313 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30313 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30314 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30314 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30314 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30315 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30315 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30315 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30316 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30316 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30316 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30317 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30317 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30318 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30318 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30318 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30319 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30320 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30320 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30320 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30321 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30322 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30322 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30322 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30323 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30323 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30323 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30324 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30324 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30324 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30325 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30325 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30326 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30326 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30326 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30327 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30327 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30327 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30328 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30329 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30329 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30329 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30330 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30330 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30331 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30331 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30331 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30332 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30332 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30333 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30333 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30333 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30334 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30334 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30334 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30335 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30335 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30335 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30336 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30336 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30337 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30337 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30338 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30338 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30338 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30339 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30339 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30339 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30340 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30340 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30340 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30341 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30341 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30342 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30342 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30342 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30343 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30343 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30343 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30344 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30344 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30344 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30345 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30345 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30345 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30346 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30346 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30346 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30347 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30347 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30348 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30348 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30348 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30349 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30349 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30350 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30350 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30350 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30351 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30351 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30352 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30352 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30353 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30353 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30354 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30354 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30354 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30355 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30355 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30355 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30356 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30356 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30356 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30357 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30357 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30358 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30358 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30359 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30359 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30359 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30360 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30360 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30360 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30361 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30361 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30361 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30362 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30362 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30362 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30363 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30363 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30364 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30364 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30364 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30365 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30365 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30365 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30366 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30366 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30366 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30367 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30367 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30367 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30368 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30368 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30368 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30369 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30369 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30370 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30370 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30370 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30371 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30371 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30372 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30372 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30372 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30373 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30373 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30373 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30374 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30374 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30374 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30375 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30375 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30375 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30376 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30376 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30376 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30377 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30378 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30378 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30378 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30379 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30380 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30381 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30381 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30381 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30382 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30382 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30382 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30383 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30384 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30384 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30384 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30385 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30386 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30386 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30386 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30387 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30387 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30388 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30388 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30388 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30389 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30389 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30389 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30390 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30390 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30390 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30391 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30391 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30391 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30392 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30392 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30392 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30393 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30393 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30394 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30394 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30394 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30395 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30395 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30395 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30396 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30396 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30396 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30397 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30397 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30397 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30398 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30398 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30398 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30399 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30400 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30400 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30401 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30401 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30401 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30402 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30402 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30403 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30403 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30403 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30404 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30404 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30404 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30405 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30405 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30405 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30406 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30406 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30406 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30407 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30407 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30407 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30408 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30408 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30408 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30409 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30409 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30409 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30410 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30410 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30410 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30411 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30411 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30411 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30412 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30412 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30412 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30413 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30413 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30413 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30414 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30415 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30416 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30416 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30416 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30417 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30418 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30419 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30420 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30420 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30420 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30421 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30421 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30421 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30422 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30422 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30422 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30423 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30423 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30423 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30424 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30425 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30425 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30425 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30426 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30426 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30426 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30427 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30427 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30428 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30428 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30429 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30429 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30429 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30430 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30430 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30431 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30431 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30431 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30432 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30433 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30433 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30434 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30434 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30434 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30435 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30435 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30435 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30436 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30436 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30436 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30437 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30437 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30437 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30438 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30438 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30438 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30439 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30439 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30440 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30440 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30440 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30442 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30442 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30443 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30443 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30443 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30444 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30444 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30444 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30445 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30445 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30445 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30446 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30446 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30446 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30447 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30447 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30447 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30448 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30448 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30448 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30449 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30449 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30449 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30450 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30450 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30450 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30451 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30451 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30451 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30452 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30452 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30452 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30453 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30453 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30453 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30454 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30454 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30454 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30455 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30455 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30455 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30456 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30456 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30456 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30457 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30457 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30458 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30458 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30458 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30459 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30459 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30459 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30460 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30460 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30461 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30461 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30461 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30462 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30462 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30463 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30463 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30463 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30464 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30464 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30465 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30465 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30465 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30466 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30467 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30467 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30467 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30468 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30468 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30468 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30469 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30469 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30469 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30470 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30470 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30470 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30471 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30471 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30471 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30472 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30473 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30473 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30474 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30474 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30474 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30475 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30475 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30475 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30476 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30476 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30477 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30477 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30478 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30478 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30479 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30479 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30479 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30480 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30480 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30480 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30481 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30481 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30481 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30482 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30482 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30483 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30483 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30483 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30484 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30484 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30484 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30485 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30485 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30485 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30486 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30486 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30486 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30487 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30487 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30487 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30488 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30488 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30488 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30489 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30490 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30490 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30490 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30491 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30491 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30491 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30492 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30492 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30492 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30493 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30493 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30493 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30494 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30494 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30494 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30495 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30495 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30496 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30496 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30496 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30497 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30497 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30497 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30498 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30498 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30498 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30499 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30499 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30499 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30500 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30501 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30502 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30502 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30503 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30503 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30504 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30504 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30504 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30505 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30505 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30506 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30506 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30506 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30507 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30507 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30508 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30508 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30508 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30509 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30509 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30509 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30510 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30510 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30510 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30511 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30511 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30511 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30512 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30512 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30512 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30513 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30514 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30514 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30514 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30515 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30515 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30515 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30516 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30516 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30516 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30517 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30517 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30517 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30518 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30518 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30518 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30519 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30519 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30519 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30520 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30521 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30522 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30522 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30522 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30523 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30523 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30523 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30524 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30524 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30524 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30525 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30525 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30526 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30526 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30526 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30527 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30527 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30527 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30528 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30528 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30528 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30529 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30529 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30529 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30530 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30530 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30530 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30531 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30531 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30531 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30532 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30532 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30532 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30533 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30533 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30534 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30534 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30535 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30535 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30535 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30536 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30536 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30536 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30537 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30537 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30538 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30538 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30538 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30539 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30539 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30539 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30540 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30540 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30540 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30541 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30541 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30542 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30542 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30542 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30543 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30543 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30543 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30544 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30544 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30545 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30545 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30545 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30546 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30546 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30546 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30547 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30547 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30548 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30548 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30548 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30549 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30549 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30549 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30550 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30550 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30550 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30551 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30552 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30552 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30552 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30553 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30553 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30553 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30554 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30554 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30555 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30555 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30555 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30556 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30556 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30556 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30557 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30558 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30558 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30558 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30559 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30559 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30559 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30560 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30560 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30561 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30561 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30561 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30562 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30563 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30563 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30564 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30564 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30564 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30565 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30565 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30565 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30566 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30566 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30566 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30567 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30567 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30567 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30568 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30568 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30568 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30569 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30569 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30569 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30570 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30570 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30570 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30571 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30572 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30573 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30573 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30573 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30574 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30575 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30575 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30575 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30576 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30576 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30577 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30577 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30577 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30578 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30578 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30578 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30579 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30579 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30579 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30580 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30581 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30582 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30582 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30582 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30583 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30583 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30583 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30584 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30584 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30584 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30585 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30585 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30585 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30586 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30586 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30586 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30587 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30587 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30587 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30588 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30588 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30588 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30589 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30589 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30589 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30590 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30590 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30590 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30591 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30591 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30591 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30592 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30592 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30592 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30593 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30593 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30593 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30594 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30594 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30594 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30595 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30595 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30595 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30596 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30596 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30596 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30597 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30597 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30597 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30598 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30598 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30598 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30599 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30599 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30599 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30600 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30600 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30600 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30601 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30601 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30601 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30602 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30602 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30602 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30603 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30603 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30603 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30604 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30604 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30604 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30605 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30605 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30605 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30606 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30606 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30606 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30607 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30607 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30607 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30608 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30608 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30608 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30609 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30609 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30609 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30610 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30610 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30610 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30611 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30611 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30611 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30612 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30612 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30612 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30613 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30613 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30613 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30614 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30614 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30614 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30615 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30615 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30615 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30616 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30616 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30616 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30617 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30617 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30617 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30618 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30618 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30618 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30619 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30620 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30621 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30622 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30622 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30622 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30623 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30623 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30623 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30624 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30624 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30624 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30625 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30625 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30625 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30626 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30626 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30627 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30627 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30627 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30628 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30628 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30628 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30629 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30630 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30631 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30631 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30631 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30632 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30632 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30632 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30633 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30634 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30635 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30636 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30636 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30636 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30637 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30637 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30637 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30638 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30638 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30638 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30639 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30639 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30639 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30640 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30640 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30640 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30641 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30641 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30641 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30642 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30642 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30642 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30643 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30643 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30643 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30644 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30644 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30644 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30645 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30645 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30645 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30646 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30646 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30646 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30647 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30647 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30647 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30648 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30648 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30648 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30649 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30649 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30649 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30650 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30650 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30650 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30651 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30651 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30651 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30652 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30652 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30652 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30653 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30653 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30653 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30654 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30654 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30654 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30655 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30655 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30655 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30656 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30656 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30656 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30657 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30658 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30659 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30659 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30659 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30660 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30660 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30660 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30661 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30662 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30662 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30662 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30663 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30663 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30663 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30664 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30664 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30664 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30665 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30665 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30665 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30666 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30667 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30667 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30667 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30668 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30668 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30668 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30669 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30669 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30670 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30670 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30670 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30671 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30671 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30671 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30672 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30672 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30672 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30673 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30674 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30674 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30674 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30675 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30676 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30676 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30676 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30677 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30677 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30678 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30678 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30678 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30679 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30680 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30681 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30682 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30682 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30682 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30683 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30683 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30683 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30684 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30684 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30684 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30685 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30685 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30685 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30686 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30686 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30687 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30687 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30688 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30688 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30688 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30689 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30689 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30689 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30690 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30690 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30690 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30691 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30691 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30691 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30692 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30692 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30692 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30693 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30693 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30694 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30695 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30695 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30695 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30696 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30696 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30696 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30697 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30698 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30699 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30699 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30699 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30700 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30700 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30700 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30701 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30701 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30701 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30702 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30702 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30702 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30703 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30703 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30703 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30704 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30704 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30704 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30705 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30705 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30705 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30706 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30706 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30706 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30707 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30707 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30707 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30708 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30708 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30708 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30709 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30709 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30709 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30710 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30710 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30710 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30711 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30711 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30711 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30712 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30712 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30712 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30713 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30713 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30713 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30714 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30714 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30714 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30715 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30715 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30715 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30716 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30716 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30716 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30717 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30717 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30717 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30718 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30718 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30718 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30719 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30719 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30719 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30720 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30720 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30720 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30721 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30721 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30721 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30722 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30722 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30722 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30723 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30723 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30723 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30724 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30724 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30724 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30725 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30725 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30725 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30726 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30726 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30726 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30727 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30727 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30727 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30728 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30728 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30728 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30729 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30729 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30729 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30730 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30730 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30730 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30731 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30731 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30731 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30732 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30732 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30732 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30733 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30733 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30733 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30734 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30734 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30735 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30735 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30735 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30736 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30736 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30736 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30737 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30737 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30737 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30738 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30738 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30738 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30739 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30739 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30739 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30740 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30740 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30740 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30741 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30741 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30742 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30742 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30742 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30743 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30743 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30743 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30744 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30744 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30744 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30745 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30745 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30745 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30746 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30746 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30746 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30747 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30747 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30747 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30748 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30748 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30748 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30749 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30749 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30750 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30750 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30750 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30751 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30751 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30751 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30752 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30752 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30752 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30753 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30753 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30753 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30754 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30754 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30754 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30755 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30755 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30755 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30756 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30756 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30756 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30757 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30757 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30757 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30758 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30758 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30758 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30759 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30759 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30759 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30760 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30760 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30760 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30761 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30761 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30761 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30762 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30762 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30763 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30763 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30763 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30764 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30764 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30764 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30765 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30765 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30765 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30766 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30766 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30766 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30767 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30767 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30767 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30768 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30768 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30768 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30769 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30769 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30769 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30770 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30770 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30770 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30771 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30771 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30771 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30772 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30772 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30772 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30773 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30773 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30773 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30774 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30774 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30774 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30775 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30775 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30775 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30776 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30776 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30776 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30777 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30777 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30777 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30778 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30778 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30778 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30779 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30779 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30779 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30780 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30780 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30780 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30781 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30781 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30781 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30782 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30782 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30782 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30783 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30784 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30784 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30784 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30785 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30786 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30786 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30787 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30787 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30787 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30788 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30788 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30788 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30789 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30789 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30789 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30790 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30790 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30790 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30791 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30791 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30791 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30792 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30792 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30792 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30793 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30793 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30793 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30794 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30794 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30794 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30795 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30795 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30796 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30796 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30796 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30797 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30798 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30798 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30798 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30799 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30799 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30799 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30800 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30800 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30800 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30801 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30801 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30801 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30802 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30802 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30802 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30803 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30803 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30804 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30804 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30805 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30805 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30806 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30806 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30807 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30807 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30808 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30808 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30808 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30809 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30809 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30809 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30810 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30810 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30810 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30811 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30811 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30811 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30812 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30812 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30812 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30813 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30813 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30813 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30814 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30814 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30814 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30815 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30815 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30815 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30816 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30816 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30816 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30817 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30817 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30817 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30818 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30818 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30818 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30819 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30819 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30819 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30820 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30820 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30820 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30821 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30821 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30821 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30822 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30822 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30822 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30823 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30823 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30823 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30824 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30824 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30824 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30825 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30825 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30825 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30826 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30826 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30826 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30827 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30827 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30827 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30828 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30828 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30828 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30829 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30829 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30829 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30830 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30830 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30831 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30831 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30831 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30832 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30832 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30832 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30833 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30833 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30833 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30834 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30834 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30834 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30835 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30835 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30836 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30836 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30836 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30837 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30837 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30837 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30838 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30839 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30839 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30839 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30840 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30840 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30840 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30841 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30841 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30841 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30842 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30842 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30842 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30843 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30844 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30845 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30845 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30845 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30846 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30846 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30846 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30847 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30847 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30847 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30848 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30848 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30848 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30849 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30849 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30849 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30850 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30850 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30850 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30851 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30851 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30851 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30852 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30852 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30853 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30853 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30854 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30854 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30854 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30855 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30855 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30855 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30856 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30856 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30856 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30857 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30857 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30857 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30858 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30858 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30858 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30859 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30860 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30860 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30860 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30861 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30862 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30863 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30863 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30864 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30864 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30864 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30865 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30865 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30865 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30866 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30866 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30866 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30867 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30867 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30867 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30868 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30868 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30868 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30869 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30869 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30869 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30870 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30870 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30870 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30871 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30871 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30871 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30872 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30872 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30873 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30873 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30873 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30874 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30874 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30874 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30875 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30875 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30875 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30876 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30876 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30876 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30877 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30877 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30877 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30878 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30878 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30878 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30879 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30879 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30879 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30880 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30880 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30880 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30881 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30881 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30881 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30882 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30882 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30882 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30883 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30883 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30883 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30884 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30884 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30884 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30885 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30885 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30885 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30886 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30886 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30886 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30887 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30887 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30887 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30888 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30888 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30888 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30889 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30889 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30889 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30890 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30890 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30890 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30891 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30891 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30891 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30892 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30892 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30892 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30893 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30893 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30893 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30894 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30894 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30894 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30895 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30895 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30895 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30896 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30896 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30896 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30897 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30897 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30897 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30898 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30899 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30899 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30899 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30900 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30900 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30900 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30901 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30901 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30901 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30902 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30902 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30902 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30903 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30903 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30903 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30904 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30904 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30904 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30905 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30905 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30905 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30906 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30906 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30906 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30907 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30907 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30907 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30908 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30908 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30908 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30909 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30909 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30909 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30910 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30910 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30910 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30911 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30911 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30911 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30912 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30912 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30912 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30913 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30913 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30913 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30914 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30914 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30914 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30915 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30915 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30915 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30916 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30916 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30916 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30917 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30917 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30917 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30918 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30918 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30918 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30919 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30919 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30919 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30920 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30920 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30920 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30921 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30921 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30921 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30922 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30922 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30922 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30923 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30923 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30923 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30924 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30925 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30925 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30925 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30926 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30926 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30927 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30927 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30927 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30928 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30928 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30928 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30929 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30929 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30929 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30930 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30930 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30930 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30931 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30932 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30932 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30932 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30933 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30933 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30933 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30934 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30934 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30934 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30935 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30935 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30935 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30936 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30936 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30936 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30937 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30937 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30937 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30938 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30938 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30939 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30939 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30939 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30940 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30940 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30941 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30941 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30942 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30942 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30942 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30943 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30943 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30943 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30944 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30944 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30944 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30945 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30945 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30945 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30946 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30946 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30946 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30947 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30947 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30947 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30948 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30948 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30948 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30949 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30949 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30949 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30950 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30950 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30950 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30951 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30951 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30951 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30952 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30952 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30952 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30953 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30953 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30953 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30954 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30954 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30954 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30955 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30955 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30955 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30956 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30956 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30956 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30957 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30957 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30957 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30958 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30958 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30958 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30959 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30959 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30959 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30960 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30960 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30961 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30961 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30961 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30962 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30962 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30962 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30963 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30963 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30963 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30964 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30964 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30964 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30965 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30965 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30966 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30966 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30967 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30967 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30967 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30968 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30968 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30968 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30969 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30969 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30969 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30970 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30970 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30970 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30971 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30971 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30972 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30972 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30972 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30973 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30973 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30973 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30974 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30974 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30974 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30975 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30975 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30975 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30976 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30976 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30976 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30977 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30977 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30977 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30978 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30978 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30978 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30979 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30979 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30979 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30980 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30980 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30981 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30981 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30981 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30982 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30982 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30983 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30983 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30983 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30984 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30984 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30984 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30985 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30985 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30985 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30986 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30986 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30986 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30987 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30987 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30987 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30988 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30988 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30988 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30989 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30989 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30990 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30991 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30991 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30991 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30992 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30992 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30992 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30993 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30993 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30993 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30994 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30994 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30994 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30995 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30995 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30995 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30996 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30996 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30996 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30997 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30997 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30997 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30998 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30998 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30998 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30999 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30999 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 30999 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31000 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31000 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31000 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31001 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31001 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31001 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31002 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31002 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31002 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31003 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31003 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31003 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31004 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31004 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31005 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31005 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31005 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31006 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31006 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31006 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31007 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31007 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31007 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31008 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31008 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31008 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31009 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31009 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31009 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31010 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31010 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31010 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31011 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31011 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31011 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31012 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31012 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31012 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31013 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31013 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31013 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31014 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31014 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31014 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31015 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31015 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31015 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31016 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31016 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31016 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31017 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31017 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31017 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31018 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31018 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31018 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31019 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31019 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31019 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31020 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31020 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31020 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31021 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31021 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31021 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31022 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31022 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31022 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31023 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31023 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31023 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31024 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31024 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31024 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31025 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31026 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31026 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31026 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31027 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31028 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31029 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31029 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31029 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31030 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31030 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31030 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31031 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31031 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31031 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31032 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31032 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31032 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31033 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31033 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31033 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31034 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31034 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31034 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31035 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31035 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31035 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31036 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31036 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31036 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31037 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31038 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31038 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31038 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31039 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31039 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31039 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31040 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31040 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31041 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31041 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31041 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31042 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31042 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31042 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31043 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31044 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31044 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31044 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31045 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31045 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31045 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31046 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31047 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31047 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31047 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31048 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31049 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31050 AND [Standard_Level] = 'H' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31050 AND [Standard_Level] = 'L' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31050 AND [Standard_Level] = 'M' AND [Level_Type] = 'NST'
DELETE FROM [dbo].[REQUIREMENT_LEVELS] WHERE [Requirement_Id] = 31051 AND [Standard_Level] = 'VH' AND [Level_Type] = 'NST'
PRINT(N'Operation applied to 2623 rows out of 2623')

PRINT(N'Delete rows from [dbo].[NEW_QUESTION_LEVELS]')
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50024
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50051
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50092
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50093
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50105
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50125
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50126
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50127
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50128
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50129
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50130
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50131
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50132
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50133
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50134
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50135
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50136
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50137
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50138
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50193
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50244
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50273
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50274
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50279
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50280
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50281
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50290
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50292
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50316
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50337
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50367
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50368
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50370
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50372
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50381
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50427
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50428
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50497
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50498
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50499
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50505
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50531
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50553
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50563
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50577
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50654
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50687
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50688
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50721
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50724
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50749
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50750
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50751
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50752
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50797
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50903
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50922
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 50986
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51007
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51008
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51009
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51010
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51011
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51012
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51013
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51018
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51020
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51022
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51023
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51030
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51031
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51032
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51033
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51034
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51036
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51046
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51047
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51048
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51049
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51050
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51055
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51056
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51060
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51063
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51326
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51327
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51333
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51343
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51344
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51345
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51346
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51355
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51384
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51401
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51409
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51430
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51435
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51436
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51437
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51438
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51439
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51440
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51441
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51513
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51544
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51554
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51561
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51570
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51571
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51572
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51573
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51574
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51578
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51579
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51580
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51581
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51583
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51585
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51586
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51595
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51596
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51597
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51598
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51599
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51600
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51611
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51614
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51616
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51817
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51818
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51820
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51821
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51822
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51823
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51824
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51825
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51826
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51827
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51828
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51829
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51830
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51831
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51837
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51838
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51839
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51840
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51841
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51842
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51843
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51846
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51847
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51848
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51849
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51851
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51852
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51853
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51854
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51855
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51856
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51857
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51858
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51859
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51860
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51861
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51862
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51863
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51870
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51871
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51873
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51874
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51875
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51876
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51877
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51878
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51879
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51880
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51881
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51882
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51883
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51884
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51885
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51886
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51887
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51888
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51890
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51891
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51892
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51893
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51894
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51895
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51896
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51897
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51898
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51900
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51901
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51902
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51903
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51905
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51906
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51907
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51908
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51909
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51910
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51911
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51912
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51913
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51915
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51916
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51917
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51918
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'H' AND [New_Question_Set_Id] = 51919
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50040
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50041
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50042
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50051
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50092
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50093
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50105
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50125
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50126
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50127
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50128
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50129
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50130
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50131
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50132
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50133
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50134
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50135
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50136
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50137
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50138
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50158
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50193
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50217
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50273
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50274
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50277
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50279
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50280
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50281
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50290
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50292
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50316
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50367
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50368
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50370
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50372
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50381
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50400
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50427
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50428
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50491
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50497
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50498
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50499
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50531
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50577
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50654
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50687
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50688
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50724
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50747
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50749
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50750
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50751
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50752
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50797
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50922
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 50986
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51007
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51008
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51009
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51010
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51011
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51012
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51013
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51018
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51020
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51022
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51023
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51030
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51031
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51032
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51033
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51034
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51036
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51046
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51047
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51048
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51049
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51050
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51055
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51056
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51060
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51063
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51326
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51327
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51333
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51343
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51344
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51345
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51346
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51355
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51358
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51384
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51401
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51409
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51430
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51435
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51436
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51437
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51438
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51439
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51440
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51441
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51484
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51513
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51544
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51554
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51561
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51570
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51571
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51572
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51573
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51574
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51578
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51579
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51580
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51581
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51583
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51585
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51586
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51595
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51596
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51597
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51598
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51599
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51600
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51611
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51614
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51616
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51817
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51818
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51820
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51821
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51822
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51823
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51824
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51825
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51826
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51827
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51828
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51829
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51830
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51831
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51837
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51838
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51839
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51840
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51841
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51842
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51843
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51846
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51847
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51848
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51849
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51851
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51852
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51853
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51854
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51855
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51856
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51857
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51858
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51859
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51860
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51861
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51862
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51863
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51870
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51871
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51873
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51874
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51875
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51876
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51877
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51878
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51879
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51880
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51881
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51882
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51883
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51884
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51885
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51886
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51887
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51888
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51890
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51891
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51892
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51893
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51894
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51895
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51896
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51897
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51898
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51900
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51901
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51902
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51903
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51905
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51906
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51907
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51908
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51909
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51910
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51911
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51912
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51913
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51915
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51916
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51917
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51918
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'L' AND [New_Question_Set_Id] = 51919
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50024
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50051
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50092
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50093
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50105
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50125
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50126
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50127
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50128
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50129
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50130
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50131
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50132
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50133
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50134
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50135
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50136
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50137
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50138
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50193
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50244
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50273
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50274
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50279
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50280
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50281
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50290
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50292
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50316
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50337
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50367
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50368
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50370
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50372
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50381
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50400
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50427
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50428
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50497
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50498
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50499
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50505
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50531
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50553
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50577
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50654
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50687
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50688
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50724
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50747
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50749
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50750
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50751
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50752
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50797
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50922
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 50986
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51007
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51008
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51009
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51010
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51011
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51012
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51013
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51018
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51020
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51022
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51023
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51030
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51031
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51032
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51033
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51034
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51036
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51046
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51047
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51048
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51049
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51050
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51055
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51056
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51060
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51063
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51326
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51327
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51333
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51343
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51344
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51345
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51346
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51355
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51384
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51401
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51409
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51430
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51435
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51436
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51437
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51438
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51439
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51440
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51441
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51513
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51544
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51554
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51561
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51570
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51571
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51572
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51573
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51574
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51578
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51579
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51580
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51581
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51583
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51585
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51586
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51595
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51596
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51597
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51598
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51599
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51600
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51611
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51614
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51616
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51817
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51818
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51820
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51821
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51822
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51823
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51824
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51825
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51826
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51827
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51828
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51829
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51830
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51831
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51836
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51837
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51838
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51839
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51840
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51841
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51842
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51843
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51846
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51847
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51848
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51849
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51851
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51852
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51853
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51854
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51855
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51856
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51857
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51858
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51859
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51860
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51861
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51862
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51863
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51870
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51871
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51873
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51874
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51875
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51876
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51877
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51878
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51879
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51880
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51881
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51882
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51883
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51884
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51885
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51886
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51887
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51888
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51889
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51890
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51891
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51892
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51893
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51894
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51895
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51896
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51897
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51898
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51899
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51900
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51901
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51902
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51903
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51905
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51906
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51907
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51908
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51909
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51910
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51911
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51912
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51913
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51915
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51916
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51917
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51918
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'M' AND [New_Question_Set_Id] = 51919
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50014
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50015
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50016
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50017
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50018
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50019
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50020
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50021
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50022
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50023
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50024
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50025
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50026
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50028
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50029
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50030
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50031
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50032
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50035
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50036
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50037
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50038
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50039
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50040
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50041
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50042
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50043
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50044
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50049
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50050
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50059
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50060
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50062
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50063
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50064
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50065
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50066
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50068
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50072
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50075
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50076
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50077
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50078
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50079
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50084
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50095
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50096
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50106
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50139
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50140
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50141
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50142
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50143
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50144
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50145
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50150
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50152
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50153
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50154
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50155
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50156
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50157
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50158
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50160
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50161
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50166
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50167
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50168
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50169
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50179
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50180
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50183
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50184
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50211
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50213
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50214
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50215
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50216
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50217
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50218
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50219
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50220
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50221
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50223
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50224
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50225
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50226
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50227
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50228
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50229
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50231
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50232
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50233
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50234
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50235
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50236
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50237
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50238
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50239
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50240
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50241
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50242
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50243
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50244
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50245
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50246
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50247
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50248
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50249
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50250
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50252
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50253
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50256
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50257
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50258
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50259
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50262
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50263
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50264
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50268
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50269
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50270
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50272
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50276
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50277
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50278
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50282
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50283
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50284
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50287
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50291
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50296
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50297
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50299
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50300
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50301
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50302
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50304
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50305
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50306
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50308
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50309
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50310
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50311
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50312
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50313
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50317
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50319
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50320
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50321
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50322
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50323
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50333
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50334
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50335
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50336
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50337
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50339
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50346
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50354
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50355
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50356
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50357
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50358
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50359
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50360
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50361
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50363
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50364
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50371
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50374
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50384
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50385
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50386
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50390
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50391
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50392
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50393
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50395
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50396
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50397
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50398
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50399
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50400
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50401
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50402
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50405
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50407
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50408
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50412
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50413
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50414
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50415
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50416
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50417
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50418
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50419
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50420
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50421
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50422
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50423
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50429
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50433
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50434
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50435
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50439
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50440
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50442
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50443
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50444
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50445
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50446
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50447
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50448
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50449
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50450
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50451
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50452
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50453
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50454
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50455
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50456
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50458
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50463
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50464
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50467
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50468
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50471
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50472
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50473
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50474
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50476
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50477
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50478
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50479
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50480
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50481
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50482
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50483
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50484
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50485
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50490
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50491
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50496
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50500
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50501
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50502
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50503
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50504
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50505
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50506
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50507
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50508
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50511
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50515
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50516
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50517
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50518
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50519
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50520
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50521
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50523
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50524
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50525
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50527
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50528
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50529
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50541
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50543
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50544
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50545
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50546
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50547
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50548
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50549
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50550
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50551
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50552
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50553
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50554
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50555
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50556
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50557
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50560
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50561
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50562
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50563
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50564
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50565
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50567
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50568
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50569
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50570
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50571
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50572
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50573
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50578
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50579
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50580
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50581
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50582
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50583
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50584
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50585
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50586
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50587
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50588
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50589
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50591
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50592
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50593
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50594
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50595
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50596
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50597
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50598
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50600
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50601
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50602
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50603
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50604
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50605
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50606
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50610
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50612
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50613
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50614
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50615
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50620
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50621
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50622
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50623
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50624
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50625
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50626
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50627
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50629
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50630
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50633
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50635
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50637
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50638
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50640
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50645
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50646
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50647
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50648
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50649
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50655
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50656
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50657
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50658
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50659
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50660
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50661
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50662
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50663
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50664
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50665
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50667
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50668
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50669
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50670
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50671
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50672
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50675
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50679
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50680
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50681
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50685
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50689
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50690
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50691
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50692
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50693
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50694
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50696
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50697
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50701
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50714
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50715
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50716
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50718
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50719
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50720
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50721
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50723
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50725
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50727
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50731
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50732
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50734
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50735
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50736
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50739
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50740
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50747
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50748
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50753
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50754
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50755
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50756
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50757
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50758
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50759
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50760
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50762
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50763
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50764
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50765
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50766
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50768
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50769
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50770
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50779
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50780
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50781
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50783
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50784
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50785
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50786
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50787
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50788
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50790
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50791
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50792
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50793
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50796
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50798
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50799
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50800
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50801
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50802
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50803
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50804
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50814
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50815
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50816
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50831
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50838
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50839
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50840
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50842
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50843
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50844
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50845
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50847
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50848
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50849
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50850
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50851
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50852
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50853
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50854
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50855
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50858
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50859
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50860
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50867
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50868
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50869
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50871
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50872
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50876
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50877
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50878
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50879
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50880
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50881
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50882
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50883
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50890
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50891
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50892
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50893
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50894
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50895
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50896
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50900
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50901
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50902
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50903
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50904
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50905
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50908
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50909
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50910
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50911
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50913
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50915
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50916
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50917
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50918
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50920
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50923
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50924
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50925
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50926
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50928
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50929
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50930
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50932
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50940
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50941
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50943
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50944
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50945
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50946
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50947
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50948
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50949
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50950
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50951
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50952
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50954
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50955
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50957
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50958
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50959
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50960
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50961
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50962
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50963
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50964
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50965
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50966
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50967
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50968
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50969
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50973
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50974
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50976
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50977
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50978
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50980
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50981
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50982
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50984
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50985
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50987
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50988
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50989
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50990
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50991
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50992
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50993
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50994
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50995
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50996
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50997
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50998
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 50999
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51000
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51004
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51016
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51025
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51026
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51027
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51040
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51041
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51045
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51061
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51062
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51068
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51069
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51070
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51072
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51079
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51080
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51081
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51082
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51084
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51085
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51086
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51087
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51092
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51093
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51094
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51095
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51098
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51099
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51100
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51101
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51102
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51104
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51105
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51108
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51109
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51112
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51113
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51115
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51116
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51117
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51118
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51120
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51121
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51122
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51127
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51131
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51133
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51134
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51135
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51137
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51138
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51139
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51140
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51141
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51146
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51147
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51149
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51150
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51151
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51152
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51157
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51158
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51160
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51161
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51162
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51163
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51164
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51165
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51166
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51167
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51168
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51169
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51171
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51172
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51182
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51183
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51184
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51185
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51193
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51194
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51195
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51207
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51219
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51277
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51278
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51280
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51282
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51283
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51286
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51288
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51290
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51295
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51296
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51297
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51298
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51299
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51300
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51305
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51306
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51307
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51312
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51316
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51322
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51328
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51329
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51332
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51334
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51340
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51341
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51349
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51357
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51358
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51359
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51360
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51366
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51369
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51370
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51371
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51372
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51375
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51376
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51381
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51388
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51400
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51412
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51413
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51414
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51419
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51429
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51431
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51445
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51446
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51449
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51450
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51451
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51452
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51453
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51458
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51459
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51460
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51461
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51468
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51469
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51470
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51471
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51472
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51475
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51476
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51477
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51478
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51480
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51481
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51482
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51483
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51484
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51485
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51491
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51492
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51493
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51494
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51507
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51508
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51514
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51515
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51516
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51517
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51518
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51519
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51520
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51523
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51524
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51525
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51526
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51527
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51530
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51534
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51542
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51545
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51546
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51548
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51549
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51555
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51556
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51557
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51558
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51560
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51575
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51576
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51577
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51601
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51602
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51603
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51604
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51606
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51617
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51621
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51627
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51628
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51633
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51814
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51816
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51819
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51845
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51850
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51864
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51865
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51866
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51868
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51869
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51872
DELETE FROM [dbo].[NEW_QUESTION_LEVELS] WHERE [Universal_Sal_Level] = 'VH' AND [New_Question_Set_Id] = 51914
PRINT(N'Operation applied to 1427 rows out of 1427')

PRINT(N'Update row in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Category]='Media Protection', [Sub_Category]='Media Protection' WHERE [Mat_Question_Id] = 4788

PRINT(N'Add row to [dbo].[DIAGRAM_TEMPLATES]')
SET IDENTITY_INSERT [dbo].[DIAGRAM_TEMPLATES] ON
INSERT INTO [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible], [Diagram_Markup], [Image_Source]) VALUES (18, N'Emergency Management', N'DiagramTemplates\EmergencyManagement.csetd', 1, 1, '<mxGraphModel>
  <root>
    <mxCell id="0" />
    <mxCell id="1" value="Main Layer" parent="0" />
    <object Criticality="Low" zone="1" ZoneType="Other" SAL="High" label="Zone Core DMZ-High" internalLabel="Zone Core DMZ" id="UxTfs5nLP9km1SiU_4_t-107">
      <mxCell style="swimlane;zone=1;startSize=30;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="870" y="123" width="359" height="440" as="geometry" />
      </mxCell>
    </object>
    <object label="MPLS" internalLabel="MPLS" id="106">
      <mxCell style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#9673a6;strokeWidth=3;endArrow=none;labelBackgroundColor=#ffffff;fillColor=#e1d5e7;" parent="UxTfs5nLP9km1SiU_4_t-107" source="21" target="35" edge="1">
        <mxGeometry relative="1" as="geometry">
          <mxPoint x="141.5" y="117" as="sourcePoint" />
        </mxGeometry>
      </mxCell>
    </object>
    <mxCell id="cjdxwiZFUEl386gS18Un-139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#d6b656;strokeWidth=7;endArrow=none;labelBackgroundColor=none;edgeStyle=isometricEdgeStyle;elbow=vertical;exitX=0;exitY=0.25;exitDx=0;exitDy=0;fillColor=#fff2cc;fontSize=11;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-142" target="35" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="141.5" y="327" as="sourcePoint" />
        <mxPoint x="59.53233354778013" y="201.21360000000004" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <object label="&amp;nbsp;" ComponentGuid="672a85a2-e7cd-4fbe-aab6-a166acf9e94e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="132.45249999999987" y="89.95079999999996" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="aee2e5d1-bf36-4630-87c9-7b55ced31283" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-28" id="cjdxwiZFUEl386gS18Un-142">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="132.45249999999987" y="335.95079999999996" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="Zone Core Pair&lt;br&gt;" ComponentGuid="8e38f60e-bb96-444d-b5f8-c5c6400754e3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="High" HostName="" parent="3" id="cjdxwiZFUEl386gS18Un-147">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="199.65589999999997" y="87.21360000000004" width="60" height="25" as="geometry" />
      </mxCell>
    </object>
    <object label="Zone Core Pair&lt;br&gt;" ComponentGuid="7108598b-52a8-4942-8091-a7c46602d01c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="High" HostName="" parent="3" id="cjdxwiZFUEl386gS18Un-153">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;labelPosition=center;verticalLabelPosition=bottom;align=center;verticalAlign=top;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="199.65589999999997" y="333.71360000000004" width="60" height="25" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="051ef56a-0113-457d-b33b-87e29a78626d" Criticality="High" label="Zone Firewall Pair" internalLabel="FW-9" id="cjdxwiZFUEl386gS18Un-156">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/firewall.svg;fontSize=11;labelPosition=center;verticalLabelPosition=top;verticalAlign=bottom;labelBackgroundColor=none;whiteSpace=wrap;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="290.5" y="74" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="71f10319-928c-49bd-ba84-cbc18b8d90c7" Criticality="High" label="Zone Firewall Pair" internalLabel="Zone Firewall Pair" id="cjdxwiZFUEl386gS18Un-158">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/firewall.svg;fontSize=11;labelBackgroundColor=none;whiteSpace=wrap;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="290.5" y="321" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <object label="Mediation LAN" internalLabel="Mediation LAN" Security="Trusted" id="cjdxwiZFUEl386gS18Un-146">
      <mxCell style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#6c8ebf;labelBackgroundColor=none;fillColor=#dae8fc;strokeWidth=8;labelPosition=right;verticalLabelPosition=middle;align=left;verticalAlign=middle;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-142" target="21" edge="1">
        <mxGeometry relative="1" as="geometry">
          <mxPoint x="142.45249999999987" y="235.95080000000007" as="sourcePoint" />
          <mxPoint x="142.45249999999987" y="155.95080000000007" as="targetPoint" />
        </mxGeometry>
      </mxCell>
    </object>
    <mxCell id="cjdxwiZFUEl386gS18Un-152" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#808080;strokeWidth=1;fontSize=11;" parent="UxTfs5nLP9km1SiU_4_t-107" source="21" target="cjdxwiZFUEl386gS18Un-147" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="cjdxwiZFUEl386gS18Un-155" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#808080;strokeWidth=1;fontSize=11;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-142" target="cjdxwiZFUEl386gS18Un-153" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="" internalLabel="" id="6nKIGXFCzWmfwkv6MnNh-109">
      <mxCell style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#6c8ebf;labelBackgroundColor=none;fillColor=#dae8fc;strokeWidth=8;labelPosition=right;verticalLabelPosition=middle;align=left;verticalAlign=middle;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-153" target="cjdxwiZFUEl386gS18Un-147" edge="1">
        <mxGeometry relative="1" as="geometry">
          <mxPoint x="238.5" y="287" as="sourcePoint" />
          <mxPoint x="248.5" y="141.5" as="targetPoint" />
        </mxGeometry>
      </mxCell>
    </object>
    <mxCell id="cjdxwiZFUEl386gS18Un-157" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#6C8EBF;strokeWidth=8;fontSize=11;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-147" target="cjdxwiZFUEl386gS18Un-156" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="cjdxwiZFUEl386gS18Un-159" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#6C8EBF;strokeWidth=8;fontSize=11;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-153" target="cjdxwiZFUEl386gS18Un-158" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="" internalLabel="" id="cjdxwiZFUEl386gS18Un-160">
      <mxCell style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#6c8ebf;labelBackgroundColor=none;fillColor=#dae8fc;strokeWidth=8;labelPosition=right;verticalLabelPosition=middle;align=left;verticalAlign=middle;" parent="UxTfs5nLP9km1SiU_4_t-107" source="cjdxwiZFUEl386gS18Un-158" target="cjdxwiZFUEl386gS18Un-156" edge="1">
        <mxGeometry relative="1" as="geometry">
          <mxPoint x="320.5" y="307" as="sourcePoint" />
          <mxPoint x="341.5" y="147" as="targetPoint" />
        </mxGeometry>
      </mxCell>
    </object>
    <object label="Console Site Router" ComponentGuid="1bf065a7-cfb5-45cd-8458-500f8e01b9a3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="High" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="UxTfs5nLP9km1SiU_4_t-107" vertex="1">
        <mxGeometry x="11.655899999999974" y="190.21360000000004" width="60" height="25" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="XH7oSB1Q3w3cp9QVCW1a-107" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;Control Room Site - Customer Enterprise Network (CEN)&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;Control Room CENs usually host Nice Recording, DSS Recording, Elite API and/or CADI Services.&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;Control Room CENs are typically &quot;stubs&quot; (CEN LAN), meaning that they are single, dedicated subnets that are created to only host specific service.&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;&lt;br&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;The Control Room Firewall is a firewall that is installed at a console site to allow communications with outside networks. The firewall will be configured for &lt;/span&gt;&lt;span style=&quot;font-size: 12px ; font-weight: 400&quot;&gt;network&lt;/span&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;&amp;nbsp;address translation (NAT) mapping. The firewall will also be configured to only pass dispatch console related traffic to and from the customer network.&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;&lt;br&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;Console Site LAN devices send all traffic to the Console Site Router. Traffic that is destined for the &lt;/span&gt;&lt;span style=&quot;font-size: 12px ; font-weight: 400&quot;&gt;Enterprise&lt;/span&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;&amp;nbsp;CEN is sent to the firewall from the Console Site Router via a static route. All CEN hosts using these services need to be able to route to the dispatch site.&lt;/span&gt;&lt;/div&gt;" style="shape=rectangle;whiteSpace=wrap;html=1;strokeWidth=1;labelPosition=center;verticalLabelPosition=middle;align=center;verticalAlign=middle;fontStyle=1" parent="1" vertex="1">
      <mxGeometry x="150" y="-141" width="950" height="170" as="geometry" />
    </mxCell>
    <object Criticality="Low" zone="1" ZoneType="Other" SAL="Very High" label="System LAN-Very High" internalLabel="System LAN" id="m1hxJIzNgrUlvDxOGyZo-107">
      <mxCell style="swimlane;zone=1;strokeColor=#B20000;fontColor=#000000;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1240.5" y="391.5" width="368" height="247" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="9b69355c-4957-4cb4-b955-80056ac4edf3" Criticality="High" label="Firewall Mgt Server" internalLabel="AD-24" id="m1hxJIzNgrUlvDxOGyZo-109">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/active_directory.svg;labelBackgroundColor=none;imageBackground=#FF6666;imageBorder=#FF0000;strokeWidth=4;" parent="m1hxJIzNgrUlvDxOGyZo-107" vertex="1">
        <mxGeometry x="119" y="48" width="44" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="86f12799-f93a-4e71-8d84-01308f21254a" Criticality="High" label="CSMS" internalLabel="DB-25" id="m1hxJIzNgrUlvDxOGyZo-110">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/database_server.svg;labelBackgroundColor=none;imageBackground=#FF6666;imageBorder=#FF0000;strokeWidth=4;" parent="m1hxJIzNgrUlvDxOGyZo-107" vertex="1">
        <mxGeometry x="244" y="147" width="43" height="60" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="984e1378-9a75-439b-96b1-eaec190b3c3e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="&amp;nbsp;" id="XNDtLr3cqQsbXonp8KkM-128">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="m1hxJIzNgrUlvDxOGyZo-107" vertex="1">
        <mxGeometry x="38" y="67" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="82282b19-f58e-4b1e-a4aa-b051aa86fe0a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="&amp;nbsp;" id="XNDtLr3cqQsbXonp8KkM-131">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="m1hxJIzNgrUlvDxOGyZo-107" vertex="1">
        <mxGeometry x="38" y="167" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-130" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="m1hxJIzNgrUlvDxOGyZo-107" source="XNDtLr3cqQsbXonp8KkM-128" target="m1hxJIzNgrUlvDxOGyZo-109" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-132" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="m1hxJIzNgrUlvDxOGyZo-107" source="XNDtLr3cqQsbXonp8KkM-128" target="XNDtLr3cqQsbXonp8KkM-131" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-134" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="m1hxJIzNgrUlvDxOGyZo-107" source="XNDtLr3cqQsbXonp8KkM-131" target="m1hxJIzNgrUlvDxOGyZo-110" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="243" y="177" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <object Criticality="Low" zone="1" ZoneType="Other" SAL="High" label="Zone Core LAN-High" internalLabel="Zone Core LAN" id="cjdxwiZFUEl386gS18Un-183">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fontSize=11;strokeColor=#82b366;whiteSpace=wrap;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1240.5" y="-207.5" width="371" height="566" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="c44bbe77-90c8-44d2-9248-b67f9cd27a78" Criticality="High" label="Zone Database Server" internalLabel="Zone Database Server" id="cjdxwiZFUEl386gS18Un-184">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/database_server.svg;labelBackgroundColor=none;fontSize=11;labelPosition=center;verticalLabelPosition=bottom;verticalAlign=top;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="118" y="225" width="43" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="96763130-f6b8-4cf0-9cc0-e0d4484dd79a" Criticality="High" label="Zone Backup Server" internalLabel="SVR-15" id="cjdxwiZFUEl386gS18Un-185">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/server.svg;labelBackgroundColor=none;fontSize=11;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="258" y="473" width="23" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="775f68d7-29b7-4fca-904d-7288ed3f6ee5" Criticality="High" label="Zone UEM Server" internalLabel="SVR-16" id="cjdxwiZFUEl386gS18Un-186">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/server.svg;labelBackgroundColor=none;fontSize=11;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="128" y="398.5" width="23" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="6622a6ba-9868-475e-bac1-8e33ec5948d9" Criticality="High" label="Zone Statistics Server" internalLabel="AS-17" id="cjdxwiZFUEl386gS18Un-187">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/application_server.svg;labelBackgroundColor=none;fontSize=11;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="244" y="325.5" width="44" height="60" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="2g9_9qOLPwzJJ6DQc6ya-110" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;endArrow=none;strokeColor=#808080;labelBackgroundColor=none;labelPosition=right;verticalLabelPosition=bottom;align=left;verticalAlign=top;" parent="cjdxwiZFUEl386gS18Un-183" source="cjdxwiZFUEl386gS18Un-184" target="cjdxwiZFUEl386gS18Un-184" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object ComponentGuid="bc088ff5-a041-4c5c-a02f-2fff627935be" Criticality="High" label="Zone Controller 01" internalLabel="EW-1" id="m-PKMXxfoYSgVNY3it_B-107">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/ews.svg;labelBackgroundColor=none;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="100" y="55" width="63" height="55" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="e299a91e-f696-4b7f-b0aa-0dc9f1d6de17" Criticality="High" label="Zone Controller 02" internalLabel="EW-1" id="m-PKMXxfoYSgVNY3it_B-108">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/ews.svg;labelBackgroundColor=none;imageBackground=#B5FA8F;imageBorder=#66CC00;strokeWidth=4;" parent="cjdxwiZFUEl386gS18Un-183" vertex="1">
        <mxGeometry x="226.5" y="142.5" width="63" height="55" as="geometry" />
      </mxCell>
    </object>
    <object SAL="Moderate" label="CEN-Moderate" internalLabel="CEN" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;labelPosition=center;verticalLabelPosition=middle;align=center;verticalAlign=middle;strokeColor=#000000;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="11" y="71" width="305" height="538" as="geometry" />
      </mxCell>
    </object>
    <object label="Audio Recording Server" ComponentGuid="e7fdf040-49a3-402a-ac95-257ade9f041c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="94" y="421" width="34" height="60" as="geometry" />
      </mxCell>
    </object>
    <object label="&lt;span&gt;Agency Software Ops&lt;/span&gt;" ComponentGuid="fb69097e-468e-4622-99cb-8deda74c35fe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="wJGx4hFZ0Sm7uMFEhMk5-141">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;labelPosition=right;verticalLabelPosition=middle;align=left;verticalAlign=middle;" parent="2" vertex="1">
        <mxGeometry x="202" y="90.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&lt;span&gt;Agency CADICAD&lt;/span&gt;" ComponentGuid="23249778-d240-4527-9517-223c32eefa33" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="4i8PqE1TzuKkrrOvAeYK-143">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;" parent="2" vertex="1">
        <mxGeometry x="162.5" y="170" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="2a8cc1fe-15d9-4d41-85dd-7401edbb9a49" Criticality="Low" label="Remote LMR Console" internalLabel="PC-1" id="wJGx4hFZ0Sm7uMFEhMk5-140">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/pc.svg;labelPosition=center;verticalLabelPosition=top;verticalAlign=bottom;whiteSpace=wrap;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="79" y="74" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="wJGx4hFZ0Sm7uMFEhMk5-143" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="wJGx4hFZ0Sm7uMFEhMk5-141" target="wJGx4hFZ0Sm7uMFEhMk5-140" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object ComponentGuid="fd0531c4-ee86-4d54-8777-74325e7c9b27" Criticality="Low" label="CAD System" internalLabel="EW-2" id="4i8PqE1TzuKkrrOvAeYK-147">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/ews.svg;labelPosition=center;verticalLabelPosition=bottom;verticalAlign=top;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="79" y="153" width="60" height="52" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="4i8PqE1TzuKkrrOvAeYK-148" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="4i8PqE1TzuKkrrOvAeYK-143" target="4i8PqE1TzuKkrrOvAeYK-147" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="CEN Network IP/Mask" ComponentGuid="0d18b12b-055c-46d7-9ae4-ee98179c4afe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" internalLabel="CON-3" id="xszBj1p53JAKddVs91M7-148">
      <mxCell style="html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;labelPosition=left;verticalLabelPosition=middle;align=right;verticalAlign=middle;" parent="2" vertex="1">
        <mxGeometry x="202" y="242.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="00572486-4939-45a5-b4fd-4d6fcf80716c" Criticality="Low" label="Audio Recorder Client" internalLabel="PC-4" id="74er5_TXb4ZCgvV5zPsg-144">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/pc.svg;whiteSpace=wrap;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="79" y="300" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-145" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="74er5_TXb4ZCgvV5zPsg-139" target="74er5_TXb4ZCgvV5zPsg-144" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="Agency Recording" ComponentGuid="98a200b6-71ad-4163-85ab-696f712d8352" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" internalLabel="CON-3" id="74er5_TXb4ZCgvV5zPsg-139">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;labelPosition=right;verticalLabelPosition=middle;align=left;verticalAlign=middle;" parent="2" vertex="1">
        <mxGeometry x="202" y="378.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="16cd40b1-38c0-4a16-87c7-4e7b8dae23b0" Criticality="Low" label="Agency Firewall&lt;br&gt;" internalLabel="FW-12" id="cjdxwiZFUEl386gS18Un-180">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/firewall.svg;labelBackgroundColor=none;fontSize=11;whiteSpace=wrap;" parent="2" vertex="1">
        <mxGeometry x="231" y="228" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="cjdxwiZFUEl386gS18Un-182" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#808080;strokeWidth=1;fontSize=11;" parent="2" source="xszBj1p53JAKddVs91M7-148" target="cjdxwiZFUEl386gS18Un-180" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="4i8PqE1TzuKkrrOvAeYK-144" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="wJGx4hFZ0Sm7uMFEhMk5-141" target="xszBj1p53JAKddVs91M7-148" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="225" y="158" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-140" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="xszBj1p53JAKddVs91M7-148" target="74er5_TXb4ZCgvV5zPsg-139" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="215" y="267" as="sourcePoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="4i8PqE1TzuKkrrOvAeYK-150" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="4i8PqE1TzuKkrrOvAeYK-143" target="xszBj1p53JAKddVs91M7-148" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="205" y="248" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-143" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="2" source="74er5_TXb4ZCgvV5zPsg-139" target="13" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="195" y="388" as="sourcePoint" />
      </mxGeometry>
    </mxCell>
    <object SAL="High" label="Control Room-High" internalLabel="Control Room" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="390" y="69" width="466" height="540" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-168" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="18" target="74er5_TXb4ZCgvV5zPsg-164" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="226" y="410" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-169" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="74er5_TXb4ZCgvV5zPsg-157" target="18" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="146" y="338" as="sourcePoint" />
        <mxPoint x="207.5" y="271.89944134078223" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-159" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="18" target="74er5_TXb4ZCgvV5zPsg-158" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="313.31414490287716" y="271.9508000000001" as="sourcePoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-152" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="18" target="74er5_TXb4ZCgvV5zPsg-151" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="Control Room Firewall" ComponentGuid="d2016409-df25-4c4f-87a0-e6b99e256d60" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="Control Room Firewall" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="17.2034" y="229.9508" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="260aa052-2428-45ad-8141-410d1d600b93" Criticality="Low" label="Dispatch Console 01" internalLabel="DC-5" id="74er5_TXb4ZCgvV5zPsg-151">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/dispatch_console.svg;whiteSpace=wrap;labelPosition=center;verticalLabelPosition=top;verticalAlign=bottom;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="114" y="111" width="46" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="d7ff4e13-cc1f-4dab-8192-3b858068cd6b" Criticality="Low" label="Dispatch Console 02&lt;br&gt;" internalLabel="DC-5" id="74er5_TXb4ZCgvV5zPsg-157">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/dispatch_console.svg;whiteSpace=wrap;labelPosition=center;verticalLabelPosition=bottom;verticalAlign=top;labelBackgroundColor=none;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="3" vertex="1">
        <mxGeometry x="116" y="339" width="46" height="60" as="geometry" />
      </mxCell>
    </object>
    <object ComponentGuid="254b52f1-89c4-4e5c-a774-a680ee1d48ef" Criticality="Low" label="Dispatch Console 03&lt;br&gt;" internalLabel="DC-5" id="74er5_TXb4ZCgvV5zPsg-158">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/dispatch_console.svg;whiteSpace=wrap;labelPosition=center;verticalLabelPosition=bottom;verticalAlign=top;labelBackgroundColor=none;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="3" vertex="1">
        <mxGeometry x="286.5" y="340" width="46" height="60" as="geometry" />
      </mxCell>
    </object>
    <object label="Console Site Firewall" ComponentGuid="c23f1123-15aa-496a-8910-2ace96d1c82c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="Control Room Firewall" id="74er5_TXb4ZCgvV5zPsg-162">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="386.7034" y="230.4508" width="60" height="51" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="303.1931999999997" y="255.95080000000007" as="sourcePoint" />
        <mxPoint x="305.47450000000026" y="255.95080000000007" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <object label="Aux I/O" ComponentGuid="8f952cf1-ca6e-46a4-959e-2dc6319e11e1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="74er5_TXb4ZCgvV5zPsg-164">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;imageBackground=#6666FF;strokeWidth=4;imageBorder=#0000CC;" parent="3" vertex="1">
        <mxGeometry x="197.5" y="418" width="43" height="60" as="geometry" />
      </mxCell>
    </object>
    <object label="Control Site LAN" ComponentGuid="37b736a8-a5b0-4adf-b7b1-b3fbefe6aa7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;labelPosition=center;verticalLabelPosition=top;align=center;verticalAlign=bottom;" parent="3" vertex="1">
        <mxGeometry x="207.9424" y="245.9508" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="14" target="18" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="18" target="74er5_TXb4ZCgvV5zPsg-162" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="303.1931999999997" y="255.95080000000007" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <object ComponentGuid="3cca3871-7b9c-4240-adad-a0a35a7e70b0" Criticality="High" label="Dispatch IP Logger" internalLabel="DB-6" id="74er5_TXb4ZCgvV5zPsg-153">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/database_server.svg;labelPosition=center;verticalLabelPosition=top;verticalAlign=bottom;whiteSpace=wrap;labelBackgroundColor=none;imageBackground=#6666FF;imageBorder=#0000CC;strokeWidth=4;" parent="3" vertex="1">
        <mxGeometry x="286" y="109" width="43" height="60" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-170" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="18" target="74er5_TXb4ZCgvV5zPsg-153" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="223" y="246" as="sourcePoint" />
        <mxPoint x="291" y="334.7627032983421" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <object label="NAT Network Address Translation&amp;nbsp;" ComponentGuid="a93040be-8a83-4d06-bd6b-045a29c4b524" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="74er5_TXb4ZCgvV5zPsg-146">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="346" y="314" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-148" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="74er5_TXb4ZCgvV5zPsg-146" target="14" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="cjdxwiZFUEl386gS18Un-181" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;labelBackgroundColor=none;endArrow=none;strokeColor=#808080;strokeWidth=1;fontSize=11;" parent="1" source="74er5_TXb4ZCgvV5zPsg-146" target="cjdxwiZFUEl386gS18Un-180" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <object label="&amp;nbsp;" ComponentGuid="41409b6b-b639-46cf-8e81-cb488a93599e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="b0xLSYqVklmmNSaO8BDo-107">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="210.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="5591b625-8c0c-4d20-9c78-294cda1bf230" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="XNDtLr3cqQsbXonp8KkM-112">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="137.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="21cde674-dc41-4bf0-a2c9-e2e9ca1f47b3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="XNDtLr3cqQsbXonp8KkM-114">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="37.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="7c3c217f-c781-4ff3-b580-894111596000" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="XNDtLr3cqQsbXonp8KkM-116">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="-47.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="389b1445-d01a-472a-9a51-ca96fc904c9d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="XNDtLr3cqQsbXonp8KkM-118">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="-133.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <object label="&amp;nbsp;" ComponentGuid="783265e3-a041-41cc-bf83-d744ed2ab8a5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-27" id="XNDtLr3cqQsbXonp8KkM-108">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="1286.5" y="286.5" width="20" height="20" as="geometry" />
      </mxCell>
    </object>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-107" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="b0xLSYqVklmmNSaO8BDo-107" target="cjdxwiZFUEl386gS18Un-186" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-109" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="b0xLSYqVklmmNSaO8BDo-107" target="XNDtLr3cqQsbXonp8KkM-108" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-111" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-108" target="cjdxwiZFUEl386gS18Un-185" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1386.5" y="324.5" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-113" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="b0xLSYqVklmmNSaO8BDo-107" target="XNDtLr3cqQsbXonp8KkM-112" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-115" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-112" target="XNDtLr3cqQsbXonp8KkM-114" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-117" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-114" target="XNDtLr3cqQsbXonp8KkM-116" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-119" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-116" target="XNDtLr3cqQsbXonp8KkM-118" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-125" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-114" target="cjdxwiZFUEl386gS18Un-184" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-127" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-112" target="cjdxwiZFUEl386gS18Un-187" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1458.5" y="149.5" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-120" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-118" target="m-PKMXxfoYSgVNY3it_B-107" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1343.5" y="-123.80519480519479" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-124" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-116" target="m-PKMXxfoYSgVNY3it_B-108" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1468.5" y="-37.92574257425747" as="targetPoint" />
      </mxGeometry>
    </mxCell>
    <mxCell id="b0xLSYqVklmmNSaO8BDo-108" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;fontColor=#000000;" parent="1" source="cjdxwiZFUEl386gS18Un-156" target="b0xLSYqVklmmNSaO8BDo-107" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="XNDtLr3cqQsbXonp8KkM-129" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="XNDtLr3cqQsbXonp8KkM-128" target="cjdxwiZFUEl386gS18Un-158" edge="1">
      <mxGeometry relative="1" as="geometry" />
    </mxCell>
    <mxCell id="74er5_TXb4ZCgvV5zPsg-172" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;exitX=0;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="35" target="74er5_TXb4ZCgvV5zPsg-162" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="880.1558999999997" y="332.29340945677586" as="sourcePoint" />
      </mxGeometry>
    </mxCell>
  </root>
</mxGraphModel>', N'iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAAACXBIWXMAAAsTAAALEwEAmpwYAAAKT2lDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVNnVFPpFj333vRCS4iAlEtvUhUIIFJCi4AUkSYqIQkQSoghodkVUcERRUUEG8igiAOOjoCMFVEsDIoK2AfkIaKOg6OIisr74Xuja9a89+bN/rXXPues852zzwfACAyWSDNRNYAMqUIeEeCDx8TG4eQuQIEKJHAAEAizZCFz/SMBAPh+PDwrIsAHvgABeNMLCADATZvAMByH/w/qQplcAYCEAcB0kThLCIAUAEB6jkKmAEBGAYCdmCZTAKAEAGDLY2LjAFAtAGAnf+bTAICd+Jl7AQBblCEVAaCRACATZYhEAGg7AKzPVopFAFgwABRmS8Q5ANgtADBJV2ZIALC3AMDOEAuyAAgMADBRiIUpAAR7AGDIIyN4AISZABRG8lc88SuuEOcqAAB4mbI8uSQ5RYFbCC1xB1dXLh4ozkkXKxQ2YQJhmkAuwnmZGTKBNA/g88wAAKCRFRHgg/P9eM4Ors7ONo62Dl8t6r8G/yJiYuP+5c+rcEAAAOF0ftH+LC+zGoA7BoBt/qIl7gRoXgugdfeLZrIPQLUAoOnaV/Nw+H48PEWhkLnZ2eXk5NhKxEJbYcpXff5nwl/AV/1s+X48/Pf14L7iJIEyXYFHBPjgwsz0TKUcz5IJhGLc5o9H/LcL//wd0yLESWK5WCoU41EScY5EmozzMqUiiUKSKcUl0v9k4t8s+wM+3zUAsGo+AXuRLahdYwP2SycQWHTA4vcAAPK7b8HUKAgDgGiD4c93/+8//UegJQCAZkmScQAAXkQkLlTKsz/HCAAARKCBKrBBG/TBGCzABhzBBdzBC/xgNoRCJMTCQhBCCmSAHHJgKayCQiiGzbAdKmAv1EAdNMBRaIaTcA4uwlW4Dj1wD/phCJ7BKLyBCQRByAgTYSHaiAFiilgjjggXmYX4IcFIBBKLJCDJiBRRIkuRNUgxUopUIFVIHfI9cgI5h1xGupE7yAAygvyGvEcxlIGyUT3UDLVDuag3GoRGogvQZHQxmo8WoJvQcrQaPYw2oefQq2gP2o8+Q8cwwOgYBzPEbDAuxsNCsTgsCZNjy7EirAyrxhqwVqwDu4n1Y8+xdwQSgUXACTYEd0IgYR5BSFhMWE7YSKggHCQ0EdoJNwkDhFHCJyKTqEu0JroR+cQYYjIxh1hILCPWEo8TLxB7iEPENyQSiUMyJ7mQAkmxpFTSEtJG0m5SI+ksqZs0SBojk8naZGuyBzmULCAryIXkneTD5DPkG+Qh8lsKnWJAcaT4U+IoUspqShnlEOU05QZlmDJBVaOaUt2ooVQRNY9aQq2htlKvUYeoEzR1mjnNgxZJS6WtopXTGmgXaPdpr+h0uhHdlR5Ol9BX0svpR+iX6AP0dwwNhhWDx4hnKBmbGAcYZxl3GK+YTKYZ04sZx1QwNzHrmOeZD5lvVVgqtip8FZHKCpVKlSaVGyovVKmqpqreqgtV81XLVI+pXlN9rkZVM1PjqQnUlqtVqp1Q61MbU2epO6iHqmeob1Q/pH5Z/YkGWcNMw09DpFGgsV/jvMYgC2MZs3gsIWsNq4Z1gTXEJrHN2Xx2KruY/R27iz2qqaE5QzNKM1ezUvOUZj8H45hx+Jx0TgnnKKeX836K3hTvKeIpG6Y0TLkxZVxrqpaXllirSKtRq0frvTau7aedpr1Fu1n7gQ5Bx0onXCdHZ4/OBZ3nU9lT3acKpxZNPTr1ri6qa6UbobtEd79up+6Ynr5egJ5Mb6feeb3n+hx9L/1U/W36p/VHDFgGswwkBtsMzhg8xTVxbzwdL8fb8VFDXcNAQ6VhlWGX4YSRudE8o9VGjUYPjGnGXOMk423GbcajJgYmISZLTepN7ppSTbmmKaY7TDtMx83MzaLN1pk1mz0x1zLnm+eb15vft2BaeFostqi2uGVJsuRaplnutrxuhVo5WaVYVVpds0atna0l1rutu6cRp7lOk06rntZnw7Dxtsm2qbcZsOXYBtuutm22fWFnYhdnt8Wuw+6TvZN9un2N/T0HDYfZDqsdWh1+c7RyFDpWOt6azpzuP33F9JbpL2dYzxDP2DPjthPLKcRpnVOb00dnF2e5c4PziIuJS4LLLpc+Lpsbxt3IveRKdPVxXeF60vWdm7Obwu2o26/uNu5p7ofcn8w0nymeWTNz0MPIQ+BR5dE/C5+VMGvfrH5PQ0+BZ7XnIy9jL5FXrdewt6V3qvdh7xc+9j5yn+M+4zw33jLeWV/MN8C3yLfLT8Nvnl+F30N/I/9k/3r/0QCngCUBZwOJgUGBWwL7+Hp8Ib+OPzrbZfay2e1BjKC5QRVBj4KtguXBrSFoyOyQrSH355jOkc5pDoVQfujW0Adh5mGLw34MJ4WHhVeGP45wiFga0TGXNXfR3ENz30T6RJZE3ptnMU85ry1KNSo+qi5qPNo3ujS6P8YuZlnM1VidWElsSxw5LiquNm5svt/87fOH4p3iC+N7F5gvyF1weaHOwvSFpxapLhIsOpZATIhOOJTwQRAqqBaMJfITdyWOCnnCHcJnIi/RNtGI2ENcKh5O8kgqTXqS7JG8NXkkxTOlLOW5hCepkLxMDUzdmzqeFpp2IG0yPTq9MYOSkZBxQqohTZO2Z+pn5mZ2y6xlhbL+xW6Lty8elQfJa7OQrAVZLQq2QqboVFoo1yoHsmdlV2a/zYnKOZarnivN7cyzytuQN5zvn//tEsIS4ZK2pYZLVy0dWOa9rGo5sjxxedsK4xUFK4ZWBqw8uIq2Km3VT6vtV5eufr0mek1rgV7ByoLBtQFr6wtVCuWFfevc1+1dT1gvWd+1YfqGnRs+FYmKrhTbF5cVf9go3HjlG4dvyr+Z3JS0qavEuWTPZtJm6ebeLZ5bDpaql+aXDm4N2dq0Dd9WtO319kXbL5fNKNu7g7ZDuaO/PLi8ZafJzs07P1SkVPRU+lQ27tLdtWHX+G7R7ht7vPY07NXbW7z3/T7JvttVAVVN1WbVZftJ+7P3P66Jqun4lvttXa1ObXHtxwPSA/0HIw6217nU1R3SPVRSj9Yr60cOxx++/p3vdy0NNg1VjZzG4iNwRHnk6fcJ3/ceDTradox7rOEH0x92HWcdL2pCmvKaRptTmvtbYlu6T8w+0dbq3nr8R9sfD5w0PFl5SvNUyWna6YLTk2fyz4ydlZ19fi753GDborZ752PO32oPb++6EHTh0kX/i+c7vDvOXPK4dPKy2+UTV7hXmq86X23qdOo8/pPTT8e7nLuarrlca7nuer21e2b36RueN87d9L158Rb/1tWeOT3dvfN6b/fF9/XfFt1+cif9zsu72Xcn7q28T7xf9EDtQdlD3YfVP1v+3Njv3H9qwHeg89HcR/cGhYPP/pH1jw9DBY+Zj8uGDYbrnjg+OTniP3L96fynQ89kzyaeF/6i/suuFxYvfvjV69fO0ZjRoZfyl5O/bXyl/erA6xmv28bCxh6+yXgzMV70VvvtwXfcdx3vo98PT+R8IH8o/2j5sfVT0Kf7kxmTk/8EA5jz/GMzLdsAAAAgY0hSTQAAeiUAAICDAAD5/wAAgOkAAHUwAADqYAAAOpgAABdvkl/FRgAAMtpJREFUeNrsvXmQJUd62PfLrOOd/bp7emZ67gsYYAAMjgUWi8XiIrBLrCXalFYSGZYvyvJBhS3GinJYMkOHHbJCtGXaMqUQKYqyw1pTligFJYqklntwDwjYBXZxLO5jBnNfPdMz3f363VWVmf6jsl7Xe13vvT6mezBU50TF9KuqrLy+/O7vS2GMYatslZUWuTUFW2ULYLbKFsBslS2A2SpbALNVtgBmq2yVLYDZKlsAs1U2pbirefntd95L/pxwBD9n4Kcizd6tabw9iokxROA6/FAbfs0YvgrwwP33bQzA2HLMEfzWXEvfe3kxohUahNhajNsCYAxIAZNF5yf3VpyfzDni7yjDX9wwDAOMO5J/eWEhuufsXITBILeA5bbDMvV5zVxDcc9O/+eLvpgB/vaGAIyU/Ln5pr7n7FyEwCC3UMttV0S8jjQCzcc3Ao7vyv3VDQMYDP/h5cUoRm1ZqEWAQKRgeavcevAAYwym+ysujhRU25qFlh7bMJKkNHtaoQZhloGDEIIwUtSbAWGkt8DlkyACC0Eh51IseMiMLayNoRHojZOSAJUwT6YPWBYbHeaqLSKlCSONEPH99e4Pcwv35u3cttYGKQWuIynkXHZMFHFdSY83i+nFOhslJfUMRwpBox1wfb6B0TGqe+DYHu46sJOc79p3xYAvmBQJW/48DAI8z8sEvATJioESgRkIsKPa1loThiG5nD+g78PaNhjDkLaNBYpskq6UQiuN73tkuSoNa9ukxnR9ocGbH13iyo1F2m3D7HyDXdvLA3qz4QDTi9aqtQ6YeKL/yBP38bkH9qENRAqLaQbtgpgBG1RarTb5XB4hV1fXmHiHOY4YsgMH11fK0Gm3KRQLmX2PAWJtbSdAkFVfCAhDjYoU+cJygBlWNxmTFU6459AUD929h3/y1Tc4PzNPO1A0WgFjxRzamDVzme6akEuq42GkiSKNVobPHD/IY/fvox0aO3EaIcTA3ZagzUEljDSOoxEZ7wyra4xBa402zkiUnQ0wijDSuJHOxm7DsNeItuO1yq6f8IEqUjiRR7835LC6CWaMAUYSAoWcy5eeu5+v/O5rLNbbtDuKciEFKWb1YLNq04ARYIRYuuwkFfIen73/INrAltfnJ6OEkWF6ssCDd+1GWWDqWbs18JhybRjGpC4QRlAu5MjnvS5a/OTpHjZGZySEwPkEay81MFkpIZEII8Do3vXbcIDJ0r0IESvxlmBo6EXf/8PeWe9lu8VctdNDu0f1jxU8EwJqzZDZhXYXaFbyXdb4fKXz2nNZSUgKcVNMOGtgenuHJwBHCAQiVhDZK6Hnw75gjEGaYYjMfstk8wqDNkhST0rodBQfnVuk3oz41LFt5Hxpyebg+toYdGocWf0SlombX+zw8YUad+4bY//uUiwSD62bSGjZ2CDd9iAeZpgA0j/v2oiuNLukmTdrVq6660X1CVfelThS8GQGyPnJPjdax0hOZIvdRseTJky2qBJ/X2Q2IKVgbqHDiXOLOFJy3x0T5DxpSWaCCsUQSUcPAVSDkAKlDPt2FPFdyakLNRYbIXfsL+O5InPsMcDE381i5JeovRmAdiwQyQFiddJmhq7FcbB2P7Ns/TYUYFKsC8ncO1LiSNkdbBfCzSA5X3Q1ACYtLw6bwIyFQ2ePWgjB2ct1LlxtcXB3iQPTpZg0mXinKaUHfjfd72ExW1obHBkDxvS2PJWSx4dnF3njgznuPTLORNknUhmWfMNA7CtSG2Ewhok30qCdaETvt+M/BY6UCCF6WJe1CCir52GE6V5GGJAGx6K7RLs7+gIpJELIoe/J7nezLomUy+t7nuTqXJvzM02OHhjjyN4yQsYYp9VRvH9qgXZgcJzhbTtD+uY4kgtXm5y6VI8XTggKeZcH75qkXPR471SVekvhujKz36PmR456LgfPq4CMuaa7Run1i68NBpiezrC0cPITIClIKVish5y5VOPOfWX27SwSqRgTXJtv89aJOXxfkvMl64n4NAamxnMs1gPeOjFPu6O6fMJ9R8YpFVw+OFNF60+Gr5AQMRXIBLTNEat7LykETqKTuUUXAiKlef90lYkxn73TRUIVa1xn59ucvljj6IEKdx2s4FrswhrbQUCl7PHQ3dsoFdwloBExb3LsUAVjDOeuNJDy1s6LsRAjUyRpoGi2GWK1EOA6okesvDW7SHD6Yh2tDYf3llGWx5id73DifI07D1TYOZVHm1iDfG2+TaTNqsfaaituLHRiBlMK7jpYYXoqz4fnqnRCDRg8T3L0YIVL15rcqHZuqZ4msTy5Tryp143FWSeKERiL7mSXi9/sS0q4eqPFzPUWxw6Pk/cdwHB9oc2Jc1WOHaqwbdxHa8NiPeDdU/N0AoUUrLotzxXcWOjw4dkqkdJoYzi0p8RYwePdk/NEUWwamBjz2DmV56Ozi7QDFUuFt2R+7KZO2AYzSgO00Yo7Ygt1sovS9JEhjBsrYI6X8Ux9zFzyjSgynL/SYHp7gYmKjzbQCTQfX6hzeO8Yk+M5AOYXA06er3Fwd5kDu8vkcg65nEM+5+B7DlJKe88nl/PxXBfHiZ/ncg453yGXc7nzQBnfk3xwuopSGm3g8L4ynic5fbGGtKj/4O4SGLhyvYUj5YrGLLJ4xfSYh8wJA74X8zDiprjTujeDFEgLMFobwjDsMpRK6y7HP0jPMoxZVkoRhuEA46NGSInrCK7NBXQCxa5tPkEQAnDuSoNiTrJ93CUIQlptzakLNQ7vKTJedlhcbPDOeycJgwADbNs2wZ7dO3j/g1NopQjDiIMH91IuFzlx8mxXLN+3bxeHDuzmwK48Zy41OHGuxtEDscLu0O4C755a5Ea1zeSYjyNgespnZrbF9KSP48RzNMz4GCnVHfdysTrBqNn7XGltzSCp59YIGgOMQK2TaVg9wIjU1bXTSKSQREoRRaor20cWYOQAfxZtTCxeDzKehVFMgTPqKxN/OxSCmestJioejlB0OhGNlmahFnLXgSLtTgeAs5fb7NrmkfcNrVaHhdoiP3j9fSYmd9Ko1yjlLyEfuY9X3/iI7dO7mbs+S73ZZtf0FK+9+TE7p3dz9col6o0me/fuIAoi9mz3OHO5w9lLNfZszyEF7Jz0OT/TJO/FkzBRdrhy3TBzvcHOSZ9QJRKVzJxbpRRaa0xnObXQlqzFvEj2nAA4qW9r5WAAx3GQUqCE7uHJNh3DADiOQErwPBfPzXV3xnrdG4SAfD6fWT/2OZGEkSZULQ7tKFIs+iBhdqHB1HiObRNFAK7PB5SKPnt3lVEq5rna7YDJyW3c//BjzM5cYu7qKXI5n527dvPAw49z4oO3yXltcr7L3n37Of7go7z1xivkfI9SoUjoRkghuPNAjo/OLYLjU8g77PNyzJ1YoBO5TI37IGDbeES1oTmwp0Au0RQPcm8IQ5RS5PP5dbk3dBfYdXBkM8YwfXNtNofpFcsuR8Sa3k3XuwioNUJ8V1IpeWhjiEJNvRmye3sOoyGKDJdnm+zcls9wSDJEUbxA3XtaE0Vhd/KThei/l9hucr5k744C1+c7CAO+K9g56XNlttV1N5meytNoRTRa0S3RywisHkb0rptArNpA4K6+cWMvUkYtq7XtN5uPUo4NMCwus0MMeVath5QKLk4spFFrRDhSUMhJBIa5agfflZQLDkrp4d/N9onsnVTTY0VEK0Ol5HJ1rk0QKlxHMDnmMVcLiSKNKwWlvIPrCpqtiHLBGT4vPa4jJqMvI+r2j8NoZEKmhInXKLWWmyolmbSUtMmKu5hmQ7MdUS668RxZdwPPk11b13wtYNu4n+l2sZ5xJ5c2xGYGBIuNCIBczsFzJJ1Aoe3uLvgOnVDdMqWm48SswXr1ZDeFjkhLHzd1IoQg0oYw0uRzDtpurEZL4XkSEIRKE4SaUtFFJQbFIQBjhjpyDFR0g4By0aXWDDEChIScL2l2FAkVyOecbvjNpgMM8frcDLFaroUepi+ZiGxy9AIsszaPeD4KE0SRQut492Cdr4NIk/PizgRBzHR7feEVmZZiIXBdt28jSFzXGeBaYdJYn2LeoRPornXY9ySdVMxPzpeEkRk67q6yDTOCYq0cTySKu0S5KpYLupssVkthjY+yZ9DpRR86OUYOea7jKwOujTEoZSUO67yldHzP9yRGQBDqLjDrlBkgdgHQXXCUUlBdrPPu+ye7EojjSK5evU693sBxyt1BG5J+LW0JDXiuRKm4D0IYXFfS6ajuXLiOJFJh18dnIIfYp6nNmjOBzAQqk7EhEonMkRIjdC+UbL5YHXdbyiVdS1rkE4iBYrWwfimxniVbphZCdr8xSO5OXCWF9U1JxHHBUrYC0eeeKCyTnv7darW5cGGG8andXd3SQrVGrdZgeu9Yd7witjAiZa8+I3EFxe5oKUTsriPFUmiWWXpRDIgzEVIitB4SBCgyFZkJOhH9a2D/ll2nK7NG3LJmgOlFZgKBY30usoSk4dhTDBemTLLrsp6J7heMiclC4t6htP0tYsY48XteLnyJrkZ5544pHn3kXl55/VQcRBdGHL3jINPTU3x0eq6POC7vkza9gKp0nNnC6F7SMEwgE31jXq4GEENdSzE9AtxSu4AjQZn1EKM1A8xyl+PEOWc5KjUjJMiVPDcDaXOCPbTWGCMRIlYEhqHuGgq10t0Qi14eZjk7q/tJwDJ+JyFJvf0SQhCEOmYqRaLfUdYjz3T5LSkTR/kV8DFDfHqH+TJnkaRE/RG7upp1qe7kOilS17DlSLHuWOrVNu46EikhUvE2kkLge4JOECvifC9Wiweh3lCFmQBa7Yi873Tb6QSGnO90l6QTaDxPrGdzr8PeB26GpnctbIxc7czIlOuk7PO+6xdENzKgLUk54nsOzbbqtl4uulZaiZ2n8r7DwmLQtSD3902sVleeEb6qDdSaEZVyHN4aRYZOqCjmHRsFAM22wnfluh2G1janievn8vXbeAzTJ5d1Y6dFtpKy/97NvASxOFtrhF0+plz0CCMd8zEGJis+C/UQpc1o5fEK9QI9fRAQhAopBKVCrEBsthWRiiUlYQRBqGgHKpbe1jnmtcxp19AoRLZuZEN5mIyoqQTLmL54n6G02spYZiVxSQPkM6U15aLLfDUgiDSOhLwfa3kb7YhKUVAuxnqUxXpIpeyhtekR97t9T/V3SbJL2k9+L/Fp2kokUgjmqwHlghMzuRjmayG+J7thHfVmnIQpn5MorYfGa60kLmmQnNMVxvrF6mRMkB2pt6G2pH7ITKM3Y6yeobezg4K64rCIISEmWsexSyI79khjKPiCSBnqjYDxcpw4p5h3uDEfUCm6YGKXg/nFgErJiftnxRqlIoJOhyAI0Ep3A+nj3wotNUbHBspOp0MUhRgjYz2Mdd1odxTXFzoc2VuyRkpDtRZyYFfRxl3FUZfFvGPjovQQMUl0x2wGANawsJxuWE9qvpJIHCklQou+tWPjowboo4HSOlBJmdIjJFfiBZa+Zy+ZeKBlPEueiyFXoqfxPJd8TnK9Gsb3pWSy4rPYiGh2DEJKJio5lIbZ+QDXcxBS4ngeEsWJ917l2uXTVCplcrk8c9ev8t4b3+Pi+VMUS0WKpRLN2g0+ePtl2s15yuVYiec4DkYILl5rMzmeo5B3kY7k6nyA70nGx3wQgk5kqNYjpiZyNjbIhpkMGLMcMnZsXTlkTrLmlFSYyXIeZoOt1dkwJHqCpFZlrDZre57mIXZtL/Dx+RqL9ZCxkkcx7zA17nHmUp1jhypIKdg3XeDUhTrKwK6pPIV8nj/5x5+3Gl+B57nU6k2KxRzPf/4xvvaNF9mze5o7juxn//7d3cYcxyGKYhLz8cU65bzL7qk8BqjWQmbn2xw9UCbxW7k828ZzJdsqPpE2K56TbD3MyhjifjOIsco+cWucwJdzvWJY1qANLlobxkse5aLH5dmWDXOF6akcAsHFq02EVd0f2VdivhrE9wTkch75XI583sfzPIIgIJfLMTU1QbFYYHGxjuu65HN+/F7Ox3Mc2h3FyfN1ijmHPTsLGBOL7ucuN5jelqOQi42fjVbEjYUOu7bnY5/nWxRSIXr4sn6fmI02PoreS4olDectKwL27MxTa0bMVTs4Mp6gQ3tLzC+GXJ1rIwDfdbhjf+x1F4Yxv6WN6dqZOp2AQj6H73sUi3mq1VrXqNl9T8Qi9PiYx/7pYsxnCDh7qUEh77JrewFtJbSLV1sU8y5TlVyPLeuWTJHIvjZcShL0pSETpAxz2Sk9ViJwrfZ5j1+MNowVPXZM5jg/06RUcHHd2KXg0N4Spy/UY7Iw7uMg2L8rjojUFmW7rouQgk4npFjMI6VDZazMjbkqyvRmBFXaMDXux/6xJs5VfPFqE6UNd+4rx37KEhYbIbVGxF0HyyBNN2/OSudkkGvFSlRE2bpc0asGYW1EYd0kSZAohGLimRYJ9ZB4Gd21Rt+c+BulNXt2FMj5DhevNrsST6XkcnhviUvXWlyba8cWZVvHkZIrM7N869vftxJPQLlcQhtDpVKi3mhYR/TlfdfGEASKM5caVOshh/aUui4erY7i/EyDXTvylItu16o+ak5Wcq2pPpYSZLjXbrgtKQsqE4Ax2IwKPQzXADM+cRCYGJCJIEmNobXODKuIny0xcknmyjv2lTh5vs75mTaHdhdRxlApuxx0ilyebVHIu+S8JWZQKcWP3nwfIQUL84vcc8+dRJGiPFak0w5oNtsUi/mu/SlmRjVSSGYXAowxHD1Qjh3IjLH8TYNS3mXXVC42W6QyVSR6qkH+Q9oC+jD3Bi3kwGSNZGRvEKk16hdWNhzDxDtTdAOjhGDN0DqMWe7aooeY+bP65rqC/bsKLCyGnJ9pdi3JhbzDkX1lG4ifaiFhBg0EQUi5XERrTbFYQAhBo9GMPe8d2fO+0jC9LceB3cXYJ0gIWm3Fx+fr+J7kwJ7isgRAIsWADvUDGDbmtdARkR4v3TgysYaEwHK1wDK7UOP6Qp1mOw4Ac2RaGZTmglPS07IL648iepmivksM/Ybo0T0klzaxPenQngLz1ZDTFxvWqYmU05fs9kMpxc6dUzzxxCNUKmUKhTxaawr5PJ7n0u50WKw1ePF7r8XZGGTS9pJbqiMFi82Qk+fr+L7k8N4iriOWlGg9lxw6ZkaN2bY9aF4zOdzUBpVSEEWKxUabKzeqNDvBxpKkKDLUWh0a7Q6OI5kql9hXmaSbv1qvUnGwrqiB7EdKGyolhzsPljh7qclHZ2rcsb+Uwi5xfRVF7Ng+xZf+2I+jlabVblPI59Ba4zoO5XKRy5eu8tFHZ7h4aYbHH3uop0+J89b8YsjZSw0mKj77p/MxL6eHGaw2M2og/i2kIIgUMzcWCUIVR6muQC+0boAxLOU8CUNFvdVZ4s616cFZK/LbXbM/zHC/EKU1xbzLnQdKXL3RSTGLS+9orcnnfVzX4fr1eZTSOI7E6NgdYtu2CT46eZYoisjnc5l+KoI4/HXX9jzTUzGwKa0HZkoYladuJf4ww+rCch7GkPjsxOvlOk4KIZmNBZiEJ5AsdUSQnR9/s8TqQc+VXuJpYl1KhvhqgWix1uiK2GEUkXi9HTq4h+npHbz62ttLC5LGZsYwMebG5DDVhlmZd8Sqxr4esXrJWC2WUs6ZTUkdb7rKqiR1hHAEwrnV2rvsiTUmXtRRol+z1WZ2do5avcHYWInrszd4970THDiwh2P33MH4xFh3krM2UBrd3YyYp5s6FyJeHyEy3A02OsfdqOwiK8txJ1ac+mIl6T5WeyX1XNfpplur1xsIIXjzrQ/xfY+33v6IXbt2IKVEK82u6R04jtMDZGLTr9XNcZYD/vqyw9wk42MXPStFFIZLDPKQ7A2J8suRg7M3BFGE6HSyszdYz/rMzBAmfu46cgBJjVHx1WuLTFTGKBYLzN1Y4Njdh7l+/QYvv/Im12/M8+wzj/GDV9+mVqvje65VnMV6GCFkZmBYEu4yqu1sHkcQqQitVMqDsa+uTfchBjD7JJJr8sWUX/HNKGt3oDJLyYwSHkYrsxS/DCit0EIOSPehY2cmOZiSKRUffJENMLFTtR4UszQgz27StpQOr776Djnf48knPk11scaBA3ezd+8ufu/ffIdnnn6U8fEKRhvq9SbjlbFYoQYYoxDCoAfogga3veRobsTgHC9KaaRSy9N9WO24I7NdqLrnCaS0gsKGczjJ+6ux3dwcKSkVV9yjQjM4roPre0vvJvE1Itv5OEn3MSzYLVfITvdhhtQ1Jk4aLR1noB7LcRzy+Rwff3yWVqtDtVpn5/R2btxYQEqJijRjlTLFYoF2J2B3qUAYqa5D2KA45VFt9wQvLdOYC4IgRKmIQqGwnF8aUjeZ766eKSXFtVW7V9u8Dl5rXTnuMqP/UzqEpdTvyy8z4vkoB9ZRdUc9M8bQ6QTs3LmdJ596lEIhh1aat976gB//8Sc5eeocCws1SuUitVoj0bmvqN8raXtgPVKi8RrGvOz5qk85uNkYxgzXLd0uRWnNrl072L9vN1ppcrkcM1evs3PnFA8cv5trM7O8+tpbVCpj1GqNPzRnc68u0PAmKe6ScPGlv1I8zWoVvev0uBsF1AN1SUrz6Ufux/M83nvvBMZozp+7xOOPP0yr3eH48bv59ndfod0OcKRjncdHj2tU25vtcbdc8WtSaftvxfE3o9DPJ/hSkUIrRbPZ4sqVWQqFPNsmxomCiEI+zwP3383ZsxepNxpWcjG33RhvNhlwbza89AayjVCBE8cLZ9HRWITVVqs84Lk2A47YG95+ot3V1ptubq5KqVTkkYfvj4/QM5pO0OHonYc5e+4Sly7N0G7HB5b2579diXq+X9IRDBoz9vi/0aGyw86iNBvIJ8i1IZHexMFpdkqnLpNxL/0s0cXoAe8kHnHZ9c3wbw/7Zqp+pDUL1UXuuecOKhNjRFp1TQYaOHL4AJ1OQKPVBinQxnSTE6217fWMeS1tm9TiZTlXbaKmt79Bk+nLleXnJbppL7KfSyGQiIHPk+Cy7GdmKfXFoLaJlX5RGNJudzh9+gKNeiNOvNP1JBRcvXaddrtDu9XuntgixbB+MbztIWOS3W+LgWMe3nb2uJNVyJaPNjrHXYZEJroZGVdXxC0WPYQQdKw/SKvV4tXX3sazWag8z2Nm5hpnz15kamqSarV2y/u7rrEma7TORH83Jd3HIC4+CTP9JEpJidddvd7E81w+9/gTvPjSq1ybvcHkxDjtdocXX3qVQ4f2oZRibn5hVX0elZJjM6WkXl3f+lR3ayJJWfTR9Ijcy0XvT+I/IWGhuojjOBy54yDHj9/Nt779fZTRvP6jd2m3Ozz66AOUSkWq1VocF73uf7dmTrpMd9+14dbqdZs7P0loWghqtQalUgGtNXfffYQwDPnmN1/k7NmLPPHEp8nlfMbGSjSbLaIouq0VeCZj/Tac6f3DBDHGQK1Wp1wuxYe1F/I8/vgjnDx5hgMH9nDo4D46nZByuUQYRvbgi9tZ5WvYfNPAEDqbnNTRS68H58aPRbvBCxApjav0AF3L4LpL4r4eqgcKw5BGo8n27duIIgUIqtUaUkoWF+u0rN+y7/sYYyy/46GUHjGmwW0POy8gSRSZXKs9a2BJB6R7vpn2L9bxMZ0r4ok2QKzuy8losn1Shx3+NCwAa/ihVAypB6MOtAJBGCra7Q5jYyWEECwsVHnzzfd48slHabXavP762/YMJR/Pc7tOVsPGNKrttHFxtdda695M+rAG42PGgqWgOQ396z3NRKZOjl1N3VHnCtnO0mq2iCJFpTKGlA6vv/4OR44c4FMPHWd8fIxvfvMldu7czrFjd1Isxoyv4zoopUZgmMFtj8IwUspu/Ztxmkl6/vuPN9ZmE1w0hxUNt/xAzJVeQggazRZCCMpjZU6dPsvMzCyfevh+Wu0OO3du58EH7+Httz9Aa8PYWInFWj3zzILb4bplpoE/LEWIWAeTz+dQSvHyy29w59FDXYkpDCMefOg+hBC8++6HTE1NUq83Mp3A/10qawqVHUgjbyPrrQDqtTpjY2Xeeut9pBA89OB9RGFkU69pPNfh/vuP8eqrbxGGIWEQosKwe4L97WitXq8taU0+vb19MT02lNSv4RrRDdT09vgcD2m72WwxP1/l0sUrPPXMZ/F9jzCMut8OwoiDB/dx6tR53n77A3zfp92Jkw4xJOE0t8gfhgGBj4PmbZOkpGwNIqugp11eJwXlWe/oHu1otuFzcN3hbUdKUa83uHLlKvcev5v9+/cShJF9x8SXjq3GTzz5GXzfp1pdpNlo9WQkHjq+zPujxszwMZu1jTtr7YZFlm4KD2NWKPKBzZDJaNF64Dcs2TBDTPYDyafRKKWo15vs27eb+44fIwiCzNw1UajIF3J85jOfQinNYq0e+5xoPXx8g/psT0JZ85i7mUpXPu6byfXeVAeqbnR6n510mXbU5nIxme+naolhiW8G59wS3ckb8G0hUZEiiiKiKKJRb1CpjBGGsSZXJlkWiIPdgk7IyY/PoJSKMYyQIPQQre8wo6vsSb+RaVEeMGbTM53Z417+7OZqptfP9C6zUaSJ8DDmkBHPh79jRtXXw+5DFEXxETcLi3z9a99h7sY8nut12xUGXMchCiO++53v8fHJ04yNlajXG2tve+ScjHqH0fOmB8zVEMXqpmt6b0eROghCxsbKPPfcE3Q6Ad/4xne5enUWz4vjqhxHopTilVde58yZ83z2s5/moYeOs7BQXXa67O1sTdoEDLMcSsUqmd5brsSySjvPc7nz6BF+4j94Hs/z+NrXvs3MzDVy+Rytdoevf/07nD59jue/+CwPPnQflfEKrVabThB2D/e6XZR2YgiPufHGx0wozc7JNpq8jSZ/q647ajIENBoNcrkcYRhRqZT5wvPP8J1vvcQf/MG/5TOPPcwHH5zg2tVZnnr6sxw6tJ92J6BQyKNUbH/ybKz1MJI9zDSwUpK/2rpZ8nJa2XELIh9XoUTY0It1Ke2ajSbFYgGMIQpCyqUSzz77BL7v8eK/fYWF+SpPP/M4d911B51OB6M1uZyPlJJWs2l9ks0tGPNqx61vKuNwC/1h1neU3LrOLjTQarUplQo9u9JxnfgMARMbTXN+bqmXxuB7Hr7v02q119Hz9Y7ZrK1av2Zxjd+6Kf4wCV8QqgilVPddZdN9iAFBNMqm+xhUgjDoGgqXW2YVUshMsTxJR+YMCIgPwoBGo4l0HFrttvW8q/PKD16n1W7z0KeOc+H8Zb797Rf53Oce5eChfYRhhOM4FAp56o0G7U7b+tCsru34lNzBh1sppWKmWogBaVeTNLQDUqD0WasRApelDBrLQmU33jTQ696AWcpQ6UinZ3HlCPcGOcK9QSkVZ+nOBBhncF27aFkZFGInpYhOJyCfz1Mo5Lly+SrffeFlBPDFLz7L+HiFQ4f28+ab7/HSSz8gjCKOHTsKGCqVMlGkrDQ1wLFrSPaG9JlMWX0TApSKz9BerXuDk5G9AQFCEesJWH5MNJvO9Aq6Pivx+chO3wQMBpjkUM+B9FJKHMcZMLlmKMAIITIXTUpJEIREUcTYWJmZmVle+O730Vrz3HNPsm1qkk67g+d5PPXUZ8HAKy+/BsADD97HWGWMhfkqjuNmZso0xmAGtD1q0ZcOPMWSxlV63CVHQfcBjNE6nisxLOZjA42P/VeS2Fj1eRXHeW0HU+1RDjzpk89WVdfWy9o9AkOz2UJKyczVa3z/pR/iOA6f/8LT7JzeTqcTxNGNURwB+dhnH6HVavP9772KMTA1NcnMzLWYdAyRkhghJYkRUpIeJCWZeE6HYq8+66NgaY3WKybdhDMfkwO2xCCL1yfqEkja7Q6tVpuXv/canufx7HNPsXPnDsIg6um7Vhrf93nmxz7H/v17+cHLr3HixCmiSMWZtm6VUmXVY47TmAkp1nvUwM3xh5FC3DZRgUJAo9FkcTFOFvT5zz/Njh3brB0pm4/K5XI8/czjHD5ykI9PnmFhfsGGnNwmEQTJCcCIZQeCbI6U1MfDJEfSOW4v/IkRTK8YwfQ6roMzgOkdWtcYxADG03FdqtVFtm/fxvNffI5CIU8URTiu29NvR/Xey+XzPPv5p9j+zge8984HtDsdJouFnpx+K2N6h/AhiW5HxP1cNQ+TxfRa4UJwi3iYtBN4wke4rkMQhLz2xntE3QyQS+efDrbpmqEx2UoppCMz3xlVN8lDt2xNpGDmylXyhQJvvfkOaoBorLTCdfqmx/IBnufyxutvUywW4uzn/SoPM2RRSXgYkUnuk5NMHMdZng1uWF2WEgSln0dKsXfXTh48dlfMVPdLSRueCTytfLFxSI4jiXTEyROn6ARhd7LECN5q1GEaiTbVrKnuYInRdR0WF2tcuTwzsG5y5HBWu47rsFitZTK9iXfBEKvE8DkZ0fao+ex/HoQBDoZHjt9j+cz1udzdHH8YAYV8ns8+/mic+jPJ8Jkk/BlEOTQDOX6AKAxxXTdbOTesbpJLd4hScFj9+OjhCC+VEXTFSuZRbZthCl+BVgqjNa7nLU8pZkYoixNsJ3tDfbaPj1vt9Qgt8GbwMEn/fd/j8OEDPYMZlnw5fm56khD3l3arjZ/PZdYfWtfmyh2kbR1VX2lN0O5QKBYGqgMGjUlbHmZQ29ryIXIADxMFIUop8oX8MiwztC7ZcUkGgWcPRhJCZLhs3gKm13EkRoj4eN70AJQeevyt1gY9BGCiKEKGzsBANj1C0zvsYM5h9ZMwEzeIsk+LMyPCf4e0PYrpVVFsXomd0U0GNzAkgC+D6TXG4HgujpPrkun1WKvXGDWQNg0saXQ1vS4NGoMwa1fc6Q1Q3K2kfpzePXYEz3rHmNGKt7Uq7nTqTMlBUpI2K1fcLZ35GEuyWX7Hm06SpBS3dXamP+xFCoF0xDKStBa/wXUr7hAgHYnrSjxH/jsfGfhJKwbIeW5sl5O3IpAtZR8QQtAOIpTW5Dyf8WKeTrXeDVbXxiAG0PvEXRA9WF8RKRWn+5BiAHM5QCNhTx1hgO/tqLaV0kSJm8Eg1C+y2+56AurVp/sAQaQ12radycPYumIYSbKHY2gMpXyOUt7DcSTNTmg3tBghbt10gDFdVHe9WuPDCzM8cd8dAOygzPXFBlGkU8fiDv7KsAPjHceNF1cP6MFQNsagtRg6guFte5ZxzQZ2sY62B6tADAKJtJbwrHeGjjs130JAOZ9jx0QJVzoorXnj1PnUIVtrY3vXddZAzNhLfv+19ziyZwd7to3jOJJi3qMdREOllJUhMnHrDjO4VW2LNa9lT/Fdh5zv4joS33X46g/f4+TFa/bcpzXr7VYNMEKnwjjjnSi5vljnV3/3Bf74Ew9x74HdFHM+pXxui4G4xdyL1oa5WoPvvHWC7771Ea7r9J0HucE8jIjVLrHiKtWS5zjMVmv8w6++yL7tk2yvlJFCrOnwg61ysxCkoB2EXJidZ6HRIuc6PXxOgmHERgKM7zqnpyuF3ZcWmriyF1oTzebF6/Ocuza3tWKfBKAhjt7Mee4yKmeINcK7x4sbBzDamF968uiuJ87eqDHfCPDd5VK5Y8W3rfIJIk4952zH+pd2EPHk0V0c2FZ+d8MARmnz21Ol3K/9qUeO/Ozvvn2OywvNNQpnW+XWAQ/4ruRzd+7iuXv2NrUxP7uhUlKg9H+7Z6I4/zOP3/XlD2cWClerzS0t722EaXzX4eh0hX2T5feUNn9eG/P9VZG51dgS3n7nve7fUoh7XEd8SSCObi3FbcXWtJQxL0RK/y7QAHjg/vs2BsOkg848KT9A8EHSi1Bpotskq4EQAldKXBmbMoI+K/tmlsQfOjnieDX1pBD2/IPNK6sCmGqrnTC/XFyoEtpIO20M+ybGOTQ5QceGXyQ2JUcIlM26lJ6gbpRe6jjfpfy2scoymcQEUNP+NYmLQXqi+53R05GAiZo/73mESnFhocqVao1y3ue+6Z04UhAotXRYuO1XbOLQ3fOTkrE41vIrUhGK8fPYRuOkrPeOBUyRAliAnOuw0GrTiSK2l0oAhNasolKHxCeHo+etj7EUgkYQsNBqs71URAhhN6vpOexcG5bqm6X7AtGzRhsGMP/1P//t2PMcw0KrbRcknsRtxSI/ce9d/NF77qbgu5RzObQxVFttthUL+F4sds8324RKsaNcItKaWruD7zpoYyj6HjcasciujWayUMCRkhuNJgbDjnKJVhhSawd4jqQVRkyV4nekEFRbHVphiGNPjt9eKqKM4XqjwVSpCAZeOn2Of/HWu3x07Tr1TvydzxzYy089dD93bN/GRCGPFIK5ZgtXSlphyEShQKAUjU6HbcUirhv3Kee6tIKQUs4n0pp2GDFZLFDwPa7XmxR9j7znMVtvMJ7PEag41qkTRYDgtQuX+I3X3qTaavPowX389EPH2V0ZI4gU20oF6p2AVhhS9nO4juSbH33MD89f5KG9u3nh1BnevXKNT+/fy09/Kq4ngKliEQPMNZsUPI+FdpuxXI6S76O0Zq7VIlKavOdSyeVYLX5aFQ+z/+f+8hJKtIuS3s3tSDFZyOO7DrsrY0Rac7m6yMP79vIT997Faxcu8+Lps7TDiB+78zBzzRYfXZul5Pt4jsOuSpk3L16h4Ht0IsWj+/cgRDyxAE8dOcSl6iJnbsxT9D3mmi0e3reHn3roPl45e4EXTp2l1ungOzEAPnH4IM0w5AdnL/C5wweYb7V4+ewFMLHqPMFU7SjCdxwmCgWevuMQY/kc3/jwJAXPo9pqs29inGYYcLXW4P7d00wU8rxy7gIThQLzzRZTpSKdKKLaanPvrp0cnprk2ydPc3Bygh3lEt87c447prZRDwI6UUTdBsvdaMQCgyMEnUhRyeeYKBRoRyH3Tu/kYrXKXLPFjlIJz5G8PzOLMkuYx5UOnSii6HuM5WLPxC/cfQdKa77z8Rm2F4tcqdXYPzHOT9x7Nz+6dIU3LlwmUIqJQp7psTLaGH7nL395YwDm0Jd/If2zAvx9YIf9/QvAjxL0F1ns40hJqFTsEW8MnnSQAjpRjHrTLhFKa3zH6brMJjvSt0rBIFI4UnTJgRSCUGk8xyFQEa7FNMmIgkghRFw/sKg+57qI2K3j54GfBH4D+HVjkwOESmFMrL1O3CEjSwodKQkjhcaQc5w4mYAlQzF5lYRaxdZ7140tz9qQcx3CJDGBJSkpnvBzwH7gN9MOY4HSuFIghUQZ3QXyVDkKPAv8ujbGJK4KgU2G4DsOShtcGfc/6aPnOJYk6S75mvmV/23jxOpUGQceAP66ZTouJvQVO7lLzPLyZop+hnavzw+20OdI7frZikJjDAVvucN2+v2+b/1d4Anb91NdRtgyw8OYfcdbGovT93//WN2eORiozbwXOA78pkz5P6f76yy1UAF+GvhHwG7gOeAfSSFM4uGdbjPRq2a17eDgORvM9C5rEy4A/zp17ylgEngM+GdAAfhjFhNdtu/8x8AdwN+yzx8HOkAJeAH4C8D7QAv4tgXGn7N1fxnYCdxjMdtR4O8LIebt8z9tgfhbtn9fB8aAf8/2MwA+A/wp4D7gRqrvPwPsA/42EAJfsGLnc3Ysh+yO/ofAeeB5+/yPAr8N7AIesWOdBZ6x45gD/gTwVeAY4ANfBF4Dfg94CTid6sefAaaB/wP49y1g/76dm1+0/XTt3HyFJce5/wrI2/Y18ONA2/b/K8AZoAz8N8BV4B+vSapbB8Bo28G9FtqlXez/wS7+t4A/CxwA/oat87PAf2Yn5M/bRf0K8H/Ze/8EuMu+8xu2jV+yAPKs/faUncDH7KL9Pfvt/xn4S8CCXbxfs316HPirQBKx9gzwQR+w/LxdiN3A/2Lv/Y/A/24B5bt28e6x/RXA37Hv+BYwnwCeBn7F1v8LFqB94FftRvoZ4P+xC/4bwBE7hr9u6/ySXdCGfWfKbsq/aTeKtBupDDxsMWXCDvwJ4I/Yd7Eb8m8B99t5Tfr8oN04Gy9W95UOcCfwmxaSf9J25DctJvjTdjd+aHegYwHoy3ZH/WPgn1rg+o/svb9mJ/EhW+eI3emfsgP/VeCbdrH/ogWiX7bA9mfsbjpp2/ordsEetLszAZjdwHwfpvyzFpg/BH5gFyCymOUfWIzxv9oF+4Elx9r2519ZYPoV4J/bC6CZarNh3/eA37IA/HngUfveIrDdztljCXm3pAfgSbsx/28LmL9kx9qxAPkzFmsq4HcsIBtb/3eAty2m/ZTFUr91KwAmD3wEfMl2rmW/l6DIup1036L4il2sX0y949vF+JHdMefs/dBO5F5LJv4VULQTlAdqKQzZsTzAIvBxIrTZb/4YcDfwtVS/m/YbSZmwQDtjAd6xGCqwC520Z+z4lP0/SjSlKYwgUkBiBmDlhdSGc1PjPW7J18XU+/+5Jen32u8VUyyTtH3YkZpHbZ9P2U1cs0AapbDO/wmcAN7ZbIDBdqSZoX5O/u9PKqEt+j1p61XswJOF8FLfTXb/dbv7kwU6npo0kXrf7Vukr1s0nWCFpLwL/Cep3/0HOSYLIezfWQkyTB9JH3S+e2S/bzLYgP5o36hvPZ60JPZ5y8MVbF3T14bKaFf39R8LbP/SboD/z5Lq+mbyMFhautvuyLxdSCeFPZLO5uzOesfS2WspQPPt8w8siXvMoutJi0pbFnXP2F0jbJ2k/yWLTRzgz1nU6wL/xn4rsHxAUn7Pfufv2t2pLTn8guVXZuxVSM2PnwKIpG0v9dxLPU+AvmWx2712frTtl9NX37Hz+CM7lv/U/n+/nacLlpk2dsNM2TEKO+fXgCsWmz5l+z6b6n/SZ2nrvWDndmKzmd66Hejv2938pBVRE5R71qJdbQdkLP/ytGWI/6QlI2ft+1eB/8nyDImEct3W+WvAN6xIOZeq0wQu2e/8rGWkv26lketWmnkho99fsovwXUv/vwz8l5YP+YVUnxdtv8+msMVZ+/xCCugv2Gcd2yaWqf0bll/5oQWMayn+6aLtS9Xeb1iG968Av27nVVgA71jAf8fO8f9rnyV9+UvAf2///+9sny+l2IIztv7ftHzZL/eRvk1R3AmL5pLdVbcAqO3kFe1ONhaDtFP1dttJiux7rRSqdS0/8xUr+iq7WyZtnUQ6a9pF8G39BJNN2Pf2WiB7fsjkTFsA71hGtmwnOuHRolT7SRvJ33m7CMnzTqoPybt7LYAHKRJr7PzkU6TXTc1PwV5zdm4SScmz9RxgmwU8L9XWNvv/XOo7Yap/Tfu9sp2fbjn7y7+4KTyMSTF9WSXN27T76l0e8N5D9vd/AfxBioFspSYmXUf13e9YTFW0IuRvj9hJV9O2VXtl9bmZ8Xe63UF/X+prTw34ftRXv5Vqq5nitZJvzGbU6/eLzZqvZgbPuXEYZqtslS3v262yBTBbZQtgtsoWwGyVLYDZKlsAs1W2Srr8/wMAUx2PePfgBCQAAAAASUVORK5CYII=')
SET IDENTITY_INSERT [dbo].[DIAGRAM_TEMPLATES] OFF

PRINT(N'Add rows to [dbo].[NEW_QUESTION_LEVELS]')
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52345, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52346, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52347, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52348, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52349, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52350, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52351, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52352, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52353, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52354, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52355, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52356, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52357, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52358, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52359, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52360, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52361, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52362, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52363, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52364, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52365, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52366, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52367, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52368, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52369, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52370, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52371, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52372, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52373, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52374, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52375, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52376, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52377, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52378, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52379, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52380, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52381, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52382, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52383, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52384, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52385, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52386, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52387, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52388, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52389, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52390, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52391, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52392, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52393, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52394, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52395, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52396, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52397, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52398, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52399, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52400, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52401, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52402, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52403, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52404, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52405, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52406, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52407, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52408, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52409, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52410, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52411, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52412, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52413, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52414, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52415, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52416, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52417, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52418, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52419, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52420, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52421, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52422, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52423, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52424, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52425, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52426, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52427, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52428, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52429, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52430, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52431, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52432, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52433, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52434, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52435, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52436, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52437, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52438, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52439, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52440, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52441, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52442, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52443, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52444, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52445, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52446, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52447, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52448, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52449, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52450, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52451, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52452, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52453, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52454, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52456, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52457, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52458, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52459, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52460, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52461, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52462, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52464, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52465, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52466, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52467, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52519, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52520, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52547, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52548, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52842, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52843, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52847, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52850, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52851, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52852, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52853, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52854, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52855, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52856, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52857, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52858, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52859, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52860, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52861, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52862, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52863, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52864, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52865, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52866, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52867, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52868, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52869, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52870, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52871, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 52872, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52345, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52346, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52347, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52348, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52349, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52350, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52351, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52352, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52353, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52354, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52355, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52356, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52357, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52358, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52359, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52360, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52361, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52362, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52363, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52364, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52365, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52366, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52367, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52368, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52369, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52370, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52371, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52372, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52373, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52374, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52375, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52376, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52377, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52378, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52379, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52380, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52381, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52382, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52383, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52384, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52385, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52386, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52387, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52388, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52389, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52390, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52391, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52392, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52393, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52394, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52395, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52396, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52397, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52398, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52399, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52400, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52401, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52402, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52403, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52404, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52405, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52406, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52407, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52408, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52409, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52410, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52411, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52412, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52413, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52414, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52415, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52416, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52417, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52418, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52419, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52420, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52421, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52422, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52423, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52424, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52425, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52426, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52427, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52428, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52429, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52430, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52431, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52432, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52433, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52434, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52435, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52436, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52437, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52438, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52439, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52440, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52441, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52442, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52443, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52444, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52445, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52446, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52447, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52448, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52449, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52450, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52451, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52452, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52453, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52454, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52461, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52462, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52547, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52548, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52842, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52847, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52852, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52853, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52854, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52855, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52856, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52857, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52858, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52859, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52860, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52861, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52862, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52863, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52864, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52869, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52870, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52871, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 52872, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52345, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52346, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52347, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52348, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52349, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52350, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52351, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52352, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52353, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52354, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52355, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52356, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52357, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52358, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52359, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52360, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52361, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52362, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52363, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52364, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52365, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52366, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52367, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52368, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52369, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52370, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52371, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52372, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52373, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52374, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52375, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52376, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52377, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52378, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52379, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52380, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52381, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52382, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52383, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52384, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52385, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52386, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52387, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52388, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52389, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52390, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52391, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52392, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52393, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52394, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52395, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52396, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52397, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52398, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52399, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52400, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52401, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52402, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52403, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52404, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52405, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52406, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52407, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52408, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52409, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52410, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52411, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52412, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52413, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52414, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52415, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52416, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52417, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52418, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52419, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52420, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52421, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52422, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52423, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52424, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52425, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52426, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52427, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52428, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52429, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52430, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52431, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52432, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52433, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52434, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52435, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52436, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52437, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52438, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52439, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52440, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52441, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52442, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52443, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52444, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52445, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52446, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52447, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52448, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52449, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52450, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52451, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52452, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52453, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52454, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52456, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52457, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52458, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52459, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52460, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52461, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52462, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52465, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52466, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52467, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52547, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52548, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52842, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52843, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52847, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52851, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52852, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52853, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52854, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52855, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52856, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52857, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52858, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52859, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52860, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52861, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52862, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52863, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52864, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52865, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52866, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52867, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52868, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52869, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52870, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52871, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 52872, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 51853, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52345, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52346, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52347, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52348, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52349, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52350, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52351, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52352, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52353, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52354, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52355, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52356, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52357, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52358, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52359, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52360, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52361, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52362, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52363, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52364, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52365, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52366, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52367, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52368, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52369, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52370, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52371, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52372, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52373, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52374, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52375, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52376, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52377, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52378, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52379, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52380, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52381, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52382, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52383, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52384, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52385, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52386, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52387, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52388, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52389, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52390, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52391, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52392, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52393, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52394, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52395, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52396, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52397, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52398, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52399, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52400, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52401, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52402, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52403, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52404, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52405, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52406, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52407, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52408, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52409, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52410, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52411, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52412, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52413, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52414, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52415, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52416, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52417, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52418, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52419, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52420, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52421, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52422, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52423, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52424, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52425, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52426, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52427, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52428, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52429, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52430, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52431, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52432, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52433, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52434, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52435, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52436, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52437, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52438, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52439, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52440, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52441, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52442, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52443, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52444, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52445, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52446, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52447, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52448, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52449, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52450, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52451, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52452, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52453, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52454, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52455, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52456, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52457, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52458, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52459, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52460, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52461, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52462, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52463, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52464, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52465, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52466, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52467, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52468, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52469, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52470, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52471, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52472, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52473, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52474, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52475, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52476, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52477, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52478, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52479, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52480, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52481, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52482, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52483, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52484, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52485, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52486, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52487, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52488, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52489, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52490, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52491, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52492, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52493, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52494, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52495, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52496, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52497, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52498, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52499, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52500, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52501, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52502, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52503, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52504, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52505, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52506, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52507, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52508, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52509, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52510, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52511, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52512, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52513, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52514, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52515, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52516, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52517, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52518, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52519, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52520, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52521, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52522, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52523, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52524, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52525, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52526, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52527, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52528, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52529, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52530, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52531, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52532, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52533, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52534, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52535, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52536, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52537, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52538, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52539, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52540, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52541, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52542, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52543, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52544, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52545, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52546, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52547, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52548, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52634, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52635, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52636, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52677, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52810, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52814, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52826, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52831, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52842, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52843, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52844, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52845, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52846, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52847, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52848, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52849, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52850, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52851, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52852, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52853, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52854, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52855, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52856, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52857, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52858, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52859, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52860, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52861, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52862, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52863, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52864, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52865, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52866, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52867, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52868, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52869, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52870, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52871, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 52872, NULL)
PRINT(N'Operation applied to 1959 rows out of 1959')

PRINT(N'Add rows to [dbo].[REQUIREMENT_LEVELS]')
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30073, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30074, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30075, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30076, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30078, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30079, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30080, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30081, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30082, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30083, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30084, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30085, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30086, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30087, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30088, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30089, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30090, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30091, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30092, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30093, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30094, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30095, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30096, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30097, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30098, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30099, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30100, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30101, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30102, 'VH', 'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (30103, 'VH', 'NST', NULL)
PRINT(N'Operation applied to 30 rows out of 30')

PRINT(N'Add constraints to [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_LEVELS]')

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
COMMIT TRANSACTION
GO
