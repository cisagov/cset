/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb120011    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.NCUAWeb120012

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/22/2022 8:20:23 AM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION

PRINT(N'Drop constraint FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Delete row from [dbo].[GALLERY_ITEM]')
DELETE FROM [dbo].[GALLERY_ITEM] WHERE [Gallery_Item_Id] = 1129

PRINT(N'Update row in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Description]=N'The Information Security Examination (ISE) provides a repeatable and consistent process for conducting the examination. The ISE is designed for credit unions of all asset sizes and complexities.', [Title]=N'Information Security Evaluation (ISE)' WHERE [Gallery_Item_Id] = 102
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
