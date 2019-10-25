SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[Answer_Questions]
AS
SELECT        Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
                         Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, 
                         Is_Framework, FeedBack
FROM            dbo.ANSWER
WHERE        (Is_Requirement = 0)

GO


