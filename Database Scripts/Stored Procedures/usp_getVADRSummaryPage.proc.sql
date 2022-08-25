-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryPage]	
@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getVADRSummaryOverall] @assessment_id
	execute [dbo].[usp_getVADRSummary] @assessment_id
	execute [dbo].[usp_getVADRSummaryByGoal] @assessment_id
	execute [dbo].[usp_getVADRSummaryByGoalOverall] @assessment_id

END
