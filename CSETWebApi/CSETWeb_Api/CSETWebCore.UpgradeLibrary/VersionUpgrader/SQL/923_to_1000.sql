
/*
Run this script on:

        (localdb)\v11.0.CSETWeb923    -  This database will be modified

to synchronize it with:

        (localdb)\v11.0.CSETWeb1000

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.1.7.14336 from Red Gate Software Ltd at 4/21/2020 9:15:40 PM

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
PRINT N'Creating [dbo].[AGGREGATION_INFORMATION]'
GO
CREATE TABLE [dbo].[AGGREGATION_INFORMATION]
(
[AggregationID] [int] NOT NULL IDENTITY(1, 1),
[Aggregation_Date] [datetime] NULL,
[Aggregation_Mode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aggregation_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Facility_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State_Province_Or_Region] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Phone] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessment_Description] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Notes_And_Comments] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enterprise_Evaluation_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__AggregationInformation] on [dbo].[AGGREGATION_INFORMATION]'
GO
ALTER TABLE [dbo].[AGGREGATION_INFORMATION] ADD CONSTRAINT [PK__AggregationInformation] PRIMARY KEY CLUSTERED  ([AggregationID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AGGREGATION_ASSESSMENT]'
GO
CREATE TABLE [dbo].[AGGREGATION_ASSESSMENT]
(
[Assessment_Id] [int] NOT NULL,
[Aggregation_Id] [int] NOT NULL,
[Sequence] [int] NULL,
[Alias] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__AGGREGAT__985B1205C06FF728] on [dbo].[AGGREGATION_ASSESSMENT]'
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [PK__AGGREGAT__985B1205C06FF728] PRIMARY KEY CLUSTERED  ([Assessment_Id], [Aggregation_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AGGREGATION_TYPES]'
GO
CREATE TABLE [dbo].[AGGREGATION_TYPES]
(
[Aggregation_Mode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AGGREGATION_TYPES] on [dbo].[AGGREGATION_TYPES]'
GO
ALTER TABLE [dbo].[AGGREGATION_TYPES] ADD CONSTRAINT [PK_AGGREGATION_TYPES] PRIMARY KEY CLUSTERED  ([Aggregation_Mode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[COMPONENT_SYMBOLS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS] ADD
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Answer_Standards_InScope]'
GO

ALTER VIEW [dbo].[Answer_Standards_InScope]
AS
		select distinct mode='Q', a.assessment_id, a.answer_id, is_requirement=0, a.question_or_requirement_id, a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid,a.is_framework,a.old_answer_id, a.reviewed, a.FeedBack
			,c.Simple_Question as Question_Text
			FROM Answer_Questions_No_Components a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id			
			join (
				select distinct s.Question_Id, v.Assessment_Id as std_assessment_id
					from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
					where v.Selected = 1 
					and l.Universal_Sal_Level = (
						select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
						where Assessment_Id = v.Assessment_Id
					)
			)	s on c.Question_Id = s.Question_Id and s.std_assessment_id = a.Assessment_Id			
		union	
		select distinct mode='R', a.assessment_id, a.answer_id, is_requirement=1, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed, a.FeedBack
			,req.Requirement_Text as Question_Text
			from Answer_Requirements a
				join REQUIREMENT_SETS rs on a.Question_Or_Requirement_Id = rs.Requirement_Id and a.is_requirement= 1
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.assessment_id		
				join [SETS] s on rs.Set_Name = s.Set_Name
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and ss.assessment_id = v.assessment_id
				join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id and rl.Standard_Level=dbo.convert_sal(ss.Selected_Sal_Level)
			where v.selected=1 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Assessments_For_User]'
GO


ALTER VIEW [dbo].[Assessments_For_User]
AS
select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,
	CreatorName = u.FirstName + ' ' + u.LastName,
	LastModifiedDate = LastAccessedDate,
	MarkedForReview = isnull(mark_for_review,0),
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		join USERS u on a.AssessmentCreatorId = u.UserId
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id
		left join (select distinct a.Assessment_Id,Mark_For_Review from ASSESSMENTS a join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
				where v.Mark_For_Review = 1
			union 
			select distinct a.Assessment_Id,Mark_For_Review from ASSESSMENTS a join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b on a.Assessment_Id = b.Assessment_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[vQUESTION_HEADINGS]'
GO
ALTER VIEW [dbo].[vQUESTION_HEADINGS]
AS
SELECT        dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Heading_Pair_Id, dbo.QUESTION_GROUP_HEADING.Question_Group_Heading, dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category, 
                         dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Sub_Heading_Question_Description, dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id
FROM            dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS INNER JOIN
                         dbo.UNIVERSAL_SUB_CATEGORIES ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Universal_Sub_Category_Id = dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id INNER JOIN
                         dbo.QUESTION_GROUP_HEADING ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Question_Group_Heading_Id = dbo.QUESTION_GROUP_HEADING.Question_Group_Heading_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Answer_Questions]'
GO



ALTER VIEW [dbo].[Answer_Questions]
AS
SELECT	Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
              Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, 
              Is_Framework, FeedBack
FROM	Answer_Standards_InScope
WHERE	mode = 'Q'

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_setTrendOrder]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_setTrendOrder]
	-- Add the parameters for the stored procedure here
	@Aggregation_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @assessment_id int, @i int
	

	declare me cursor for 
	select aa.Assessment_Id from AGGREGATION_ASSESSMENT aa
	join ASSESSMENTS a on aa.Assessment_Id = a.Assessment_Id
	where Aggregation_Id = @Aggregation_id
	order by a.Assessment_Date
	
	open me

	fetch next from me into @assessment_id
	set @i = 0;
	while(@@FETCH_STATUS = 0)
	begin
	update AGGREGATION_ASSESSMENT set Sequence = @i where Assessment_Id = @assessment_id and Aggregation_Id=@Aggregation_id
	set @i= @i+1
	fetch next from me into @assessment_id
	end 
	close me 
	deallocate me    
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetRelevantAnswers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Returns a table containing ANSWER rows that are relevant
--              to the assessment's current question mode, standard selection and SAL level.
-- =============================================
ALTER PROCEDURE [dbo].[GetRelevantAnswers]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	-- get the application mode
	declare @applicationMode varchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- get currently selected sets
	IF OBJECT_ID('tempdb..#mySets') IS NOT NULL DROP TABLE #mySets
	select set_name into #mySets from AVAILABLE_STANDARDS where Assessment_Id = @assessment_Id and Selected = 1
	
	if(@ApplicationMode = 'Questions Based')	
	begin
		
		select distinct a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id, a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed

			FROM ANSWER a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id			
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
			and a.Is_Requirement = 0
	
	end
	else
	begin		

		select distinct a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed

			from REQUIREMENT_SETS rs
				left join ANSWER a on a.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and a.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level 	

	end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetTop5Areas]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 1/27/2020
-- Description:	get the percentages for each area
-- line up the assessments 
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTop5Areas]
	@Aggregation_id int
AS
BEGIN
/*
set the sequence based on assessment date
get the last two assessments.   Then compute
the percentages for all areas and take the difference
between the two assessments
once the difference is determined sort the the difference
get the top 5 for most improved and the bottom 5 for least improved.
*/
	SET NOCOUNT ON;
	exec usp_setTrendOrder @aggregation_id
    
	

	declare @assessment1 int, @assessment2 int
	set @assessment1 = null;
	set @assessment2 = null; 
	


	--declare @aggregation_id int
	--set @Aggregation_id = 2

	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers
	IF OBJECT_ID('tempdb..#TopBottomType') IS NOT NULL DROP TABLE #TopBottomType
	
	CREATE TABLE #TopBottomType(
	[Question_Group_Heading] [varchar](100) NOT NULL,
	[pdifference] [float] NULL,
	[TopBottomType] [varchar](10) NOT NULL
	)

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	declare me cursor for select Assessment_Id from AGGREGATION_ASSESSMENT where Aggregation_Id = @Aggregation_id
	order by Sequence desc
	Declare @assessment_id int

	open me
	fetch next from me into @assessment_id 
	while(@@FETCH_STATUS = 0)
	begin
		if (@assessment1 is null) set @assessment1 = @assessment_id 

		insert into #answers exec [GetRelevantAnswers] @assessment_id		
		fetch next from me into @assessment_id 
		if(@assessment2 is null ) set @assessment2 = @assessment_id
	end
	close me 
	deallocate me
	
	insert into #TopBottomType(Question_Group_Heading,pdifference,TopBottomType)
	select  
	 assessment1.Question_Group_Heading Question_Group_Heading,
	 assessment1.percentage-assessment2.percentage as pdifference,
	 [TopBottomType] = 'None'
	 from (
	select a.*,b.Total, (isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float) as percentage  from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA' and assessment_id= @assessment1
	group by  Assessment_Id, h.Question_Group_Heading) b on a.assessment_id = b.assessment_id 
	and a.Question_Group_Heading=b.Question_Group_Heading ) assessment1 join (
	
	select a.*,b.Total, (isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float) as percentage  from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA' and assessment_id= @assessment2
	group by  Assessment_Id, h.Question_Group_Heading) b on a.assessment_id = b.assessment_id 
	and a.Question_Group_Heading=b.Question_Group_Heading) assessment2 on assessment1.Question_Group_Heading = assessment2.Question_Group_Heading
	order by pdifference desc

	----------------------------------------------------------
	
		
	update #TopBottomType set TopBottomType = 'BOTTOM' from (
	select top 5 Question_Group_Heading from #TopBottomType order by pdifference) a
	where #TopBottomType.Question_Group_Heading = a.Question_Group_Heading

	update #TopBottomType set TopBottomType = 'TOP' from (
	select top 5 Question_Group_Heading from #TopBottomType 
	where pdifference>=0
	order by pdifference desc) a
	where #TopBottomType.Question_Group_Heading = a.Question_Group_Heading


	select a.*,b.Total, ((isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float))*100 as percentage
	, #TopBottomType.pdifference, TopBottomType , Assessment_Date
	from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA'
	group by  Assessment_Id, h.Question_Group_Heading) b 
	on a.assessment_id = b.assessment_id and a.Question_Group_Heading=b.Question_Group_Heading 
	join #TopBottomType on b.Question_Group_Heading = #TopBottomType.Question_Group_Heading
	join ASSESSMENTS on a.assessment_id = assessments.Assessment_Id
	where #TopBottomType.TopBottomType in ('Top','Bottom')
	order by TopBottomType desc, pdifference desc,Question_Group_Heading, Assessment_Date, Assessment_Id
	
	
	
		
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InScopeQuestions]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Question IDs that are
--              'in scope' for an Assessment.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeQuestions]
	@assessment_id int
AS
BEGIN
select distinct s.Question_Id 
	from NEW_QUESTION_SETS s 
	join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
	where v.Selected = 1 and v.Assessment_Id = @assessment_id 
	and l.Universal_Sal_Level = (
		select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where Assessment_Id = @assessment_id 
	)
END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InScopeRequirements]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Requirement IDs that are
--              'in scope' for an Assessment based on assessment mode,
--              standard selection and SAL.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeRequirements]
	@assessment_id int
AS
BEGIN
select s.Requirement_Id from requirement_sets s 
	join AVAILABLE_STANDARDS av on s.Set_Name=av.Set_Name
	join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
where av.Selected = 1 and av.Assessment_Id = @Assessment_Id
	and rl.Level_Type = 'NST'
	and rl.Standard_Level = (
	select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where Assessment_Id = @assessment_id 
	)	
END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetComparisonBestToWorst]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	NOTE that this needs to be changed
-- to allow for mulitple asssessments just by 
-- passing mulitple id's 
-- =============================================
ALTER PROCEDURE [dbo].[GetComparisonBestToWorst]	
@assessment_id int,
@applicationMode varchar(100) = null
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
			from answer_lookup l, (select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a 
			join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQuestion_Headings h on q.Heading_Pair_Id = h.heading_pair_id
			) b left join 
			(select Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a 
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
			from answer_lookup l, (select * from Answer_Requirements where assessment_id = @assessment_id) a 
			join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id
			join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id = h.Question_Group_Heading_Id
			) b left join 
			(select a.Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Requirements where assessment_id = @assessment_id) a 
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
PRINT N'Creating [dbo].[INSTALLATION]'
GO
CREATE TABLE [dbo].[INSTALLATION]
(
[JWT_Secret] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Generated_UTC] [datetime] NOT NULL,
[Installation_ID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AGGREGATION_ASSESSMENT]'
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [FK__AGGREGATI__Asses__6CC31A31] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [FK__AGGREGATI__Aggre__6EAB62A3] FOREIGN KEY ([Aggregation_Id]) REFERENCES [dbo].[AGGREGATION_INFORMATION] ([AggregationID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AGGREGATION_INFORMATION]'
GO
ALTER TABLE [dbo].[AGGREGATION_INFORMATION] ADD CONSTRAINT [FK_AGGREGATION_INFORMATION_AGGREGATION_TYPES] FOREIGN KEY ([Aggregation_Mode]) REFERENCES [dbo].[AGGREGATION_TYPES] ([Aggregation_Mode])
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
