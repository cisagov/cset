/*
Run this script on:       

        (localdb)\v11.0.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.4.4.16824 from Red Gate Software Ltd at 12/10/2020 3:40:27 PM

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
PRINT N'Altering [dbo].[ANSWER]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANSWER] ADD
[Question_Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_QUESTION_TYPES]'
GO
CREATE TABLE [dbo].[ANSWER_QUESTION_TYPES]
(
[Question_Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Answer_Question_Types] on [dbo].[ANSWER_QUESTION_TYPES]'
GO
ALTER TABLE [dbo].[ANSWER_QUESTION_TYPES] ADD CONSTRAINT [PK_Answer_Question_Types] PRIMARY KEY CLUSTERED  ([Question_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT(N'Add 5 rows to [dbo].[ANSWER_QUESTION_TYPES]')
INSERT INTO [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) VALUES ('Component')
INSERT INTO [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) VALUES ('Maturity')
INSERT INTO [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) VALUES ('Question')
INSERT INTO [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) VALUES ('Requirement')
INSERT INTO [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) VALUES ('Framework')
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
update answer set question_type = 'Maturity' where Is_Maturity = 1
update answer set question_type = 'Requirement' where Is_Requirement = 1
update answer set question_type = 'Framework' where Is_Framework = 1
update answer set question_type = 'Component' where Is_Component = 1
update answer set question_type = 'Question' where Is_Requirement = 0 and Is_Component = 0 and Is_Maturity = 0

ALTER TABLE
  answer 
ALTER COLUMN
  [Question_Type]
    NVARCHAR(20) NOT NULL;

ALTER TABLE [dbo].[ANSWER] DROP
CONSTRAINT [DF_ANSWER_Is_Requirement],
CONSTRAINT [DF_ANSWER_Is_Component],
CONSTRAINT [DF_ANSWER_Is_Framework],
CONSTRAINT [DF_ANSWER_Is_Maturity]

Drop Index [IX_ANSWER_1] on [dbo].[ANSWER]
GO
PRINT N'Adding constraints to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [IX_ANSWER] UNIQUE NONCLUSTERED  ([Assessment_ID], [Question_Or_Requirement_Id], [Question_Type],[Component_Guid])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANSWER] DROP
COLUMN [Is_Requirement],
COLUMN [Is_Component],
COLUMN [Is_Framework],
COLUMN [Is_Maturity]

ALTER TABLE [dbo].[ANSWER] ADD
	[Is_Requirement] AS cast(case [Question_Type] when 'Requirement' then (1) else (0) end as bit),
	[Is_Component] AS cast(case [Question_Type] when 'Component' then (1) else (0) end as bit),
	[Is_Framework] AS cast(case [Question_Type] when 'Framework' then (1) else (0) end as bit),
	[Is_Maturity]  AS cast(case [Question_Type] when 'Maturity' then (1) else (0) end as bit)

IF @@ERROR <> 0 SET NOEXEC ON
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


