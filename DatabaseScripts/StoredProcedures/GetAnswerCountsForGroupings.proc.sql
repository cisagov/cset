
-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	Generically return answer counts for all groupings in 
--              an assessment's maturity model
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerCountsForGroupings]
	@assessmentId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec [FillEmptyMaturityQuestionsForAnalysis] @assessmentId

    select Title, Sequence, Grouping_Id, Parent_Id, Answer_Text, count(*) as AnsCount
	from (
		select mg.Title, mg.Sequence, mg.grouping_id, mg.Parent_Id, a.Answer_Text
		from answer a
		left join maturity_questions mq on a.Question_Or_Requirement_Id = mq.Mat_Question_Id and a.Question_Type = 'maturity'
		left join maturity_groupings mg on mq.Grouping_Id = mg.Grouping_Id
		where assessment_id = @assessmentId
	) b
	group by title, sequence, grouping_id, parent_id, answer_text
	order by sequence, answer_text
END
