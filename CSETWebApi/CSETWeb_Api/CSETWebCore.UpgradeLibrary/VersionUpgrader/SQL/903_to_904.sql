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
PRINT N'Dropping foreign keys from [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[QUESTION_SUB_QUESTION]'
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION] DROP CONSTRAINT [FK_QUESTION_SUB_QUESTION_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] DROP CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[NERC_RISK_RANKING]'
GO
ALTER TABLE [dbo].[NERC_RISK_RANKING] DROP CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] DROP CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_LEVELS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] DROP CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] DROP CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SETS] DROP CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] DROP CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[COMPONENT_STANDARD_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] DROP CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [PK_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[QUESTION_SUB_QUESTION]'
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION] DROP CONSTRAINT [PK_Question_Sub_Question_1]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[INFORMATION]'
GO
ALTER TABLE [dbo].[INFORMATION] DROP CONSTRAINT [DF_INFORMATION_IsAcetOnly]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[QUESTION_SUB_QUESTION]'
GO
ALTER TABLE [dbo].[QUESTION_SUB_QUESTION] DROP CONSTRAINT [DF_Question_Sub_Question_List_Order]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[usp_getStandardSummaryOverall2]'
GO
DROP PROCEDURE [dbo].[usp_getStandardSummaryOverall2]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[QUESTION_SUB_QUESTION]'
GO
DROP TABLE [dbo].[QUESTION_SUB_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD
[Zone_Id] [int] NULL,
[Layer_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_CONTAINER]'
GO
CREATE TABLE [dbo].[DIAGRAM_CONTAINER]
(
[Container_Id] [int] NOT NULL IDENTITY(1, 1),
[ContainerType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Visible] DEFAULT ((1)),
[DrawIO_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assessment_Id] [int] NOT NULL,
[Universal_Sal_Level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Universal_Sal_Level] DEFAULT ('L'),
[Parent_Id] [int] NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Parent_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_CONTAINER] on [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] ADD CONSTRAINT [PK_DIAGRAM_CONTAINER] PRIMARY KEY CLUSTERED  ([Container_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_CONTAINER_TYPES]'
GO
CREATE TABLE [dbo].[DIAGRAM_CONTAINER_TYPES]
(
[ContainerType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_CONTAINER_TYPES] on [dbo].[DIAGRAM_CONTAINER_TYPES]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER_TYPES] ADD CONSTRAINT [PK_DIAGRAM_CONTAINER_TYPES] PRIMARY KEY CLUSTERED  ([ContainerType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[NEW_REQUIREMENT]'
GO
CREATE TABLE [dbo].[RG_Recovery_1_NEW_REQUIREMENT]
(
[Requirement_Id] [int] NOT NULL IDENTITY(1, 1),
[Requirement_Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requirement_Text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Supplemental_Info] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard_Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard_Sub_Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weight] [int] NULL,
[Implementation_Recommendations] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Original_Set_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Text_Hash] AS (CONVERT([varbinary](20),hashbytes('SHA1',[Requirement_Text]),(0))) PERSISTED,
[NCSF_Cat_Id] [int] NULL,
[NCSF_Number] [int] NULL,
[Supp_Hash] AS (CONVERT([varbinary](32),hashbytes('SHA1',left([Supplemental_Info],(8000))),(0))) PERSISTED,
[Ranking] [int] NULL,
[Question_Group_Heading_Id] [int] NOT NULL,
[ExaminationApproach] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_1_NEW_REQUIREMENT] ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO [dbo].[RG_Recovery_1_NEW_REQUIREMENT]([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach]) SELECT [Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach] FROM [dbo].[NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
SET IDENTITY_INSERT [dbo].[RG_Recovery_1_NEW_REQUIREMENT] OFF
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @idVal BIGINT
SELECT @idVal = IDENT_CURRENT(N'[dbo].[NEW_REQUIREMENT]')
IF @idVal IS NOT NULL
    DBCC CHECKIDENT(N'[dbo].[RG_Recovery_1_NEW_REQUIREMENT]', RESEED, @idVal)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[RG_Recovery_1_NEW_REQUIREMENT]', N'NEW_REQUIREMENT', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NEW_REQUIREMENT] on [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [PK_NEW_REQUIREMENT] PRIMARY KEY CLUSTERED  ([Requirement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_InScope]'
GO

CREATE VIEW [dbo].[Answer_Components_InScope]
AS
SELECT DISTINCT 
                         a.Assessment_Id, a.Answer_Id, a.Question_Or_Requirement_Id, a.Answer_Text, CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
                         a.Question_Number, q.Simple_Question AS QuestionText, adc.label AS ComponentName, adc.Diagram_Component_Type AS Component_Type, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
                         z.Name AS ZoneName, z.Universal_Sal_Level AS SAL, a.Is_Component, a.Component_Id, a.Component_Guid, a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.Mark_For_Review, a.Is_Requirement, 
                         a.Is_Framework
FROM            dbo.ANSWER AS a INNER JOIN
                         dbo.COMPONENT_QUESTIONS AS cq ON cq.Question_Id = a.Question_Or_Requirement_Id INNER JOIN
                         dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id INNER JOIN
                         dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc ON a.Assessment_Id = adc.Assessment_Id AND adc.Diagram_Component_Type = cq.Component_Type LEFT OUTER JOIN
                         dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id LEFT OUTER JOIN
                         dbo.DIAGRAM_CONTAINER AS z ON z.Assessment_Id = adc.Assessment_Id AND z.Container_Id = adc.Zone_Id
WHERE        (a.Is_Component = 1) AND (COALESCE (l.Visible, 1) = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[convert_sal]'
GO
-- =============================================
-- Author:		WOODRK
-- Create date: 9/12/2019
-- Description:	function to convert the SAL from 
-- word to letter or vice versa
-- =============================================
CREATE FUNCTION [dbo].[convert_sal]
(
	@SAL varchar(10)
)
RETURNS varchar(10)
AS
BEGIN
	declare @rval varchar(10)
	
	select @rval = UNIVERSAL_SAL_LEVEL from UNIVERSAL_SAL_LEVEL where Full_Name_Sal = @SAL;	
	if (@rval is null)
		select @rval = Full_Name_Sal from UNIVERSAL_SAL_LEVEL where Universal_Sal_Level = @SAL;	

	RETURN @rval;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_Exploded]'
GO



CREATE VIEW [dbo].[Answer_Components_Exploded]
AS

SELECT                   
	-- This guarantees a unique column to key on in the model
	CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	adc.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, q.Simple_Question AS QuestionText, 
	adc.label AS ComponentName, adc.Diagram_Component_Type AS Component_Type, a.Is_Component, a.Component_Id, a.Component_Guid, 
	adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
	z.Name AS ZoneName, ISNULL(z.Universal_Sal_Level, dbo.convert_sal(ss.Selected_Sal_Level)) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework
from     dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc 
			join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
			join dbo.COMPONENT_QUESTIONS AS cq ON adc.Diagram_Component_Type = cq.Component_Type			
            join dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 
			join NEW_QUESTION_SETS s on q.Question_Id = s.Question_Id
            join dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id  
            left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = ISNULL(z.Universal_Sal_Level, dbo.convert_sal(ss.Selected_Sal_Level))
			left join Answer_Components AS a on q.Question_Id = a.Question_Or_Requirement_Id and adc.Assessment_Id = a.Assessment_Id
WHERE l.Visible = 1 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_Default]'
GO


CREATE VIEW [dbo].[Answer_Components_Default]
AS

SELECT distinct Assessment_Id, Question_Id, Question_Number, QuestionText, SAL, 
	Answer_Id, Answer_Text, Comment, Alternate_Justification, Mark_For_Review
	from answer_components_exploded
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetCombinedOveralls]'
GO

ALTER PROCEDURE [dbo].[GetCombinedOveralls]	
@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Generate temporary tables containing all relevant/in-scope answers for the Assessment	

	SELECT a.*
	into #questionAnswers
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id				
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join [sets] ms on s.Set_Name = ms.Set_Name
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id 
			and v.Selected = 1 
			and v.Assessment_Id = @assessment_id 
			and l.Universal_Sal_Level = ul.Universal_Sal_Level
	
	SELECT ar.*
	into #requirementAnswers
		FROM Answer_Requirements ar
		join NEW_REQUIREMENT r on ar.Question_Or_Requirement_Id = r.Requirement_Id
		join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
		join REQUIREMENT_LEVELS l on ar.Question_Or_Requirement_Id = l.Requirement_Id
		join [sets] ms on s.Set_Name = ms.Set_Name
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where ar.Assessment_Id = @assessment_id 
			and v.Selected = 1 
			and v.Assessment_Id = @assessment_id 
			and l.Standard_Level = ul.Universal_Sal_Level
	
	SELECT ac.*
	into #componentAnswers 
		FROM Answer_Components_InScope ac
		where ac.Assessment_Id = @Assessment_Id

	

	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '#assessmentAnswers')
		drop table #asessmentAnswers;
	create table #assessmentAnswers (answer_text varchar(50), assessment_id int, is_requirement bit, is_component bit, is_framework bit)


	-- Populate #assessmentAnswers from the correct source table
	declare @applicationMode varchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	if(@ApplicationMode = 'Questions Based')
	begin		
		insert into #assessmentAnswers 
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #questionAnswers
	end
	else
	begin		
		insert into #assessmentAnswers 
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #requirementAnswers
	end

	-- Include component answers regardless of the application mode
	insert into #assessmentAnswers
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #componentAnswers


    -- Insert statements for procedure here
	SELECT StatType,isNull(Total,0) as Total, 
					cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],
					cast(IsNull(Round((cast(([N]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [N],
					cast(IsNull(Round((cast(([NA]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [NA],
					cast(IsNull(Round((cast(([A]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [A],
					cast(IsNull(Round((cast(([U]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [U],
					[Y] as [YCount],[N] as [NCount],[NA] as [NACount],[A] as [ACount],[U] as [UCount],
					--Value = (IsNull(cast(([Y]+[A]) as float)/((isnull(nullif(Total,0),1)-isnull([NA],0))),0))*100, 					
					Value = (cast(([Y]+[A]) as float)/ isnull(nullif((isnull(Total,0)-isnull([NA],0)),0),1))*100, 					
					
					--Value = cast(1 as float), 					
					TotalNoNA = isnull(Total,0)- isnull(NA,0)
		FROM 
		(
			select [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=1, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text 
				from #assessmentAnswers  -- !!! 
				where Assessment_Id  = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Requirement', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  		
				from (select t=2, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 1 and assessment_id = @assessment_id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Questions', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=3, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 0 and Is_Component = 0 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 	
			union
				select [StatType]='Components', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=4, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 0 and Is_Component = 1 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total    
				from (select t=5, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Framework = 1 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		ORDER BY pvt.StatType;

END
/*
declare @assessment_id int
set @Assessment_Id = 1041

				select [StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text ,SUM(isnull(acount,0)) OVER(PARTITION BY aw.t) AS Total    
				from (select t=5,ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from answer 
				where Is_Framework = 1 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
				*/
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsSummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select l.Answer_Text, l.Answer_Full_Name, isnull(b.vcount, 0) vcount, round(isnull(b.value, 0),0) [value] 
	from ANSWER_LOOKUP l 
	left join (select Answer_Text, count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] 
	from  Answer_Components_InScope 
	where assessment_id = @assessment_id
	group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsResultsByCategory]'
GO
-- =============================================
-- Author:		woodrk
-- Create date: 8/20/2019
-- Description:	Get answered component questions by category
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsResultsByCategory]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- get all answers
	select Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #temp	
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id
	where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' 
	group by Question_Group_Heading


	-- get passing answers (Y, A)
	SELECT Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #tempAnswered
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id		
	where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') 	
	group by Question_Group_Heading


	-- calc totals/percentage of passing		 
	select t.Question_Group_Heading, 
	ISNULL(a.qc,0) as [passed], 
	ISNULL(t.qc,0) as [total], 
	ROUND(ISNULL(CAST(a.qc as decimal(18,3))/t.qc,0),5) * 100 as [percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by Question_Group_Heading	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentTypes]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	remember the answer values are percents
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentTypes]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT Assessment_Id,
			component_type,
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],
			ISNULL(Total,0) as [Total], 
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(	
			select Assessment_Id, b.component_type, isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY Assessment_Id, component_type) AS Total  
			from (select diagram_component_type, answer_text from ANSWER_LOOKUP a, assessment_diagram_components c
			where c.assessment_id = @assessment_id) aw left join (
				select assessment_id, a.Component_Type, a.answer_text, count(a.answer_text) acount 
				from Answer_Components_Inscope a 
				where a.assessment_id = @assessment_id
				group by assessment_id, Component_Type, a.answer_text) b 
			on aw.Answer_Text = b.answer_text and aw.diagram_component_type = b.Component_Type
			where b.Component_Type is not null
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.Component_Type;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] WITH NOCHECK  ADD CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER] FOREIGN KEY ([Parent_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id]) NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category] FOREIGN KEY ([NCSF_Cat_Id]) REFERENCES [dbo].[NCSF_CATEGORY] ([NCSF_Cat_Id])
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_SETS] FOREIGN KEY ([Original_Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY] FOREIGN KEY ([Standard_Category]) REFERENCES [dbo].[STANDARD_CATEGORY] ([Standard_Category]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NERC_RISK_RANKING]'
GO
ALTER TABLE [dbo].[NERC_RISK_RANKING] WITH NOCHECK  ADD CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] WITH NOCHECK  ADD CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_LEVELS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_STANDARD_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER1] FOREIGN KEY ([Zone_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id])
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER] FOREIGN KEY ([Layer_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] ADD CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER_TYPES] FOREIGN KEY ([ContainerType]) REFERENCES [dbo].[DIAGRAM_CONTAINER_TYPES] ([ContainerType]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING] FOREIGN KEY ([Question_Group_Heading_Id]) REFERENCES [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading_Id]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STATES_AND_PROVINCES]'
GO
ALTER TABLE [dbo].[STATES_AND_PROVINCES] ADD CONSTRAINT [FK_STATES_AND_PROVINCES_COUNTRIES] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[COUNTRIES] ([ISO_code]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] ADD CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] NOCHECK CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[INFORMATION]'
GO
ALTER TABLE [dbo].[INFORMATION] ADD CONSTRAINT [DF_INFORMATION_IsAcetOnly] DEFAULT ((1)) FOR [IsAcetOnly]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 6
               Left = 319
               Bottom = 136
               Right = 543
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cq"
            Begin Extent = 
               Top = 6
               Left = 1061
               Bottom = 136
               Right = 1245
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "adc"
            Begin Extent = 
               Top = 6
               Left = 581
               Bottom = 136
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 853
               Bottom = 136
               Right = 1023
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "z"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 227
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
     ', 'SCHEMA', N'dbo', 'VIEW', N'Answer_Components_InScope', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_DiagramPane2', N'    Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Answer_Components_InScope', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Answer_Components_InScope', NULL, NULL
END TRY
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
