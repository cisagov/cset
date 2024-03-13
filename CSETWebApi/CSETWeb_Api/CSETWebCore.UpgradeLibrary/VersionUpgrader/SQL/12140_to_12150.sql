/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12140    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12150

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/13/2024 12:02:37 PM

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
PRINT N'Dropping foreign keys from [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] DROP CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vAllSimpleQuestions]'
GO
CREATE VIEW [dbo].[vAllSimpleQuestions]
AS
SELECT        AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId, Simple_Question AS question
				,h.Question_Group_Heading AS Heading, h.Universal_Sub_Category AS SubHeading
FROM          NEW_QUESTION q JOIN
              vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
UNION
SELECT        AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question,
			  r.Standard_Category AS Heading, 
             r.Standard_Sub_Category AS SubHeading
FROM            REQUIREMENT_QUESTIONS_SETS s JOIN
                         NEW_REQUIREMENT r ON s.Requirement_Id = r.Requirement_Id
UNION
SELECT        AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS queestion, 
			  g.Title AS Heading, Question_Title AS SubHeading
FROM            MATURITY_QUESTIONS q JOIN
                         MATURITY_GROUPINGS g ON q.Grouping_Id = g.Grouping_Id JOIN
                         MATURITY_MODELS m ON q.Maturity_Model_Id = m.Maturity_Model_Id AND g.Maturity_Model_Id = m.Maturity_Model_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category] FOREIGN KEY ([NCSF_Cat_Id]) REFERENCES [dbo].[NCSF_CATEGORY] ([NCSF_Cat_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING] FOREIGN KEY ([Question_Group_Heading_Id]) REFERENCES [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading_Id]) ON DELETE CASCADE ON UPDATE CASCADE
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
