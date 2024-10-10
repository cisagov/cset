/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12263    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12300

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 10/10/2024 3:59:37 PM

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
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]
(
[Entry_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Requirement_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_ENTRY] on [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_ENTRY] PRIMARY KEY CLUSTERED ([Entry_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_ENTRY_TO_MID]'
GO
CREATE TABLE [dbo].[NCSF_ENTRY_TO_MID]
(
[Entry_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_ENTRY_TO_MID] on [dbo].[NCSF_ENTRY_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [PK_NCSF_ENTRY_TO_MID] PRIMARY KEY CLUSTERED ([Entry_Level_Titles], [Mid_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_MID]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_MID]
(
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_MID] on [dbo].[NCSF_CONVERSION_MAPPINGS_MID]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_MID] PRIMARY KEY CLUSTERED ([Mid_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]
(
[Full_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Requirement_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_FULL] on [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_FULL] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_FULL] PRIMARY KEY CLUSTERED ([Full_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_FULL_TO_MID]'
GO
CREATE TABLE [dbo].[NCSF_FULL_TO_MID]
(
[Full_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_FULL_TO_MID] on [dbo].[NCSF_FULL_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [PK_NCSF_FULL_TO_MID] PRIMARY KEY CLUSTERED ([Full_Level_Titles], [Mid_Level_Titles])
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
	[Security_Practice] nvarchar(max) null,
	[Implementation_Guides] nvarchar(max) null
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
PRINT N'Creating [dbo].[vAllQuestionsOnly]'
GO
CREATE VIEW [dbo].[vAllQuestionsOnly]
AS
SELECT AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId,Simple_Question AS question, q.Original_Set_Name
FROM     NEW_QUESTION q
UNION
SELECT AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question, r.Original_Set_name
FROM     NEW_REQUIREMENT r
UNION
SELECT AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS question, m.Model_Name as Original_Set_Name 
FROM MATURITY_QUESTIONS mq
JOIN MATURITY_MODELS m on m.Maturity_Model_Id = mq.Maturity_Model_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillEmptyMaturityQuestionsForModel]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 09/10/2024
-- Description:	Create empty data for questions that have not been filled out.
--              This version of the proc is designed for deliberately fleshing out SSG questions
--              because their relevance is not determined by AVAILABLE_MATURITY_MODELS.
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyMaturityQuestionsForModel]
	@Assessment_Id int,
	@Model_Id int
AS
BEGIN	
	DECLARE @result int;  
	begin
	BEGIN TRANSACTION;  
	EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';
	INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id],[Answer_Text],[Question_Type],[Assessment_Id])     
		select mq.Mat_Question_Id,Answer_Text = 'U', Question_Type='Maturity', Assessment_Id = @Assessment_Id
		from [dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id = @Model_Id
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [dbo].[ANSWER] 
			where Assessment_Id = @Assessment_Id and Maturity_Model_Id = @Model_Id)
		IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END
	end

END
/****** Object:  StoredProcedure [dbo].[FillEmptyQuestionsForAnalysis]    Script Date: 12/16/2020 11:01:33 AM ******/
SET ANSI_NULLS ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAnswerCountsForGroupings]'
GO

-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	Generically return answer counts for all groupings in 
--              an assessment's maturity model
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerCountsForGroupings]
	@assessmentId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec [FillEmptyMaturityQuestionsForAnalysis] @assessmentId

    select Title, Sequence, Grouping_Id, Parent_Id, Answer_Text, count(*) as AnsCount
	from (
		select mg.Title, mg.Sequence, mg.grouping_id, mg.Parent_Id, a.Answer_Text
		from answer a
		left join maturity_questions mq on a.Question_Or_Requirement_Id = mq.Mat_Question_Id and a.Question_Type = 'maturity'
		left join maturity_groupings mg on mq.Grouping_Id = mg.Grouping_Id
		where assessment_id = @assessmentId
	) b
	group by title, sequence, grouping_id, parent_id, answer_text
	order by sequence, answer_text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetQuestions]'
GO
-- =============================================
-- Author:		Barry Hansen
-- Create date: 10/8/2024
-- Description:	Ranked Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetQuestions]
@assessment_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id
	-- get the application mode
	declare @applicationMode nvarchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output
	-- get currently selected sets
	IF OBJECT_ID('tempdb..#mySets') IS NOT NULL DROP TABLE #mySets
	select set_name into #mySets from AVAILABLE_STANDARDS where Assessment_Id = @assessment_Id and Selected = 1
	
	if(@ApplicationMode = 'Questions Based')	
	begin
		SELECT Short_Name as ShortName,
			Question_Group_Heading as [Category], 							
			Simple_Question as [QuestionText], 						
			c.Question_Id as [QuestionId],
			null as [RequirementId],
			a.Answer_ID as [AnswerID],
			Answer_Text as [AnswerText],
			c.Universal_Sal_Level as [Level],
			CONVERT(varchar(10), a.Question_Number) as [QuestionRef],
			Question_Group_Heading + ' # ' + CONVERT(varchar(10), a.Question_Number) as CategoryAndNumber,
			a.Question_Or_Requirement_Id as [QuestionOrRequirementID]
			FROM Answer_Questions a
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
			join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
			join (
				select distinct s.question_id, ns.Short_Name from NEW_QUESTION_SETS s
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join SETS ns on s.Set_Name = ns.Set_Name
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
					join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
					join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
			)	s on c.Question_Id = s.Question_Id		
			where a.Assessment_Id = @assessment_id
			order by ShortName,Question_Group_Heading,Question_Number
	end
	else
	begin
		SELECT Short_Name ShortName,
			Standard_Category as [Category], 			
			Requirement_Text as [QuestionText], 				
			null as [QuestionId],
			req.Requirement_Id as [RequirementId],
			Answer_Id as [AnswerID],
			Answer_Text as [AnswerText],
			u.Universal_Sal_Level as [Level],
			requirement_title as [QuestionRef],
			Standard_Category + ' - ' + requirement_title as CategoryAndNumber,
			rs.Requirement_Id as [QuestionOrRequirementID]
			from REQUIREMENT_SETS rs
				left join ANSWER ans on ans.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and ans.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level
			order by rs.Requirement_Sequence
	end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetMaturityComparisonBestToWorst]'
GO

-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[GetMaturityComparisonBestToWorst]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		SELECT Assessment_Id,
		AssessmentName = Alias,                
		Name = Title,
		*
		--AlternateCount = [I],
		--AlternateValue = Round(((cast(([I]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NaCount = [S],
		--NaValue = Round(((cast(([S]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NoCount = [N],
		--NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--TotalCount = Total,
		--TotalValue = Total,
		--UnansweredCount = [U],
		--UnansweredValue = Round(cast([U] as float)/Total*100,2),
		--YesCount = [Y],
		--YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		--Value = Round(((cast(([Y]+ isnull([I],0)) as float)/isnull(nullif((Total-[S]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id, f.Alias, b.Title, b.Answer_Text, isnull(c.Value,0) as Value, 
			Total = sum(c.Value) over(partition by b.Assessment_Id, b.Title)			
			from 
			 (select distinct a.[Assessment_Id], g.Title, l.answer_Text
			from answer_lookup l, (select * from Answer_Maturity where assessment_id = @assessment_id) a 
			join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
			join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			) b left join 
			(select a.Assessment_Id, g.Title, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Maturity where assessment_id = @assessment_id) a 
				join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
				join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			 group by Assessment_Id, g.Title, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Title = c.Title and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p


			PIVOT
			(
				sum(value)
				FOR answer_text IN ( [Y],[I],[S],[N],[U] )
			) AS pvt
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS]
(
[Conversion_Id] [int] NOT NULL IDENTITY(1, 1),
[Entry_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Full_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Maturity_Model_Id] [int] NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_ASSESSMENT_UPGRADE] on [dbo].[NCSF_CONVERSION_MAPPINGS]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS] ADD CONSTRAINT [PK_NCSF_ASSESSMENT_UPGRADE] PRIMARY KEY CLUSTERED ([Conversion_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NCSF_ENTRY_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [FK_NCSF_ENTRY_TO_MID_NCSF_CONVERSION_MAPPINGS_ENTRY] FOREIGN KEY ([Entry_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY] ([Entry_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [FK_NCSF_ENTRY_TO_MID_NCSF_CONVERSION_MAPPINGS_MID] FOREIGN KEY ([Mid_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ([Mid_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NCSF_FULL_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [FK_NCSF_FULL_TO_MID_NCSF_CONVERSION_MAPPINGS_FULL] FOREIGN KEY ([Full_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_FULL] ([Full_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [FK_NCSF_FULL_TO_MID_NCSF_CONVERSION_MAPPINGS_MID] FOREIGN KEY ([Mid_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ([Mid_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
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
