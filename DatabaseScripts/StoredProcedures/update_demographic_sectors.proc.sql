CREATE PROCEDURE [dbo].[update_demographic_sectors]
AS
BEGIN
    -- Variables for reporting
    DECLARE @UpdatedCount INT = 0;
    DECLARE @ProcessedCount INT = 0;

    -- Clear SUBSECTOR values for affected assessments
    UPDATE dd
    SET dd.IntValue = NULL
    FROM DETAILS_DEMOGRAPHICS dd
    WHERE dd.DataItemName = 'SUBSECTOR'
      AND EXISTS (
          SELECT 1 
          FROM DETAILS_DEMOGRAPHICS dd2
          WHERE dd2.Assessment_Id = dd.Assessment_Id
            AND dd2.DataItemName = 'SECTOR'
            AND dd2.IntValue BETWEEN 17 AND 34
      );

    -- Update SECTOR values in one operation
    UPDATE dd
    SET dd.IntValue = CASE dd.IntValue
        WHEN 17 THEN 10
        WHEN 18 THEN 9
        WHEN 19 THEN 1
        WHEN 20 THEN 2
        WHEN 21 THEN 3
        WHEN 22 THEN 5
        WHEN 23 THEN 6
        WHEN 24 THEN 7
        WHEN 25 THEN 8
        WHEN 26 THEN 11
        WHEN 27 THEN 12
        WHEN 28 THEN 13
        WHEN 29 THEN 4
        WHEN 30 THEN 11
        WHEN 31 THEN 14
        WHEN 32 THEN 15
        WHEN 33 THEN 15
        WHEN 34 THEN 16
        ELSE NULL
    END
    FROM DETAILS_DEMOGRAPHICS dd
    WHERE dd.DataItemName = 'SECTOR'
      AND dd.IntValue BETWEEN 17 AND 34;
    
    SET @UpdatedCount = @@ROWCOUNT;

    -- Insert acknowledgement flags
    INSERT INTO DETAILS_DEMOGRAPHICS (Assessment_Id, DataItemName, BoolValue)
    SELECT DISTINCT Assessment_Id, 'ACK_SECTOR_UPDATED_PPD21', 1
    FROM DETAILS_DEMOGRAPHICS
    WHERE DataItemName = 'SECTOR'
      AND IntValue BETWEEN 1 AND 16  -- New values after update
      AND NOT EXISTS (
          SELECT 1 
          FROM DETAILS_DEMOGRAPHICS dd2
          WHERE dd2.Assessment_Id = DETAILS_DEMOGRAPHICS.Assessment_Id
            AND dd2.DataItemName = 'ACK_SECTOR_UPDATED_PPD21'
      );
    
    SET @ProcessedCount = @UpdatedCount;

    -- Optional: Report results
    PRINT 'Processed ' + CAST(@ProcessedCount AS VARCHAR(10)) + ' SECTOR records';
    PRINT 'Updated ' + CAST(@UpdatedCount AS VARCHAR(10)) + ' SECTOR values';
END;
