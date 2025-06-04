-- =============================================
-- Author:		hansbk
-- Create date: 3/15/2022
-- Description:	quick return of CyOTE Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_CyOTEQuestionsAnswers]
	@Assessment_id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Question_Level =  CASE WHEN Parent_Question_Id IS NULL THEN 1 ELSE 2 END,Mat_Question_Id,Question_Title,Question_Text,Mat_Question_Type,[Sequence],Answer_Text,Free_Response_Answer,Comment,Parent_Question_Id, Supplemental_Info
	from MATURITY_QUESTIONS M left join (select Question_Or_Requirement_Id,Answer_Text,Free_Response_Answer,Comment from ANSWER where Assessment_Id=@Assessment_Id and Question_Type='Maturity') a on m.Mat_Question_Id=a.question_or_requirement_id
	where Maturity_Model_Id = 9
	order by Sequence
END


--update MATURITY_QUESTIONS set Sequence = Sequence + 2 where Mat_Question_Id >=6341 and mat_question_id not in (6390,6392)
