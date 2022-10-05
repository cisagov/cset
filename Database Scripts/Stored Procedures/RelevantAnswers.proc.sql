-- =============================================
-- Author:		Randy Woods
-- Create date: 29-May-2019
-- Description:	This proc is a wrapper for GetRelevantAnswers and returns 
--              everything it comes up with.
-- =============================================
CREATE PROCEDURE [dbo].[RelevantAnswers]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    ------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	
	SELECT a.*
			FROM #answers a 				
			where a.Assessment_Id = @assessment_id 
END
