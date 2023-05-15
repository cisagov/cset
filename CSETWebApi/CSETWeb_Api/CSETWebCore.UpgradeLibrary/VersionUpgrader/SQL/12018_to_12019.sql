/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb12018    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb12019

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 5/12/2023 10:58:10 AM

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
PRINT N'Dropping foreign keys from [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] DROP CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[GALLERY_GROUP_DETAILS]'
GO
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] DROP CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM] FOREIGN KEY ([GalleryItemGuid]) REFERENCES [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid]) ON DELETE SET NULL ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GALLERY_GROUP_DETAILS]'
GO
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] ADD CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM] FOREIGN KEY ([Gallery_Item_Guid]) REFERENCES [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid]) ON DELETE CASCADE ON UPDATE CASCADE
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
