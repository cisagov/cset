SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[Answer_Components_Default]
AS

SELECT distinct Assessment_Id, Question_Id, Question_Number, QuestionText, SAL, 
	Answer_Id, Answer_Text, Comment, Alternate_Justification, Mark_For_Review
	from answer_components_exploded
GO

