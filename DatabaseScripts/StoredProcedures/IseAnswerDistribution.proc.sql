
-- =============================================
-- Author:	mrwinston
-- Create date: 10/10/2022
-- Description:	Gets all the AnswerText values, excluding parent questions
-- =============================================
CREATE PROCEDURE [dbo].[IseAnswerDistribution] 
	@Assessment_Id int,
	@targetLevel int
AS
BEGIN

	SET NOCOUNT ON;

	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id

	declare @model_id int
	select @model_id = (select model_id from AVAILABLE_MATURITY_MODELS where assessment_id = @Assessment_id and selected = 1)


    select a.Answer_Text, count(*) as [Count] from maturity_questions q 
	left join answer a on a.Question_Or_Requirement_Id = q.Mat_Question_Id
	left join maturity_levels l on q.Maturity_Level_Id = l.Maturity_Level_Id
	where a.Question_Type = 'Maturity' and q.Maturity_Model_Id = @model_id
	and l.Maturity_Level_Id = @targetLevel
	and a.Assessment_Id = @assessment_id
	and q.Parent_Question_Id IS NOT NULL
	and q.Maturity_Level_Id != 19
	group by Answer_Text


END
