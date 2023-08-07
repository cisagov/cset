/*
Run this script on:

        (localdb)\INLLocalDb2022.CSETWeb12022    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDb2022.CSETWeb12023

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/21/2023 3:50:11 PM

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
PRINT N'Altering [dbo].[DOCUMENT_FILE]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ALTER COLUMN [CreatedTimestamp] [datetime] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ALTER COLUMN [UpdatedTimestamp] [datetime] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[DOCUMENT_FILE]'
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ADD CONSTRAINT [DF_DOCUMENT_FILE_CreatedTimestamp] DEFAULT (getdate()) FOR [CreatedTimestamp]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ADD CONSTRAINT [DF_DOCUMENT_FILE_UpdatedTimestamp] DEFAULT (getdate()) FOR [UpdatedTimestamp]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[DOCUMENT_FILE]'
GO
UPDATE [dbo].[DOCUMENT_FILE] SET [CreatedTimestamp]=DEFAULT WHERE [CreatedTimestamp] IS NULL
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ALTER COLUMN [CreatedTimestamp] [datetime] NOT NULL
GO
UPDATE [dbo].[DOCUMENT_FILE] SET [UpdatedTimestamp]=DEFAULT WHERE [UpdatedTimestamp] IS NULL
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ALTER COLUMN [UpdatedTimestamp] [datetime] NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[HYDRO_PROGRESS]'
GO
CREATE TABLE [dbo].[HYDRO_PROGRESS]
(
[Progress_Id] [int] NOT NULL,
[Progress_Text] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__HYDRO_PR__D558797A8254CF40] on [dbo].[HYDRO_PROGRESS]'
GO
ALTER TABLE [dbo].[HYDRO_PROGRESS] ADD CONSTRAINT [PK__HYDRO_PR__D558797A8254CF40] PRIMARY KEY CLUSTERED ([Progress_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[HYDRO_DATA_ACTIONS]'
GO
CREATE TABLE [dbo].[HYDRO_DATA_ACTIONS]
(
[Answer_Id] [int] NOT NULL,
[Progress_Id] [int] NOT NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__HYDRO_DA__36918F3818A6E56C] on [dbo].[HYDRO_DATA_ACTIONS]'
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [PK__HYDRO_DA__36918F3818A6E56C] PRIMARY KEY CLUSTERED ([Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[INTERNATIONALIZATION_VALUES]'
GO
CREATE TABLE [dbo].[INTERNATIONALIZATION_VALUES]
(
[TargetTableName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetColumnName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeyColumns] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeyValues] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LanguageCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[HYDRO_DATA_ACTIONS]'
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [FK__HYDRO_DAT__Progr__76D69450] FOREIGN KEY ([Progress_Id]) REFERENCES [dbo].[HYDRO_PROGRESS] ([Progress_Id])
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [FK_HYDRO_DATA_ACTIONS_ANSWER] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[ANSWER] ([Answer_Id]) ON DELETE CASCADE
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
