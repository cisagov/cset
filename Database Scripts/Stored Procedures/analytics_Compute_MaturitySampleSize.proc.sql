
-- =============================================
-- Author:		Mostafa, Randy
-- Create date: 11-12-2024
-- Description: Return Assessment count based on maturity model id and optional sector_id
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturitySampleSize]
@maturity_model_id int,
@sector_id int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--test base case where there is no data in db at all
SELECT SectorId, COUNT(Assessment_Id) AS AssessmentCount
FROM (
    SELECT dd.Assessment_Id, dd.IntValue as SectorId FROM DETAILS_DEMOGRAPHICS dd
    JOIN AVAILABLE_MATURITY_MODELS amm
    ON dd.Assessment_Id = amm.Assessment_Id
    WHERE amm.model_id = @maturity_model_id
    AND (@sector_id IS NULL OR (DataItemName = 'SECTOR' AND dd.IntValue = @sector_id))

    UNION

    SELECT d.Assessment_Id, d.SectorId FROM DEMOGRAPHICS d
    JOIN AVAILABLE_MATURITY_MODELS amm
    ON d.Assessment_Id = amm.Assessment_Id
    WHERE amm.model_id = @maturity_model_id
    AND (@sector_id IS NULL OR d.SectorId = @sector_id)
) AS CombinedResult
GROUP BY SectorId;
END
