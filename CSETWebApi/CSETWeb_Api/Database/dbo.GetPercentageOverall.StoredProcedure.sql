USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[GetPercentageOverall]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[GetPercentageOverall]
@Assessment_id int 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,Alias as [Name], StatType,isNull(Total,0) as Total, 
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],			
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 				
		FROM 
		(
			select b.Assessment_Id,af.Alias, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text , SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
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
GO
