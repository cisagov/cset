-- =============================================
-- Author:		Lilly, Barry Hansen
-- Create date: 3/29/2022
-- Description:	get min, max, average for a given sector sub sector
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMinMaxAverageForSectorIndustry]
	-- Add the parameters for the stored procedure here
	@sector_id int,
	@industry_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select min([percentage]) [min],max([percentage]) [max],avg([percentage]) [avg] from (
	select a.Assessment_Id, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total	
	,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
	from ANSWER a	
	join demographics d on a.assessment_id = d.assessment_id
	where a.question_type = 'Question' and answer_text != 'NA' and d.SectorId = @sector_id and d.IndustryId=@industry_id
	group by a.assessment_id, Answer_Text
	) B
	where answer_text = 'Y'

END
