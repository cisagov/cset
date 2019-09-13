SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Answer_Components_Exploded]
AS

SELECT                   
	CONCAT(adc.Assessment_Id, '-', q.Question_Id, '-', ISNULL(a.Component_Id,0)) as primarykey,
	adc.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, q.Simple_Question AS QuestionText, 
	adc.label AS ComponentName, adc.Diagram_Component_Type AS Component_Type, a.Is_Component, a.Component_Id, a.Component_Guid, 
	adc.Layer_Id, l.Layer_Name AS LayerName, z.Zone_Id, 
	z.Zone_Name AS ZoneName, ISNULL(z.Universal_Sal_Level, dbo.convert_sal(ss.Selected_Sal_Level)) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework
from     dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc 
join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
join     dbo.COMPONENT_QUESTIONS AS cq ON adc.Diagram_Component_Type = cq.Component_Type			
            join dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 
			join NEW_QUESTION_SETS s on q.Question_Id=s.Question_Id
            join dbo.DIAGRAM_LAYERS AS l ON adc.Layer_Id = l.Layer_Id  
            left join dbo.DIAGRAM_ZONES AS z ON z.Zone_Id = adc.Zone_Id
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = ISNULL(z.Universal_Sal_Level, dbo.convert_sal(ss.Selected_Sal_Level))
			left join Answer_Components AS a on q.Question_Id=a.Question_Or_Requirement_Id and a.Assessment_Id=adc.Assessment_Id
WHERE l.Visible= 1 
GO