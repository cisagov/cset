/*
Run this script on:

(localdb)\MSSQLLocalDB.NCUAWeb120014    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.NCUAWeb120015

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 12/6/2022 2:29:49 PM

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

PRINT(N'Add row to [dbo].[GLOBAL_PROPERTIES]')
INSERT INTO [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'NCUAMeritExportPath', N'\\hqwinfs1\global\Field_Staff\ISE')
COMMIT TRANSACTION
GO
