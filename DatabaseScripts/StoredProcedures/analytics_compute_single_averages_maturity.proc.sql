
-- =============================================
-- Author:      Barry
-- Create date: 4/6/2022
-- Description: Average for maturity model
-- =============================================
CREATE PROCEDURE [dbo].[analytics_compute_single_averages_maturity]
    @assessment_id     INT,
    @maturity_model_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        G1.Title,
        G1.Answer_Text,
        ISNULL(G2.Answer_Count, 0) AS Answer_Count,
        ISNULL(G2.Total, 0) AS Total,
        ISNULL(G2.Percentage, 0) AS [Percentage]
    FROM (
        SELECT DISTINCT
            Assessment_Id  = @assessment_id,
            Question_Group AS Title,
            Global_Sequence,
            Answer_Text    = 'Y'
        FROM ANALYTICS_MATURITY_GROUPINGS
        WHERE Maturity_Model_Id = @maturity_model_id
    ) G1
    LEFT JOIN (
        SELECT
            Question_Group AS Title,
            Answer_Text,
            COUNT(Answer_Text) AS Answer_Count,
            SUM(COUNT(Answer_Text))
                OVER (PARTITION BY Question_Group) AS Total,
            CAST(
                ISNULL(
                    (
                        CAST(COUNT(a.Answer_Text) AS FLOAT)
                        / ISNULL(NULLIF(SUM(COUNT(Answer_Text))
                            OVER (PARTITION BY Question_Group), 0), 1)
                    ) * 100,
                    0
                )
            AS FLOAT) AS [Percentage]
        FROM Analytics_Answers a
        JOIN ANALYTICS_MATURITY_GROUPINGS g ON a.Question_Or_Requirement_Id = g.Maturity_Question_Id
        JOIN MATURITY_QUESTIONS mq ON a.Question_Or_Requirement_Id = mq.Mat_Question_Id
        WHERE Assessment_Id = @assessment_id
          AND mq.Is_Answerable = 1
        GROUP BY
            Question_Group,
            Answer_Text
    ) G2 ON G1.Title = G2.Title AND G1.Answer_Text = G2.Answer_Text
    WHERE G1.Answer_Text = 'Y'
    ORDER BY Global_Sequence;

END
