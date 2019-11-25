-- =============================================
-- Author:		hansbk
-- Create date: 7/30/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetComponentsSummaryPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getComponentsSummary] @assessment_id

END
