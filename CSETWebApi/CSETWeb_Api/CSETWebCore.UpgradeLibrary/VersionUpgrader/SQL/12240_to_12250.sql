/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12240    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12250

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 8/15/2024 2:00:51 PM

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
PRINT N'Dropping foreign keys from [dbo].[MATURITY_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] DROP CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] DROP CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
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
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] DROP CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] DROP CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] DROP CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] DROP CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] DROP CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] DROP CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] DROP CONSTRAINT [PK_MATURITY_REFERENCES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[MATURITY_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] DROP CONSTRAINT [PK_MATURITY_SOURCE_FILES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[MQ_BONUS]'
GO
ALTER TABLE [dbo].[MQ_BONUS] DROP CONSTRAINT [PK_MQ_APPEND]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] DROP CONSTRAINT [PK_REQUIREMENT_REFERENCES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] DROP CONSTRAINT [PK_REQUIREMENT_SOURCE_FILES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[INTERNATIONALIZATION_VALUES]'
GO
DROP TABLE [dbo].[INTERNATIONALIZATION_VALUES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
DROP TABLE [dbo].[REQUIREMENT_SOURCE_FILES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[MQ_BONUS]'
GO
DROP TABLE [dbo].[MQ_BONUS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[MATURITY_SOURCE_FILES]'
GO
DROP TABLE [dbo].[MATURITY_SOURCE_FILES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_REFERENCES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD
[Source] [bit] NOT NULL CONSTRAINT [DF__MATURITY___Sourc__25276EE5] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_REFERENCES] on [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD CONSTRAINT [PK_MATURITY_REFERENCES] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Source])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[REQUIREMENT_REFERENCES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] ADD
[Source] [bit] NOT NULL CONSTRAINT [DF__REQUIREME__Sourc__7F01C5FD] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_REFERENCES] on [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] ADD CONSTRAINT [PK_REQUIREMENT_REFERENCES] PRIMARY KEY CLUSTERED ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref])
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
PRINT N'Creating [dbo].[GetMaturityComparisonBestToWorst]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	NOTE that this needs to be changed
-- to allow for mulitple asssessments just by 
-- passing mulitple id's 
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityComparisonBestToWorst]	
@assessment_id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@ApplicationMode = 'Questions Based')
		SELECT assessment_id,
		AssessmentName = Alias,                
		Name = Question_Group_Heading,
		AlternateCount = [A],
		AlternateValue = Round(((cast(([A]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NaCount = [NA],
		NaValue = Round(((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100),2),
		NoCount = [N],
		NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		TotalCount = Total,
		TotalValue = Total,
		UnansweredCount = [U],
		UnansweredValue = Round(cast([U] as float)/Total*100,2),
		YesCount = [Y],
		YesValue =  Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value = Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.assessment_id, f.Alias, b.Question_Group_Heading, b.Answer_Text, isnull(c.Value,0) as Value, Total = sum(c.Value) over(partition by b.assessment_id,b.question_group_heading)
			from 
			 (select distinct Assessment_Id, Question_Group_Heading, l.answer_Text
			from answer_lookup l, (select * from Answer_Maturity where assessment_id = @assessment_id) a 
			join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQuestion_Headings h on q.Heading_Pair_Id = h.heading_pair_id
			) b left join 
			(select Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Maturity where assessment_id = @assessment_id) a 
				join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
				join vQuestion_Headings h on q.Heading_Pair_Id = h.heading_pair_id
			 group by Assessment_Id, Question_Group_Heading, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Question_Group_Heading = c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p
		PIVOT
		(
			sum(value)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
	else-----------------------------------------requirements and framework side
		SELECT Assessment_Id,
		AssessmentName = Alias,                
		Name = Question_Group_Heading,
		AlternateCount = [A],
		AlternateValue = Round(((cast(([A]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NaCount = [NA],
		NaValue = Round(((cast(([NA]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NoCount = [N],
		NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		TotalCount = Total,
		TotalValue = Total,
		UnansweredCount = [U],
		UnansweredValue = Round(cast([U] as float)/Total*100,2),
		YesCount = [Y],
		YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value = Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id, f.Alias, b.Question_Group_Heading, b.Answer_Text, isnull(c.Value,0) as Value, Total = sum(c.Value) over(partition by b.Assessment_Id, b.question_group_heading)			
			from 
			 (select distinct a.[Assessment_Id], h.Question_Group_Heading, l.answer_Text
			from answer_lookup l, (select * from Answer_Maturity where assessment_id = @assessment_id) a 
			join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id
			join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id = h.Question_Group_Heading_Id
			) b left join 
			(select a.Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Maturity where assessment_id = @assessment_id) a 
				join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id
				join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id = h.Question_Group_Heading_Id
			 group by Assessment_Id, Question_Group_Heading, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Question_Group_Heading = c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p
		PIVOT
		(
			sum(value)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getMaturitySummaryOverall]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMaturitySummaryOverall]
	@assessment_id int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select *
into #answers
from answer
where question_type = 'maturity' and Question_Or_Requirement_Id in (select mat_question_id from maturity_questions where maturity_model_id = 5)
	select a.Answer_Full_Name,a.Answer_Text, isnull(m.qc,0) qc,isnull(m.Total,0) Total, isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0)  as [Percent]
	from ANSWER_LOOKUP a left join (
	SELECT a.Answer_Text, isnull(count(a.question_or_requirement_id),0) qc, SUM(count(a.question_or_requirement_id)) OVER() AS Total
			FROM #answers a 				
			where a.Assessment_Id = @assessment_id
			group by a.Answer_Text
	) m on a.Answer_Text = m.Answer_Text

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
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
