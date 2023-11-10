/*
Run this script on:

        (localdb)\INLLocalDb2022.CyberFlorida    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDb2022.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.6.10.20102 from Red Gate Software Ltd at 11/10/2023 7:10:25 AM

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
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_SUB_MODELS] FOREIGN KEY ([Sub_Model_Name]) REFERENCES [dbo].[MATURITY_SUB_MODELS] ([Sub_Model_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
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
delete NEW_QUESTION_LEVELS from NEW_QUESTION_LEVELS l left join NEW_QUESTION_SETS s on l.New_Question_Set_Id=s.New_Question_Set_Id
where s.New_Question_Set_Id is null
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering extended properties'
GO
BEGIN TRY
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'ANSWER_LOOKUP', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Answer Full Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'ANSWER_LOOKUP', 'COLUMN', N'Answer_Full_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Answer Text is used to', 'SCHEMA', N'dbo', 'TABLE', N'ANSWER_LOOKUP', 'COLUMN', N'Answer_Text'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'AVAILABLE_STANDARDS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Selected is used to', 'SCHEMA', N'dbo', 'TABLE', N'AVAILABLE_STANDARDS', 'COLUMN', N'Selected'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Old Entity Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'AVAILABLE_STANDARDS', 'COLUMN', N'Set_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Data Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Data_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Enhancement is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Enhancement'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Enhancement Html is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Enhancement_Html'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Flow Document is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Flow_Document'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Heading'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading Html is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Heading_Html'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Parent Heading Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Parent_Heading_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Req Oracle Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Req_Oracle_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Requirement is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Requirement'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Requirement Html is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Requirement_Html'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Requirement Text is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Requirement_Text'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Section Long Number is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Section_Long_Number'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Section Short Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Section_Short_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Section Short Number is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Section_Short_Number'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Supplemental Guidance is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Supplemental_Guidance'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Supplemental Guidance Html is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Supplemental_Guidance_Html'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Topic Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_DATA', 'COLUMN', N'Topic_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_HEADINGS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_HEADINGS', 'COLUMN', N'Heading_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading Num is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_HEADINGS', 'COLUMN', N'Heading_Num'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CATALOG_RECOMMENDATIONS_HEADINGS', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'CNSS_CIA_JUSTIFICATIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'CNSS_CIA_JUSTIFICATIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_FAMILY', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Component Family Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_FAMILY', 'COLUMN', N'Component_Family_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_QUESTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_QUESTIONS', 'COLUMN', N'Question_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Rank is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_QUESTIONS', 'COLUMN', N'Rank'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Seq is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_QUESTIONS', 'COLUMN', N'Seq'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Weight is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_QUESTIONS', 'COLUMN', N'Weight'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Abbreviation is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', 'COLUMN', N'Abbreviation'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Component Family Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', 'COLUMN', N'Component_Family_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', 'COLUMN', N'Component_Symbol_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', 'COLUMN', N'File_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Symbol Group Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS', 'COLUMN', N'Symbol_Group_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'COMPONENT_SYMBOLS_GM_TO_CSET', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'CSET_VERSION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Cset Version is used to', 'SCHEMA', N'dbo', 'TABLE', N'CSET_VERSION', 'COLUMN', N'Cset_Version'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CSET_VERSION', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Version Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'CSET_VERSION', 'COLUMN', N'Version_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_OBJECT_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', 'COLUMN', N'File_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Is Read Only is used to', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', 'COLUMN', N'Is_Read_Only'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Is Visible is used to', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', 'COLUMN', N'Is_Visible'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Template Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TEMPLATES', 'COLUMN', N'Template_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'DIAGRAM_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_ANSWERS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_ANSWERS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Document Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_ANSWERS', 'COLUMN', N'Document_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_FILE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_FILE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Document Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_FILE', 'COLUMN', N'Document_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Path is used to', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_FILE', 'COLUMN', N'Path'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Title is used to', 'SCHEMA', N'dbo', 'TABLE', N'DOCUMENT_FILE', 'COLUMN', N'Title'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'FILE_REF_KEYS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Num is used to', 'SCHEMA', N'dbo', 'TABLE', N'FILE_REF_KEYS', 'COLUMN', N'Doc_Num'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'FILE_TYPE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Description is used to', 'SCHEMA', N'dbo', 'TABLE', N'FILE_TYPE', 'COLUMN', N'Description'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'FILE_TYPE', 'COLUMN', N'File_Type'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Type Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'FILE_TYPE', 'COLUMN', N'File_Type_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Mime Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'FILE_TYPE', 'COLUMN', N'Mime_Type'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'FRAMEWORK_TIERS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'FRAMEWORK_TIER_DEFINITIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'FRAMEWORK_TIER_TYPE_ANSWER', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'FRAMEWORK_TIER_TYPE_ANSWER', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'GENERAL_SAL', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'GENERAL_SAL', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GENERAL_SAL', 'COLUMN', N'Assessment_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Sal Weight Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GENERAL_SAL', 'COLUMN', N'Sal_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Comments is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Comments'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Description is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Description'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Num is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Doc_Num'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Version is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Doc_Version'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'File_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Size is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'File_Size'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The File Type Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'File_Type_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Gen File Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Gen_File_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Publish Date is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Publish_Date'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Short Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Short_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Source Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Source_Type'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Summary is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Summary'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Title is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE', 'COLUMN', N'Title'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE_LIB_PATH_CORL', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Gen File Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE_LIB_PATH_CORL', 'COLUMN', N'Gen_File_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Lib Path Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_FILE_LIB_PATH_CORL', 'COLUMN', N'Lib_Path_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Display is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', 'COLUMN', N'Display'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Sal Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', 'COLUMN', N'Sal_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Sal Weight Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', 'COLUMN', N'Sal_Weight_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Slider Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', 'COLUMN', N'Slider_Value'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Weight is used to', 'SCHEMA', N'dbo', 'TABLE', N'GEN_SAL_WEIGHTS', 'COLUMN', N'Weight'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'GLOBAL_PROPERTIES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Property is used to', 'SCHEMA', N'dbo', 'TABLE', N'GLOBAL_PROPERTIES', 'COLUMN', N'Property'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Property Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'GLOBAL_PROPERTIES', 'COLUMN', N'Property_Value'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_NAMES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Level Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'LEVEL_NAMES', 'COLUMN', N'Level_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NCSF_CATEGORY', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NCSF_FUNCTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION_LEVELS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Sal Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION_LEVELS', 'COLUMN', N'Universal_Sal_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION_SETS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION_SETS', 'COLUMN', N'Question_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Set Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'NEW_QUESTION_SETS', 'COLUMN', N'Set_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Area is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Area'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Assessment_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Availability Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Availability_Value'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Confidentiality Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Confidentiality_Value'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Integrity Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Integrity_Value'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Selected is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Selected'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Type Value is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_INFO_TYPES', 'COLUMN', N'Type_Value'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_QUESTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_QUESTIONS', 'COLUMN', N'Question_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Number is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_QUESTIONS', 'COLUMN', N'Question_Number'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Text is used to', 'SCHEMA', N'dbo', 'TABLE', N'NIST_SAL_QUESTIONS', 'COLUMN', N'Question_Text'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_DEPENDENCY', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Dependencies Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_DEPENDENCY', 'COLUMN', N'Dependencies_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Procurement Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_DEPENDENCY', 'COLUMN', N'Procurement_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Basis is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Basis'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Fatmeasures is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Fatmeasures'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Flow Document is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Flow_Document'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Heading'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Language Guidance is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Language_Guidance'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Maintenance Guidance is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Maintenance_Guidance'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Parent Heading Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Parent_Heading_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Procurement Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Procurement_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Procurement Language is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Procurement_Language'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The References Doc is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'References_Doc'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Satmeasures is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Satmeasures'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Section Number is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Section_Number'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Topic Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_DATA', 'COLUMN', N'Topic_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_HEADINGS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_HEADINGS', 'COLUMN', N'Heading_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Heading Num is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_HEADINGS', 'COLUMN', N'Heading_Num'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_LANGUAGE_HEADINGS', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_REFERENCES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Procurement Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_REFERENCES', 'COLUMN', N'Procurement_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'PROCUREMENT_REFERENCES', 'COLUMN', N'Reference_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_HEADING', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Group Heading is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_HEADING', 'COLUMN', N'Question_Group_Heading'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Group Heading Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_HEADING', 'COLUMN', N'Question_Group_Heading_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Std Ref is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_HEADING', 'COLUMN', N'Std_Ref'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Weight is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_HEADING', 'COLUMN', N'Universal_Weight'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Group Header is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', 'COLUMN', N'Group_Header'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Group Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', 'COLUMN', N'Group_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Question Group Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', 'COLUMN', N'Question_Group_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Scoring Group is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', 'COLUMN', N'Scoring_Group'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Scoring Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'QUESTION_GROUP_TYPE', 'COLUMN', N'Scoring_Type'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'RECENT_FILES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'RECENT_FILES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'RECOMMENDATIONS_REFERENCES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Data Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'RECOMMENDATIONS_REFERENCES', 'COLUMN', N'Data_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'RECOMMENDATIONS_REFERENCES', 'COLUMN', N'Reference_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCES_DATA', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Doc Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCES_DATA', 'COLUMN', N'Reference_Doc_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCES_DATA', 'COLUMN', N'Reference_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Sections is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCES_DATA', 'COLUMN', N'Reference_Sections'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Date Last Checked is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Date_Last_Checked'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Date Updated is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Date_Updated'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Link is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Doc_Link'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Doc_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Notes is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Doc_Notes'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Short is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Doc_Short'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Url is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Doc_Url'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Reference Doc Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REFERENCE_DOCS', 'COLUMN', N'Reference_Doc_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REF_LIBRARY_PATH', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Lib Path Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REF_LIBRARY_PATH', 'COLUMN', N'Lib_Path_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Parent Path Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REF_LIBRARY_PATH', 'COLUMN', N'Parent_Path_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Path Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'REF_LIBRARY_PATH', 'COLUMN', N'Path_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_DETAIL_SECTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_DETAIL_SECTION_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_DETAIL_SECTION_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_OPTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_OPTIONS_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_OPTIONS_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_STANDARDS_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'REPORT_STANDARDS_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVELS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVELS', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Level Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVELS', 'COLUMN', N'Level_Type'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Requirement Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVELS', 'COLUMN', N'Requirement_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Standard Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVELS', 'COLUMN', N'Standard_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVEL_TYPE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Level Type is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVEL_TYPE', 'COLUMN', N'Level_Type'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Level Type Full Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_LEVEL_TYPE', 'COLUMN', N'Level_Type_Full_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_QUESTIONS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_REFERENCES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_SETS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Requirement Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_SETS', 'COLUMN', N'Requirement_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Set Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_SETS', 'COLUMN', N'Set_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'REQUIREMENT_SOURCE_FILES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SAL_DETERMINATION_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SETS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Full Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'SETS', 'COLUMN', N'Full_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Is Pass Fail is used to', 'SCHEMA', N'dbo', 'TABLE', N'SETS', 'COLUMN', N'Is_Pass_Fail'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Old Std Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'SETS', 'COLUMN', N'Old_Std_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Set Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'SETS', 'COLUMN', N'Set_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SETS_CATEGORY', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SHAPE_TYPES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_CATEGORY', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Standard Category is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_CATEGORY', 'COLUMN', N'Standard_Category'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_CATEGORY_SEQUENCE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SELECTION', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Application Mode is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SELECTION', 'COLUMN', N'Application_Mode'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SELECTION', 'COLUMN', N'Assessment_Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Selected Sal Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SELECTION', 'COLUMN', N'Selected_Sal_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SOURCE_FILE', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Doc Num is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SOURCE_FILE', 'COLUMN', N'Doc_Num'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Set Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SOURCE_FILE', 'COLUMN', N'Set_Name'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SPECIFIC_LEVEL', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Full Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SPECIFIC_LEVEL', 'COLUMN', N'Full_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Level Order is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SPECIFIC_LEVEL', 'COLUMN', N'Level_Order'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Standard is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SPECIFIC_LEVEL', 'COLUMN', N'Standard'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Standard Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_SPECIFIC_LEVEL', 'COLUMN', N'Standard_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_TO_UNIVERSAL_MAP', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Standard Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_TO_UNIVERSAL_MAP', 'COLUMN', N'Standard_Level'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Sal Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'STANDARD_TO_UNIVERSAL_MAP', 'COLUMN', N'Universal_Sal_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SUB_CATEGORY_ANSWERS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'SUB_CATEGORY_ANSWERS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Answer Text is used to', 'SCHEMA', N'dbo', 'TABLE', N'SUB_CATEGORY_ANSWERS', 'COLUMN', N'Answer_Text'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Component Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'SUB_CATEGORY_ANSWERS', 'COLUMN', N'Component_Guid'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Is Component is used to', 'SCHEMA', N'dbo', 'TABLE', N'SUB_CATEGORY_ANSWERS', 'COLUMN', N'Is_Component'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'SYMBOL_GROUPS', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'SYMBOL_GROUPS', 'COLUMN', N'Id'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Symbol Group Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'SYMBOL_GROUPS', 'COLUMN', N'Symbol_Group_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Symbol Group Title is used to', 'SCHEMA', N'dbo', 'TABLE', N'SYMBOL_GROUPS', 'COLUMN', N'Symbol_Group_Title'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Area Weight is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_AREA', 'COLUMN', N'Area_Weight'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Comments is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_AREA', 'COLUMN', N'Comments'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Area Name is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_AREA', 'COLUMN', N'Universal_Area_Name'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Area Number is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_AREA', 'COLUMN', N'Universal_Area_Number'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SAL_LEVEL', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Full Name Sal is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SAL_LEVEL', 'COLUMN', N'Full_Name_Sal'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Sal Level Order is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SAL_LEVEL', 'COLUMN', N'Sal_Level_Order'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Sal Level is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SAL_LEVEL', 'COLUMN', N'Universal_Sal_Level'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SUB_CATEGORIES', NULL, NULL
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Sub Category is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SUB_CATEGORIES', 'COLUMN', N'Universal_Sub_Category'
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
	EXEC sp_updateextendedproperty N'MS_Description', N'The Universal Sub Category Id is used to', 'SCHEMA', N'dbo', 'TABLE', N'UNIVERSAL_SUB_CATEGORIES', 'COLUMN', N'Universal_Sub_Category_Id'
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'VISIO_MAPPING', NULL, NULL
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
	EXEC sp_updateextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'WEIGHT', NULL, NULL
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
