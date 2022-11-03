/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb12003    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb12004

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.5.22.19589 from Red Gate Software Ltd at 10/18/2022 8:06:55 AM

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
PRINT N'Dropping foreign keys from [dbo].[FINDING]'
GO
ALTER TABLE [dbo].[FINDING] DROP CONSTRAINT [FK_FINDING_SUB_RISK_AREA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[RISK_SUB_RISK_AREA]'
GO
ALTER TABLE [dbo].[RISK_SUB_RISK_AREA] DROP CONSTRAINT [FK_RISK_SUB_RISK_AREA_RISK_AREA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[RISK_AREA]'
GO
ALTER TABLE [dbo].[RISK_AREA] DROP CONSTRAINT [PK_RISK_AREA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[RISK_SUB_RISK_AREA]'
GO
ALTER TABLE [dbo].[RISK_SUB_RISK_AREA] DROP CONSTRAINT [PK_SUB_RISK_AREA_1]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[RISK_AREA]'
GO
DROP TABLE [dbo].[RISK_AREA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[RISK_SUB_RISK_AREA]'
GO
DROP TABLE [dbo].[RISK_SUB_RISK_AREA]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[STANDARD_SELECTION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD
[Only_Mode] [bit] NOT NULL CONSTRAINT [DF_STANDARD_SELECTION_Only_Mode] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[AVAILABLE_STANDARDS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] ADD
[Suppress_Mode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STATE_REGION]'
GO
CREATE TABLE [dbo].[STATE_REGION]
(
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STATE_REGION] on [dbo].[STATE_REGION]'
GO
ALTER TABLE [dbo].[STATE_REGION] ADD CONSTRAINT [PK_STATE_REGION] PRIMARY KEY CLUSTERED ([State], [RegionCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COUNTIES]'
GO
CREATE TABLE [dbo].[COUNTIES]
(
[County_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_counties1] on [dbo].[COUNTIES]'
GO
ALTER TABLE [dbo].[COUNTIES] ADD CONSTRAINT [PK_counties1] PRIMARY KEY CLUSTERED ([County_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[METRO_AREA]'
GO
CREATE TABLE [dbo].[METRO_AREA]
(
[MetropolitanAreaName] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Metro_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MetropolitanArea_1] on [dbo].[METRO_AREA]'
GO
ALTER TABLE [dbo].[METRO_AREA] ADD CONSTRAINT [PK_MetropolitanArea_1] PRIMARY KEY CLUSTERED ([Metro_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COUNTY_METRO_AREA]'
GO
CREATE TABLE [dbo].[COUNTY_METRO_AREA]
(
[County_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Metro_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_County_MetropolitanArea] on [dbo].[COUNTY_METRO_AREA]'
GO
ALTER TABLE [dbo].[COUNTY_METRO_AREA] ADD CONSTRAINT [PK_County_MetropolitanArea] PRIMARY KEY CLUSTERED ([County_FIPS], [Metro_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DEMOGRAPHIC_ANSWERS]'
GO
CREATE TABLE [dbo].[DEMOGRAPHIC_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Employees] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomersSupported] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeographicScope] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CIOExists] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CISOExists] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CyberTrainingProgramExists] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectorId] [int] NULL,
[SubSectorId] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FloridaDemographicRenameMe] on [dbo].[DEMOGRAPHIC_ANSWERS]'
GO
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] ADD CONSTRAINT [PK_FloridaDemographicRenameMe] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[EXT_SECTOR]'
GO
CREATE TABLE [dbo].[EXT_SECTOR]
(
[SectorId] [int] NOT NULL IDENTITY(1, 1),
[SectorName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SectorHelp] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ExtendedSector] on [dbo].[EXT_SECTOR]'
GO
ALTER TABLE [dbo].[EXT_SECTOR] ADD CONSTRAINT [PK_ExtendedSector] PRIMARY KEY CLUSTERED ([SectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[EXT_SUB_SECTOR]'
GO
CREATE TABLE [dbo].[EXT_SUB_SECTOR]
(
[SectorId] [int] NOT NULL,
[SubSectorName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SubSectorId] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ExtendedSubSector_1] on [dbo].[EXT_SUB_SECTOR]'
GO
ALTER TABLE [dbo].[EXT_SUB_SECTOR] ADD CONSTRAINT [PK_ExtendedSubSector_1] PRIMARY KEY CLUSTERED ([SubSectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COUNTY_ANSWERS]'
GO
CREATE TABLE [dbo].[COUNTY_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[County_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ExtendedDemographicCountyAnswers] on [dbo].[COUNTY_ANSWERS]'
GO
ALTER TABLE [dbo].[COUNTY_ANSWERS] ADD CONSTRAINT [PK_ExtendedDemographicCountyAnswers] PRIMARY KEY CLUSTERED ([Assessment_Id], [County_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[METRO_ANSWERS]'
GO
CREATE TABLE [dbo].[METRO_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Metro_FIPS] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ExtendedDemographicMetropolitanAnswers_1] on [dbo].[METRO_ANSWERS]'
GO
ALTER TABLE [dbo].[METRO_ANSWERS] ADD CONSTRAINT [PK_ExtendedDemographicMetropolitanAnswers_1] PRIMARY KEY CLUSTERED ([Assessment_Id], [Metro_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REGION_ANSWERS]'
GO
CREATE TABLE [dbo].[REGION_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RegionCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ExtendedDemographicRegionAnswers] on [dbo].[REGION_ANSWERS]'
GO
ALTER TABLE [dbo].[REGION_ANSWERS] ADD CONSTRAINT [PK_ExtendedDemographicRegionAnswers] PRIMARY KEY CLUSTERED ([Assessment_Id], [State], [RegionCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FINDING]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINDING] ADD
[Citations] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINDING] DROP
COLUMN [Disposition],
COLUMN [Identified_Date],
COLUMN [Due_Date]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[FINDING].[Sub_Risk_Area_Id]', N'Auto_Generated', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[INFORMATION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[INFORMATION] ADD
[Origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ISE_ACTIONS]'
GO
CREATE TABLE [dbo].[ISE_ACTIONS]
(
[Question_Id] [int] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action_Items] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regulatory_Citation] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__ISE_ACTI__B0B2E4E66B6807D2] on [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [PK__ISE_ACTI__B0B2E4E66B6807D2] PRIMARY KEY CLUSTERED ([Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetRelevantAnswers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Returns a table containing ANSWER rows that are relevant
--              to the assessment's current question mode, standard selection and SAL level.
-- =============================================
ALTER PROCEDURE [dbo].[GetRelevantAnswers]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	-- get the application mode
	declare @applicationMode nvarchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- get currently selected sets
	IF OBJECT_ID('tempdb..#mySets') IS NOT NULL DROP TABLE #mySets
	select set_name into #mySets from AVAILABLE_STANDARDS where Assessment_Id = @assessment_Id and Selected = 1

	IF OBJECT_ID('tempdb..#relevantAnswers') IS NOT NULL DROP TABLE #relevantAnswers
	CREATE TABLE #relevantAnswers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)
	
	if(@ApplicationMode = 'Questions Based')	
	begin
		insert into #relevantAnswers
		select distinct a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id, a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed

			FROM ANSWER a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id			
			join (
				select distinct s.question_id, ns.Short_Name from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join SETS ns on s.Set_Name = ns.Set_Name
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
					join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
					join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
			)	s on c.Question_Id = s.Question_Id		
			where a.Assessment_Id = @assessment_id 
			and a.Is_Requirement = 0
	
	end
	else
	begin		
		insert into #relevantAnswers
		select distinct a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed

			from REQUIREMENT_SETS rs
				left join ANSWER a on a.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and a.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level 	
	end
	-- Get all of the component questions. The questions available are not currently filtered by SAL level, so just get them all.
	insert into #relevantAnswers
	select distinct a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed
			from ANSWER a
			where a.Assessment_Id = @assessment_id and a.Question_Type = 'Component'

	select a.assessment_id, a.answer_id, a.is_requirement, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed
			from #relevantAnswers a
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetChildrenAnswers]'
GO
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetChildrenAnswers]
   @Parent_Id int,
   @Assess_Id int
  
AS
BEGIN
   SET NOCOUNT ON;
   SELECT [Mat_Question_Id], [Question_Title], [Question_Text],
          [Answer_Text], [Maturity_Level_Id], [Parent_Question_Id],
          [Ranking], [Grouping_Id] FROM MATURITY_QUESTIONS
       JOIN ANSWER
       ON MATURITY_QUESTIONS.Mat_Question_Id = ANSWER.Question_Or_Requirement_Id
   WHERE ([Parent_Question_Id] = @Parent_Id) AND ([Assessment_Id] = @Assess_Id) AND ([Maturity_Level_Id] != 19)
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[IseAnswerDistribution]'
GO

-- =============================================
-- Author:	mrwinston
-- Create date: 10/10/2022
-- Description:	Gets all the AnswerText values, excluding parent questions
-- =============================================
CREATE PROCEDURE [dbo].[IseAnswerDistribution] 
	@Assessment_Id int,
	@targetLevel int
AS
BEGIN

	SET NOCOUNT ON;

	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id

	declare @model_id int
	select @model_id = (select model_id from AVAILABLE_MATURITY_MODELS where assessment_id = @Assessment_id and selected = 1)


    select a.Answer_Text, count(*) as [Count] from maturity_questions q 
	left join answer a on a.Question_Or_Requirement_Id = q.Mat_Question_Id
	left join maturity_levels l on q.Maturity_Level_Id = l.Maturity_Level_Id
	where a.Question_Type = 'Maturity' and q.Maturity_Model_Id = @model_id
	and l.Maturity_Level_Id = @targetLevel
	and a.Assessment_Id = @assessment_id
	and q.Parent_Question_Id IS NOT NULL
	and q.Maturity_Level_Id != 19
	group by Answer_Text


END
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
PRINT N'Adding foreign keys to [dbo].[COUNTY_METRO_AREA]'
GO
ALTER TABLE [dbo].[COUNTY_METRO_AREA] ADD CONSTRAINT [FK_County_MetropolitanArea_COUNTIES] FOREIGN KEY ([County_FIPS]) REFERENCES [dbo].[COUNTIES] ([County_FIPS])
GO
ALTER TABLE [dbo].[COUNTY_METRO_AREA] ADD CONSTRAINT [FK_COUNTY_METRO_AREA_METRO_AREA] FOREIGN KEY ([Metro_FIPS]) REFERENCES [dbo].[METRO_AREA] ([Metro_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COUNTY_ANSWERS]'
GO
ALTER TABLE [dbo].[COUNTY_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicCountyAnswers_COUNTIES] FOREIGN KEY ([County_FIPS]) REFERENCES [dbo].[COUNTIES] ([County_FIPS])
GO
ALTER TABLE [dbo].[COUNTY_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicCountyAnswers_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COUNTIES]'
GO
ALTER TABLE [dbo].[COUNTIES] ADD CONSTRAINT [FK_COUNTIES_STATE_REGION] FOREIGN KEY ([State], [RegionCode]) REFERENCES [dbo].[STATE_REGION] ([State], [RegionCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DEMOGRAPHIC_ANSWERS]'
GO
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicAnswer_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicAnswer_ExtendedSector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[EXT_SECTOR] ([SectorId])
GO
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicAnswer_ExtendedSubSector] FOREIGN KEY ([SubSectorId]) REFERENCES [dbo].[EXT_SUB_SECTOR] ([SubSectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[EXT_SUB_SECTOR]'
GO
ALTER TABLE [dbo].[EXT_SUB_SECTOR] ADD CONSTRAINT [FK_ExtendedSubSector_ExtendedSector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[EXT_SECTOR] ([SectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[METRO_ANSWERS]'
GO
ALTER TABLE [dbo].[METRO_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicMetropolitanAnswers_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[METRO_ANSWERS] ADD CONSTRAINT [FK_METRO_ANSWERS_METRO_AREA] FOREIGN KEY ([Metro_FIPS]) REFERENCES [dbo].[METRO_AREA] ([Metro_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REGION_ANSWERS]'
GO
ALTER TABLE [dbo].[REGION_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicRegionAnswers_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REGION_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicRegionAnswers_STATE_REGION] FOREIGN KEY ([State], [RegionCode]) REFERENCES [dbo].[STATE_REGION] ([State], [RegionCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_Description', N'ISE specific fields for issues', 'SCHEMA', N'dbo', 'TABLE', N'ISE_ACTIONS', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
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
