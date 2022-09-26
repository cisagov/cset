/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb12000    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb12001

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.6.10.20102 from Red Gate Software Ltd at 9/26/2022 10:43:24 AM

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
PRINT N'Dropping [dbo].[spEXECsp_RECOMPILE]'
GO
DROP PROCEDURE [dbo].[spEXECsp_RECOMPILE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PASSWORD_HISTORY]'
GO
CREATE TABLE [dbo].[PASSWORD_HISTORY]
(
[UserId] [int] NOT NULL,
[Created] [datetime] NOT NULL,
[Password] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_Temp] [bit] NOT NULL CONSTRAINT [DF_PASSWORD_HISTORY_Is_Temp] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_PASSWORD_HISTORY] on [dbo].[PASSWORD_HISTORY]'
GO
ALTER TABLE [dbo].[PASSWORD_HISTORY] ADD CONSTRAINT [PK_PASSWORD_HISTORY] PRIMARY KEY CLUSTERED ([UserId], [Created])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PASSWORD_HISTORY]'
GO
ALTER TABLE [dbo].[PASSWORD_HISTORY] ADD CONSTRAINT [FK_PASSWORD_HISTORY_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId])
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
