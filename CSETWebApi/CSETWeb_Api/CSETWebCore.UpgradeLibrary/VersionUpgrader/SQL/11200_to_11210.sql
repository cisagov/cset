/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb11200    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.TSAWeb11210

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.6.10.20102 from Red Gate Software Ltd at 8/25/2022 12:40:01 PM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getVADRSummaryByGoal]'
GO
-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary data for VADR report. 
-- =============================================
ALTER PROCEDURE [dbo].[usp_getVADRSummaryByGoal]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Answer_Full_Name, a.Title, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from MATURITY_GROUPINGS, ANSWER_LOOKUP 
		where Maturity_Model_Id = 7 and answer_text in ('Y','N','A','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM Answer_Maturity a 
			join (
				select q.Mat_Question_Id, g.* 
				from MATURITY_QUESTIONS q 
				join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
					and g.Maturity_Model_Id = 7 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 		
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	join ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getVADRSummaryByGoalOverall]'
GO
-- =============================================
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary data for VADR report. 
-- =============================================
ALTER PROCEDURE [dbo].[usp_getVADRSummaryByGoalOverall]
@assessment_id int
AS
BEGIN
                SET NOCOUNT ON;

                select a.Title, 
                                isnull(m.qc,0) as [qc],
                                isnull(m.Total,0) as [Total], 
                                IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
                from          
                (select * from MATURITY_GROUPINGS
                                where Maturity_Model_Id = 7 and Group_Level = 2) a left join (
                                SELECT g.Title, isnull(count(question_or_requirement_id),0) qc , SUM(count(Title)) OVER(PARTITION BY assessment_id) AS Total
                                                FROM Answer_Maturity a 
                                                join (
                                                                select q.Mat_Question_Id, g.* 
                                                                from MATURITY_QUESTIONS q 
                                                                join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
                                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                                and g.Maturity_Model_Id=7 and Group_Level = 2
                                                ) g on a.Question_Or_Requirement_Id=g.Mat_Question_Id
                                                where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
                                                group by a.Assessment_Id, g.Title)
                                                m on a.Title=m.Title     
                order by a.Sequence

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getVADRSummary]'
GO
-- =============================================
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary data for VADR report. 
-- =============================================
ALTER PROCEDURE [dbo].[usp_getVADRSummary]
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
                                                                join MATURITY_LEVELS l on a.Maturity_Level = l.Maturity_Level_Id
                                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                                and a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
                                                                group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text
                                )m on a.Level_Name=m.Level_Name and a.Answer_Text=m.Answer_Text                         
                JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
                order by a.Level,o.answer_order

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getVADRSummaryOverall]'
GO
-- =============================================
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary overall data for VADR report. 
-- =============================================
ALTER PROCEDURE [dbo].[usp_getVADRSummaryOverall]
@assessment_id int
AS
BEGIN
                SET NOCOUNT ON;

                select a.Answer_Full_Name, a.Answer_Text, 
                                isnull(m.qc,0) as [qc],
                                isnull(m.Total,0) as [Total], 
                                IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
                from 
                (select * from ANSWER_LOOKUP 
                where answer_text in ('Y','N','U','A') ) a left join (
SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
                                                FROM Answer_Maturity a 
                                                join MATURITY_LEVELS l on a.Maturity_Level = l.Maturity_Level_Id --VADR uses all Levels, hence Level 1
                                                join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                and a.Assessment_Id = @assessment_id and Is_Maturity = 1 
                                                group by a.Assessment_Id, a.Answer_Text)
                                                m on a.Answer_Text=m.Answer_Text                            
                JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
                order by o.answer_order

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
