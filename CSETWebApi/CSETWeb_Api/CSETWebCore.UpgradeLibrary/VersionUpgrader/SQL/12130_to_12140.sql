/*
Run this script on:

        (localdb)\INLLocalDB2022.TestUpgrade    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.RENEWWeb12140

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/1/2024 3:09:35 PM

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
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] DROP CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_GROUPINGS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ALTER COLUMN [Description] [nvarchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MALCOLM_ANSWERS]'
GO
CREATE TABLE [dbo].[MALCOLM_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Question_Or_Requirement_Id] [int] NOT NULL,
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Malcolm_Id] [int] NOT NULL,
[Malcolm_Answer_Id] [int] NOT NULL IDENTITY(1, 1),
[Mat_Option_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MALCOLM_ANSWERS] on [dbo].[MALCOLM_ANSWERS]'
GO
ALTER TABLE [dbo].[MALCOLM_ANSWERS] ADD CONSTRAINT [PK_MALCOLM_ANSWERS] PRIMARY KEY CLUSTERED ([Malcolm_Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_MALCOLM_ANSWERS] on [dbo].[MALCOLM_ANSWERS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MALCOLM_ANSWERS] ON [dbo].[MALCOLM_ANSWERS] ([Assessment_Id], [Question_Or_Requirement_Id], [Malcolm_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getCSETQuestionsForCRRM]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/15/2023
-- Description:	gets the general questions regardless of maturity,new_question,or new_requirement
-- =============================================

--exec usp_getCSETQuestionsForCRRM 'SD02 Series'
ALTER PROCEDURE [dbo].[usp_getCSETQuestionsForCRRM]
	-- Add the parameters for the stored procedure here
	@setname varchar(100)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select AssessmentMode='question', q.Std_Ref_Id as title ,   q.question_id as Id,Simple_Question as question
	,r.Supplemental_Info as Info
	,h.Question_Group_Heading as Heading,h.Universal_Sub_Category as SubHeading,Set_Name as SetName, IsComplete=cast(0 as bit), CRRMId = 0
	from NEW_QUESTION q 
	join REQUIREMENT_QUESTIONS_SETS s on q.Question_Id=s.Question_Id
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id=h.Heading_Pair_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='requirement', r.Requirement_Title as title,  r.Requirement_Id as Id, r.Requirement_Text as question,r.Supplemental_Info as Info,r.Standard_Category as Heading,r.Standard_Sub_Category as SubHeading,s.Set_Name as setname , IsComplete=cast(0 as bit), CRRMId = 0
	from REQUIREMENT_QUESTIONS_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='maturity', Question_Title as title, mat_question_id as Id ,Question_Text as queestion,Supplemental_Info as Info,g.Title as Heading, Question_Title as SubHeading, m.Model_Name as setname, IsComplete=cast(0 as bit), CRRMId = 0
	from MATURITY_QUESTIONS q 
	join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id
	join MATURITY_MODELS m on q.Maturity_Model_Id=m.Maturity_Model_Id and g.Maturity_Model_Id=m.Maturity_Model_Id
	where m.Model_Name = @setname
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Acet_GetActionItemsForReport]'
GO
-- =============================================
-- Author:		mrwinston
-- Create date: 11/4/2022
-- Description:	loads in the Action_Items for ACET ISE's MERIT and Examination reports
-- =============================================
ALTER PROCEDURE [dbo].[Acet_GetActionItemsForReport]
	@Assessment_Id int,
	@Exam_Level int, 
	@Additional_Exam_Level int
AS
BEGIN
	SELECT a.Parent_Question_Id, a.Mat_Question_Id,a.Observation_Id,a.Question_Title,a.answer_text,Regulatory_Citation, isnull(b.action_items_override,a.Action_Items) as Action_Items, a.Maturity_Level_Id
	FROM (select m.mat_question_id,m.Question_Title, m.Parent_Question_Id,i.Action_Items, Regulatory_Citation, a.Answer_Text,m.Maturity_Level_Id, mf.Finding_Id as [Observation_Id]
		from [MATURITY_QUESTIONS] AS [m]
		join [ANSWER] [a] on m.Mat_Question_Id = a.Question_Or_Requirement_Id and a.Question_Type = 'Maturity' and Assessment_Id = @Assessment_Id
		join (select a1.Question_Or_Requirement_Id,f1.Finding_Id,f1.Auto_Generated from ANSWER a1 join FINDING f1 on a1.Answer_Id=f1.Answer_Id where Assessment_Id = @Assessment_Id and a1.Question_Type = 'Maturity') mf on m.Parent_Question_Id = mf.Question_Or_Requirement_Id
		INNER JOIN [ISE_ACTIONS] AS [i] ON [m].[Mat_Question_Id] = [i].[Mat_Question_Id]
		where a.Answer_Text = 'N' or Auto_Generated = 0
	) a

	left join (select a.Assessment_Id,a.Question_Or_Requirement_Id,f.Finding_Id,i0.Action_Items_Override,i0.Mat_Question_Id
		from [ANSWER] [a]
		JOIN [FINDING] AS [f] ON [a].[Answer_Id] = [f].[Answer_Id]
		LEFT JOIN [ISE_ACTIONS_FINDINGS] AS [i0] ON f.Finding_Id = i0.Finding_Id
		WHERE [a].[Assessment_Id] = @Assessment_Id and a.Question_Type = 'Maturity'
	) b on a.Parent_Question_Id = b.Question_Or_Requirement_Id and a.Mat_Question_Id = b.Mat_Question_Id and a.Observation_Id = b.Finding_Id
	
	where a.Maturity_Level_Id = @Exam_Level or a.Maturity_Level_Id = @Additional_Exam_Level
	order by a.Mat_Question_Id

END
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

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	IF OBJECT_ID('tempdb..#AvailableMatQuestions') IS NOT NULL drop table #availableMatQuestions
	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseMaturity = 1 and mm.Maturity_Level_Usage_Type = 'Static'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	IF OBJECT_ID('tempdb..#AvailableMatQuestionsWithLevels') IS NOT NULL drop table #AvailableMatQuestionsWithLevels
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and mm.Maturity_Level_Usage_Type = 'User_Selected'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)
    
	-- special case for ISE
	IF OBJECT_ID('tempdb..#AvailableMatQuestionsForIse') IS NOT NULL drop table #AvailableMatQuestionsForIse
		select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse	
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id and asl.Level_Name = 'Maturity_Level'
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	-- special case for VADR
	IF OBJECT_ID('tempdb..#AvailableMatQuestionsForVadr') IS NOT NULL drop table #availableMatQuestionsForVadr
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestionsForVadr
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseMaturity = 1 and amm.model_id = 7
			and mq.Parent_Question_Id is null

	IF OBJECT_ID('tempdb..#AvailableQuestionBasedStandard') IS NOT NULL drop table #AvailableQuestionBasedStandard		
	select a.Assessment_Id, q.question_Id, ss.Selected_Sal_Level into #AvailableQuestionBasedStandard
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
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseStandard = 1 and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level 

	IF OBJECT_ID('tempdb..#AvailableRequirementBasedStandard') IS NOT NULL drop table #AvailableRequirementBasedStandard		
	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseStandard = 1 and rl.Standard_Level = usl.Universal_Sal_Level

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
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(DISTINCT(ans.Answer_Id))
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where ans.Answer_Text != 'U'
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions avq 
												where avq.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select aqbs.Question_Id from #AvailableQuestionBasedStandard aqbs
												where aqbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard arbs 
												where arbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions adq
												where adq.Assessment_Id = a.Assessment_Id)
			or
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse amqi
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amqi.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level = ml.Level)
			or 
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForVadr amqv 
												where amqv.Assessment_Id = a.Assessment_Id)
			)
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id, CompletedCount = 0
		from ASSESSMENTS a
		join ASSESSMENT_CONTACTS ac on a.Assessment_Id = ac.Assessment_Id and ac.UserId = @User_Id
		where a.Assessment_Id 
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
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
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
PRINT N'Altering [dbo].[MALCOLM_MAPPING]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MALCOLM_MAPPING] ADD
[Is_Standard] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Requirement] DEFAULT ((0)),
[Is_Component] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Component] DEFAULT ((0)),
[Is_Maturity] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Maturity] DEFAULT ((0)),
[Mat_Option_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[MALCOLM_MAPPING].[Question_Id]', N'Question_Or_Requirement_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MALCOLM_MAPPING] ALTER COLUMN [Rule_Violated] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[MALCOLM_MAPPING]'
GO
ALTER TABLE [dbo].[MALCOLM_MAPPING] ADD CONSTRAINT [DF_MALCOLM_MAPPING_Rule_Violated] DEFAULT ((0)) FOR [Rule_Violated]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MALCOLM_MAPPING]'
GO
UPDATE [dbo].[MALCOLM_MAPPING] SET [Rule_Violated]=DEFAULT WHERE [Rule_Violated] IS NULL
GO
ALTER TABLE [dbo].[MALCOLM_MAPPING] ALTER COLUMN [Rule_Violated] [int] NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_SYMBOLS_MAPPINGS] on [dbo].[COMPONENT_SYMBOLS_MAPPINGS]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS_MAPPINGS] ADD CONSTRAINT [PK_COMPONENT_SYMBOLS_MAPPINGS] PRIMARY KEY CLUSTERED ([Mapping_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MALCOLM_ANSWERS]'
GO
ALTER TABLE [dbo].[MALCOLM_ANSWERS] ADD CONSTRAINT [FK_MALCOLM_ANSWERS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] ADD CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
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
