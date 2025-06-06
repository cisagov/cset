
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FillAll]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	exec FillEmptyQuestionsForAnalysis @assessment_id
END
