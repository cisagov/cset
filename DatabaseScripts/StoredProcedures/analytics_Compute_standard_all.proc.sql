-- =============================================
-- Author:		Barry H
-- Create date: 4-19-2022
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_standard_all]
	@assessment_id int, --default assessment_id the mode will be pulled from this assessment
	@set_name nvarchar(20), --this is the standard set name key
	@sector_id int,
	@industry_id int	
AS
BEGIN
	SET NOCOUNT ON;
	declare @ApplicationMode nvarchar(20)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

if(@ApplicationMode = 'Questions Based')	
begin
	
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2

	---This is step 1 get the base data
	
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
		and nullif(@sector_id,sectorid) is null
		and nullif(@industry_id,industryid) is null
	group by a.assessment_id, Question_Group_Heading, Answer_Text 
	order by Question_Group_Heading, Assessment_Id

	insert #temp
	select	assessment_id=@assessment_id,
	a.Question_Group_Heading,Answer_Text='Y',qc=0
	from (
	select Question_Group_Heading	FROM  
	NEW_QUESTION c 
	join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
	join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id			
	where  s.Set_Name = @set_name
	group by Question_Group_Heading) A left join #temp b on a.Question_Group_Heading=b.Question_Group_Heading
	where b.Question_Group_Heading is null

	--this is step 2 calculate percentages and group up by assessment id and question group
	select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage] into #temp2
	from (		
		select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
		from #temp
		group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a

	--this is step 3 fix the outside cases where the answers are either all no or all yes
	--case 100% No
	--case 100% Yes
	--case mixed yes and no
	insert #temp2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage]=0 from #temp2 where Answer_Text = 'N' and qc=total
	insert #temp2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage] from #temp2 where Answer_Text = 'Y' 


	--finally step 4 give me the answers with the calculated median
	 select a.QUESTION_GROUP_HEADING, a.minimum, a.maximum, a.average, b.median--, b.rown 
          from 
          (
                 select QUESTION_GROUP_HEADING, minimum, maximum, average 
                 from (
                                    select question_group_heading, round((ISNULL(min([percentage]),0) *100),1) minimum, 
                                       round((ISNULL(max(percentage),0) *100),1) maximum, 
                                       round((ISNULL(AVG(percentage),0) *100),1) average
                                       from #Temp2
                                       group by Question_Group_Heading
                 ) qryA
          ) a
          join
          (
                 select QUESTION_GROUP_HEADING, median, rown 
                 from 
                 (
                         select QUESTION_GROUP_HEADING, 
                                    isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [percentage]) OVER (PARTITION BY Question_Group_Heading),0) AS median,
                                   ROW_NUMBER() OVER (PARTITION BY question_group_heading ORDER BY question_group_heading) rown
                         from (
                                           select question_group_heading, 
                                                  round((ISNULL([percentage],0) *100),0) [percentage]
                                              from #Temp2
                         ) qry
                 ) qryB
                 where rown = 1
          ) b ON a.QUESTION_GROUP_HEADING = b.QUESTION_GROUP_HEADING
end
else 
begin 
	IF OBJECT_ID('tempdb..#tempR') IS NOT NULL DROP TABLE #tempR	 
	IF OBJECT_ID('tempdb..#tempR2') IS NOT NULL DROP TABLE #tempR2	 

	
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
			and nullif(@sector_id,sectorid) is null
			and nullif(@industry_id,industryid) is null
	group by a.assessment_id, Standard_Category, Answer_Text
	order by Question_Group_Heading, Assessment_Id

	insert #tempR
	select	assessment_id=@assessment_id,
	a.Question_Group_Heading,Answer_Text='Y',qc=0
	from (
	select distinct STANDARD_CATEGORY as Question_Group_Heading	FROM  
	NEW_REQUIREMENT c
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id			
	where  s.Set_Name = @set_name
	group by Standard_Category) A left join #tempR b on a.Question_Group_Heading=b.Question_Group_Heading
	where b.Question_Group_Heading is null






	select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage] into #tempR2
	from (		
		select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
		from #tempR
		group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a

	--case 100% No
	--case 100% Yes
	--case mixed yes and no
	insert #tempR2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage]=0 from #tempR2 where Answer_Text = 'N' and qc=total
	insert #tempR2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage] from #tempR2 where Answer_Text = 'Y' 


  select a.QUESTION_GROUP_HEADING, a.minimum, a.maximum, a.average, b.median--, b.rown 
          from 
          (
				select question_group_heading, round((ISNULL(min([percentage]),0) *100),1) minimum, 
                round((ISNULL(max(percentage),0) *100),1) maximum, 
                round((ISNULL(AVG(percentage),0) *100),1) average
                from #tempR2
                group by Question_Group_Heading          
          ) a
          left join
          (
                 select QUESTION_GROUP_HEADING, median, rown 
                 from 
                 (
                         select QUESTION_GROUP_HEADING, 
                                    isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [percentage]) OVER (PARTITION BY Question_Group_Heading),0) AS median,
                                    ROW_NUMBER() OVER (PARTITION BY question_group_heading ORDER BY question_group_heading) rown
                         from (
                                           select question_group_heading, 
                                                  round((ISNULL([percentage],0) *100),0) [percentage]
                                              from #tempR2
                         ) qry
                 ) qryB
                 where rown = 1
          ) b ON a.QUESTION_GROUP_HEADING = b.QUESTION_GROUP_HEADING
end
END



