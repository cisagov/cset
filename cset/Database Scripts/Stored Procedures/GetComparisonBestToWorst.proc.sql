-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	NOTE that this needs to be changed
-- to allow for mulitple asssessments just by 
-- passing mulitple id's 
-- =============================================
CREATE PROCEDURE [dbo].[GetComparisonBestToWorst]	
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
		NaValue =  Round(((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100),2),
		NoCount = [N],
		NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		TotalCount = Total,
		TotalValue = Total,
		UnansweredCount =[U],
		UnansweredValue = Round((cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1)),0),0) as int))*100,2),
		YesCount = [Y],
		YesValue =  Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value = Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.assessment_id,f.Alias,b.Question_Group_Heading,b.Answer_Text,isnull(c.Value,0) as Value ,Total =sum(c.Value) over(partition by b.assessment_id,b.question_group_heading)
			from 
			 (select distinct Assessment_Id,Question_Group_Heading, l.answer_Text
			from answer_lookup l,(select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a 
			join NEW_QUESTION q on a.Question_Or_Requirement_Id=q.Question_Id
			join vQuestion_Headings h on q.Heading_Pair_Id=h.heading_pair_id
			) b left join 
			(select Assessment_Id,Question_Group_Heading,a.Answer_Text, count(a.answer_text) as Value
				from (select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a join NEW_QUESTION q on a.Question_Or_Requirement_Id=q.Question_Id
				join vQuestion_Headings h on q.Heading_Pair_Id=h.heading_pair_id
			 group by Assessment_Id,Question_Group_Heading,a.Answer_Text) c
			 on b.Assessment_Id=c.Assessment_Id and b.Question_Group_Heading=c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
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
		UnansweredCount =[U],
		UnansweredValue = Round((cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1)),0),0) as int))*100,2),
		YesCount = [Y],
		YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value =Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id,f.Alias,b.Question_Group_Heading,b.Answer_Text,isnull(c.Value,0) as Value ,Total =sum(c.Value) over(partition by b.Assessment_Id,b.question_group_heading)			
			from 
			 (select distinct a.[Assessment_Id],h.Question_Group_Heading, l.answer_Text
			from answer_lookup l,Answer_Requirements a 
			join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id=q.Requirement_Id
			join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id=h.Question_Group_Heading_Id) b left join 
			(select a.Assessment_Id,Question_Group_Heading,a.Answer_Text, count(a.answer_text) as Value
				from Answer_Requirements a join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id=q.Requirement_Id
				join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id=h.Question_Group_Heading_Id
			 group by Assessment_Id,Question_Group_Heading,a.Answer_Text) c
			 on b.Assessment_Id=c.Assessment_Id and b.Question_Group_Heading=c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p
		PIVOT
		(
			sum(value)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
END
