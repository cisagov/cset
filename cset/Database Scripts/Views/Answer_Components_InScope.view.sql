
CREATE VIEW [dbo].[Answer_Components_InScope]
AS
SELECT DISTINCT 
                         a.Assessment_Id, a.Answer_Id, a.Question_Or_Requirement_Id, a.Answer_Text, CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
                         a.Question_Number, q.Simple_Question AS QuestionText, adc.label AS ComponentName, adc.Component_Symbol_Id, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
                         z.Name AS ZoneName, z.Universal_Sal_Level AS SAL, a.Is_Component, a.Component_Guid, a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.Mark_For_Review, a.Is_Requirement, 
                         a.Is_Framework
FROM            dbo.ANSWER AS a INNER JOIN
                         dbo.COMPONENT_QUESTIONS AS cq ON cq.Question_Id = a.Question_Or_Requirement_Id INNER JOIN
                         dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id INNER JOIN
                         dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc ON a.Assessment_Id = adc.Assessment_Id AND adc.Component_Symbol_Id = cq.Component_Symbol_Id LEFT OUTER JOIN
                         dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id 
						 LEFT OUTER JOIN dbo.DIAGRAM_CONTAINER AS z ON z.Assessment_Id = adc.Assessment_Id AND z.Container_Id = adc.Zone_Id
WHERE        (a.Is_Component = 1) AND (COALESCE (l.Visible, 1) = 1)
