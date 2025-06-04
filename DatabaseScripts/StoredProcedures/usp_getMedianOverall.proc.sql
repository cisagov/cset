-- =============================================
-- Author:		Lilly, Barry Hansen
-- Create date: 3/29/2022
-- Description:	retrieve the median overall
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMedianOverall]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 select [Percentage] into #tempRows from (
		select a.Assessment_Id, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total	
		,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
		from ANSWER a	
		left join demographics d on a.assessment_id = d.assessment_id
		where a.question_type = 'Question' and answer_text != 'NA' 
		group by a.assessment_id, Answer_Text
		) B
	where answer_text = 'Y'

	select * from #tempRows order by [percentage]

	DECLARE @c BIGINT = (SELECT COUNT(*) FROM #tempRows);

	SELECT AVG(1.0 * [Percentage]) as Median
	FROM (
		SELECT [Percentage] FROM #tempRows
		 ORDER BY [Percentage]
		 OFFSET (@c - 1) / 2 ROWS
		 FETCH NEXT 1 + (1 - @c % 2) ROWS ONLY
	) AS x;

	drop table #tempRows
END
