/*
Run this script on:

(localdb)\MSSQLLocalDB.NCUAWeb12007    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.NCUAWeb12008

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/8/2022 1:44:30 PM

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

PRINT(N'Drop constraints from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Delete row from [dbo].[GALLERY_GROUP_DETAILS]')
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 2140

PRINT(N'Delete row from [dbo].[GALLERY_GROUP]')
DELETE FROM [dbo].[GALLERY_GROUP] WHERE [Group_Id] = 54

PRINT(N'Update rows in [dbo].[GALLERY_ROWS]')
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=2 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 0
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=3 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 1
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=4 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 2
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=5 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 3
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=6 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 4
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=7 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 5
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=8 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 6
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=9 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 7
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=10 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 8
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=12 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 10
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=13 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 11
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=14 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 12
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=15 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 13
PRINT(N'Operation applied to 13 rows out of 13')

PRINT(N'Update row in [dbo].[GALLERY_GROUP_DETAILS]')
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Group_Id]=31, [Column_Index]=0 WHERE [Group_Detail_Id] = 114

PRINT(N'Update row in [dbo].[GALLERY_GROUP]')
UPDATE [dbo].[GALLERY_GROUP] SET [Group_Title]=N'Transportation' WHERE [Group_Id] = 27

PRINT(N'Add rows to [dbo].[GALLERY_ROWS]')
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'NCUA', 23, 24)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 14, 16)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 15, 17)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 16, 18)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 17, 19)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 18, 20)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 19, 21)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 20, 22)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 21, 23)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 22, 24)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 23, 25)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 24, 26)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 25, 27)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 26, 28)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 27, 29)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 28, 30)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 29, 31)
PRINT(N'Operation applied to 17 rows out of 17')

PRINT(N'Add constraints to [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
