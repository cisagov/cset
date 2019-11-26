-- =============================================
-- Author:		woodrk
-- Create date: 8/20/2019
-- Description:	Get answered component questions by category
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentsResultsByCategory]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- get all answers
	select Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #temp	
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id
	where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' 
	group by Question_Group_Heading


	-- get passing answers (Y, A)
	SELECT Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #tempAnswered
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id		
	where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') 	
	group by Question_Group_Heading


	-- calc totals/percentage of passing		 
	select t.Question_Group_Heading, 
	ISNULL(a.qc,0) as [passed], 
	ISNULL(t.qc,0) as [total], 
	ROUND(ISNULL(CAST(a.qc as decimal(18,3))/t.qc,0),5) * 100 as [percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by Question_Group_Heading	
END
