-- =============================================
-- Author:		Barry
-- Create date: 4/6/2022
-- Description:	average for maturity model
-- =============================================
CREATE PROCEDURE [dbo].[analytics_compute_single_averages_maturity]
	@assessment_id int,
	@maturity_model_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	select G1.Title, G1.Answer_Text,isnull(G2.Answer_Count,0) as Answer_Count, isnull(G2.Total,0) as Total, isnull(G2.Percentage, 0) as [Percentage]
	from
	(
		select distinct Assessment_Id= @assessment_id,
		Question_Group as Title, Answer_Text = 'Y'
		from ANALYTICS_MATURITY_GROUPINGS		
		where Maturity_Model_Id= @maturity_model_id			
	) G1 LEFT OUTER JOIN
	(
		select
		Question_Group as Title,answer_text, count(answer_text) answer_count,
		sum(count(answer_text)) OVER(PARTITION BY Question_Group) AS Total,
		cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY Question_Group),0),1)))*100,0),0) as int)  as [Percentage] 
		from Analytics_Answers a
		join ANALYTICS_MATURITY_GROUPINGS g on a.Question_Or_Requirement_Id=g.Maturity_Question_Id
		where assessment_id = @assessment_id
		group by Question_Group, Answer_Text
	) G2 ON G1.Title = G2.Title AND G1.Answer_Text = G2.Answer_Text		
	where g1.answer_text = 'Y'
	order by Title
END

--update ANSWER set Answer_Text = 'NA' where Assessment_Id = 9
