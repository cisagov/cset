/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12100    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12110

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 11/29/2023 8:59:59 AM

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
PRINT N'Dropping constraints from [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DETAIL_FILTER_DATA] DROP CONSTRAINT [PK_ASSESSMENT_DETAIL_FILTER_DATA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ACCESS_KEY]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ACCESS_KEY] ADD
[Lang] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ACCESS_KEY_Lang] DEFAULT ('en')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENT_DETAIL_FILTER_DATA] ALTER COLUMN [Charter] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_DETAIL_FILTER_DATA] on [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DETAIL_FILTER_DATA] ADD CONSTRAINT [PK_ASSESSMENT_DETAIL_FILTER_DATA] PRIMARY KEY CLUSTERED ([Charter])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_Completion_For_Access_Key]'
GO




ALTER PROCEDURE [dbo].[usp_Assessments_Completion_For_Access_Key]
@accessKey varchar(20)
AS
BEGIN
	SET NOCOUNT ON;

	--This procedure returns the number of answers and total number of available standard, maturity, and diagram questions
	--	available for each of the user's assessments.

	--Creating table variables
	declare @AssessmentCompletedQuestions table(AssessmentId INT, CompletedCount INT)
	declare @AssessmentTotalMaturityQuestionsCount table(AssessmentId INT, TotalMaturityQuestionsCount INT)
	declare @AssessmentTotalStandardQuestionsCount table(AssessmentId INT, TotalStandardQuestionsCount INT)
	declare @AssessmentTotalDiagramQuestionsCount table(AssessmentId INT, TotalDiagramQuestionsCount INT)

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseMaturity = 1 and mm.Maturity_Level_Usage_Type = 'Static'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and mm.Maturity_Level_Usage_Type = 'User_Selected'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

    
	-- special case for ISE
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id and asl.Level_Name = 'Maturity_Level'
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


	-- special case for VADR
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestionsForVadr
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseMaturity = 1 and amm.model_id = 7
			and mq.Parent_Question_Id is null


	select a.Assessment_Id, q.question_Id into #AvailableQuestionBasedStandard
		from NEW_QUESTION q
			join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
			join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
			join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
			join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
			join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
			join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseStandard = 1 and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level


	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseStandard = 1 and rl.Standard_Level = usl.Universal_Sal_Level


	select a.Assessment_Id, q.Question_Id into #AvailableDiagramQuestions
		from STANDARD_SELECTION ss
			join 
			(select q.question_id, adc.assessment_id
				from ASSESSMENT_DIAGRAM_COMPONENTS adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id = nq.question_id		
				join new_question_sets qs on nq.question_id = qs.question_id	
				join DIAGRAM_CONTAINER l on adc.Layer_id = l.Container_Id
				left join DIAGRAM_CONTAINER z on adc.Zone_Id = z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
				where l.visible = 1) f on ss.assessment_id = f.assessment_id							
			join NEW_QUESTION q on f.Question_Id = q.Question_Id 
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
			join Answer_Components ac on f.Question_Id = ac.Question_Or_Requirement_Id and f.assessment_id = ac.assessment_id
			join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(DISTINCT(ans.Answer_Id))
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where ans.Answer_Text != 'U' 
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions amq
												where amq.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableQuestionBasedStandard aqbs
												where aqbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard arbs
												where arbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions ads
												where ads.Assessment_Id = a.Assessment_Id)
			OR
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse amqi
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amqi.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level = ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForVadr amqv 
												where amqv.Assessment_Id = a.Assessment_Id))
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = 0
		from ASSESSMENTS a
		join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
		WHERE a.Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
		

	--Maturity questions count (For maturity models with level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsWithLevels
		group by Assessment_Id


	--Total Maturity questions count (for maturity models without level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestions
		group by Assessment_Id


	--Total Maturity questions count for ISE available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForIse
		group by Assessment_Id
	

	--Total Maturity questions count for VADR available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForVadr
		group by Assessment_Id


	--Requirements based questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Requirement_Id))
		from #AvailableRequirementBasedStandard
		group by Assessment_Id


	--Questions based standards questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Question_Id))
		from #AvailableQuestionBasedStandard
		group by Assessment_Id
	

		--Total diagram questions count
	insert into @AssessmentTotalDiagramQuestionsCount
	select                  
		AssessmentId = a.Assessment_Id,
		TotalDiagramQuestionsCount = COUNT(ans.Answer_Id)
		from ANSWER ans
			join ASSESSMENTS a on a.Assessment_Id = ans.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseDiagram = 1 and ans.Question_Type = 'Component'
			group by a.Assessment_Id
	
	select
		AssessmentId = acq.AssessmentId,
		CompletedCount = acq.CompletedCount,
		TotalMaturityQuestionsCount = atmq.TotalMaturityQuestionsCount,
		TotalStandardQuestionsCount = atsq.TotalStandardQuestionsCount,
		TotalDiagramQuestionsCount = atdq.TotalDiagramQuestionsCount
		from @AssessmentCompletedQuestions acq
			full join @AssessmentTotalMaturityQuestionsCount atmq on atmq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalStandardQuestionsCount atsq on atsq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalDiagramQuestionsCount atdq on atdq.AssessmentId = acq.AssessmentId
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
