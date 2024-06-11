/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12200    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12210

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/11/2024 10:54:10 AM

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
PRINT N'Dropping foreign keys from [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] DROP CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ACCESS_KEY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] DROP CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_QUESTIONS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD
[Outcome] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_Practice] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MQ_BONUS]'
GO
CREATE TABLE [dbo].[MQ_BONUS]
(
[BaseQuestionId] [int] NOT NULL,
[BonusQuestionId] [int] NOT NULL,
[ModelId] [int] NOT NULL,
[Action] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MQ_APPEND] on [dbo].[MQ_BONUS]'
GO
ALTER TABLE [dbo].[MQ_BONUS] ADD CONSTRAINT [PK_MQ_APPEND] PRIMARY KEY CLUSTERED ([BaseQuestionId], [BonusQuestionId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[func_MQ]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all MATURITY_QUESTIONS rows applicable for an assessment.
--              If the assessment is using a "sub model", only the questions in the
--              sub model are returned.  Otherwise, all questions for the assessment's
--              model are returned.
-- =============================================
ALTER FUNCTION [dbo].[func_MQ]
(
	@assessmentId int
)
RETURNS 
@MQ TABLE 
(
	[Mat_Question_Id] [int] NOT NULL,
	[Question_Title] [nvarchar](250) NULL,
	[Question_Text] [nvarchar](max) NOT NULL,
	[Supplemental_Info] [nvarchar](max) NULL,
	[Category] [nvarchar](250) NULL,
	[Sub_Category] [nvarchar](250) NULL,
	[Maturity_Level_Id] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[Text_Hash]  [varbinary](20),
	[Maturity_Model_Id] [int] NOT NULL,
	[Parent_Question_Id] [int] NULL,
	[Ranking] [int] NULL,
	[Grouping_Id] [int] NULL,
	[Examination_Approach] [nvarchar](max) NULL,
	[Short_Name] [nvarchar](80) NULL,
	[Mat_Question_Type] [nvarchar](50) NULL,
	[Parent_Option_Id] [int] NULL,
	[Supplemental_Fact] [nvarchar](max) NULL,
	[Scope] [nvarchar](250) NULL,
	[Recommend_Action] [nvarchar](max) NULL,
	[Risk_Addressed] [nvarchar](max) NULL,
	[Services] [nvarchar](max) NULL,
	[Outcome] nvarchar(max) null,
	[Security_Practice] nvarchar(max) null
)
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
	end
	else
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
		and mat_question_id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end
	
	RETURN 
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ACCESS_KEY] FOREIGN KEY ([AccessKey]) REFERENCES [dbo].[ACCESS_KEY] ([AccessKey]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MQ_BONUS]'
GO
ALTER TABLE [dbo].[MQ_BONUS] ADD CONSTRAINT [FK_mq_bonus_mat_model] FOREIGN KEY ([ModelId]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
ALTER TABLE [dbo].[MQ_BONUS] ADD CONSTRAINT [FK_mq_bonus_mat_q] FOREIGN KEY ([BonusQuestionId]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
ALTER TABLE [dbo].[MQ_BONUS] ADD CONSTRAINT [FK_mq_bonus_mat_q1] FOREIGN KEY ([BaseQuestionId]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
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
