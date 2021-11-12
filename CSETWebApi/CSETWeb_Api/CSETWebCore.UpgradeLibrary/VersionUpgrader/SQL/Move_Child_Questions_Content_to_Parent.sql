SELECT a.*,q.* FROM ANSWER as a
JOIN MATURITY_QUESTIONS as q on a.Question_Or_Requirement_Id = Mat_Question_Id

SELECT * FROM ANSWER

DELETE FROM ANSWER WHERE Question_Or_Requirement_Id = 1230 OR Question_Or_Requirement_Id = 1285;


update ANSWER set Comment = 'Comment ' + q.question_title, Alternate_Justification = 'AltJust'+q.Question_Title, FeedBack = 'Feedback'+q.Question_Title
from answer join MATURITY_QUESTIONS q on ANSWER.Question_Or_Requirement_Id=q.Mat_Question_Id 







--This is the transaction that will transfer all comments, documents, and feedback to parent question
BEGIN TRAN;
INSERT INTO ANSWER (Assessment_Id, Question_Or_Requirement_Id, Comment, Alternate_Justification, FeedBack, Question_Type)
	SELECT Assessment_Id, Parent_Question_Id, STRING_AGG(Comment, ' / '), STRING_AGG(Alternate_Justification, ' / '), STRING_AGG(FeedBack, ' / '), Question_Type
	FROM ANSWER
	JOIN MATURITY_QUESTIONS ON Question_Or_Requirement_Id = Mat_Question_Id WHERE Parent_Question_Id IS NOT NULL
	GROUP BY Parent_Question_Id, Assessment_Id, Question_Type;

--Making sure Parent question is marked for review if any of child questions are marked
UPDATE ANSWER
SET Mark_For_Review = 1
WHERE Question_Or_Requirement_Id IN (SELECT q.Parent_Question_Id FROM ANSWER AS a
JOIN MATURITY_QUESTIONS AS q ON a.Question_Or_Requirement_Id = Mat_Question_Id WHERE q.Parent_Question_Id IS NOT NULL AND a.Mark_For_Review = 1);

--Deal with documents...

UPDATE DOCUMENT_ANSWERS
SET Answer_Id = 1;

COMMIT TRAN;

SELECT a.Answer_Id, a.Comment, m.Parent_Question_Id, m.Question_Text FROM ANSWER AS a
JOIN MATURITY_QUESTIONS AS m ON Question_Or_Requirement_Id = Mat_Question_Id;

-- Get the new parent questions with moved comments 
SELECT Answer_Id FROM ANSWER 
WHERE Question_or_Requirement_Id IN 
	(SELECT m.Parent_Question_Id FROM ANSWER AS a
	JOIN DOCUMENT_ANSWERS AS d on a.Answer_Id = d.Answer_Id
	JOIN MATURITY_QUESTIONS AS m on m.Mat_Question_Id = a.Question_Or_Requirement_Id);


INSERT INTO DOCUMENT_ANSWERS (Document_Id, Answer_Id)
	SELECT d.Document_Id, a.Answer_Id FROM ANSWER AS a, DOCUMENT_ANSWERS AS d
	WHERE a.Question_or_Requirement_Id IN 
	(SELECT m.Parent_Question_Id FROM ANSWER AS a
	JOIN DOCUMENT_ANSWERS AS d on a.Answer_Id = d.Answer_Id
	JOIN MATURITY_QUESTIONS AS m on m.Mat_Question_Id = a.Question_Or_Requirement_Id);
	
	

SELECT d.Document_Id, a.Answer_Id, q.Mat_Question_Id, q.Parent_Question_Id FROM DOCUMENT_ANSWERS AS d
FULL OUTER JOIN ANSWER AS a ON a.Answer_Id = d.Answer_Id
JOIN MATURITY_QUESTIONS as q ON q.Mat_Question_Id = a.Question_Or_Requirement_Id



	--WHERE a.Question_or_Requirement_Id IN
	--	(SELECT d.Document_Id, a.Answer_Id, m.Mat_Question_Id, m.Parent_Question_Id FROM ANSWER AS a
	--	JOIN DOCUMENT_ANSWERS AS d on a.Answer_Id = d.Answer_Id
	--	JOIN MATURITY_QUESTIONS AS m on m.Mat_Question_Id = a.Question_Or_Requirement_Id)
	





--DECLARE
--	@document_id INT,
--	@answer_Id INT;

--DECLARE documents_cursor CURSOR
--FOR SELECT Document_Id, Answer_Id FROM DOCUMENT_ANSWERS;

--OPEN documents_cursor;

--FETCH NEXT FROM documents_cursor INTO 
--    @document_id, 
--    @answer_id;

--WHILE @@FETCH_STATUS = 0
--    BEGIN
--        UPDATE DOCUMENT_ANSWERS
--			SET Answer_Id = ;

--        FETCH NEXT FROM documents_cursor INTO 
--            @document_id, 
--            @answer_id;
--    END;

--CLOSE documents_cursor;
--DEALLOCATE documents_cursor;