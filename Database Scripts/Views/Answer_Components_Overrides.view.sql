SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[Answer_Components_Overrides]
AS
/**
retreives only overriden component answers
so it is the same normal query but only returns 
those records where component guid is not null
*/
select * from answer_components_exploded where Answer_Id is not null

/*SELECT   distinct                
	-- This guarantees a unique column to key on in the model
	CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, nq.Simple_Question AS QuestionText, 		
	h.Question_Group_Heading, h.Universal_Sub_Category,
	a.Is_Component, adc.Component_Guid, 
	dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,
	nq.heading_pair_id, h.Sub_Heading_Question_Description,
	nq.Simple_Question,
	a.Reviewed, adc.Diagram_Component_Type, adc.label,

from   [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
		join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id				
		join component_questions q on adc.Diagram_Component_Type = q.Component_Type				
		join new_question nq on q.question_id=nq.question_id		
		join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
		join dbo.DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
		left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
		join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
		and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))				        
		join dbo.vQUESTION_HEADINGS h on nq.Heading_Pair_Id = h.Heading_Pair_Id			    
		join Answer_Components AS a on q.Question_Id = a.Question_Or_Requirement_Id and ss.assessment_id = a.assessment_id	  
		where l.visible=1 and a.Component_Guid <> '00000000-0000-0000-0000-000000000000'*/
GO


