/*
Run this script on:

        (localdb)\INLLocalDb2022.CSETWeb12020    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDb2022.CSETWeb12021

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/1/2023 11:13:19 AM

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
PRINT N'Creating [dbo].[HYDRO_DATA]'
GO
CREATE TABLE [dbo].[HYDRO_DATA]
(
[Mat_Option_Id] [int] NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Feasibility] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Feasibility_Limit] [int] NULL,
[Impact] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Impact_Limit] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [IX_HYDRO_DATA] UNIQUE CLUSTERED ([Mat_Question_Id], [Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_HYDRO_DATA] on [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [PK_HYDRO_DATA] PRIMARY KEY NONCLUSTERED ([Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [FK__HYDRO_DAT__Mat_O__377107A9] FOREIGN KEY ([Mat_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
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
