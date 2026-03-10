
-- =============================================
-- Author:       Luke G, Lilly, Barry
-- Create date:  4-6-2022
-- Description:  18 stored procedures for analytics.
--               This procedure returns the AVG, MIN, MAX, MEDIAN Question Group Heading
--               for the Question_Type 'Maturity' for all sectors and industries.
--
-- Modification: 12-NOV-2024
-- Author:       Randy
-- Description:  Made sector and industry parameters optional, to cast a wider net.
--               Added consideration for a sector and industry stored in DETAILS_DEMOGRAPHICS.
--               Groupings are now sorted in sequence order rather than alphabetically.
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturityAll]
    @maturity_model_id  INT,
    @sector_id          INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Drop temp tables if they exist
    IF OBJECT_ID('tempdb..#Temp')  IS NOT NULL DROP TABLE #Temp;
    IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2;
    IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL DROP TABLE #Temp3;

    -- -------------------------------------------------------------------------
    -- Step 1: Get the base data
    -- -------------------------------------------------------------------------
    SELECT
        a.Assessment_Id,
        Question_Group,
        Answer_Text,
        ISNULL(COUNT(a.Answer_Text), 0) AS Answer_Count,
        SUM(ISNULL(COUNT(Answer_Text), 0))
            OVER (PARTITION BY a.Assessment_Id, Question_Group) AS Total,
        CAST(
            ISNULL(
                (
                    CAST(COUNT(a.Answer_Text) AS FLOAT)
                    / ISNULL(NULLIF(SUM(COUNT(Answer_Text))
                        OVER (PARTITION BY a.Assessment_Id, Question_Group), 0), 1)
                ) * 100,
                0
            )
        AS FLOAT) AS [Percentage]
    INTO #Temp
    FROM [Analytics_Answers] a
    JOIN MATURITY_QUESTIONS q ON a.Question_Or_Requirement_Id = q.Mat_Question_Id
    JOIN ANALYTICS_MATURITY_GROUPINGS g ON q.Mat_Question_Id = g.Maturity_Question_Id
    LEFT JOIN ASSESSMENT_SECTOR_SUBSECTOR ddsector ON a.Assessment_Id = ddsector.Assessment_Id
    WHERE
        a.Question_Type = 'Maturity'
        AND q.Is_Answerable = 1
        AND q.Maturity_Model_Id = @maturity_model_id
        AND g.Maturity_Model_Id = @maturity_model_id
        AND NULLIF(@sector_id, ddsector.SectorId) IS NULL
    GROUP BY
        a.Assessment_Id,
        Question_Group,
        Answer_Text;

    -- -------------------------------------------------------------------------
    -- Step 2: Handle all-Yes, all-No, and mixed answer cases
    -- -------------------------------------------------------------------------

    -- Capture Yes answers and mixed cases
    SELECT *
    INTO #Temp2
    FROM #Temp
    WHERE Answer_Text = 'Y';

    -- Capture all-No cases (no Yes answers exist; treat percentage as 0)
    INSERT INTO #Temp2
    SELECT
        Assessment_Id,
        Question_Group,
        Answer_Text = 'Y',
        Answer_Count,
        Total,
        [Percentage] = 0
    FROM #Temp
    WHERE Answer_Text = 'N'
      AND Answer_Count = Total;

    -- -------------------------------------------------------------------------
    -- Step 3: Calculate MIN, MAX, AVG per grouping
    -- -------------------------------------------------------------------------
    SELECT
        G1.Question_Group AS Question_Group_Heading,
        G1.Global_Sequence,
        MIN(ISNULL(G2.[Percentage], 0)) AS [minimum],
        MAX(ISNULL(G2.[Percentage], 0)) AS [maximum],
        AVG(ISNULL(G2.[Percentage], 0)) AS [average]
    INTO #Temp3
    FROM (
        SELECT DISTINCT
            Question_Group,
            Global_Sequence
        FROM ANALYTICS_MATURITY_GROUPINGS
        WHERE Maturity_Model_Id = @maturity_model_id
    ) G1
    LEFT JOIN #Temp2 G2 ON G1.Question_Group = G2.Question_Group
    GROUP BY
        G1.Question_Group,
        G1.Global_Sequence;

    -- -------------------------------------------------------------------------
    -- Step 4: Add median and return final result set
    -- -------------------------------------------------------------------------
    SELECT
        a.Question_Group_Heading,
        CAST(a.minimum AS FLOAT) AS minimum,
        CAST(a.maximum AS FLOAT) AS maximum,
        CAST(a.average AS FLOAT) AS average,
        ISNULL(b.median, 0) AS median
    FROM #Temp3 a
    LEFT JOIN (
        SELECT DISTINCT
            Question_Group AS Question_Group_Heading,
            ISNULL(
                PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY [Percentage])
                    OVER (PARTITION BY Question_Group),
                0
            ) AS median
        FROM #Temp2
    ) b ON a.Question_Group_Heading = b.Question_Group_Heading
    ORDER BY
        a.Global_Sequence;

END
