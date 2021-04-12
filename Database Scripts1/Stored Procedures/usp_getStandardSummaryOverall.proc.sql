-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardSummaryOverall]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode varchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	
	select a.Answer_Full_Name,a.Answer_Text, isnull(m.qc,0) qc,isnull(m.Total,0) Total, isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0)  as [Percent] 
	from ANSWER_LOOKUP a left join (
	SELECT a.Answer_Text, isnull(count(a.question_or_requirement_id),0) qc, SUM(count(a.question_or_requirement_id)) OVER() AS Total
			FROM #answers a 				
			where a.Assessment_Id = @assessment_id 
			group by a.Answer_Text
	) m on a.Answer_Text = m.Answer_Text

END

