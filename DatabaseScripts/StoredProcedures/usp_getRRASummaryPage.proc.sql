-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryPage]	
@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getRRASummaryOverall] @assessment_id
	execute [dbo].[usp_getRRASummary] @assessment_id
	execute [dbo].[usp_getRRASummaryByGoal] @assessment_id
	execute [dbo].[usp_getRRASummaryByGoalOverall] @assessment_id

END
