
-- =============================================
-- Author:		Randy Woods
-- Create date: 27 AUG 2024
-- Description:	Flexible answer count/percentages for maturity models that have their own 
--              answer options other than Y, N, NA, etc.
--
--              A model ID can be supplied (for querying SSG answers), or if not supplied,
--              the assigned model ID is used.
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMaturityAnswerTotals]
	@assessment_id int,
	@model_id int = null
AS
BEGIN
	-- Get the assigned maturity model ID if a model was not specified in the arguments
	if @model_id is null begin
	  set @model_id = (select model_id from AVAILABLE_MATURITY_MODELS where assessment_id = @assessment_id)
	end

	-- Create all missing answer rows
	exec [FillEmptyMaturityQuestionsForAnalysis] @assessment_id


	select *
	into #answers
	from answer
	where question_type = 'maturity' and Question_Or_Requirement_Id in (select mat_question_id from maturity_questions where maturity_model_id = @model_id)

	select [Answer_Text], 
		isnull(qc, 0) as [QC], 
		isnull(m.Total, 0) as [Total], 
		isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int), 0) as [Percent]
	from  (
		SELECT a.Answer_Text, count(a.question_or_requirement_id) qc, SUM(count(a.question_or_requirement_id)) OVER() AS [Total]
		FROM #answers a 				
		where a.Assessment_Id = @assessment_id
		group by a.Answer_Text
	) m 
END
