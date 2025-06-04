
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getOverallRankedCategories]
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
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id,Assessment_Id from NEW_QUESTION_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Question_Id = s.Question_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT h.Question_Group_Heading,
		h.Question_Group_Heading_Id as [QGH_Id],
		isnull(count(c.question_id),0) qc,  
		isnull(SUM(@maxRank-c.Ranking),0) cr, 
		sum(sum(@maxrank - c.Ranking)) OVER() AS Total 
		into #temp
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)
		s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading, Question_Group_Heading_id
     
	 SELECT h.Question_Group_Heading, 
		h.Question_Group_Heading_Id as [QGH_Id],
		isnull(count(c.question_id),0) nuCount, 
		isnull(SUM(@maxRank-c.Ranking),0) cr 
		into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)	s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading, Question_Group_Heading_Id

	select t.*, 
	isnull(a.nuCount,0) nuCount, 
	isnull(a.cr,0) Actualcr, 
	Round(isnull(cast(a.cr as decimal(18,3))/Total,0)*100,2) [prc],  
	isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
else 
begin 
	select @maxRank = max(c.Ranking) 
		FROM NEW_REQUIREMENT c 
		join (select distinct requirement_id,Assessment_Id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id=s.Requirement_Id
		where s.Assessment_Id = @assessment_id 
	
	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR
	IF OBJECT_ID('tempdb..#TempRAnswered') IS NOT NULL DROP TABLE #TempRAnswered

	SELECT h.Question_Group_Heading,
	h.Question_Group_Heading_Id as [QGH_Id],
	count(c.Requirement_Id) qc,  
	SUM(@maxRank-c.Ranking) cr, 
	sum(sum(@maxrank - c.Ranking)) OVER() AS Total
	into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1 and v.assessment_id = @assessment_id)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading, h.Question_Group_Heading_Id

	SELECT h.Question_Group_Heading,
	h.Question_Group_Heading_Id as [QGH_Id],
	isnull(count(c.requirement_id),0) nuCount,
	SUM(@maxRank-c.Ranking) cr
	into #tempRAnswered
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1 and v.assessment_id = @assessment_id)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading, h.Question_Group_Heading_Id

	select t.*, 
	isnull(a.nuCount,0) nuCount, 
	isnull(a.cr,0) Actualcr, 	
	ROUND(isnull(cast(a.cr as decimal(18,3))/Total,0)*100,2) [prc],  
	isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #tempR t left join #tempRAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
END
