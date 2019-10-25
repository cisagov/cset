SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	remember the answer values are percents
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentTypes]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT Assessment_Id,
			Component_Symbol_Id,
			Symbol_Name,
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],
			ISNULL(Total,0) as [Total], 
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(	
			select Assessment_Id, b.Component_Symbol_Id, s.Symbol_Name,
			isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY Assessment_Id, b.Component_Symbol_Id) AS Total  
			from (select Component_Symbol_Id, answer_text from ANSWER_LOOKUP a, assessment_diagram_components c
			where c.assessment_id = @assessment_id) aw 
			left join (
				select assessment_id, a.Component_Symbol_Id, a.answer_text, count(a.answer_text) acount 
				from Answer_Components_Inscope a 
				where a.assessment_id = @assessment_id
				group by assessment_id, Component_Symbol_Id, a.answer_text) b 
			on aw.Answer_Text = b.answer_text and aw.Component_Symbol_Id = b.Component_Symbol_Id
			left join COMPONENT_SYMBOLS s on s.Component_Symbol_Id = b.Component_Symbol_Id
			where b.Component_Symbol_Id is not null
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.Component_Symbol_Id;

END