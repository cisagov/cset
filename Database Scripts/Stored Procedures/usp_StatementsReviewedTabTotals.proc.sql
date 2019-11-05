-- =============================================
-- Author:		hansbk
-- Create date: Mar 2, 2019
-- Description:	fill it and if missing get the data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_StatementsReviewedTabTotals]
	@Assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [dbo].[FINANCIAL_HOURS]
				([Assessment_Id]
				,[Component]
				,[ReviewType]
				,[Hours])     
	select a.* from (
	SELECT @assessment_id Assessment_id, Component, ReviewType, [Hours] = 0
		FROM [dbo].[FINANCIAL_HOURS_COMPONENT], FINANCIAL_REVIEWTYPE) a left join [dbo].[FINANCIAL_HOURS] f on 
		a.Assessment_id = f.Assessment_Id and a.Component = f.Component and a.ReviewType = f.ReviewType
		where f.Assessment_Id is null
  
	select * from (select Assessment_Id,ReviewType,sum([Hours]) as Totals from FINANCIAL_HOURS
	where assessment_id = @Assessment_id
	group by Assessment_Id,ReviewType) a,(
	select SUM([Hours]) AS GrandTotal from FINANCIAL_HOURS
	where assessment_id = @Assessment_id) b
END
