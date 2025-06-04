CREATE VIEW [dbo].[vAllSimpleQuestions]
AS
SELECT        AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId, Simple_Question AS question
				,h.Question_Group_Heading AS Heading, h.Universal_Sub_Category AS SubHeading
FROM          NEW_QUESTION q JOIN
              vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
UNION
SELECT        AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question,
			  r.Standard_Category AS Heading, 
             r.Standard_Sub_Category AS SubHeading
FROM            REQUIREMENT_QUESTIONS_SETS s JOIN
                         NEW_REQUIREMENT r ON s.Requirement_Id = r.Requirement_Id
UNION
SELECT        AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS queestion, 
			  g.Title AS Heading, Question_Title AS SubHeading
FROM            MATURITY_QUESTIONS q JOIN
                         MATURITY_GROUPINGS g ON q.Grouping_Id = g.Grouping_Id JOIN
                         MATURITY_MODELS m ON q.Maturity_Model_Id = m.Maturity_Model_Id AND g.Maturity_Model_Id = m.Maturity_Model_Id
