-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryByGoalOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)

	
	select a.Title, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from #MG
		where Maturity_Model_Id = 5 and Group_Level = 2) a left join (
		SELECT g.Title, isnull(count(question_or_requirement_id),0) qc , SUM(count(Title)) OVER(PARTITION BY assessment_id) AS Total
			FROM #AM a 
			join (
				select q.Mat_Question_Id, g.* 
				from #MQ q join #MG g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
				where g.Maturity_Model_Id=5 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			group by a.Assessment_Id, g.Title)
			m on a.Title=m.Title	
	order by a.Sequence

END

