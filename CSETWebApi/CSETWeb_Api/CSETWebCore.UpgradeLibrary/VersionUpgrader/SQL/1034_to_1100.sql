/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb11000

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.5.22.19589 from Red Gate Software Ltd at 11/8/2021 2:38:03 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[DEMOGRAPHICS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD
[CriticalService] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[INFORMATION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[INFORMATION] ADD
[Workflow] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CONFIDENTIAL_TYPE]'
GO
CREATE TABLE [dbo].[CONFIDENTIAL_TYPE]
(
[ConfidentialTypeId] [int] NOT NULL IDENTITY(1, 1),
[ConfidentialTypeKey] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfidentialTypeOrder] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CONFIDENTIAL_TYPE] on [dbo].[CONFIDENTIAL_TYPE]'
GO
ALTER TABLE [dbo].[CONFIDENTIAL_TYPE] ADD CONSTRAINT [PK_CONFIDENTIAL_TYPE] PRIMARY KEY CLUSTERED ([ConfidentialTypeId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
CREATE TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT]
(
[Requirement_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Reference_Text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_REFERENCE_TEXT] on [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] ADD CONSTRAINT [PK_REQUIREMENT_REFERENCE_TEXT] PRIMARY KEY CLUSTERED ([Requirement_Id], [Sequence])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[maturity_groupings_rkw_backup]'
GO
CREATE TABLE [dbo].[maturity_groupings_rkw_backup]
(
[Grouping_Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Model_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Parent_Id] [int] NULL,
[Group_Level] [int] NULL,
[Type_Id] [int] NOT NULL,
[Title_Id] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Abbreviation] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[maturity_questions_rkw_backup]'
GO
CREATE TABLE [dbo].[maturity_questions_rkw_backup]
(
[Mat_Question_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Supplemental_Info] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Text_Hash] [varbinary] (20) NULL,
[Maturity_Model_Id] [int] NOT NULL,
[Parent_Question_Id] [int] NULL,
[Ranking] [int] NULL,
[Grouping_Id] [int] NULL,
[Examination_Approach] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_INSTALLATION] on [dbo].[INSTALLATION]'
GO
ALTER TABLE [dbo].[INSTALLATION] ADD CONSTRAINT [PK_INSTALLATION] PRIMARY KEY CLUSTERED ([Installation_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
