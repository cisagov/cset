/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb120019    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb12012

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 1/26/2023 11:23:05 AM

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

PRINT(N'Update rows in [dbo].[GALLERY_ROWS]')
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=1071 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 0
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=13 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 1
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=6 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 2
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=2 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 3
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=9 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 4
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=5 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 5
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=3 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 6
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=4 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 7
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=11 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 8
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=14 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 9
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=15 WHERE [Layout_Name] = N'TSA' AND [Row_Index] = 10
PRINT(N'Operation applied to 11 rows out of 11')

PRINT(N'Update rows in [dbo].[GALLERY_GROUP_DETAILS]')
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=4 WHERE [Group_Detail_Id] = 40
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Group_Id]=1071 WHERE [Group_Detail_Id] = 41
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Group_Id]=1071 WHERE [Group_Detail_Id] = 42
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=1 WHERE [Group_Detail_Id] = 44
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=2 WHERE [Group_Detail_Id] = 57
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Column_Index]=3 WHERE [Group_Detail_Id] = 92
UPDATE [dbo].[GALLERY_GROUP_DETAILS] SET [Group_Id]=1071, [Column_Index]=5 WHERE [Group_Detail_Id] = 114
PRINT(N'Operation applied to 7 rows out of 7')

PRINT(N'Update row in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Configuration_Setup]=N'{Model:{ModelName:"VADR"}, Sets:["TSA2018"], SALLevel:"Low"}' WHERE [Gallery_Item_Id] = 108

PRINT(N'Add row to [dbo].[GALLERY_GROUP]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] ON
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (1071, N'Basic TSA Assessments')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] OFF

PRINT(N'Add rows to [dbo].[GALLERY_ITEM]')
SET IDENTITY_INSERT [dbo].[GALLERY_ITEM] ON
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Id], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES (1131, N'TSA2018.png', N'TSA2018.png', N'', N'These guidelines are applicable to operational natural gas and hazardous liquid transmission pipeline systems, natural gas distribution pipeline systems, and liquefied natural gas facility operators. Additionally, they apply to operational pipeline systems that transport materials categorized as toxic inhalation hazards (TIH). TIH materials are gases or liquids that are known or presumed on the basis of tests to be so toxic to humans as to pose a health hazard in the event of a release during transportation.

This standard includes the replacement of section 5 (Criticality)', NULL, N'Basic TSA Pipeline Security Guidelines March 2018 with April 2021 revision', 1, '2023-01-24 16:35:24.697')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Id], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES (1132, N'VADR.png', N'VADR.png', N'', N'The VADR maturity model enables participants to perform assessments virtually. Virtual assessments include the same elements that make up a traditional VADR: Architecture Design Review, System Configuration and Log Review, as well as Network Traffic Analysis.', NULL, N'Basic TSA Validated Architecture Design Reviews (VADR)', 1, '2023-01-24 16:35:38.980')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Id], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES (1133, N'RRA.png', N'RRA.png', N'', N'Securing Control and Communications Systems in Rail Transit Environments', NULL, N'Basic Defining a Security Zone Architecture for Rail Transit and Protecting Critical Zones', 1, '2023-01-24 16:36:09.657')
SET IDENTITY_INSERT [dbo].[GALLERY_ITEM] OFF
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4177, 13, 5, 90, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4178, 13, 6, 108, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4179, 13, 7, 29, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4181, 1071, 0, 28, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4182, 1071, 1, 1131, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (4183, 1071, 2, 1131, 0)
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Add row to [dbo].[GALLERY_ROWS]')
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'TSA', 11, 30)

PRINT(N'Add constraints to [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
