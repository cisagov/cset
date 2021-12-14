/*
Run this script on:

        (localdb)\MSSQLLocalDB.NCUAWeb10314    -  This database will be modified

to synchronize it with:

        sql19dev1.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.5.22.19589 from Red Gate Software Ltd at 12/14/2021 7:41:08 AM

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
PRINT N'Dropping foreign keys from [HangFire].[JobParameter]'
GO
ALTER TABLE [HangFire].[JobParameter] DROP CONSTRAINT [FK_HangFire_JobParameter_Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [HangFire].[State]'
GO
ALTER TABLE [HangFire].[State] DROP CONSTRAINT [FK_HangFire_State_Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[AggregatedCounter]'
GO
ALTER TABLE [HangFire].[AggregatedCounter] DROP CONSTRAINT [PK_HangFire_CounterAggregated]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Counter]'
GO
ALTER TABLE [HangFire].[Counter] DROP CONSTRAINT [PK_HangFire_Counter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Hash]'
GO
ALTER TABLE [HangFire].[Hash] DROP CONSTRAINT [PK_HangFire_Hash]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[JobParameter]'
GO
ALTER TABLE [HangFire].[JobParameter] DROP CONSTRAINT [PK_HangFire_JobParameter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[JobQueue]'
GO
ALTER TABLE [HangFire].[JobQueue] DROP CONSTRAINT [PK_HangFire_JobQueue]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Job]'
GO
ALTER TABLE [HangFire].[Job] DROP CONSTRAINT [PK_HangFire_Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[List]'
GO
ALTER TABLE [HangFire].[List] DROP CONSTRAINT [PK_HangFire_List]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Schema]'
GO
ALTER TABLE [HangFire].[Schema] DROP CONSTRAINT [PK_HangFire_Schema]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Server]'
GO
ALTER TABLE [HangFire].[Server] DROP CONSTRAINT [PK_HangFire_Server]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[Set]'
GO
ALTER TABLE [HangFire].[Set] DROP CONSTRAINT [PK_HangFire_Set]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [HangFire].[State]'
GO
ALTER TABLE [HangFire].[State] DROP CONSTRAINT [PK_HangFire_State]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [UX_HangFire_CounterAggregated_Key] from [HangFire].[AggregatedCounter]'
GO
DROP INDEX [UX_HangFire_CounterAggregated_Key] ON [HangFire].[AggregatedCounter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Counter_Key] from [HangFire].[Counter]'
GO
DROP INDEX [IX_HangFire_Counter_Key] ON [HangFire].[Counter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Hash_ExpireAt] from [HangFire].[Hash]'
GO
DROP INDEX [IX_HangFire_Hash_ExpireAt] ON [HangFire].[Hash]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Hash_Key] from [HangFire].[Hash]'
GO
DROP INDEX [IX_HangFire_Hash_Key] ON [HangFire].[Hash]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [UX_HangFire_Hash_Key_Field] from [HangFire].[Hash]'
GO
DROP INDEX [UX_HangFire_Hash_Key_Field] ON [HangFire].[Hash]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_JobParameter_JobIdAndName] from [HangFire].[JobParameter]'
GO
DROP INDEX [IX_HangFire_JobParameter_JobIdAndName] ON [HangFire].[JobParameter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_JobQueue_QueueAndFetchedAt] from [HangFire].[JobQueue]'
GO
DROP INDEX [IX_HangFire_JobQueue_QueueAndFetchedAt] ON [HangFire].[JobQueue]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Job_ExpireAt] from [HangFire].[Job]'
GO
DROP INDEX [IX_HangFire_Job_ExpireAt] ON [HangFire].[Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Job_StateName] from [HangFire].[Job]'
GO
DROP INDEX [IX_HangFire_Job_StateName] ON [HangFire].[Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_List_ExpireAt] from [HangFire].[List]'
GO
DROP INDEX [IX_HangFire_List_ExpireAt] ON [HangFire].[List]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_List_Key] from [HangFire].[List]'
GO
DROP INDEX [IX_HangFire_List_Key] ON [HangFire].[List]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Set_ExpireAt] from [HangFire].[Set]'
GO
DROP INDEX [IX_HangFire_Set_ExpireAt] ON [HangFire].[Set]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_Set_Key] from [HangFire].[Set]'
GO
DROP INDEX [IX_HangFire_Set_Key] ON [HangFire].[Set]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [UX_HangFire_Set_KeyAndValue] from [HangFire].[Set]'
GO
DROP INDEX [UX_HangFire_Set_KeyAndValue] ON [HangFire].[Set]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_HangFire_State_JobId] from [HangFire].[State]'
GO
DROP INDEX [IX_HangFire_State_JobId] ON [HangFire].[State]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_Parameters] from [dbo].[PARAMETERS]'
GO
DROP INDEX [IX_Parameters] ON [dbo].[PARAMETERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Set]'
GO
DROP TABLE [HangFire].[Set]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Server]'
GO
DROP TABLE [HangFire].[Server]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Schema]'
GO
DROP TABLE [HangFire].[Schema]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[List]'
GO
DROP TABLE [HangFire].[List]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[JobQueue]'
GO
DROP TABLE [HangFire].[JobQueue]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Hash]'
GO
DROP TABLE [HangFire].[Hash]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Counter]'
GO
DROP TABLE [HangFire].[Counter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[AggregatedCounter]'
GO
DROP TABLE [HangFire].[AggregatedCounter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[State]'
GO
DROP TABLE [HangFire].[State]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[JobParameter]'
GO
DROP TABLE [HangFire].[JobParameter]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [HangFire].[Job]'
GO
DROP TABLE [HangFire].[Job]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[PARAMETERS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[PARAMETERS] ALTER COLUMN [Parameter_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_Parameters] on [dbo].[PARAMETERS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameters] ON [dbo].[PARAMETERS] ([Parameter_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CyOTE]'
GO
CREATE TABLE [dbo].[CyOTE]
(
[Mat_Question_ID] [int] NOT NULL,
[Answer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mat_Question_ID_Child] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CyOTE] on [dbo].[CyOTE]'
GO
ALTER TABLE [dbo].[CyOTE] ADD CONSTRAINT [PK_CyOTE] PRIMARY KEY CLUSTERED ([Mat_Question_ID], [Answer], [Mat_Question_ID_Child])
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
PRINT N'Creating [dbo].[MATURITY_EXTRA]'
GO
CREATE TABLE [dbo].[MATURITY_EXTRA]
(
[Maturity_Question_Id] [int] NOT NULL,
[NIST171_Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_text] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPRSValue] [int] NULL,
[Comment for Guidance Field] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMMC1_Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMMC2_Title] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_EXTRA] on [dbo].[MATURITY_EXTRA]'
GO
ALTER TABLE [dbo].[MATURITY_EXTRA] ADD CONSTRAINT [PK_MATURITY_EXTRA] PRIMARY KEY CLUSTERED ([Maturity_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GenerateSPRSScore]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 11/17/2021
-- Description:	generate scores for SPRS
-- =============================================
CREATE PROCEDURE [dbo].[usp_GenerateSPRSScore]
	-- Add the parameters for the stored procedure here
	@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;	
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	select sum(Score) +110 as SPRS_SCORE from (
	SELECT Mat_Question_Id,answer_text,e.CMMC1_Title,  case answer_text when 'Y' then 0 when 'NA' then 0 else -1*e.SPRSValue end as Score from Answer_Maturity a join MATURITY_QUESTIONS m on a.Question_Or_Requirement_Id=m.Mat_Question_Id
	join MATURITY_EXTRA e on m.Mat_Question_Id=e.Maturity_Question_Id
	where m.Maturity_Model_Id = 6 and Assessment_Id = @assessment_id) A

END
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
PRINT N'Creating primary key [PK_INSTALLATION] on [dbo].[INSTALLATION]'
GO
ALTER TABLE [dbo].[INSTALLATION] ADD CONSTRAINT [PK_INSTALLATION] PRIMARY KEY CLUSTERED ([Installation_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CyOTE]'
GO
ALTER TABLE [dbo].[CyOTE] ADD CONSTRAINT [FK_CyOTE_ANSWER_LOOKUP] FOREIGN KEY ([Answer]) REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Enabling constraints on [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping schemas'
GO
DROP SCHEMA [HangFire]
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
