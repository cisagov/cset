

CREATE VIEW [dbo].[Answer_Components_Exploded]
AS

SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) as UniqueKey,
	a.Assessment_Id, b.Answer_Id, a.Question_Id, isnull(b.Answer_Text, c.Answer_Text) as Answer_Text, 
	CONVERT(nvarchar(1000), b.Comment) AS Comment, CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification, 
	b.FeedBack,
	b.Question_Number, a.Simple_Question AS QuestionText, 	
	a.label AS ComponentName, a.Symbol_Name, 
	a.Question_Group_Heading, a.GroupHeadingId, 
	a.Universal_Sub_Category, a.SubCategoryId, 
	isnull(b.Is_Component,1) as Is_Component, a.Component_Guid, 
	a.Layer_Id, a.LayerName, a.Container_Id, 
	a.ZoneName, dbo.convert_sal(a.SAL) as SAL, 
	b.Mark_For_Review, Is_Requirement=cast(0 as bit), Is_Framework=cast(0 as bit),
	b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description, a.heading_pair_id, a.label, a.Component_Symbol_Id
from (
SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	adc.Assessment_Id, q.Question_Id, q.Simple_Question,
	adc.label, adc.Component_Symbol_Id, 
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
	z.Name AS ZoneName,  dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
	h.Sub_Heading_Question_Description,h.Heading_Pair_Id, cs.Symbol_Name
from	 dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc
			join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
			join dbo.COMPONENT_QUESTIONS AS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id			
			join dbo.COMPONENT_SYMBOLS as cs on adc.Component_Symbol_Id = cs.Component_Symbol_Id
            join dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 			
            join dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id  
            left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id and adc.Assessment_Id=adc.Assessment_Id
			join (select s.*,nql.Universal_Sal_Level from NEW_QUESTION_SETS s
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id
			where set_name = 'Components' ) s on q.Question_Id = s.Question_Id and s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))		
			left join dbo.vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id
			left join dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id
			 
WHERE l.Visible = 1) a left join Answer_Components AS b on a.Question_Id = b.Question_Or_Requirement_Id and a.Assessment_Id = b.Assessment_Id and a.component_guid = b.component_guid
left join (SELECT a.Assessment_Id, q.Question_Id, a.Answer_Text		
from   (SELECT distinct q.question_id,adc.assessment_id
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'						
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)) as f  
            join dbo.NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 			
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000') c on a.Assessment_Id=c.Assessment_Id and a.Question_Id = c.Question_Id




