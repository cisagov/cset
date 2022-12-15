--This is the transaction that will transfer all comments, documents, and feedback to parent question
BEGIN TRAN;

INSERT INTO ANSWER (Assessment_Id, Question_Or_Requirement_Id, Comment, Alternate_Justification, FeedBack, Question_Type)
	SELECT Assessment_Id, Parent_Question_Id, STRING_AGG(Comment, ' / '), STRING_AGG(Alternate_Justification, ' / '), STRING_AGG(FeedBack, ' / '), Question_Type
	FROM ANSWER
	JOIN MATURITY_QUESTIONS ON Question_Or_Requirement_Id = Mat_Question_Id WHERE Parent_Question_Id IS NOT NULL AND (Comment IS NOT NULL OR Alternate_Justification IS NOT NULL OR FeedBack IS NOT NULL)
	GROUP BY Parent_Question_Id, Assessment_Id, Question_Type;

--Making sure Parent question is marked for review if any of child questions are marked
UPDATE ANSWER
SET Mark_For_Review = 1
WHERE Question_Or_Requirement_Id IN (SELECT q.Parent_Question_Id FROM ANSWER AS a
JOIN MATURITY_QUESTIONS AS q ON a.Question_Or_Requirement_Id = Mat_Question_Id WHERE q.Parent_Question_Id IS NOT NULL AND a.Mark_For_Review = 1);

--Moving Documents from child questions into their respective parents
SELECT Document_Id, a.Answer_Id, a.Question_Or_Requirement_Id, q.Mat_Question_Id, q.Parent_Question_Id
	INTO #TempDocTable 
	FROM DOCUMENT_ANSWERS as d
	JOIN ANSWER AS a ON a.Answer_Id = d.Answer_Id
	JOIN MATURITY_QUESTIONS as q ON q.Mat_Question_Id = a.Question_Or_Requirement_Id

INSERT INTO DOCUMENT_ANSWERS (Document_Id, Answer_Id)
SELECT d.Document_Id, a.Answer_Id FROM #TempDocTable AS d
JOIN MATURITY_QUESTIONS AS q ON d.Parent_Question_Id = q.Mat_Question_Id
JOIN ANSWER AS a ON q.Mat_Question_Id = a.Question_Or_Requirement_Id

DROP TABLE #TempDocTable

COMMIT TRAN;