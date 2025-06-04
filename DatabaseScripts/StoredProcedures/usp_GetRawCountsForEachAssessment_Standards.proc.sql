-- =============================================
-- Author:		Lilly,Barry Hansen
-- Create date: 3/29/2022
-- Description:	get the aggregates for analysis
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetRawCountsForEachAssessment_Standards]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select a.Assessment_Id,qgh.Question_Group_Heading, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total
	,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
	from ANSWER a
	left join new_question q on a.question_or_requirement_id = q.Question_id
	left join universal_sub_category_headings usch on usch.heading_pair_id = q.Heading_Pair_Id	
	left join question_group_heading qgh on qgh.Question_Group_Heading_Id = usch.Question_Group_Heading_Id
	left join demographics d on a.assessment_id = d.assessment_id
	where a.question_type = 'Question' and answer_text != 'NA'
	group by a.assessment_id, qgh.Question_Group_Heading, Answer_Text
END
