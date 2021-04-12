



/**
The default consists of one one question 
joined on the types in the diagram
filtered by level 
left joined by the answers
*/
CREATE VIEW [dbo].[Answer_Components_Default]
AS

SELECT                   
	-- This guarantees a unique column to key on in the model
	CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, q.Simple_Question AS QuestionText, 		
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	a.FeedBack,
	a.Is_Component, a.Component_Guid, 
	dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,	
	q.heading_pair_id, h.Sub_Heading_Question_Description,
	q.Simple_Question, 
	a.Reviewed, label = null, ComponentName = null, Symbol_Name = null, Component_Symbol_id = 0
from   STANDARD_SELECTION ss
		 join 
		 (SELECT distinct q.question_id,adc.assessment_id
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
				join dbo.DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
				left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
				where l.visible = 1) as f  on ss.assessment_id=f.assessment_id							
            join dbo.NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 
			join dbo.vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			join dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000'
--order by question_group_heading,universal_sub_category
