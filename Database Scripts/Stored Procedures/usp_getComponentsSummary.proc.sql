-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select l.Answer_Text, l.Answer_Full_Name, isnull(b.vcount, 0) vcount, round(isnull(b.value, 0),0) [value] 
	from ANSWER_LOOKUP l 
	left join (select Answer_Text, count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] 
	from  Answer_Components_InScope 
	where assessment_id = @assessment_id
	group by answer_text) b on l.Answer_Text = b.Answer_Text
END
