/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb120015    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb120016

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.7.8.21163 from Red Gate Software Ltd at 12/19/2022 2:16:05 PM

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
PRINT N'Dropping foreign keys from [dbo].[FINANCIAL_GROUPS]'
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] DROP CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_MATURITY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] DROP CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_DOMAINS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] DROP CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_ASSESSMENT_FACTORS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] DROP CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_COMPONENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[FINANCIAL_MATURITY]'
GO
ALTER TABLE [dbo].[FINANCIAL_MATURITY] DROP CONSTRAINT [PK_FINANCIAL_MATURITY]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[FiltersNormalized]'
GO
ALTER TABLE [dbo].[FiltersNormalized] DROP CONSTRAINT [PK_FiltersNormalized]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_FINANCIAL_GROUPS] from [dbo].[FINANCIAL_GROUPS]'
GO
DROP INDEX [IX_FINANCIAL_GROUPS] ON [dbo].[FINANCIAL_GROUPS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[FiltersNormalized]'
GO
DROP TABLE [dbo].[FiltersNormalized]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[AssessmentEffectiveDate] [datetime2] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_QUESTIONS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD
[Supplemental_Fact] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FINANCIAL_GROUPS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[FINANCIAL_GROUPS].[MaturityId]', N'Financial_Level_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_GROUPS] on [dbo].[FINANCIAL_GROUPS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_GROUPS] ON [dbo].[FINANCIAL_GROUPS] ([DomainId], [AssessmentFactorId], [FinComponentId], [Financial_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]'
GO
CREATE TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
(
[Assessment_Id] [int] NOT NULL,
[DomainId] [int] NOT NULL,
[Financial_Level_Id] [int] NOT NULL,
[IsOn] [bit] NOT NULL CONSTRAINT [DF_FiltersNormalized_IsOn] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FiltersNormalized] on [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]'
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS_V2] ADD CONSTRAINT [PK_FiltersNormalized] PRIMARY KEY CLUSTERED ([Assessment_Id], [DomainId], [Financial_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FINANCIAL_MATURITY]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[FINANCIAL_MATURITY].[MaturityId]', N'Financial_Level_Id', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_MATURITY] on [dbo].[FINANCIAL_MATURITY]'
GO
ALTER TABLE [dbo].[FINANCIAL_MATURITY] ADD CONSTRAINT [PK_FINANCIAL_MATURITY] PRIMARY KEY CLUSTERED ([Financial_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FINDING]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[FINDING] ADD
[Supp_Guidance] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[vFinancialGroups]'
GO

ALTER VIEW [dbo].[vFinancialGroups]
AS
SELECT        dbo.FINANCIAL_GROUPS.FinancialGroupId, dbo.FINANCIAL_DOMAINS.Domain, dbo.FINANCIAL_MATURITY.MaturityLevel, dbo.FINANCIAL_ASSESSMENT_FACTORS.AssessmentFactor, 
                         dbo.FINANCIAL_COMPONENTS.FinComponent
FROM            dbo.FINANCIAL_GROUPS INNER JOIN
                         dbo.FINANCIAL_DOMAINS ON dbo.FINANCIAL_GROUPS.DomainId = dbo.FINANCIAL_DOMAINS.DomainId INNER JOIN
                         dbo.FINANCIAL_MATURITY ON dbo.FINANCIAL_GROUPS.Financial_Level_Id = dbo.FINANCIAL_MATURITY.Financial_Level_Id INNER JOIN
                         dbo.FINANCIAL_ASSESSMENT_FACTORS ON dbo.FINANCIAL_GROUPS.AssessmentFactorId = dbo.FINANCIAL_ASSESSMENT_FACTORS.AssessmentFactorId INNER JOIN
                         dbo.FINANCIAL_COMPONENTS ON dbo.FINANCIAL_GROUPS.FinComponentId = dbo.FINANCIAL_COMPONENTS.FinComponentId
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Answer_Components]'
GO
ALTER VIEW [dbo].[Answer_Components]
AS
SELECT a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, a.Component_Guid, a.Is_Component, a.Is_Framework, 
                  a.Reviewed, a.FeedBack, q.Simple_Question AS QuestionText
FROM     dbo.ANSWER AS a INNER JOIN
                  dbo.NEW_QUESTION AS q ON q.Question_Id = a.Question_Or_Requirement_Id
WHERE  (a.Is_Requirement = 0) AND (a.Is_Component = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getFinancialQuestions]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getFinancialQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select r.Requirement_title, r.Requirement_text, a.Answer_text, m.MaturityLevel  from 
	FINANCIAL_DOMAIN_FILTERS_V2 f 	
	join FINANCIAL_GROUPS g on f.domainid = g.domainid and f.Financial_Level_Id = g.Financial_Level_Id
	join FINANCIAL_MATURITY m on g.Financial_Level_Id = m.Financial_Level_Id
	join FINANCIAL_DETAILS fd on g.FinancialGroupId = fd.FinancialGroupId
	join FINANCIAL_REQUIREMENTS fr on fd.StmtNumber = fr.StmtNumber
	join NEW_REQUIREMENT r on fr.Requirement_Id=r.Requirement_Id
	join Answer_Requirements a on r.requirement_id = a.Question_Or_Requirement_Id 
where a.assessment_id = @assessment_id and f.assessment_id = @assessment_id and f.IsOn = 1
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CSAF_FILE]'
GO
CREATE TABLE [dbo].[CSAF_FILE]
(
[File_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [varbinary] (max) NULL,
[File_Size] [float] NULL,
[Upload_Date] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CSAF_FILE] on [dbo].[CSAF_FILE]'
GO
ALTER TABLE [dbo].[CSAF_FILE] ADD CONSTRAINT [PK_CSAF_FILE] PRIMARY KEY CLUSTERED ([File_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]'
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS_V2] ADD CONSTRAINT [FK_FINANCIAL_DOMAIN_FILTERS_V2_FINANCIAL_DOMAINS] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[FINANCIAL_DOMAINS] ([DomainId])
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS_V2] ADD CONSTRAINT [FK_FINANCIAL_DOMAIN_FILTERS_V2_FINANCIAL_MATURITY] FOREIGN KEY ([Financial_Level_Id]) REFERENCES [dbo].[FINANCIAL_MATURITY] ([Financial_Level_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_GROUPS]'
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_MATURITY] FOREIGN KEY ([Financial_Level_Id]) REFERENCES [dbo].[FINANCIAL_MATURITY] ([Financial_Level_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_DOMAINS] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[FINANCIAL_DOMAINS] ([DomainId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_ASSESSMENT_FACTORS] FOREIGN KEY ([AssessmentFactorId]) REFERENCES [dbo].[FINANCIAL_ASSESSMENT_FACTORS] ([AssessmentFactorId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_COMPONENTS] FOREIGN KEY ([FinComponentId]) REFERENCES [dbo].[FINANCIAL_COMPONENTS] ([FinComponentId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_Description', N'A collection of FiltersNormalized records', 'SCHEMA', N'dbo', 'TABLE', N'FINANCIAL_DOMAIN_FILTERS_V2', NULL, NULL
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
