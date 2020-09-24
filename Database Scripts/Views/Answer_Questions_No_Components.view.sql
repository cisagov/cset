CREATE VIEW [dbo].[Answer_Questions_No_Components]
AS
SELECT        Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, Is_Framework, Reviewed, 
                         FeedBack, Custom_Question_Guid, Old_Answer_Id
FROM            dbo.ANSWER
WHERE        (Is_Requirement = 0) AND (Is_Component = 0)
