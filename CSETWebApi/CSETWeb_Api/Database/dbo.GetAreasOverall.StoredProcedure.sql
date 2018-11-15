USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[GetAreasOverall]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetAreasOverall]		
@Assessment_Id int,
@applicationMode varchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output
	if(@Assessment_Id is null)  
	begin
		declare @ghq varchar(150)
		set @ghq = 'Access Control'
		declare @value float 
		set @value = 1.0001;
		SELECT Question_group_heading=@ghq,Total=0, 
					[Y] = 0,
					[YValue] = @value,
					[N] = 0,
					[NValue] = @value,
					[NA] = 0,
					[NAValue] = @value,
					[A] = 0,
					[AValue] = @value,
					[U] = 0,
					[UValue] = @value,
					Value = @value,
					TotalNoNA = 0 
	end

	
	if(@ApplicationMode = 'Questions Based')	
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						isnull([Y],0) as [Y],
						isnull(cast([Y] as float)/isnull(nullif(Total-[NA],0),1),0) as [YValue],
						isnull([N],0) as [N],
						isnull(cast([N] as float)/isnull(nullif(Total-[NA],0),1),0) as [NValue],
						isnull([NA],0) as [NA],
						isnull(cast([NA] as float)/nullif(Total,1),0) as [NAValue],
						isnull([A],0) as [A],
						isnull(cast([A] as float)/isnull(nullif(Total-[NA],0),1),0) as [AValue],
						isnull([U],0) as [U],
						isnull(cast([U] as float)/isnull(nullif(Total-[NA],0),1),0) as [UValue],
						(cast((isnull([Y],0)+isnull([A],0)) as float)/isnull(nullif(Total-isnull([NA],0),0),1))*100 as Value,
						isnull(cast(isnull(Total-isnull([NA],0),0) as int),0) as TotalNoNA 
			from
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, isnull(count(a.question_or_requirement_id),0) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Questions] where assessment_id = @Assessment_Id)  a   
				  join (select Question_Or_Requirement_Id from answer_Questions where assessment_Id = @Assessment_Id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
				   join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
				   group by Question_Group_Heading, Answer_Text			   
	   ) p
			PIVOT
			(
			sum(acount)
			FOR Answer_Text IN
			( [Y],[N],[NA],[A],[U] )
			) AS pvt
			ORDER BY question_group_heading;
	else
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						isnull([Y],0) as [Y],
						isnull(cast([Y] as float)/isnull(nullif(Total-[NA],0),1),0) as [YValue],
						isnull([N],0) as [N],
						isnull(cast([N] as float)/isnull(nullif(Total-[NA],0),1),0) as [NValue],
						isnull([NA],0) as [NA],
						isnull(cast([NA] as float)/nullif(Total,1),0) as [NAValue],
						isnull([A],0) as [A],
						isnull(cast([A] as float)/isnull(nullif(Total-[NA],0),1),0) as [AValue],
						isnull([U],0) as [U],
						isnull(cast([U] as float)/isnull(nullif(Total-[NA],0),1),0) as [UValue],
						(cast((isnull([Y],0)+isnull([A],0)) as float)/isnull(nullif(Total-isnull([NA],0),0),1))*100 as Value,
						isnull(cast(isnull(Total-isnull([NA],0),0) as int),0) as TotalNoNA 
			FROM 
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Requirements] where assessment_id = @Assessment_Id)  a   
				  join (select Question_Or_Requirement_Id from answer_Requirements where assessment_id = @Assessment_Id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
				   join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id=h.Question_Group_Heading_Id
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
GO
