

CREATE VIEW [dbo].[Answer_Maturity]
AS
SELECT 
	a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, 
	a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, 
	a.Component_Guid, a.Is_Component, a.Is_Framework, a.Is_Maturity,
    a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.FeedBack, q.Maturity_Level, q.Question_Text
FROM       [ANSWER] a
LEFT JOIN  [MATURITY_QUESTIONS] q on q.Mat_Question_Id = a.Question_Or_Requirement_Id
LEFT JOIN  [ASSESSMENT_SELECTED_LEVELS] l on l.Assessment_Id = a.Assessment_Id and l.Standard_Specific_Sal_Level = q.Maturity_Level and l.Level_Name = 'Maturity_Level'
WHERE      a.Is_Maturity = 1
