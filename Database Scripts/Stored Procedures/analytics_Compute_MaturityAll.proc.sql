-- =============================================
-- Author:		Luke G, Lilly, Barry
-- Create date: 4-6-2022
-- Description:	18 stored procedures for analytics. 
-- This procedure returns the AVG, MIN, MAX, MEDIAN Question Group Heading for the Question_Type 'Maturity' for all sectory and industry. 
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturityAll]
@maturity_model_id int,
@sector_id int,
@industry_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--test base case where there is no data in db at all
--test case where the data is ther
--need to address the cases where all no, all yes, and mixed
--next steps the base data is there but the lower data(median) is not
--need to determine why it is not there
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2
	IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL DROP TABLE #Temp3

--step 1 get the base data
select a.Assessment_Id,Question_Group, Answer_Text, isnull(COUNT(a.answer_text),0) Answer_Count, 
		sum(isnull(count(answer_text),0)) OVER(PARTITION BY a.assessment_id,question_group) AS Total	
		,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id,question_group),0),1)))*100,0),0) as int)  as [Percentage] 
		into #temp
		from [Analytics_Answers] a	
		join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
		join ANALYTICS_MATURITY_GROUPINGS g on q.Mat_Question_Id=g.Maturity_Question_Id
		left join demographics d on a.assessment_id = d.assessment_id
		where a.question_type = 'Maturity' and q.Maturity_Model_Id=@maturity_model_id and g.Maturity_Model_Id=@maturity_model_id
			and nullif(@sector_id,sectorid) is null
			and nullif(@industry_id,industryid) is null
		group by a.assessment_id, Question_Group, Answer_Text
--step 2 handle the cases where we have all yes, all no, and mixed
	--get the yes and mixed case
	select * into #temp2 from #temp where answer_text='Y'
	--get the all no case
	insert #temp2
	select assessment_id,QUESTION_GROUP,Answer_Text='Y',Answer_Count,total, [percentage]=0 from #temp where Answer_Text = 'N' and Answer_Count=total
--step 3 calculate the min,max,avg
	select G1.Question_Group as Question_Group_Heading, min(isnull([percentage],0)) [minimum],max(isnull([percentage],0)) [maximum],avg(isnull([percentage],0)) [average] 
	into #temp3
	from
	(	
		select distinct Question_Group from ANALYTICS_MATURITY_GROUPINGS where Maturity_Model_Id = @maturity_model_id
	) G1 LEFT OUTER JOIN #temp2 G2 ON G1.Question_Group = G2.Question_Group 
	group by G1.Question_Group
--step 4 add median
	select a.Question_Group_Heading,cast(a.minimum as float) as minimum,cast(a.maximum as float) as maximum,cast(a.average as float) as average,isnull(b.median,0) as median from
	#temp3 a left join 
	(
	select distinct Question_Group as Question_Group_Heading		
	,isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [Percentage]) OVER (PARTITION BY question_group),0) AS median	
	from #temp2) b on a.Question_Group_Heading=b.Question_Group_Heading
	order by a.Question_Group_Heading
end
