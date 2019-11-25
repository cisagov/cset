
CREATE PROCEDURE [dbo].[GetComparisonFileOveralls]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,StatType,isNull(Total,0) as Total, 
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],			
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(
			select Assessment_Id, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer
					 where assessment_id=@assessment_Id
					 group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Requirements', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  		
				from (select t=1,ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text
					from answer 
					where Is_Requirement = 1 and assessment_id=@assessment_Id
					group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Questions', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 0 and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 	
			union
				select Assessment_Id,[StatType]='Components', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 1 and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total    
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Framework = 1  and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;

END
