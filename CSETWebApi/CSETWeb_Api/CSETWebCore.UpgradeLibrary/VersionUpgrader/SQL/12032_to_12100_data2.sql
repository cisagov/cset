/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12032    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12100

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 11/10/2023 9:07:58 AM

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

PRINT(N'Drop constraints from [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_SUB_MODELS]

PRINT(N'Drop constraints from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Update rows in [dbo].[MATURITY_SOURCE_FILES]')
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7568 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'ID.GV-1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7568 AND [Gen_File_Id] = 3943 AND [Section_Ref] = N'II.C.1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7568 AND [Gen_File_Id] = 6088 AND [Section_Ref] = N'page 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7569 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7569 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, A, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7569 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7570 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7570 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, a'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7570 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 223'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7571 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'PE-3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=5 WHERE [Mat_Question_Id] = 7571 AND [Gen_File_Id] = 3970 AND [Section_Ref] = N'3.10.1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7571 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7571 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, b'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7571 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 228'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7572 AND [Gen_File_Id] = 6087 AND [Section_Ref] = N'3.10, 3.11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7572 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7572 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, c'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7572 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 230 & 231'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7573 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7573 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 93 & 283'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7574 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'AC-5'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=5 WHERE [Mat_Question_Id] = 7574 AND [Gen_File_Id] = 3970 AND [Section_Ref] = N'3.1.4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7574 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7574 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, e'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7574 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 219'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7575 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'MP-6'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7575 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7575 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 393'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7576 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7576 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, A, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7576 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 1 & 393'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7578 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 13'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7578 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7579 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'SA-9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7579 AND [Gen_File_Id] = 6087 AND [Section_Ref] = N'15'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7579 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 13'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7579 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 388'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7580 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7580 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7580 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 90'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7583 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7583 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7583 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7584 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7584 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 90'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7585 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7585 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7585 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7586 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7586 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7586 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7587 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 5'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7587 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7590 AND [Gen_File_Id] = 3866 AND [Section_Ref] = N'PR.AT-1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7590 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 10'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7590 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7590 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 118'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7595 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7595 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7596 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7596 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7596 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 464'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7596 AND [Gen_File_Id] = 7073 AND [Section_Ref] = N'Update Response Plan'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7597 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7597 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7598 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7598 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7599 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7599 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7599 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7600 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7600 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7600 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7601 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7601 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7601 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7603 AND [Gen_File_Id] = 6118 AND [Section_Ref] = N'Policies and Procedures'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7603 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'C'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7603 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 380'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7604 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7604 AND [Gen_File_Id] = 6118 AND [Section_Ref] = N'Controls'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7604 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, D, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7604 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 377'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7605 AND [Gen_File_Id] = 6118 AND [Section_Ref] = N'Staff Oversight'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7605 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 378'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7606 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7606 AND [Gen_File_Id] = 6118 AND [Section_Ref] = N'Legal Review'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7606 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, D, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7606 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 388'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7608 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Plan Detail'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7608 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'3, i-Vii'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7608 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 416'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7609 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Business Impact Analysis'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7609 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7609 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 421'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7610 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Validation'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7610 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'3, Vii'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7610 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 417'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7611 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Organizational Planning Guidelines'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7611 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7616 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 8'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7616 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, a'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7616 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 223, 224, 225, 226'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7617 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 8'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7617 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, f'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7617 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 187'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7618 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 8'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7618 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, f'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7618 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 187, 188, 198'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7620 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7620 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, A, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7620 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7621 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7621 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, a'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7621 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 223'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7622 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'PE-3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=5 WHERE [Mat_Question_Id] = 7622 AND [Gen_File_Id] = 3970 AND [Section_Ref] = N'3.10.1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7622 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7622 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, b'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7622 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 228'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7623 AND [Gen_File_Id] = 6087 AND [Section_Ref] = N'3.10'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7623 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7623 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, c'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7623 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 230'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7624 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7624 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 93, 283'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7625 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'AC-5'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=5 WHERE [Mat_Question_Id] = 7625 AND [Gen_File_Id] = 3970 AND [Section_Ref] = N'3.1.4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7625 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 7'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7625 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 1, e'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7625 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 219'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7626 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'MP-6'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7626 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7626 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 393'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7627 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7627 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, A, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7627 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 1, 393'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7629 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 13'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7629 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7630 AND [Gen_File_Id] = 3968 AND [Section_Ref] = N'SA-9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=4 WHERE [Mat_Question_Id] = 7630 AND [Gen_File_Id] = 6087 AND [Section_Ref] = N'15'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7630 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 12'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7630 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 388, 389'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7631 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7631 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7631 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 90, 389'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7640 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7640 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7640 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7641 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7641 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 90'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7642 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7642 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7642 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7643 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 4'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7643 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, B, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7643 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7644 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 5'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7644 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7646 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7646 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 65, 90, 96'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7657 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 10'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7657 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, C, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7657 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 118'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7662 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7662 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7663 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7663 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7663 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 464'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7664 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7664 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7665 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7665 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7666 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7666 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7666 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7667 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7667 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7667 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7668 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7668 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N''
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7668 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 483'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7670 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'C'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7670 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 380'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7671 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7671 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, D, 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7671 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 377'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7673 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 11'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7673 AND [Gen_File_Id] = 7070 AND [Section_Ref] = N'III, D, 2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7673 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 388'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7675 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Plan Detail'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7675 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'3, i-Vii'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7675 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 416'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7676 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Business Impact Analysis'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7676 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'2'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7676 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 421'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7677 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Validation'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7677 AND [Gen_File_Id] = 7069 AND [Section_Ref] = N'3, Vii'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=3 WHERE [Mat_Question_Id] = 7677 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 417'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7678 AND [Gen_File_Id] = 6095 AND [Section_Ref] = N'Organizational Planning Guidelines'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7678 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 3'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7680 AND [Gen_File_Id] = 6099 AND [Section_Ref] = N'Developing an Effective Patch Management Program'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7680 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 337'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7681 AND [Gen_File_Id] = 6099 AND [Section_Ref] = N'Page 1'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7681 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 337'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7682 AND [Gen_File_Id] = 6099 AND [Section_Ref] = N'Evaluating the Impact of Patches'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 7682 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 339'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=1 WHERE [Mat_Question_Id] = 9919 AND [Gen_File_Id] = 6092 AND [Section_Ref] = N'Page 9'
UPDATE [dbo].[MATURITY_SOURCE_FILES] SET [Sequence]=2 WHERE [Mat_Question_Id] = 9919 AND [Gen_File_Id] = 7073 AND [Section_Ref] = N'Update Response Plan'
PRINT(N'Operation applied to 209 rows out of 209')

PRINT(N'Add row to [dbo].[MATURITY_SUB_MODELS]')
INSERT INTO [dbo].[MATURITY_SUB_MODELS] ([Sub_Model_Name]) VALUES (N'RRA CF')

PRINT(N'Add rows to [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
INSERT INTO [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ([Mat_Question_Id], [Sub_Model_Name]) VALUES (1920, N'RRA CF')
INSERT INTO [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ([Mat_Question_Id], [Sub_Model_Name]) VALUES (1925, N'RRA CF')
INSERT INTO [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ([Mat_Question_Id], [Sub_Model_Name]) VALUES (1937, N'RRA CF')
INSERT INTO [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ([Mat_Question_Id], [Sub_Model_Name]) VALUES (1938, N'RRA CF')
INSERT INTO [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ([Mat_Question_Id], [Sub_Model_Name]) VALUES (1939, N'RRA CF')
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Add constraints to [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_SUB_MODELS]

PRINT(N'Add constraints to [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
COMMIT TRANSACTION
GO
