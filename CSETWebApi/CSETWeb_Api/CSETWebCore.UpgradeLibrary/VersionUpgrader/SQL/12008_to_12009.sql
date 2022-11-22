/*
Run this script on:

        (localdb)\MSSQLLocalDB.NCUAWeb12008    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.NCUAWeb12009

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/18/2022 7:38:42 AM

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
PRINT N'Dropping foreign keys from [dbo].[ASSESSMENT_IRP]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP] DROP CONSTRAINT [FK__Assessmen__IRP_I__5EDF0F2E]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ACCESS_KEY]'
GO
CREATE TABLE [dbo].[ACCESS_KEY]
(
[AccessKey] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GeneratedDate] [datetime2] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ACCESS_KEY] on [dbo].[ACCESS_KEY]'
GO
ALTER TABLE [dbo].[ACCESS_KEY] ADD CONSTRAINT [PK_ACCESS_KEY] PRIMARY KEY CLUSTERED ([AccessKey])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
CREATE TABLE [dbo].[ACCESS_KEY_ASSESSMENT]
(
[AccessKey] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assessment_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ACCESS_KEY_ASSESSMENT] on [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [PK_ACCESS_KEY_ASSESSMENT] PRIMARY KEY CLUSTERED ([AccessKey], [Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[DEMOGRAPHIC_ANSWERS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] ADD
[cyberRiskService] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTION_PROPS]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTION_PROPS]
(
[Mat_Question_Id] [int] NOT NULL,
[PropertyName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PropertyValue] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_QUESTION_PROPS] on [dbo].[MATURITY_QUESTION_PROPS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] ADD CONSTRAINT [PK_MATURITY_QUESTION_PROPS] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [PropertyName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_Completion_For_User]'
GO

ALTER PROCEDURE [dbo].[usp_Assessments_Completion_For_User]
@User_Id int
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

	-- I don't like hardcoding in these model ids, but we have to manually declare which models utilize user selected levels to 
	-- filter questions since some maturity models default to ML 1, but also have questions above that level.
	declare @MaturityModelsWithLevels table(ModelId INT)
	declare @MaturityModelsWithoutLevels table (ModelId INT)
	insert into @MaturityModelsWithLevels values (1), (2), (6), (7), (9)
	insert into @MaturityModelsWithoutLevels values (3), (4), (8), (5), (11)

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	IF OBJECT_ID('tempdb..#AvailableMatQuestions') IS NOT NULL drop table #availableMatQuestions
	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseMaturity = 1 and amm.model_id in (select ModelId from @MaturityModelsWithoutLevels)
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	IF OBJECT_ID('tempdb..#AvailableMatQuestionsWithLevels') IS NOT NULL drop table #AvailableMatQuestionsWithLevels
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where u.UserId = @User_Id and a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and amm.model_id in (select ModelId from @MaturityModelsWithLevels)
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

    
	-- special case for ISE
	IF OBJECT_ID('tempdb..#AvailableMatQuestionsForIse') IS NOT NULL drop table #AvailableMatQuestionsForIse
		select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse	
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id and asl.Level_Name = 'Maturity_Level'
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where u.UserId = @User_Id and a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	IF OBJECT_ID('tempdb..#AvailableQuestionBasedStandard') IS NOT NULL drop table #AvailableQuestionBasedStandard		
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
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseStandard = 1 and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level

	IF OBJECT_ID('tempdb..#AvailableRequirementBasedStandard') IS NOT NULL drop table #AvailableRequirementBasedStandard		
	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseStandard = 1 and rl.Standard_Level = usl.Universal_Sal_Level

	IF OBJECT_ID('tempdb..#AvailableDiagramQuestions') IS NOT NULL drop table #AvailableDiagramQuestions		
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
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(ans.Answer_Id)
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and ans.Answer_Text != 'U' 
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableQuestionBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions)
			OR
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse amq
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amq.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level = ml.Level)
			)
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = Assessment_Id,
		CompletedCount = 0
		from ASSESSMENTS where Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
		and 
		AssessmentCreatorId = @User_Id
	

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
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseDiagram = 1 and ans.Question_Type = 'Component'
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
PRINT N'Creating [dbo].[usp_Assessments_Completion_For_Access_Key]'
GO

CREATE PROCEDURE [dbo].[usp_Assessments_Completion_For_Access_Key]
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

	-- I don't like hardcoding in these model ids, but we have to manually declare which models utilize user selected levels to 
	-- filter questions since some maturity models default to ML 1, but also have questions above that level.
	declare @MaturityModelsWithLevels table(ModelId INT)
	declare @MaturityModelsWithoutLevels table (ModelId INT)
	insert into @MaturityModelsWithLevels values (1), (2), (6), (7), (9)
	insert into @MaturityModelsWithoutLevels values (3), (4), (8), (5), (11)

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseMaturity = 1 and amm.model_id in (select ModelId from @MaturityModelsWithoutLevels)
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and amm.model_id in (select ModelId from @MaturityModelsWithLevels)
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

    
	-- special case for ISE
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


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
		CompletedCount = COUNT(ans.Answer_Id)
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where ans.Answer_Text != 'U' 
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableQuestionBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions)
			OR
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse))
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
PRINT N'Creating [dbo].[GetAnswerDistribMaturity]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 11 November 2022
-- Description:	Get a generic answer distribution for an assessment
--              without having to worry about which answers it supports.
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribMaturity]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- build list of answer options supported by the assessment's model
	declare @ao varchar(20)
	select @ao = answer_options
	from maturity_models mm
	left join AVAILABLE_MATURITY_MODELS amm on mm.Maturity_Model_Id = amm.model_id
	where amm.Assessment_Id = @assessment_id

	select * into #ao from STRING_SPLIT(@ao, ',')
	insert into #ao (value) values ('U')
	update #ao set value = TRIM(value)


	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP where Answer_Text in (select value from #ao)) a left join (
SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM Answer_Maturity a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text = m.Answer_Text		
	LEFT JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by o.answer_order

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAnswerDistribGroupings]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 15 November 2022
-- Description:	Tallies answer counts for all maturity groupings
--              at the top level.  
--              TODO:  What if we want to target the children of a 
--              specific grouping?  g.Parent_Id = X
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribGroupings] 
	@assessmentId int
AS
BEGIN
	SET NOCOUNT ON;
	exec FillEmptyMaturityQuestionsForAnalysis @assessmentId

	declare @maturityModelId int = (select model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId)

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
PRINT N'Adding foreign keys to [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ACCESS_KEY] FOREIGN KEY ([AccessKey]) REFERENCES [dbo].[ACCESS_KEY] ([AccessKey])
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_IRP]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP] ADD CONSTRAINT [FK__Assessmen__IRP_I__5EDF0F2E] FOREIGN KEY ([IRP_Id]) REFERENCES [dbo].[IRP] ([IRP_ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTION_PROPS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] ADD CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
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
