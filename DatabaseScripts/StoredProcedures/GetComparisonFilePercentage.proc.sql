-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[GetComparisonFilePercentage]
@Assessment_id int 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,Alias as [Name], StatType,isNull(Total,0) as Total, 
			isnull([Y],0) as [YesCount],			
			isnull([N],0) as [NoCount],
			isnull([NA],0) as [NaCount],
			isnull([A],0) as [AlternateCount],
			isnull([U],0) as [UnansweredCount],			
			Total as [TotalCount]
		FROM 
		(
			select b.Assessment_Id,af.Alias, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer
					where assessment_id = @assessment_id
					 group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
					join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id			
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;
end
