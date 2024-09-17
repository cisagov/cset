/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12260    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12261

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 8/30/2024 9:54:35 AM

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
IF OBJECT_ID('[dbo].[usp_GetMaturityAnswerTotals]') IS NOT NULL
BEGIN
DROP PROCEDURE [dbo].[usp_GetMaturityAnswerTotals]
END
PRINT N'Creating [dbo].[usp_GetMaturityAnswerTotals]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 27 AUG 2024
-- Description:	Flexible answer count/percentages for maturity models that have their own 
--              answer options other than Y, N, NA, etc.
--
--              A model ID can be supplied (for querying SSG answers), or if not supplied,
--              the assigned model ID is used.
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMaturityAnswerTotals]
	@assessment_id int,
	@model_id int = null
AS
BEGIN
	-- Get the assigned maturity model ID if a model was not specified in the arguments
	if @model_id is null begin
	  set @model_id = (select model_id from AVAILABLE_MATURITY_MODELS where assessment_id = @assessment_id)
	end

	-- Create all missing answer rows
	exec [FillEmptyMaturityQuestionsForAnalysis] @assessment_id


	select *
	into #answers
	from answer
	where question_type = 'maturity' and Question_Or_Requirement_Id in (select mat_question_id from maturity_questions where maturity_model_id = @model_id)

	select [Answer_Text], 
		isnull(qc, 0) as [QC], 
		isnull(m.Total, 0) as [Total], 
		isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int), 0) as [Percent]
	from  (
		SELECT a.Answer_Text, count(a.question_or_requirement_id) qc, SUM(count(a.question_or_requirement_id)) OVER() AS [Total]
		FROM #answers a 				
		where a.Assessment_Id = @assessment_id
		group by a.Answer_Text
	) m 
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
