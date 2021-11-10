/*
Run this script on:

        (localdb)\v11.0.CSETWeb1000    -  This database will be modified

to synchronize it with:

        (localdb)\v11.0.CSETWeb1001

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.1.7.14336 from Red Gate Software Ltd at 5/12/2020 9:22:06 AM

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
PRINT N'Altering [dbo].[Answer_Components_InScope]'
GO


ALTER VIEW [dbo].[Answer_Components_InScope]
AS
SELECT DISTINCT 
                a.Assessment_Id, a.Answer_Id, a.Question_Or_Requirement_Id, a.Answer_Text, CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
                a.Question_Number, q.Simple_Question AS QuestionText, adc.label AS ComponentName, adc.Component_Symbol_Id, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
                z.Name AS ZoneName, z.Universal_Sal_Level AS SAL, a.Is_Component, a.Component_Guid, a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.Mark_For_Review, a.Is_Requirement, 
                a.Is_Framework
FROM            dbo.ANSWER AS a 
					INNER JOIN dbo.COMPONENT_QUESTIONS AS cq ON cq.Question_Id = a.Question_Or_Requirement_Id 
					INNER JOIN dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 
					INNER JOIN dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc ON a.Assessment_Id = adc.Assessment_Id AND adc.Component_Symbol_Id = cq.Component_Symbol_Id 
					LEFT OUTER JOIN dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id 
					LEFT OUTER JOIN dbo.DIAGRAM_CONTAINER AS z ON z.Assessment_Id = adc.Assessment_Id AND z.Container_Id = adc.Zone_Id
					INNER JOIN STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
					INNER JOIN NEW_QUESTION_SETS qs on q.question_id = qs.question_id and qs.Set_Name = 'Components'		
					INNER JOIN NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
						and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))

WHERE        (a.Is_Component = 1) AND (COALESCE (l.Visible, 1) = 1)
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
