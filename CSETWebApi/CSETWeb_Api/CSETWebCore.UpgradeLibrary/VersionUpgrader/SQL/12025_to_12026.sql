/*
Run this script on:

        (localdb)\INLLocalDb2022.CSETWeb12025    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDb2022.CSETWeb12026

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 8/14/2023 5:25:17 PM

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
PRINT N'Altering [dbo].[SECTOR]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[SECTOR] ADD
[Is_NIPP] [bit] NOT NULL CONSTRAINT [DF__SECTOR__Is_NIPP__4C214075] DEFAULT ((0)),
[NIPP_sector] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[SECTOR_INDUSTRY]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[SECTOR_INDUSTRY] ADD
[Is_NIPP] [bit] NOT NULL CONSTRAINT [DF__SECTOR_IN__Is_NI__4D1564AE] DEFAULT ((0)),
[Is_Other] [bit] NOT NULL CONSTRAINT [DF__SECTOR_IN__Is_Ot__4E0988E7] DEFAULT ((0)),
[NIPP_subsector] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DETAILS_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[DETAILS_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[DataItemName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StringValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntValue] [int] NULL,
[FloatValue] [float] NULL,
[BoolValue] [bit] NULL,
[DateTimeValue] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DETAILS_DEMOGRAPHICS] on [dbo].[DETAILS_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[DETAILS_DEMOGRAPHICS] ADD CONSTRAINT [PK_DETAILS_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id], [DataItemName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]'
GO
CREATE TABLE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]
(
[Option_Id] [int] NOT NULL IDENTITY(1, 1),
[DataItemName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL,
[OptionValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OptionText] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DETAIL_DEMOG_OPTIONS] on [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]'
GO
ALTER TABLE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ADD CONSTRAINT [PK_DETAIL_DEMOG_OPTIONS] PRIMARY KEY CLUSTERED ([Option_Id])
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
