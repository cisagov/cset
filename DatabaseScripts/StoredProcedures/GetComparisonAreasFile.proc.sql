-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetComparisonAreasFile]		
@assessment_id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	if(@assessment_id is null)  
	begin
		declare @ghq nvarchar(150), @alias nvarchar(255)
		set @ghq = 'Access Control'
		set @alias = 'Test'
		SELECT Alias=@alias,Question_group_heading=@ghq,Total=0, 
					[Y]=cast(1.0000001 as float),
					[N]=cast(1.0000001 as float),
					[NA]=cast(1.0000001 as float),
					[A]=cast(1.0000001 as float),
					[U]=cast(1.0000001 as float),
					Value=cast(1.0000001 as float),
					TotalNoNA=0 
	end

	if(@ApplicationMode = 'Questions Based')
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						cast(IsNull(cast(([Y]) as float)/isnull(nullif(Total,0),1),0) as float) as [Y],
						cast(IsNull(cast(([N]) as float)/isnull(nullif(Total,0),1),0) as float) as [N],
						cast(IsNull(cast(([NA]) as float)/isnull(nullif(Total,0),1),0) as float) as [NA],
						cast(IsNull(cast(([A]) as float)/isnull(nullif(Total,0),1),0) as float) as [A],
						cast(IsNull(cast(([U]) as float)/isnull(nullif(Total,0),1),0) as float) as [U],					
						cast(isnull([Y],0)+isnull([A],0) as float)/cast(isnull(nullif(Total-isnull([NA],0),0),1) as float) as Value, 										
						(Total-isnull([NA],0)) as TotalNoNA 
			FROM 
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Questions] where assessment_id = @assessment_id) a   
				  join (select Question_Or_Requirement_Id from answer_questions where assessment_id = @assessment_id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
				   join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_id
				   join ASSESSMENTS f on a.assessment_id=f.Assessment_Id
				   group by Question_Group_Heading, Answer_Text
	   ) p
			PIVOT
			(
			sum(acount)
			FOR Answer_Text IN
			( [Y],[N],[NA],[A],[U] )
			) AS pvt
			ORDER BY question_group_heading;
	else--this is requirement and framework
			SELECT Question_group_heading,isNull(Total,0) as Total, 
						cast(IsNull(cast(([Y]) as float)/isnull(nullif(Total,0),1),0) as float) as [Y],
						cast(IsNull(cast(([N]) as float)/isnull(nullif(Total,0),1),0) as float) as [N],
						cast(IsNull(cast(([NA]) as float)/isnull(nullif(Total,0),1),0) as float) as [NA],
						cast(IsNull(cast(([A]) as float)/isnull(nullif(Total,0),1),0) as float) as [A],
						cast(IsNull(cast(([U]) as float)/isnull(nullif(Total,0),1),0) as float) as [U],					
						cast(isnull([Y],0)+isnull([A],0) as float)/cast(isnull(nullif(Total-isnull([NA],0),0),1) as float) as Value, 										
						(Total-isnull([NA],0)) as TotalNoNA 
		FROM 
		(
			SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
			  FROM (select * from [answer_requirements] where assessment_Id=@assessment_id)  a   
			  join (select Question_Or_Requirement_Id from answer_requirements where assessment_id =@assessment_id) b
			   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
			   join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_id
			   join QUESTION_GROUP_HEADING h on h.Question_Group_Heading_Id = c.Question_Group_Heading_Id
			   join ASSESSMENTS f on a.assessment_id=f.Assessment_Id
			   group by Question_Group_Heading, Answer_Text
 ) p
		PIVOT
		(
		sum(acount)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		ORDER BY question_group_heading;

END
