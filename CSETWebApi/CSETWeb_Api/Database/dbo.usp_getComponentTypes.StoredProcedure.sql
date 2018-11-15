USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[usp_getComponentTypes]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	remember the answer values are percents
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentTypes]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	


	SELECT Assessment_Id,component_type,isNull(Total,0) as Total, 
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],			
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(	
			select Assessment_Id,component_type, isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id,component_type) AS Total  
			from (select diagram_component_type, answer_text from ANSWER_LOOKUP a, assessment_diagram_components c
			where c.assessment_id = @assessment_id) aw left join (
			select assessment_id, c.Component_Type,a.answer_text, count(a.answer_text) acount from NEW_QUESTION s 
			join COMPONENT_QUESTIONS c on s.Question_id= c.Question_Id			
			join answer_components a on s.Question_Id = a.question_or_requirement_id
			where a.assessment_id=@assessment_id
			group by assessment_id,Component_Type, a.answer_text) B on aw.Answer_Text = b.answer_text and aw.diagram_component_type = b.Component_Type
			where component_type is not null
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.Component_Type;
END
GO
