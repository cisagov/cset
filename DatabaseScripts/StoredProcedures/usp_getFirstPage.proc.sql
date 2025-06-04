-- =============================================
-- Author:		hansbk
-- Create date: 7/30/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getFirstPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id
	EXECUTE [dbo].[GetCombinedOveralls] @Assessment_Id	
	EXECUTE [dbo].[usp_GetOverallRankedCategoriesPage] @assessment_id
	-- EXECUTE [dbo].[usp_getRankedCategories] @assessment_id

END
