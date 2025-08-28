CREATE VIEW [dbo].[Answer_Components]
AS
SELECT a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, a.Component_Guid, a.Is_Component, a.Is_Framework, 
                  a.Reviewed, a.FeedBack, q.Simple_Question AS QuestionText
FROM     dbo.ANSWER AS a INNER JOIN
                  dbo.NEW_QUESTION AS q ON q.Question_Id = a.Question_Or_Requirement_Id
WHERE  (a.Is_Requirement = 0) AND (a.Is_Component = 1)
