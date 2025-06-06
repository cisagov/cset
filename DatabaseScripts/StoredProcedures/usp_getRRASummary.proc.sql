-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummary]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)

	select a.Answer_Full_Name, a.Level_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from MATURITY_LEVELS, ANSWER_LOOKUP 
	where Maturity_Model_Id = 5 and answer_text in ('Y','N','U') ) a left join (
	SELECT l.Level_Name, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY Level_Name) AS Total
			FROM #AM a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text)
			m on a.Level_Name = m.Level_Name and a.Answer_Text = m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Level,o.answer_order

END



