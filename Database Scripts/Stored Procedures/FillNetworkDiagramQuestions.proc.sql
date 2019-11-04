-- =============================================
-- Author:		hansbk
-- Create date: 9/27/2019
-- Description:	calll to get defaults
-- =============================================
CREATE PROCEDURE [dbo].[FillNetworkDiagramQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

	  delete a from ANSWER a 
		left join (SELECT distinct q.question_id 
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
				join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id
				join new_question_sets qs on nq.question_id=qs.question_id		
				left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
				where a.assessment_id = @assessment_id and qs.Set_Name = 'Components') b on a.Question_Or_Requirement_Id = b.Question_Id and a.Assessment_Id = @assessment_id
		where b.Question_Id is null and Is_Component = 1 and Assessment_Id = @assessment_id 

    /*Rules for Component questions
	For the default questions 
	select the set of component types and questions associated with the component types
	then insert an answer for each unique question in that list. 
	this needs filterd for level

	the major dimensions are 
	*/
	--generate defaults 
	INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])   	  		
		select Is_Requirement = 0,Question_id, Answer_Text = 'U', Is_Component = '1', Is_Framework = 0, Assessment_Id = @Assessment_Id 
		from (select * from [ANSWER] where [Assessment_Id] = @assessment_id and [IS_COMPONENT] = 1) a 		
		right join 
		(SELECT distinct q.question_id 
		FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
		join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
		join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
		join new_question nq on q.question_id=nq.question_id
		join new_question_sets qs on nq.question_id=qs.question_id		
		left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
		join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
		where a.assessment_id = @assessment_id and qs.Set_Name = 'Components'
		) t 		
		on a.Question_Or_Requirement_Id = t.question_id
		where assessment_id is null
		and Question_Or_Requirement_Id not in 
		(select [Question_Or_Requirement_Id] from [ANSWER] where [Assessment_Id] = @assessment_id and [Component_Guid] = CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER))
END

