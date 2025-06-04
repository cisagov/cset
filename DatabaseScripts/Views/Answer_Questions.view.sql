


CREATE VIEW [dbo].[Answer_Questions]
AS
SELECT	Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
              Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, 
              Is_Framework, FeedBack
FROM	Answer_Standards_InScope
WHERE	mode = 'Q'

