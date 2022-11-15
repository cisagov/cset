/*
Run this script on:

        (localdb)\MSSQLLocalDB.NCUAWeb12005    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.NCUAWeb12006

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/7/2022 2:10:30 PM

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
PRINT N'Dropping foreign keys from [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] DROP CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] DROP CONSTRAINT [PK__ISE_ACTI__B0B2E4E66B6807D2]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[USERS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[USERS] ADD
[EmailSentCount] [int] NOT NULL CONSTRAINT [DF_USERS_EmailSentCount] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FINDING]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINDING] ADD
[Risk_Area] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Risk] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionItems] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[INFORMATION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[INFORMATION] ADD
[Postal_Code] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ISE_ACTIONS_FINDINGS]'
GO
CREATE TABLE [dbo].[ISE_ACTIONS_FINDINGS]
(
[Finding_Id] [int] NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Action_Items_Override] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ISE_ACTIONS_FINDINGS] on [dbo].[ISE_ACTIONS_FINDINGS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] ADD CONSTRAINT [PK_ISE_ACTIONS_FINDINGS] PRIMARY KEY CLUSTERED ([Finding_Id], [Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ISE_ACTIONS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD
[Parent_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[ISE_ACTIONS].[Question_Id]', N'Mat_Question_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__ISE_ACTI__B0B2E4E66B6807D2] on [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [PK__ISE_ACTI__B0B2E4E66B6807D2] PRIMARY KEY CLUSTERED ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USER_EMAIL_HISTORY]'
GO
CREATE TABLE [dbo].[USER_EMAIL_HISTORY]
(
[UserId] [int] NOT NULL,
[EmailSentDate] [datetime2] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USER_EMAIL_HISTORY] on [dbo].[USER_EMAIL_HISTORY]'
GO
ALTER TABLE [dbo].[USER_EMAIL_HISTORY] ADD CONSTRAINT [PK_USER_EMAIL_HISTORY] PRIMARY KEY CLUSTERED ([UserId], [EmailSentDate])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetChildrenAnswers]'
GO
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetChildrenAnswers]
   @Parent_Id int,
   @Assess_Id int
  
AS
BEGIN
   SET NOCOUNT ON;
   SELECT [Mat_Question_Id], [Question_Title], [Question_Text],
          [Answer_Text], [Maturity_Level_Id], [Parent_Question_Id],
          [Ranking], [Grouping_Id] FROM MATURITY_QUESTIONS
       JOIN ANSWER
       ON MATURITY_QUESTIONS.Mat_Question_Id = ANSWER.Question_Or_Requirement_Id
   WHERE ([Parent_Question_Id] = @Parent_Id) AND ([Assessment_Id] = @Assess_Id)
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

	-- I don't like hardcoding in these model ids, but we have to manually declare which models utilize user selected levels to 
	-- filter questions since some maturity models default to ML 1, but also have questions above that level.
	declare @MaturityModelsWithLevels table(ModelId INT)
	declare @MaturityModelsWithoutLevels table (ModelId INT)
	insert into @MaturityModelsWithLevels values (1), (2), (6), (7), (9)
	insert into @MaturityModelsWithoutLevels values (3), (4), (8), (5)

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	IF OBJECT_ID('tempdb..#AvailableMatQuestions') IS NOT NULL drop table #availableMatQuestions
	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseMaturity = 1 and amm.model_id in (select ModelId from @MaturityModelsWithoutLevels)
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	IF OBJECT_ID('tempdb..#AvailableMatQuestionsWithLevels') IS NOT NULL drop table #AvailableMatQuestionsWithLevels
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
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
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
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
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
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
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
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
			full join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
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
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse))
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
PRINT N'Creating [dbo].[usp_countsForLevelsByGroupMaturityModel]'
GO
-- =============================================
-- Author:        hansbk
-- Create date: 11/3/2022
-- Description:    getting all the counts for a mat,grouping,level and answer
-- =============================================
CREATE PROCEDURE [dbo].[usp_countsForLevelsByGroupMaturityModel]
    -- Add the parameters for the stored procedure here
    @assessment_id int,
    @mat_model_id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    select a.*,b.Answer_Text as Answer_Text2,b.answer_count from (
    select distinct GROUPING_ID,Maturity_Level_Id, Answer_Text
    from MATURITY_QUESTIONS, (select ANSWER_text from ANSWER_LOOKUP where Answer_Text in ('Y','U','N')) ans
    where Maturity_Model_Id = @mat_model_id) a left join (
    select q.Grouping_Id,q.Maturity_Level_Id, a.Answer_Text, count(a.Answer_Text) answer_count from ANSWER a
    join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
    join MATURITY_LEVELS l on q.Maturity_Level_Id = l.Maturity_Level_Id
    where a.Question_Type = 'Maturity' and Assessment_Id = @assessment_id
    group  by q.Grouping_Id, q.Maturity_Level_Id, a.Answer_Text) b on a.Grouping_Id=b.Grouping_Id and a.Maturity_Level_Id=b.Maturity_Level_Id and a.Answer_Text=b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Acet_GetActionItemsForReport]'
GO
-- =============================================
-- Author:		mrwinston
-- Create date: 11/4/2022
-- Description:	loads in the Action_Items for ACET ISE's MERIT and Examination reports
-- =============================================
CREATE PROCEDURE [dbo].[Acet_GetActionItemsForReport]
	-- Add the parameters for the stored procedure here
	--assessId
	@Assessment_Id int
AS
BEGIN
	declare @Maturity_Level_Id int

	select @Maturity_Level_Id = Maturity_Level_Id from ASSESSMENT_SELECTED_LEVELS salLevel
	join MATURITY_LEVELS matLevel on salLevel.Standard_Specific_Sal_Level = matLevel.Level
	where salLevel.Assessment_Id = @Assessment_Id and matLevel.Maturity_Model_Id = 10 and salLevel.Level_Name = 'Maturity_Level'

	SELECT a.Parent_Question_Id, a.Mat_Question_Id,a.Finding_Id,a.Question_Title,a.Regulatory_Citation, isnull(b.action_items_override,a.Action_Items) as Action_Items, a.Maturity_Level_Id
	FROM (select m.mat_question_id,m.Question_Title, m.Parent_Question_Id,Action_Items, Regulatory_Citation, a.Answer_Text,m.Maturity_Level_Id, mf.Finding_Id
		from [MATURITY_QUESTIONS] AS [m]
		join ANSWER a on m.Mat_Question_Id = a.Question_Or_Requirement_Id and a.Question_Type = 'Maturity'
		join (select a1.Question_Or_Requirement_Id,f1.Finding_Id from answer a1 join FINDING f1 on a1.Answer_Id=f1.Answer_Id where Assessment_Id = 1019 and a1.Question_Type = 'Maturity') mf on m.Parent_Question_Id = mf.Question_Or_Requirement_Id
		INNER JOIN [ISE_ACTIONS] AS [i] ON [m].[Mat_Question_Id] = [i].[Mat_Question_Id]
		where Action_Items <> '' and answer_text = 'N'
	) a
	left join (select a.Assessment_Id,a.Question_Or_Requirement_Id,f.Finding_Id,i0.Action_Items_Override,i0.Mat_Question_Id
		from [ANSWER] a
		JOIN [FINDING] AS [f] ON [a].[Answer_Id] = [f].[Answer_Id]
		LEFT JOIN [ISE_ACTIONS_FINDINGS] AS [i0] ON f.Finding_Id = i0.Finding_Id
		WHERE [a].[Assessment_Id] = @Assessment_Id and a.Question_Type = 'Maturity'
	) b on a.Parent_Question_Id = b.Question_Or_Requirement_Id and a.Mat_Question_Id = b.Mat_Question_Id
	
	where a.Maturity_Level_Id = @Maturity_Level_Id
	order by a.Mat_Question_Id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RapidAssessmentControls]'
GO
CREATE TABLE [dbo].[RapidAssessmentControls]
(
[order] [tinyint] NOT NULL,
[value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_RapidAssessmentControls] on [dbo].[RapidAssessmentControls]'
GO
ALTER TABLE [dbo].[RapidAssessmentControls] ADD CONSTRAINT [PK_RapidAssessmentControls] PRIMARY KEY CLUSTERED ([order])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ISE_ACTIONS_FINDINGS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] ADD CONSTRAINT [FK_ISE_ACTIONS_FINDINGS_FINDING] FOREIGN KEY ([Finding_Id]) REFERENCES [dbo].[FINDING] ([Finding_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] ADD CONSTRAINT [FK_ISE_ACTIONS_FINDINGS_ISE_ACTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[ISE_ACTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [FK_NEW_REQUIREMENT_SETS] FOREIGN KEY ([Original_Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[USER_EMAIL_HISTORY]'
GO
ALTER TABLE [dbo].[USER_EMAIL_HISTORY] ADD CONSTRAINT [FK_USER_EMAIL_HISTORY_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
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
