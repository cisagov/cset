/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12401    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12402

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/12/2025 1:19:22 PM

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

PRINT(N'Drop constraints from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Delete rows from [dbo].[ISE_ACTIONS]')
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 123 AND [Mat_Question_Id] = 7853
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 124 AND [Mat_Question_Id] = 7854
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 125 AND [Mat_Question_Id] = 7855
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 126 AND [Mat_Question_Id] = 7856
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 127 AND [Mat_Question_Id] = 7857
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 128 AND [Mat_Question_Id] = 7858
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 129 AND [Mat_Question_Id] = 7859
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 130 AND [Mat_Question_Id] = 7860
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 131 AND [Mat_Question_Id] = 7861
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 132 AND [Mat_Question_Id] = 7862
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 133 AND [Mat_Question_Id] = 7863
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 134 AND [Mat_Question_Id] = 7864
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 135 AND [Mat_Question_Id] = 7865
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 138 AND [Mat_Question_Id] = 7869
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 139 AND [Mat_Question_Id] = 7870
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 140 AND [Mat_Question_Id] = 7871
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 141 AND [Mat_Question_Id] = 7872
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 142 AND [Mat_Question_Id] = 7873
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 143 AND [Mat_Question_Id] = 7875
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 144 AND [Mat_Question_Id] = 7876
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 145 AND [Mat_Question_Id] = 7877
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 146 AND [Mat_Question_Id] = 7878
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 147 AND [Mat_Question_Id] = 7879
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 148 AND [Mat_Question_Id] = 7880
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 149 AND [Mat_Question_Id] = 7881
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 150 AND [Mat_Question_Id] = 7882
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 151 AND [Mat_Question_Id] = 7883
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 152 AND [Mat_Question_Id] = 7884
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 153 AND [Mat_Question_Id] = 7885
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 158 AND [Mat_Question_Id] = 7891
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 159 AND [Mat_Question_Id] = 7892
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 168 AND [Mat_Question_Id] = 7902
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 169 AND [Mat_Question_Id] = 7903
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 170 AND [Mat_Question_Id] = 7904
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 171 AND [Mat_Question_Id] = 7905
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 172 AND [Mat_Question_Id] = 7906
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 173 AND [Mat_Question_Id] = 7907
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 174 AND [Mat_Question_Id] = 7908
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 177 AND [Mat_Question_Id] = 7912
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 178 AND [Mat_Question_Id] = 7913
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 179 AND [Mat_Question_Id] = 7914
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 180 AND [Mat_Question_Id] = 7915
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 181 AND [Mat_Question_Id] = 7916
DELETE FROM [dbo].[ISE_ACTIONS] WHERE [Action_Item_Id] = 182 AND [Mat_Question_Id] = 7917
PRINT(N'Operation applied to 44 rows out of 44')

PRINT(N'Add constraints to [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
COMMIT TRANSACTION
GO
