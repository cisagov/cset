CREATE VIEW [dbo].[vAllQuestionsOnly]
AS
SELECT AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId,Simple_Question AS question, q.Original_Set_Name
FROM     NEW_QUESTION q
UNION
SELECT AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question, r.Original_Set_name
FROM     NEW_REQUIREMENT r
UNION
SELECT AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS question, m.Model_Name as Original_Set_Name 
FROM MATURITY_QUESTIONS mq
JOIN MATURITY_MODELS m on m.Maturity_Model_Id = mq.Maturity_Model_Id
