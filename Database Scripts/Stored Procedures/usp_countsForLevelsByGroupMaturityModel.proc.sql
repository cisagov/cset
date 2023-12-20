-- =============================================
-- Author:        hansbk
-- Create date: 11/3/2022
-- Description:    getting all the counts for a mat,grouping,level and answer
-- =============================================
CREATE PROCEDURE [dbo].[usp_countsForLevelsByGroupMaturityModel]
    -- Add the parameters for the stored procedure here
    @assessment_id int,
    @mat_model_id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    select a.*,b.Answer_Text as Answer_Text2,b.answer_count from (
    select distinct GROUPING_ID,Maturity_Level_Id, Answer_Text
    from MATURITY_QUESTIONS, (select ANSWER_text from ANSWER_LOOKUP where Answer_Text in ('Y','U','N')) ans
    where Maturity_Model_Id = @mat_model_id) a left join (
    select q.Grouping_Id,q.Maturity_Level_Id, a.Answer_Text, count(a.Answer_Text) answer_count from ANSWER a
    join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
    join MATURITY_LEVELS l on q.Maturity_Level_Id = l.Maturity_Level_Id
    where a.Question_Type = 'Maturity' and Assessment_Id = @assessment_id
    group  by q.Grouping_Id, q.Maturity_Level_Id, a.Answer_Text) b on a.Grouping_Id=b.Grouping_Id and a.Maturity_Level_Id=b.Maturity_Level_Id and a.Answer_Text=b.Answer_Text
END
