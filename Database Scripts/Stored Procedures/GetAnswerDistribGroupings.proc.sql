-- =============================================
-- Author:		Randy Woods
-- Create date: 15 November 2022
-- Description:	Tallies answer counts for all maturity groupings
--              at the top level.  
--              TODO:  What if we want to target the children of a 
--              specific grouping?  g.Parent_Id = X
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribGroupings] 
	@assessmentId int
AS
BEGIN
	SET NOCOUNT ON;
	exec FillEmptyMaturityQuestionsForAnalysis @assessmentId

	declare @maturityModelId int = (select model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId)

	select [grouping_id], [title], [answer_text], count(answer_text) as [answer_count]
	from (
		select g.grouping_id, g.title, g.sequence, a.Answer_Text
		from maturity_groupings g 
		left join maturity_questions q on q.grouping_id = g.Grouping_Id
		left join ANSWER a on a.Question_Or_Requirement_Id = q.Mat_Question_Id
		where a.Assessment_Id = @assessmentId and g.Parent_Id is null and 
		g.maturitY_model_id = @maturityModelId
	) N
	group by n.answer_text, n.grouping_id, n.title, n.Sequence
	order by n.Sequence
END
