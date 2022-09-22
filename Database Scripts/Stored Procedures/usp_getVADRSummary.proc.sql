-- =============================================
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummary]
@assessment_id int
AS
BEGIN
                SET NOCOUNT ON;



                
                select a.Answer_Full_Name, a.Level_Name, a.Answer_Text, 
                                isnull(m.qc,0) as [qc],
                                isnull(m.Total,0) as [Total], 
                                IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
                from 
                (select * from MATURITY_LEVELS, ANSWER_LOOKUP 
                                where Maturity_Model_Id = 7 and 
                                answer_text in ('Y','N','A','U') ) a 
                                join 
                                (
                                                                SELECT l.Level_Name, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY Level_Name) AS Total
                                                                FROM Answer_Maturity a 
                                                                join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
                                                                join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
                                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                                and a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
                                                                group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text
                                )m on a.Level_Name=m.Level_Name and a.Answer_Text=m.Answer_Text                         
                JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
                order by a.Level,o.answer_order

END
