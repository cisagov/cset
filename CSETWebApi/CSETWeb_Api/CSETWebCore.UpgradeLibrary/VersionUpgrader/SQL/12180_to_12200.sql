/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12180    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12200

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 5/22/2024 3:49:39 PM

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
PRINT N'Dropping foreign keys from [dbo].[ANSWER_PROFILE]'
GO
ALTER TABLE [dbo].[ANSWER_PROFILE] DROP CONSTRAINT [FK_ANSWER_PROFILE_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] DROP CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] DROP CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] DROP CONSTRAINT [PK_SUB_CATEGORY_ANSWERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ANSWER_PROFILE]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[ANSWER_PROFILE].[Asessment_Id]', N'Assessment_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[SUB_CATEGORY_ANSWERS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[SUB_CATEGORY_ANSWERS].[Assessement_Id]', N'Assessment_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SUB_CATEGORY_ANSWERS] on [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD CONSTRAINT [PK_SUB_CATEGORY_ANSWERS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Heading_Pair_Id], [Component_Guid], [Is_Component])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[clean_out_requirements_mode]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[clean_out_requirements_mode]
	   @standard_name nvarchar(50), @standard_name_with_mode nvarchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

/**
we will do a sheet by sheet clean
select all the q_s_r id's into a temp table
delete out all the corresponding records.

*/


SELECT * INTO #tempSetList FROM dbo.REQUIREMENT_sets WHERE Set_Name = @standard_name_with_mode;

BEGIN TRANSACTION
IF @standard_name = 'ICS'
BEGIN
	delete  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
ELSE
begin
	DELETE FROM dbo.REQUIREMENT_SOURCE_FILES
	FROM dbo.REQUIREMENT_SOURCE_FILES a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_REFERENCES
	FROM dbo.REQUIREMENT_REFERENCES a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_levels
	FROM dbo.REQUIREMENT_levels a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_QUESTIONS_SETS
	FROM dbo.REQUIREMENT_QUESTIONS_SETS a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	DELETE  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
COMMIT TRANSACTION

DROP TABLE #tempsetlist;


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[LU_WEIGHTS]'
GO
CREATE TABLE [dbo].[LU_WEIGHTS]
(
[DisplayID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WEIGHT_VAL] [float] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__LU_WEIGH__76EAD95D2B2B4749] on [dbo].[LU_WEIGHTS]'
GO
ALTER TABLE [dbo].[LU_WEIGHTS] ADD CONSTRAINT [PK__LU_WEIGH__76EAD95D2B2B4749] PRIMARY KEY CLUSTERED ([DisplayID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_MIGRATION]'
GO
CREATE TABLE [dbo].[NCSF_MIGRATION]
(
[V2id] [int] NULL,
[V2Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[V1Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[V1Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_MIGRATION] on [dbo].[NCSF_MIGRATION]'
GO
ALTER TABLE [dbo].[NCSF_MIGRATION] ADD CONSTRAINT [PK_NCSF_MIGRATION] PRIMARY KEY CLUSTERED ([V2Title], [V1Title])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[spEXECsp_RECOMPILE]'
GO
CREATE PROCEDURE [dbo].[spEXECsp_RECOMPILE] AS 

SET NOCOUNT ON 

-- 1 - Declaration statements for all variables
DECLARE @TableName varchar(128)
DECLARE @OwnerName varchar(128)
DECLARE @CMD1 varchar(8000)
DECLARE @TableListLoop int
DECLARE @TableListTable table
(UIDTableList int IDENTITY (1,1),
OwnerName varchar(128),
TableName varchar(128))

-- 2 - Outer loop for populating the database names
INSERT INTO @TableListTable(OwnerName, TableName)
SELECT u.[Name], o.[Name]
FROM sys.objects o
INNER JOIN sys.schemas u
 ON o.schema_id  = u.schema_id
WHERE o.Type = 'V'
ORDER BY o.[Name]



-- 3 - Determine the highest UIDDatabaseList to loop through the records
SELECT @TableListLoop = MAX(UIDTableList) FROM @TableListTable

-- 4 - While condition for looping through the database records
WHILE @TableListLoop > 0
 BEGIN

 -- 5 - Set the @DatabaseName parameter
 SELECT @TableName = TableName,
 @OwnerName = OwnerName
 FROM @TableListTable
 WHERE UIDTableList = @TableListLoop

 -- 6 - String together the final backup command
 SELECT @CMD1 = 'EXEC sp_recompile ' + '[' + @OwnerName + '.' + @TableName + ']' + char(13)

 -- 7 - Execute the final string to complete the backups
 SELECT @CMD1
 --EXEC (@CMD1)
 end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER_PROFILE]'
GO
ALTER TABLE [dbo].[ANSWER_PROFILE] ADD CONSTRAINT [FK_ANSWER_PROFILE_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_UNIVERSAL_SUB_CATEGORY_HEADINGS] FOREIGN KEY ([Heading_Pair_Id]) REFERENCES [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ([Heading_Pair_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Enabling constraints on [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
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
