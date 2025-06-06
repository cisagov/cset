-- =============================================
-- Author:		Barry
-- Create date: 4/21/2022
-- Description:	average for maturity model
-- =============================================
CREATE PROCEDURE [dbo].[analytics_compute_single_averages_standard]
	@assessment_id int,
	@set_name nvarchar(20)
AS
BEGIN
SET NOCOUNT ON;
	declare @ApplicationMode nvarchar(20)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

if(@ApplicationMode = 'Questions Based')	
begin
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp	 
	
	select a.Assessment_Id,Question_Group_Heading, Answer_Text,count(answer_text) qc into #temp
	FROM Analytics_Answers a 
	join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
	join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
	join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id			
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Question' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name
			and a.Assessment_Id = @assessment_id
	group by a.assessment_id, Question_Group_Heading, Answer_Text 
	order by Question_Group_Heading, Assessment_Id

	select 
	all1.Question_Group_Heading,	
	round((ISNULL(all2.percentage,0) *100),0) average 
	from (
	select distinct Question_Group_Heading,[percentage] = 0
	FROM NEW_QUESTION c 
	join vQUESTION_HEADINGS h on c.Heading_Pair_Id=h.Heading_Pair_Id
	join NEW_QUESTION_SETS s on c.Question_Id=s.Question_Id
	where Set_Name = @set_name)
		all1 left join (		
			select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage]
			from (		
				select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
				from #temp
				group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a
		where answer_text = 'Y'		
	) all2 on all1.Question_Group_Heading=all2.Question_Group_Heading
end
else 
begin 
	IF OBJECT_ID('tempdb..#tempR') IS NOT NULL DROP TABLE #tempR	 

	
	select a.Assessment_Id,Standard_Category as Question_Group_Heading, Answer_Text
	,count(answer_text) qc into #tempR
	FROM Analytics_Answers a 
	join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id	
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Requirement' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name			
			and a.assessment_id= @assessment_id
	group by a.assessment_id, Standard_Category, Answer_Text
	order by Question_Group_Heading, Assessment_Id

	select 
	all1.Question_Group_Heading,	
	round((ISNULL(all2.[percentage],0) *100),0) [percentage]
	from (
	select distinct Standard_Category as Question_Group_Heading, [Percentage] = 0
	FROM NEW_REQUIREMENT c 
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id	
	where Set_Name = @set_name)
		all1 left join (		
			select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage]
			from (		
				select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
				from #tempR
				group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a
		where answer_text = 'Y')
	 all2 on all1.Question_Group_Heading=all2.Question_Group_Heading
end
END
