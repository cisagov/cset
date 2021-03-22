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

	declare sse cursor for select Assessment_Id from AGGREGATION_ASSESSMENT where Aggregation_Id = @Aggregation_id
	order by Sequence desc
	Declare @assessment_id int

	open sse
	fetch next from sse into @assessment_id 
	while(@@FETCH_STATUS = 0)
	begin
		if (@assessment1 is null) set @assessment1 = @assessment_id 

		insert into #answers exec [GetRelevantAnswers] @assessment_id		
		fetch next from sse into @assessment_id 
		if(@assessment2 is null ) set @assessment2 = @assessment_id
	end
	close sse 
	deallocate sse
	
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
