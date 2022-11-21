/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb12009    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb120010

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/21/2022 10:38:41 AM

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

PRINT(N'Delete rows from [dbo].[GALLERY_ROWS]')
DELETE FROM [dbo].[GALLERY_ROWS] WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 12
DELETE FROM [dbo].[GALLERY_ROWS] WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 13
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Delete rows from [dbo].[GALLERY_GROUP_DETAILS]')
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 52
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 112
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 1123
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 2159
DELETE FROM [dbo].[GALLERY_GROUP_DETAILS] WHERE [Group_Detail_Id] = 2161
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Update rows in [dbo].[GALLERY_ROWS]')
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=73 WHERE [Layout_Name] = N'CSET' AND [Row_Index] = 7
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=9 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 3
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=2 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 4
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=5 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 5
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=3 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 6
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=4 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 7
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=11 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 8
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=14 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 9
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=15 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 10
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=30 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 11
PRINT(N'Operation applied to 10 rows out of 10')

PRINT(N'Update rows in [dbo].[GALLERY_GROUP_DETAILS]')
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=2 WHERE [Group_Detail_Id] = 15
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=4 WHERE [Group_Detail_Id] = 16
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=5 WHERE [Group_Detail_Id] = 17
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=7 WHERE [Group_Detail_Id] = 18
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=3 WHERE [Group_Detail_Id] = 75
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=1 WHERE [Group_Detail_Id] = 102
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=6 WHERE [Group_Detail_Id] = 105
PRINT(N'Operation applied to 7 rows out of 7')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] ON
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (71, N'Financial')
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (72, N'Financial Online')
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (73, N'Financial CSET')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] OFF
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add row to [dbo].[GALLERY_LAYOUT]')
INSERT INTO [dbo].[GALLERY_LAYOUT] ([Layout_Name]) VALUES (N'ONLINE')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2176, 71, 1, 102, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2177, 71, 2, 85, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2178, 71, 0, 28, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2179, 72, 0, 28, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2180, 72, 2, 85, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2182, 6, 0, 76, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2183, 73, 0, 28, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (2184, 73, 2, 85, 0)
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Add rows to [dbo].[GALLERY_ROWS]')
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 0, 1)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 1, 2)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 2, 4)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 3, 9)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 4, 3)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 5, 5)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 6, 72)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 7, 6)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 9, 30)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 10, 11)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 11, 13)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 12, 15)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'ONLINE', 13, 14)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 2, 6)
PRINT(N'Operation applied to 14 rows out of 14')

PRINT(N'Add constraints to [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
