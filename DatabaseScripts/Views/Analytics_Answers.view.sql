CREATE VIEW dbo.Analytics_Answers
AS
SELECT Assessment_Id, Question_Or_Requirement_Id, Question_Type, CASE WHEN ANSWER.Answer_Text = 'A' OR
                  ANSWER.Answer_Text = 'Y' THEN N'Y' ELSE 'N' END AS Answer_Text
FROM     dbo.ANSWER
WHERE  (Answer_Text <> 'NA')
