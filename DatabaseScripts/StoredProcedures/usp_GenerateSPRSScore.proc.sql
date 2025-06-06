-- =============================================
-- Author:		hansbk
-- Create date: 11/17/2021
-- Description:	generate scores for SPRS
-- =============================================
CREATE PROCEDURE [dbo].[usp_GenerateSPRSScore]
	-- Add the parameters for the stored procedure here
	@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;	
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	select sum(Score) +110 as SPRS_SCORE from (
	SELECT Mat_Question_Id,answer_text,e.CMMC1_Title,  case answer_text when 'Y' then 0 when 'NA' then 0 else -1*e.SPRSValue end as Score from Answer_Maturity a join MATURITY_QUESTIONS m on a.Question_Or_Requirement_Id=m.Mat_Question_Id
	join MATURITY_EXTRA e on m.Mat_Question_Id=e.Maturity_Question_Id
	where m.Maturity_Model_Id = 6 and Assessment_Id = @assessment_id) A

END
