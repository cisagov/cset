-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetAreasData]		
@Assessment_Id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @Assessment_Id, @ApplicationMode output

	if(@Assessment_Id is null)  
	begin
		declare @ghq nvarchar(150)
		set @ghq = 'Access Control'
		 select [Assessment_id]=0,Question_Group_Heading=@ghq,    AreasPercent= 0.200000000, Assessment_Date=GETDATE()
		 union
		 select [Assessment_id]=0,Question_Group_Heading='Account Management',AreasPercent= 0.200000000, Assessment_Date=GETDATE()
	end

	if(@ApplicationMode = 'Questions Based')
	begin					
		select [Assessment_Id],[question_group_heading], answer_text,count(answer_text) ac into #TempStats2 from Answer_Questions join 
		(SELECT q.[Question_Id],h.[Question_Group_Heading],[Universal_Sal_Level],s.[Set_Name]
		  FROM NEW_QUESTION q 
		  join NEW_QUESTION_SETS s on q.Question_Id=s.Question_Id
		  join vQuestion_Headings h on q.Heading_Pair_Id=h.heading_pair_Id
		  join (select distinct [Set_Name] from available_standards where selected = 1 and Assessment_Id=@Assessment_Id) a on s.Set_Name=a.Set_Name) main 
		  on answer_questions.question_or_requirement_id = main.Question_Id
		  group by [assessment_id],[question_group_heading],[Answer_Text]

		  
		--YesCount + AlternateCount, TotalCount - NaCount
		select b.[assessment_id], b.question_group_heading, i.Assessment_Date, 
		 (isnull(cast(ynalt as decimal),0)/cast(total as decimal))*100 as AreasPercent from(
		select question_group_heading, sum(ac) as ynalt from #TempStats2
		where answer_text in ('Y','A') and Assessment_Id = @Assessment_Id
		group by question_group_heading) a right join 
		(select question_group_heading, sum(ac) as total    from #TempStats2
		where answer_text not in ('NA') and Assessment_Id = @Assessment_Id
		group by question_group_heading) b on a.Question_Group_Heading = b.question_group_heading
		join INFORMATION i on b.assessment_id = i.id
	end 
	else --- this is either framework or requirement
	begin		
		select [question_group_heading], answer_text,count(answer_text) ac into #TempStats from Answer_Requirements join 
		(SELECT q.[Requirement_Id],[Question_Group_Heading],s.[Set_Name]
		  FROM NEW_REQUIREMENT q join REQUIREMENT_SETS s on q.Requirement_Id=s.Requirement_Id
		  join QUESTION_GROUP_HEADING qgh on q.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
		  join (select distinct [Set_Name] from available_standards where selected = 1) a on s.Set_Name=a.Set_Name) main on answer_Requirements.question_or_requirement_id = main.requirement_id
		  where answer_requirements.assessment_id = @Assessment_Id
		  group by [question_group_heading],[Answer_Text]

		--YesCount + AlternateCount, TotalCount - NaCount
		select b.question_group_heading,i.Assessment_Date, 
		 (isnull(cast(ynalt as decimal),0)/cast(total as decimal))*100 as AreasPercent from(
		select question_group_heading, sum(ac) as ynalt from #Tempstats
		where answer_text in ('Y','A') and assessment_id = @Assessment_Id
		group by question_group_heading) a right join 
		(select question_group_heading, sum(ac) as total from #TempStats
		where answer_text not in ('NA')
		group by question_group_heading) b on a.Question_Group_Heading = b.question_group_heading
		join INFORMATION i on b.assessment_Id = i.Id
	end

END
