/*
Run this script on:

(localdb)\MSSQLLocalDB.NCUAWeb12006    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.NCUAWeb12007

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 11/8/2022 10:31:30 AM

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

PRINT(N'Drop constraint FK_ISE_ACTIONS_FINDINGS_ISE_ACTIONS from [dbo].[ISE_ACTIONS_FINDINGS]')
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] NOCHECK CONSTRAINT [FK_ISE_ACTIONS_FINDINGS_ISE_ACTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 18.1' WHERE [Mat_Question_Id] = 7870
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 18.2' WHERE [Mat_Question_Id] = 7871
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 18.3' WHERE [Mat_Question_Id] = 7872
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 18.4' WHERE [Mat_Question_Id] = 7873
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 18.5' WHERE [Mat_Question_Id] = 7874
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Add rows to [dbo].[ISE_ACTIONS]')
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7854, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7855, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7856, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7857, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7858, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7859, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7860, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7861, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7862, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7863, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7864, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7865, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7866, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7867, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7868, N'', N'', N'', 7853)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7870, N'', N'', N'', 7869)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7871, N'', N'', N'', 7869)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7872, N'', N'', N'', 7869)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7873, N'', N'', N'', 7869)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7874, N'', N'', N'', 7869)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7876, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7877, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7878, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7879, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7880, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7881, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7882, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7883, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7884, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7885, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7886, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7887, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7888, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7889, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7890, N'', N'', N'', 7875)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7892, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7893, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7894, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7895, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7896, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7897, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7898, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7899, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7900, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7901, N'', N'', N'', 7891)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7903, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7904, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7905, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7906, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7907, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7908, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7909, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7910, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7911, N'', N'', N'', 7902)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7913, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7914, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7915, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7916, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7917, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7918, N'', N'', N'', 7912)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7920, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7921, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7922, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7923, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7924, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7925, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7926, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7927, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7928, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7929, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7930, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7931, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7932, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7933, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7934, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7935, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7936, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7937, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7938, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7939, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7940, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7941, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7942, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7943, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7944, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7945, N'', N'', N'', 7919)
INSERT INTO [dbo].[ISE_ACTIONS] ([Mat_Question_Id], [Description], [Action_Items], [Regulatory_Citation], [Parent_Id]) VALUES (7946, N'', N'', N'', 7919)
PRINT(N'Operation applied to 87 rows out of 87')

PRINT(N'Add constraints to [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] WITH CHECK CHECK CONSTRAINT [FK_ISE_ACTIONS_FINDINGS_ISE_ACTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
COMMIT TRANSACTION
GO
