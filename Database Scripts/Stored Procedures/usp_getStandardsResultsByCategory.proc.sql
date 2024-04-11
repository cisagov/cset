
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsResultsByCategory]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id, isnull(count(c.question_id),0) qc into #temp	
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id

	insert into #temp (Set_Name, Question_Group_Heading, QC) 
	select a.Set_name,a.Question_Group_Heading, qc=0 from 
	(select * from (select distinct question_group_heading from #temp) a, (select distinct set_name from #temp) b) a 
	left join #temp on a.question_group_heading=#temp.question_group_heading and a.set_name = #temp.set_name
	where #temp.set_name is null

	SELECT s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id, isnull(count(c.question_id),0) qc into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading, question_group_Heading_Id
     
	select t.Set_Name,
	s.Short_Name,
	t.Question_Group_Heading, 
	t.Question_Group_Heading_Id as [QGH_Id],
	isnull(a.qc,0) yaCount, 
	isnull(t.qc,0) Actualcr, 
	round(isnull(cast(a.qc as decimal(18,3))/t.qc,0),5) * 100 [prc]
	from #temp t left join #tempAnswered a on t.Set_Name = a.Set_Name and  t.Question_Group_Heading = a.Question_Group_Heading
	join [SETS] s on t.Set_Name = s.Set_Name
	order by Question_Group_Heading desc	
end
else 
begin 

	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR
	IF OBJECT_ID('tempdb..#TempRAnswer') IS NOT NULL DROP TABLE #TempRAnswer

	SELECT s.set_name, h.Question_Group_Heading, h.Question_Group_Heading_Id, isnull(count(c.Requirement_Id),0) qc into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text <> 'NA'
		group by s.set_name, Question_Group_Heading, h.question_group_heading_id

			/**for multiple sets get the unique list of sets and question_group headers
	   take the cross product 
	   left join and fill with zero
	   Essentially fill in the gaps on the categories
	   */


	insert into #tempR (Set_Name,Question_Group_Heading, QC) 
	select a.Set_name,a.Question_Group_Heading, qc=0 from 
	(select * from (select distinct question_group_heading from #tempR) a, (select distinct set_name from #tempR) b) a 
	left join #tempR on a.question_group_heading=#tempR.question_group_heading and a.set_name = #tempR.set_name
	where #tempR.set_name is null

	SELECT s.set_name, h.Question_Group_Heading, h.question_group_heading_id, count(c.Requirement_Id) qc into #tempRAnswer
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text in ('Y','A')
		group by s.set_name, Question_Group_Heading, h.Question_Group_Heading_Id

	select t.Set_Name, 
	s.Short_Name, 
	t.Question_Group_Heading, 
	t.Question_Group_heading_id as [QGH_Id],
	isnull(a.qc,0) yaCount, 
	isnull(t.qc,0) Actualcr, 
	--isnull(a.qc,0)/cast(t.qc as decimal(18,3)) * 100 [prc]
	round(isnull(cast(a.qc as decimal(18,3))/t.qc,0),5) * 100 [prc]
	from #tempR t 
	left join #tempRAnswer a on t.Set_Name = a.Set_Name and t.Question_Group_Heading = a.Question_Group_Heading
	join [SETS] s on t.Set_Name = s.Set_Name
	order by Question_Group_Heading desc
end
END
