-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryByGoal]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Answer_Full_Name, a.Title, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from MATURITY_GROUPINGS, ANSWER_LOOKUP 
		where Maturity_Model_Id = 7 and answer_text in ('Y','N','A','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM Answer_Maturity a 
			join (
				select q.Mat_Question_Id, g.* 
				from MATURITY_QUESTIONS q 
				join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
					and g.Maturity_Model_Id = 7 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 		
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	join ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END



