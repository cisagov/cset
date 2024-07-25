/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12240    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12250

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 7/25/2024 11:25:12 AM

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
PRINT N'Dropping foreign keys from [dbo].[MQ_BONUS]'
GO
ALTER TABLE [dbo].[MQ_BONUS] DROP CONSTRAINT [FK_mq_bonus_mat_model]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MQ_BONUS] DROP CONSTRAINT [FK_mq_bonus_mat_q]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MQ_BONUS] DROP CONSTRAINT [FK_mq_bonus_mat_q1]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[MQ_BONUS]'
GO
ALTER TABLE [dbo].[MQ_BONUS] DROP CONSTRAINT [PK_MQ_APPEND]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[INTERNATIONALIZATION_VALUES]'
GO
DROP TABLE [dbo].[INTERNATIONALIZATION_VALUES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[MQ_BONUS]'
GO
DROP TABLE [dbo].[MQ_BONUS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetAnswerDistribGroupings]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 15 November 2022
-- Description:	Tallies answer counts for all maturity groupings
--              at the top level.  
--              TODO:  What if we want to target the children of a 
--              specific grouping?  g.Parent_Id = X
-- =============================================
ALTER PROCEDURE [dbo].[GetAnswerDistribGroupings] 
	@assessmentId int,
	@modelId int = null
AS
BEGIN
	SET NOCOUNT ON;
	exec FillEmptyMaturityQuestionsForAnalysis @assessmentId

	-- get the main model ID for the assessment
	declare @maturityModelId int = (select model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId)

	-- if the caller specified a model ID, use that instead
	if @modelId is not null 
	BEGIN
		select @maturityModelId = @modelId
	END

	select [grouping_id], [title], [answer_text], count(answer_text) as [answer_count]
	from (
		select g.grouping_id, g.title, g.sequence, a.Answer_Text
		from maturity_groupings g 
		left join maturity_questions q on q.grouping_id = g.Grouping_Id
		left join ANSWER a on a.Question_Or_Requirement_Id = q.Mat_Question_Id
		where a.Assessment_Id = @assessmentId and g.Parent_Id is null and 
		g.maturitY_model_id = @maturityModelId
	) N
	group by n.answer_text, n.grouping_id, n.title, n.Sequence
	order by n.Sequence
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillAll]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FillAll]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	exec FillEmptyQuestionsForAnalysis @assessment_id
END
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
