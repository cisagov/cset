/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb120011    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.NCUAWeb120012

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/22/2022 8:19:22 AM

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
PRINT N'Altering [dbo].[Acet_GetActionItemsForReport]'
GO
-- =============================================
-- Author:		mrwinston
-- Create date: 11/4/2022
-- Description:	loads in the Action_Items for ACET ISE's MERIT and Examination reports
-- =============================================
ALTER PROCEDURE [dbo].[Acet_GetActionItemsForReport]
	@Assessment_Id int,
	@Exam_Level int, 
	@Additional_Exam_Level int
AS
BEGIN
	SELECT a.Parent_Question_Id, a.Mat_Question_Id,a.Finding_Id,a.Question_Title,a.answer_text,Regulatory_Citation, isnull(b.action_items_override,a.Action_Items) as Action_Items, a.Maturity_Level_Id
	FROM (select m.mat_question_id,m.Question_Title, m.Parent_Question_Id,i.Action_Items, Regulatory_Citation, a.Answer_Text,m.Maturity_Level_Id, mf.Finding_Id
		from [MATURITY_QUESTIONS] AS [m]
		join [ANSWER] [a] on m.Mat_Question_Id = a.Question_Or_Requirement_Id and a.Question_Type = 'Maturity' and Assessment_Id = @Assessment_Id
		join (select a1.Question_Or_Requirement_Id,f1.Finding_Id,f1.Auto_Generated from ANSWER a1 join FINDING f1 on a1.Answer_Id=f1.Answer_Id where Assessment_Id = @Assessment_Id and a1.Question_Type = 'Maturity') mf on m.Parent_Question_Id = mf.Question_Or_Requirement_Id
		INNER JOIN [ISE_ACTIONS] AS [i] ON [m].[Mat_Question_Id] = [i].[Mat_Question_Id]
		where a.Answer_Text = 'N' or Auto_Generated = 0
	) a

	left join (select a.Assessment_Id,a.Question_Or_Requirement_Id,f.Finding_Id,i0.Action_Items_Override,i0.Mat_Question_Id
		from [ANSWER] [a]
		JOIN [FINDING] AS [f] ON [a].[Answer_Id] = [f].[Answer_Id]
		LEFT JOIN [ISE_ACTIONS_FINDINGS] AS [i0] ON f.Finding_Id = i0.Finding_Id
		WHERE [a].[Assessment_Id] = @Assessment_Id and a.Question_Type = 'Maturity'
	) b on a.Parent_Question_Id = b.Question_Or_Requirement_Id and a.Mat_Question_Id = b.Mat_Question_Id and a.Finding_Id = b.Finding_Id
	
	where a.Maturity_Level_Id = @Exam_Level or a.Maturity_Level_Id = @Additional_Exam_Level
	order by a.Mat_Question_Id

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
