
-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityComparisonBestToWorst]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		SELECT Assessment_Id,
		AssessmentName = Alias,                
		Name = Title,
		*
		--AlternateCount = [I],
		--AlternateValue = Round(((cast(([I]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NaCount = [S],
		--NaValue = Round(((cast(([S]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NoCount = [N],
		--NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--TotalCount = Total,
		--TotalValue = Total,
		--UnansweredCount = [U],
		--UnansweredValue = Round(cast([U] as float)/Total*100,2),
		--YesCount = [Y],
		--YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		--Value = Round(((cast(([Y]+ isnull([I],0)) as float)/isnull(nullif((Total-[S]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id, f.Alias, b.Title, b.Answer_Text, isnull(c.Value,0) as Value, 
			Total = sum(c.Value) over(partition by b.Assessment_Id, b.Title)			
			from 
			 (select distinct a.[Assessment_Id], g.Title, l.answer_Text
			from answer_lookup l, (select * from Answer_Maturity where assessment_id = @assessment_id) a 
			join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
			join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			) b left join 
			(select a.Assessment_Id, g.Title, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Maturity where assessment_id = @assessment_id) a 
				join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
				join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			 group by Assessment_Id, g.Title, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Title = c.Title and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p


			PIVOT
			(
				sum(value)
				FOR answer_text IN ( [Y],[I],[S],[N],[U] )
			) AS pvt
END
