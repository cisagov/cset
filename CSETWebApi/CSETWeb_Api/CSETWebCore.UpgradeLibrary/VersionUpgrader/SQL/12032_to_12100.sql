/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12032    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12100

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 11/10/2023 9:07:08 AM

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
ALTER TABLE [dbo].[ISE_ACTIONS] DROP CONSTRAINT [FK__ISE_ACTIO__Mat_Q__7F2CAE86]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping trigger [dbo].[Move_Domain_Filters_To_Normal_Form] from [dbo].[FINANCIAL_DOMAIN_FILTERS]'
GO
DROP TRIGGER [dbo].[Move_Domain_Filters_To_Normal_Form]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[Is_PCII] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_PCII] DEFAULT ((0)),
[PCII_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[USERS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[USERS] ADD
[Lang] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_USERS_Lang] DEFAULT ('en'),
[IsFirstLogin] [bit] NOT NULL CONSTRAINT [DF_USERS_IsFirstLogin] DEFAULT ((1))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[INFORMATION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[INFORMATION] ADD
[Ise_Submitted] [bit] NULL,
[Submitted_Date] [date] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_REFERENCES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD
[Sequence] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_SOURCE_FILES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] ADD
[Sequence] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS]
(
[Mat_Question_Id] [int] NOT NULL,
[Sub_Model_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_SUB_MODEL_QUESTIONS] on [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [PK_MATURITY_SUB_MODEL_QUESTIONS] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [Sub_Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_SUB_MODELS]'
GO
CREATE TABLE [dbo].[MATURITY_SUB_MODELS]
(
[Sub_Model_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_SUB_MODELS] on [dbo].[MATURITY_SUB_MODELS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODELS] ADD CONSTRAINT [PK_MATURITY_SUB_MODELS] PRIMARY KEY CLUSTERED ([Sub_Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[REQUIREMENT_REFERENCES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] ADD
[Sequence] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] ADD
[Sequence] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[func_MQ]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all MATURITY_QUESTIONS rows applicable for an assessment.
--              If the assessment is using a "sub model", only the questions in the
--              sub model are returned.  Otherwise, all questions for the assessment's
--              model are returned.
-- =============================================
CREATE FUNCTION [dbo].[func_MQ]
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
	[Services] [nvarchar](max) NULL
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
PRINT N'Creating [dbo].[func_AM]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all applicable rows from the ANSWER_MATURITY view.
--              If the assessment has a "sub model" defined, only the answers
--              for the sub model are returned.  Otherwise all maturity answers
--              are returned for the assessment.
-- =============================================
CREATE FUNCTION [dbo].[func_AM]
(	
	@assessmentId int
)
RETURNS  @AM TABLE (
	   [Answer_Id] int
      ,[Assessment_Id] int
      ,[Mark_For_Review] bit
      ,[Comment] nvarchar(max)
      ,[Alternate_Justification] varchar(2048)
      ,[Is_Requirement] bit
      ,[Question_Or_Requirement_Id] int
      ,[Question_Number] int
      ,[Answer_Text] nvarchar(50)
      ,[Component_Guid] uniqueidentifier
      ,[Is_Component] bit
      ,[Is_Framework] bit
      ,[Is_Maturity] bit
      ,[Custom_Question_Guid] nvarchar(50)
      ,[Old_Answer_Id] int
      ,[Reviewed] bit
      ,[FeedBack] nvarchar(2048)
      ,[Maturity_Level_Id] int
      ,[Question_Text] nvarchar(max))
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and Is_Maturity = 1
	end
	else
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and is_Maturity = 1 
		and Question_Or_Requirement_Id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end

	RETURN
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getRRASummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRRASummary]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)

	select a.Answer_Full_Name, a.Level_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from MATURITY_LEVELS, ANSWER_LOOKUP 
	where Maturity_Model_Id = 5 and answer_text in ('Y','N','U') ) a left join (
	SELECT l.Level_Name, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY Level_Name) AS Total
			FROM #AM a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text)
			m on a.Level_Name = m.Level_Name and a.Answer_Text = m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Level,o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_For_User]'
GO

ALTER PROCEDURE [dbo].[usp_Assessments_For_User]
@User_Id int
AS
SET NOCOUNT ON;

-- Replaces view Assessments_For_User.  Gathering missing alt justification is
-- more straightforward using a procedure than a view.

-- build a table variable with ALT answers without justification
declare @ATM table(assessment_id INT)

insert into @ATM
select distinct assessment_id 
from Answer_Standards_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Maturity
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Components_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,	
	LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	UseDiagram,
	UseStandard,
	UseMaturity,	
	workflow,
	SelectedMaturityModel = m.Model_Name,
	iseSubmitted = i.Ise_Submitted,
	submittedDate = i.Submitted_Date,
	SelectedStandards = string_agg(s.Short_Name, ', '),
	case when a.assessment_id in (select assessment_id from @ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		left join AVAILABLE_MATURITY_MODELS amm on amm.Assessment_Id = a.Assessment_Id
		left join MATURITY_MODELS m on m.Maturity_Model_Id = amm.model_id
		left join AVAILABLE_STANDARDS astd on astd.Assessment_Id = a.Assessment_Id
		left join SETS s on s.Set_Name = astd.Set_Name		
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id		
		left join (
			select distinct a.Assessment_Id, v.Mark_For_Review
			from ASSESSMENTS a 
			join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1 

			union

			select distinct a.Assessment_Id, Mark_For_Review
			from ASSESSMENTS a
			join Answer_Maturity v on a.Assessment_id = v.Assessment_Id
			where v.Mark_For_Review = 1

			union 

			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b 
			
		on a.Assessment_Id = b.Assessment_Id
		where c.UserId = @User_Id
		group by a.Assessment_Id, Assessment_Name, Assessment_Date, AssessmentCreatedDate, 
					LastModifiedDate, mark_for_review, UseDiagram,
					UseStandard, UseMaturity, Workflow, Model_Name, 
					Ise_Submitted, Submitted_Date, c.UserId



					

					
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getRRASummaryOverall]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRRASummaryOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;
	
	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)

	
	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP 
	where answer_text in ('Y','N','U') ) a left join (
	SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM #AM a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text = m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getRRASummaryByGoalOverall]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRRASummaryByGoalOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)

	
	select a.Title, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from #MG
		where Maturity_Model_Id = 5 and Group_Level = 2) a left join (
		SELECT g.Title, isnull(count(question_or_requirement_id),0) qc , SUM(count(Title)) OVER(PARTITION BY assessment_id) AS Total
			FROM #AM a 
			join (
				select q.Mat_Question_Id, g.* 
				from #MQ q join #MG g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
				where g.Maturity_Model_Id=5 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			group by a.Assessment_Id, g.Title)
			m on a.Title=m.Title	
	order by a.Sequence

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getRRASummaryByGoal]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRRASummaryByGoal]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	--select Answer_Full_Name = N'Yes',Title=N'Robust Data Backup (DB)', Sequence=1, Answer_Text=N'Y',qc=0,Total=0,[Percent]=0	

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)


	select a.Answer_Full_Name, a.Title, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from #MG, ANSWER_LOOKUP 
		where Maturity_Model_Id = 5 and answer_text in ('Y','N','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM #AM a 
			join (
				select q.Mat_Question_Id, g.* 
				from #MQ q join #MG g on q.Grouping_Id = g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where g.Maturity_Model_Id = 5 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id	
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_SUB_MODELS] FOREIGN KEY ([Sub_Model_Name]) REFERENCES [dbo].[MATURITY_SUB_MODELS] ([Sub_Model_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Enabling constraints on [dbo].[NEW_QUESTION_LEVELS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering extended properties'
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', 'YES', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Additional Contacts is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Additional_Contacts'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Additional Notes And Comments is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Additional_Notes_And_Comments'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Assessment Description is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Assessment_Description'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Assessment Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Assessment_Name'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Assessor Email is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Assessor_Email'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Assessor Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Assessor_Name'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Assessor Phone is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Assessor_Phone'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The City Or Site Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'City_Or_Site_Name'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Enterprise Evaluation Summary is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Enterprise_Evaluation_Summary'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Executive Summary is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Executive_Summary'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Facility Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Facility_Name'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'Id'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'MS_Description', 'The State Province Or Region is used to', 'SCHEMA', N'dbo', 'TABLE', N'INFORMATION', 'COLUMN', N'State_Province_Or_Region'
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
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
