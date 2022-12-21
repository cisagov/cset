/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb11013    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb11100

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.6.10.20102 from Red Gate Software Ltd at 6/22/2022 2:45:46 PM

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
PRINT N'Dropping foreign keys from [dbo].[CyOTE]'
GO
ALTER TABLE [dbo].[CyOTE] DROP CONSTRAINT [FK_CyOTE_ANSWER_LOOKUP]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] DROP CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] DROP CONSTRAINT [FK_ANSWER_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] DROP CONSTRAINT [IX_ANSWER]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ANSWER_QUESTION_TYPES]'
GO
ALTER TABLE [dbo].[ANSWER_QUESTION_TYPES] DROP CONSTRAINT [PK_Answer_Question_Types]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CyOTE]'
GO
ALTER TABLE [dbo].[CyOTE] DROP CONSTRAINT [PK_CyOTE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CyOTE]'
GO
DROP TABLE [dbo].[CyOTE]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[ASSESSMENTS].[LastAccessedDate]', N'LastModifiedDate', N'COLUMN'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ANSWER]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANSWER] ADD
[Mat_Option_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [IX_ANSWER] UNIQUE NONCLUSTERED ([Assessment_Id], [Question_Or_Requirement_Id], [Question_Type], [Component_Guid], [Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_GROUPINGS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ADD
[Title_Prefix] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_QUESTIONS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD
[Mat_Question_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Option_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_MODELS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_MODELS] ADD
[Analytics_Rollup_Level] [int] NOT NULL CONSTRAINT [DF_MATURITY_MODELS_Analytics_Rollup_Level] DEFAULT ((1)),
[Model_Description] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model_Title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_MATURITY_MODELS] on [dbo].[MATURITY_MODELS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MATURITY_MODELS] ON [dbo].[MATURITY_MODELS] ([Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANALYTICS_MATURITY_GROUPINGS]'
GO
CREATE TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS]
(
[Maturity_Model_Id] [int] NOT NULL,
[Maturity_Question_Id] [int] NOT NULL,
[Question_Group] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ANALYTICS_MATURITY_GROUPINGS] on [dbo].[ANALYTICS_MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] ADD CONSTRAINT [PK_ANALYTICS_MATURITY_GROUPINGS] PRIMARY KEY CLUSTERED ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_setup_maturity_groupings]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 3/31/2022
-- Description:	setup for analytics.  This stored proces creates a global temporary
-- table that contains the categories to group by for each maturity model. 
-- the stored proc should look to see if the temporary table exists if it does then 
-- we don't need to do anything if it does not then we should build the temp table
-- =============================================
CREATE PROCEDURE [dbo].[analytics_setup_maturity_groupings]
AS
BEGIN
	SET NOCOUNT ON;
	/*
	clean out the table and rebuild it
	go through the maturity models table and for each one select the appropriate level 
	of maturity grouping (make sure they are distinct)
	into the temp table
	*/
delete from analytics_maturity_Groupings

declare @maturity_model_id int, @analytics_rollup_level int


DECLARE maturity_cursor CURSOR FOR   
SELECT Maturity_Model_Id,Analytics_Rollup_Level 
FROM MATURITY_MODELS
  
OPEN maturity_cursor  
  
FETCH NEXT FROM maturity_cursor   
INTO @maturity_model_id, @analytics_rollup_level
  
WHILE @@FETCH_STATUS = 0  
BEGIN      
	INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id],[Maturity_Question_Id],[Question_Group])
	select distinct g.Maturity_Model_Id,q.Mat_Question_Id, title 
	from MATURITY_GROUPINGS g join MATURITY_QUESTIONS q on g.Grouping_Id=q.Grouping_Id 
	where q.Maturity_Model_Id = @maturity_model_id and g.Maturity_Model_Id=@maturity_model_id 
	and Group_Level = @analytics_rollup_level
    
    FETCH NEXT FROM maturity_cursor   
    into @maturity_model_id, @analytics_rollup_level
END   
CLOSE maturity_cursor;  
DEALLOCATE maturity_cursor;  

	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating trigger [dbo].[trg_update_maturity_groupings] on [dbo].[MATURITY_GROUPINGS]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trg_update_maturity_groupings]
   ON  [dbo].[MATURITY_GROUPINGS]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    exec analytics_setup_maturity_groupings

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[IRP]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[IRP] ADD
[Risk_Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [df_Risk_Type] DEFAULT ('IRP')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ANSWER_QUESTION_TYPES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANSWER_QUESTION_TYPES] ALTER COLUMN [Question_Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Answer_Question_Types] on [dbo].[ANSWER_QUESTION_TYPES]'
GO
ALTER TABLE [dbo].[ANSWER_QUESTION_TYPES] ADD CONSTRAINT [PK_Answer_Question_Types] PRIMARY KEY CLUSTERED ([Question_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_PROFILE]'
GO
CREATE TABLE [dbo].[ANSWER_PROFILE]
(
[Asessment_Id] [int] NOT NULL,
[Profile_Id] [int] NOT NULL IDENTITY(1, 1),
[ProfileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Profile_Date] [datetime] NOT NULL CONSTRAINT [DF_ANSWER_PROFILE_Profile_Date] DEFAULT (getdate())
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ANSWER_PROFILE] on [dbo].[ANSWER_PROFILE]'
GO
ALTER TABLE [dbo].[ANSWER_PROFILE] ADD CONSTRAINT [PK_ANSWER_PROFILE] PRIMARY KEY CLUSTERED ([Profile_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_CLONE]'
GO
CREATE TABLE [dbo].[ANSWER_CLONE]
(
[Profile_Id] [int] NOT NULL,
[Question_Or_Requirement_Id] [int] NOT NULL,
[Mark_For_Review] [bit] NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alternate_Justification] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Number] [int] NULL,
[Answer_Text] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Component_Guid] [uniqueidentifier] NOT NULL,
[Custom_Question_Guid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Old_Answer_Id] [int] NULL,
[Reviewed] [bit] NOT NULL,
[FeedBack] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_Requirement] [bit] NULL,
[Is_Component] [bit] NULL,
[Is_Framework] [bit] NULL,
[Is_Maturity] [bit] NULL,
[Free_Response_Answer] [varchar] (4096) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mat_Option_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ANSWER_CLONE] on [dbo].[ANSWER_CLONE]'
GO
ALTER TABLE [dbo].[ANSWER_CLONE] ADD CONSTRAINT [PK_ANSWER_CLONE] PRIMARY KEY CLUSTERED ([Profile_Id], [Question_Or_Requirement_Id], [Question_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_ANSWER_OPTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_ANSWER_OPTIONS]
(
[Mat_Option_Id] [int] NOT NULL IDENTITY(1, 1),
[Option_Text] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Answer_Sequence] [int] NOT NULL CONSTRAINT [DF_MATURITY_ANSWER_OPTIONS_Answer_Sequence_1] DEFAULT ((0)),
[ElementId] [int] NULL,
[Weight] [decimal] (18, 2) NULL,
[Mat_Option_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Option_Id] [int] NULL,
[Has_Answer_Text] [bit] NOT NULL CONSTRAINT [DF__MATURITY___Has_A__7266E4EE] DEFAULT ((0)),
[Formula] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Threshold] [decimal] (18, 2) NULL,
[RiFormula] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThreatType] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_ANSWER_OPTIONS_1] on [dbo].[MATURITY_ANSWER_OPTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] ADD CONSTRAINT [PK_MATURITY_ANSWER_OPTIONS_1] PRIMARY KEY CLUSTERED ([Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENT_CONTACTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD
[Is_Primary_POC] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENT_CONTACTS_Is_Primary_POC] DEFAULT ((0)),
[Site_Name] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization_Name] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cell_Phone] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reports_To] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emergency_Communications_Protocol] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Site_Participant] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENT_CONTACTS_Is_Site_Participant] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[Critical_Service_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Critical_Service_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Multi_Site] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_DEMOGRAPHICS_Multi_Site] DEFAULT ((0)),
[Multi_Site_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Budget_Basis] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Authorized_Organizational_User_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Authorized_Non_Organizational_User_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customers_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Staff_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cybersecurity_IT_ICS_Staff_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CS_DEMOGRAPHICS] on [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIST_CS_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[Motivation_CRR] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_CRR] DEFAULT ((0)),
[Motivation_CRR_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_RRAP] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_RRAP] DEFAULT ((0)),
[Motivation_RRAP_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Organization_Request] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Organization_Request] DEFAULT ((0)),
[Motivation_Organization_Request_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Law_Enforcement_Request] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Law_Enforcement_Request] DEFAULT ((0)),
[Motivation_Law_Enforcement_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Direct_Threats] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Direct_Threats] DEFAULT ((0)),
[Motivation_Direct_Threats_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Special_Event] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Special_Event] DEFAULT ((0)),
[Motivation_Special_Event_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Other] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Other] DEFAULT ((0)),
[Motivation_Other_Description] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Organization] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street_Address] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Visit_Date] [date] NULL,
[Completed_For_SLTT] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_SLTT] DEFAULT ((0)),
[Completed_For_Federal] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_Federal] DEFAULT ((0)),
[Completed_For_National_Special_Event] [bit] NOT NULL CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_National_Special_Event] DEFAULT ((0)),
[CIKR_Sector] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Sector] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Staff_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cybersecurity_IT_ICS_Staff_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CS_SITE_INFORMATION] on [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIST_CS_SITE_INFORMATION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_STAFF_COUNTS]'
GO
CREATE TABLE [dbo].[CIST_CSI_STAFF_COUNTS]
(
[Staff_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_STAFF_AMOUNTS] on [dbo].[CIST_CSI_STAFF_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_STAFF_COUNTS] ADD CONSTRAINT [PK_CIST_CSI_STAFF_AMOUNTS] PRIMARY KEY CLUSTERED ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_SERVICE_COMPOSITION]'
GO
CREATE TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION]
(
[Assessment_Id] [int] NOT NULL,
[Networks_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Services_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Applications_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Connections_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Personnel_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other_Defining_System_Description] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Defining_System] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_SERVICE_COMPOSITION] on [dbo].[CIST_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [PK_CIST_CSI_SERVICE_COMPOSITION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_DEFINING_SYSTEMS]'
GO
CREATE TABLE [dbo].[CIST_CSI_DEFINING_SYSTEMS]
(
[Defining_System_Id] [int] NOT NULL IDENTITY(1, 1),
[Defining_System] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_DEFINING_SYSTEMS] on [dbo].[CIST_CSI_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIST_CSI_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_CIST_CSI_DEFINING_SYSTEMS] on [dbo].[CIST_CSI_DEFINING_SYSTEMS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CIST_CSI_DEFINING_SYSTEMS] ON [dbo].[CIST_CSI_DEFINING_SYSTEMS] ([Defining_System])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
CREATE TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]
(
[Assessment_Id] [int] NOT NULL,
[Defining_System_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] on [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_BUDGET_BASES]'
GO
CREATE TABLE [dbo].[CIST_CSI_BUDGET_BASES]
(
[Budget_Basis] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_BUDGET_BASES] on [dbo].[CIST_CSI_BUDGET_BASES]'
GO
ALTER TABLE [dbo].[CIST_CSI_BUDGET_BASES] ADD CONSTRAINT [PK_CIST_CSI_BUDGET_BASES] PRIMARY KEY CLUSTERED ([Budget_Basis])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_CUSTOMER_COUNTS]'
GO
CREATE TABLE [dbo].[CIST_CSI_CUSTOMER_COUNTS]
(
[Customer_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_CIST_CSI_CUSTOMER_COUNTS_Sequence] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_CUSTOMER_AMOUNTS] on [dbo].[CIST_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_CUSTOMER_COUNTS] ADD CONSTRAINT [PK_CIST_CSI_CUSTOMER_AMOUNTS] PRIMARY KEY CLUSTERED ([Customer_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIST_CSI_USER_COUNTS]'
GO
CREATE TABLE [dbo].[CIST_CSI_USER_COUNTS]
(
[User_Count] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_CIST_CSI_USER_COUNTS_Sequence] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIST_CSI_USER_AMOUNTS] on [dbo].[CIST_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_USER_COUNTS] ADD CONSTRAINT [PK_CIST_CSI_USER_AMOUNTS] PRIMARY KEY CLUSTERED ([User_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_ANSWERS]'
GO
CREATE TABLE [dbo].[CYOTE_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Observable_Id] [int] NOT NULL,
[Answer_Id] [int] NOT NULL IDENTITY(1, 1),
[Path_Id] [int] NOT NULL,
[Option_Id] [int] NOT NULL,
[Selected] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CYOTE_ANSWERS] on [dbo].[CYOTE_ANSWERS]'
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [PK_CYOTE_ANSWERS] PRIMARY KEY CLUSTERED ([Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_OBSERVABLES]'
GO
CREATE TABLE [dbo].[CYOTE_OBSERVABLES]
(
[Assessment_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF__CYOTE_OBS__Seque__13FCE2E3] DEFAULT ((0)),
[Observable_Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhenThisHappened] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reporter] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Approximate_Start] [datetime] NULL,
[Approximate_End] [datetime] NULL,
[PhysicalCategory] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__Physi__3B16B004] DEFAULT ((0)),
[DigitalCategory] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__Digit__3C0AD43D] DEFAULT ((0)),
[NetworkCategory] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__Netwo__3CFEF876] DEFAULT ((0)),
[IsFirstTimeSeen] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__IsFir__3DF31CAF] DEFAULT ((0)),
[IsAffectingOperations] [bit] NOT NULL CONSTRAINT [DF_CYOTE_OBSERVABLES_IsAffectingOperations] DEFAULT ((0)),
[AffectingOperationsText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsAffectingProcesses] [bit] NOT NULL CONSTRAINT [DF_CYOTE_OBS_IsAff_123] DEFAULT ((0)),
[AffectingProcessesText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMultipleDevices] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__IsMul__3EE740E8] DEFAULT ((0)),
[MultipleDevicesText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMultipleNetworkLayers] [bit] NOT NULL CONSTRAINT [DF__CYOTE_OBS__IsMul__3FDB6521] DEFAULT ((0)),
[MultipleNetworkLayersText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldBeAndCantTell] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldBeAndWas] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldBeAndWasNot] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldNotBeAndCantTell] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldNotBeAndWasNot] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObservedShouldNotBeAndWas] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CYOTE_OBSERVABLES] on [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] ADD CONSTRAINT [PK_CYOTE_OBSERVABLES] PRIMARY KEY CLUSTERED ([Observable_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_OPTIONS]'
GO
CREATE TABLE [dbo].[CYOTE_OPTIONS]
(
[Option_Id] [int] NOT NULL IDENTITY(1, 1),
[Option_Text] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__CYOTE_OP__3260907E3CCCC788] on [dbo].[CYOTE_OPTIONS]'
GO
ALTER TABLE [dbo].[CYOTE_OPTIONS] ADD CONSTRAINT [PK__CYOTE_OP__3260907E3CCCC788] PRIMARY KEY CLUSTERED ([Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_PATHS]'
GO
CREATE TABLE [dbo].[CYOTE_PATHS]
(
[Path_Id] [int] NOT NULL IDENTITY(1, 1),
[Option1] [int] NOT NULL,
[Option2] [int] NOT NULL,
[Option3] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CYOTE_PATHS] on [dbo].[CYOTE_PATHS]'
GO
ALTER TABLE [dbo].[CYOTE_PATHS] ADD CONSTRAINT [PK_CYOTE_PATHS] PRIMARY KEY CLUSTERED ([Path_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[INFORMATION]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[INFORMATION] ADD
[Baseline_Assessment_Id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTION_TYPES]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTION_TYPES]
(
[Mat_Question_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_QUESTION_TYPES] on [dbo].[MATURITY_QUESTION_TYPES]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_TYPES] ADD CONSTRAINT [PK_MATURITY_QUESTION_TYPES] PRIMARY KEY CLUSTERED ([Mat_Question_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MODES_SETS_MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[MODES_SETS_MATURITY_MODELS]
(
[App_Code_Id] [int] NOT NULL IDENTITY(1, 1),
[AppCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Set_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Included] [bit] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MODES_MATURITY_MODELS_1] on [dbo].[MODES_SETS_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] ADD CONSTRAINT [PK_MODES_MATURITY_MODELS_1] PRIMARY KEY CLUSTERED ([App_Code_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ExcelExport]'
GO
ALTER VIEW [dbo].[ExcelExport]
AS
SELECT dbo.INFORMATION.Assessment_Name, dbo.INFORMATION.Facility_Name, dbo.INFORMATION.City_Or_Site_Name, dbo.INFORMATION.State_Province_Or_Region, dbo.INFORMATION.Executive_Summary, 
                  dbo.ASSESSMENTS.Assessment_Id, dbo.ASSESSMENTS.AssessmentCreatedDate, dbo.ASSESSMENTS.AssessmentCreatorId, dbo.ASSESSMENTS.LastModifiedDate, dbo.ASSESSMENTS.Alias, dbo.ASSESSMENTS.Assessment_GUID, 
                  dbo.ASSESSMENTS.Assessment_Date, dbo.ASSESSMENTS.CreditUnionName, dbo.ASSESSMENTS.Charter, dbo.ASSESSMENTS.Assets, dbo.INFORMATION.Assessment_Description, dbo.USERS.PrimaryEmail, dbo.USERS.UserId, 
                  dbo.USERS.PasswordResetRequired, dbo.USERS.FirstName, dbo.USERS.LastName
FROM     dbo.ASSESSMENTS INNER JOIN
                  dbo.INFORMATION ON dbo.ASSESSMENTS.Assessment_Id = dbo.INFORMATION.Id INNER JOIN
                  dbo.USERS ON dbo.ASSESSMENTS.AssessmentCreatorId = dbo.USERS.UserId
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getStandardSummaryOverall]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
ALTER PROCEDURE [dbo].[usp_getStandardSummaryOverall]
	@assessment_id int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode varchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	
	select a.Answer_Full_Name,a.Answer_Text, isnull(m.qc,0) qc,isnull(m.Total,0) Total, isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0)  as [Percent] 
	from ANSWER_LOOKUP a left join (
	SELECT a.Answer_Text, isnull(count(a.question_or_requirement_id),0) qc, SUM(count(a.question_or_requirement_id)) OVER() AS Total
			FROM #answers a 				
			where a.Assessment_Id = @assessment_id 
			group by a.Answer_Text
	) m on a.Answer_Text = m.Answer_Text

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GetCombinedOveralls]'
GO
ALTER PROCEDURE [dbo].[GetCombinedOveralls]	
@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Generate temporary tables containing all relevant/in-scope answers for the Assessment	

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT a.*
	into #questionAnswers
		FROM Answer_Questions a
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id				
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join [sets] ms on s.Set_Name = ms.Set_Name
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id 
			and v.Selected = 1 
			and v.Assessment_Id = @assessment_id 
			and l.Universal_Sal_Level = ul.Universal_Sal_Level
	
	SELECT ar.*
	into #requirementAnswers
		FROM Answer_Requirements ar
		join NEW_REQUIREMENT r on ar.Question_Or_Requirement_Id = r.Requirement_Id
		join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
		join REQUIREMENT_LEVELS l on ar.Question_Or_Requirement_Id = l.Requirement_Id
		join [sets] ms on s.Set_Name = ms.Set_Name
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where ar.Assessment_Id = @assessment_id 
			and v.Selected = 1 
			and v.Assessment_Id = @assessment_id 
			and l.Standard_Level = ul.Universal_Sal_Level
	
	
	IF OBJECT_ID('tempdb..##componentAnswers') IS NOT NULL DROP TABLE #componentAnswers
	create table #componentAnswers (UniqueKey int, Assessment_Id int, Answer_Id int, Question_Id int, Answer_Text varchar(50), Comment varchar(2048),
		Alternate_JustificaTion ntext, FeedBack varchar(2048), Question_Number int, QuestionText varchar(7338), ComponentName varchar(200), Symbol_Name varchar(100),
		Question_Group_Heading nvarchar(250), GroupHeadingId int, Universal_Sub_Category varchar(100), SubCategoryId int, Is_Component bit, Component_Guid uniqueidentifier,
		Layer_Id int, LayerName varchar(250),Container_Id int, ZoneName varchar(250), SAL varchar(20), Mark_For_Review bit, Is_Requirement bit,
		Is_Framework bit, Reviewed bit, Simple_Question varchar(7338), Sub_Heading_Question_Description varchar(200), heading_pair_id int,
		label varchar(200), Component_Symbol_Id int)
	insert into #componentAnswers exec [usp_getExplodedComponent] @assessment_id



	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '#assessmentAnswers')
		drop table #asessmentAnswers;
	create table #assessmentAnswers (answer_text varchar(50), assessment_id int, is_requirement bit, is_component bit, is_framework bit)


	-- Populate #assessmentAnswers from the correct source table
	declare @applicationMode varchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	if(@ApplicationMode = 'Questions Based')
	begin		
		insert into #assessmentAnswers 
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #questionAnswers
	end
	else
	begin		
		insert into #assessmentAnswers 
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #requirementAnswers
	end

	-- Include component answers regardless of the application mode
	insert into #assessmentAnswers
		select answer_text, assessment_id, is_requirement, is_component, is_framework 
		from #componentAnswers


    -- Insert statements for procedure here
	SELECT StatType,isNull(Total,0) as Total, 
					cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],
					cast(IsNull(Round((cast(([N]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [N],
					cast(IsNull(Round((cast(([NA]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [NA],
					cast(IsNull(Round((cast(([A]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [A],
					cast(IsNull(Round((cast(([U]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [U],
					[Y] as [YCount],[N] as [NCount],[NA] as [NACount],[A] as [ACount],[U] as [UCount],
					--Value = (IsNull(cast(([Y]+[A]) as float)/((isnull(nullif(Total,0),1)-isnull([NA],0))),0))*100, 					
					Value = (cast(([Y]+[A]) as float)/ isnull(nullif((isnull(Total,0)-isnull([NA],0)),0),1))*100, 					
					
					--Value = cast(1 as float), 					
					TotalNoNA = isnull(Total,0)- isnull(NA,0)
		FROM 
		(
			select [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=1, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text 
				from #assessmentAnswers  -- !!! 
				where Assessment_Id  = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Requirement', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  		
				from (select t=2, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 1 and assessment_id = @assessment_id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Questions', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=3, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 0 and Is_Component = 0 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 	
			union
				select [StatType]='Components', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total  
				from (select t=4, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Requirement = 0 and Is_Component = 1 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select [StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY aw.t) AS Total    
				from (select t=5, ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select count(answer_text) as Acount, answer_text
				from #assessmentAnswers 
				where Is_Framework = 1 and Assessment_Id = @Assessment_Id
				group by answer_Text) B on aw.Answer_Text=b.Answer_Text 
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		ORDER BY pvt.StatType;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getGenericModelSummaryByGoal]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 5/16/2022
-- Description:	general for 
-- =============================================
Create PROCEDURE [dbo].[usp_getGenericModelSummaryByGoal]
@assessment_id int,
@maturity_model_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Answer_Full_Name, a.Title, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from MATURITY_GROUPINGS, ANSWER_LOOKUP 
		where Maturity_Model_Id = @maturity_model_id and answer_text in ('Y','N','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM Answer_Maturity a 
			join (
				select q.Mat_Question_Id, g.* 
				from MATURITY_QUESTIONS q join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where g.Maturity_Model_Id=@maturity_model_id and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 			
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummaryByGoalOverall]'
GO
-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryByGoalOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Title, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from MATURITY_GROUPINGS
		where Maturity_Model_Id = 7 and Group_Level = 2) a left join (
		SELECT g.Title, isnull(count(question_or_requirement_id),0) qc , SUM(count(Title)) OVER(PARTITION BY assessment_id) AS Total
			FROM Answer_Maturity a 
			join (
				select q.Mat_Question_Id, g.* 
				from MATURITY_QUESTIONS q join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
				where g.Maturity_Model_Id=7 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id=g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
			group by a.Assessment_Id, g.Title)
			m on a.Title=m.Title	
	order by a.Sequence

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummary]'
GO
-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummary]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;



	
	select a.Answer_Full_Name, a.Level_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from MATURITY_LEVELS, ANSWER_LOOKUP 
		where Maturity_Model_Id = 7 and 
		answer_text in ('Y','N','A','U') ) a 
		join 
		(
				SELECT l.Level_Name, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY Level_Name) AS Total
				FROM Answer_Maturity a 
				join MATURITY_LEVELS l on a.Maturity_Level = l.Maturity_Level_Id
				where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
				group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text
		)m on a.Level_Name=m.Level_Name and a.Answer_Text=m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
	order by a.Level,o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CyOTEQuestionsAnswers]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 3/15/2022
-- Description:	quick return of CyOTE Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_CyOTEQuestionsAnswers]
	@Assessment_id int = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select Question_Level =  CASE WHEN Parent_Question_Id IS NULL THEN 1 ELSE 2 END,Mat_Question_Id,Question_Title,Question_Text,Mat_Question_Type,[Sequence],Answer_Text,Free_Response_Answer,Comment,Parent_Question_Id, Supplemental_Info
	from MATURITY_QUESTIONS M left join (select Question_Or_Requirement_Id,Answer_Text,Free_Response_Answer,Comment from ANSWER where Assessment_Id=@Assessment_Id and Question_Type='Maturity') a on m.Mat_Question_Id=a.question_or_requirement_id
	where Maturity_Model_Id = 9
	order by Sequence
END


--update MATURITY_QUESTIONS set Sequence = Sequence + 2 where Mat_Question_Id >=6341 and mat_question_id not in (6390,6392)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Assessments_For_User]'
GO





ALTER VIEW [dbo].[Assessments_For_User]
AS
select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,
	CreatorName = u.FirstName + ' ' + u.LastName,
	LastModifiedDate = LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		join USERS u on a.AssessmentCreatorId = u.UserId
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id
		left join (
			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1
			union
			select distinct a.Assessment_Id, Mark_For_Review
			from ASSESSMENTS a
			join Answer_Maturity v on a.Assessment_id = v.Assessment_Id
			where v.Mark_For_Review = 1
			union 
			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b on a.Assessment_Id = b.Assessment_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummaryByGoal]'
GO
-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryByGoal]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Answer_Full_Name, a.Title, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from MATURITY_GROUPINGS, ANSWER_LOOKUP 
		where Maturity_Model_Id = 7 and answer_text in ('Y','N','A','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM Answer_Maturity a 
			join (
				select q.Mat_Question_Id, g.* 
				from MATURITY_QUESTIONS q join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where g.Maturity_Model_Id=7 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 			
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetRawCountsForEachAssessment_Standards]'
GO
-- =============================================
-- Author:		Lilly,Barry Hansen
-- Create date: 3/29/2022
-- Description:	get the aggregates for analysis
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetRawCountsForEachAssessment_Standards]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select a.Assessment_Id,qgh.Question_Group_Heading, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total
	,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
	from ANSWER a
	left join new_question q on a.question_or_requirement_id = q.Question_id
	left join universal_sub_category_headings usch on usch.heading_pair_id = q.Heading_Pair_Id	
	left join question_group_heading qgh on qgh.Question_Group_Heading_Id = usch.Question_Group_Heading_Id
	left join demographics d on a.assessment_id = d.assessment_id
	where a.question_type = 'Question' and answer_text != 'NA'
	group by a.assessment_id, qgh.Question_Group_Heading, Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummaryOverall]'
GO
-- =============================================
-- Author:		Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:	Gets the summary overall data for VADR report. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP 
	where answer_text in ('Y','N','U','A') ) a left join (
SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM Answer_Maturity a 
			join MATURITY_LEVELS l on a.Maturity_Level = l.Maturity_Level_Id --VADR uses all Levels, hence Level 1
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text=m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
	order by o.answer_order

END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getMinMaxAverageForSectorIndustry]'
GO
-- =============================================
-- Author:		Lilly, Barry Hansen
-- Create date: 3/29/2022
-- Description:	get min, max, average for a given sector sub sector
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMinMaxAverageForSectorIndustry]
	-- Add the parameters for the stored procedure here
	@sector_id int,
	@industry_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select min([percentage]) [min],max([percentage]) [max],avg([percentage]) [avg] from (
	select a.Assessment_Id, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total	
	,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
	from ANSWER a	
	join demographics d on a.assessment_id = d.assessment_id
	where a.question_type = 'Question' and answer_text != 'NA' and d.SectorId = @sector_id and d.IndustryId=@industry_id
	group by a.assessment_id, Answer_Text
	) B
	where answer_text = 'Y'

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummaryPage]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getVADRSummaryPage]	
@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getVADRSummaryOverall] @assessment_id
	execute [dbo].[usp_getVADRSummary] @assessment_id
	execute [dbo].[usp_getVADRSummaryByGoal] @assessment_id
	execute [dbo].[usp_getVADRSummaryByGoalOverall] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getMedianOverall]'
GO
-- =============================================
-- Author:		Lilly, Barry Hansen
-- Create date: 3/29/2022
-- Description:	retrieve the median overall
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMedianOverall]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 select [Percentage] into #tempRows from (
		select a.Assessment_Id, Answer_Text, COUNT(a.answer_text) Answer_Count,  sum(count(answer_text)) OVER(PARTITION BY a.assessment_id) AS Total	
		,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id),0),1)))*100,0),0) as int)  as [Percentage] 
		from ANSWER a	
		left join demographics d on a.assessment_id = d.assessment_id
		where a.question_type = 'Question' and answer_text != 'NA' 
		group by a.assessment_id, Answer_Text
		) B
	where answer_text = 'Y'

	select * from #tempRows order by [percentage]

	DECLARE @c BIGINT = (SELECT COUNT(*) FROM #tempRows);

	SELECT AVG(1.0 * [Percentage]) as Median
	FROM (
		SELECT [Percentage] FROM #tempRows
		 ORDER BY [Percentage]
		 OFFSET (@c - 1) / 2 ROWS
		 FETCH NEXT 1 + (1 - @c % 2) ROWS ONLY
	) AS x;

	drop table #tempRows
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Assessments_Completion_For_User]'
GO

CREATE PROCEDURE [dbo].[usp_Assessments_Completion_For_User]
@User_Id int
AS
BEGIN
	SET NOCOUNT ON;

	--This procedure returns the number of answers and total number of available standard, maturity, and diagram questions
	--	available for each of the user's assessments.

	--Creating table variables
	declare @AssessmentCompletedQuestions table(AssessmentId INT, CompletedCount INT)
	declare @AssessmentTotalMaturityQuestionsCount table(AssessmentId INT, TotalMaturityQuestionsCount INT)
	declare @AssessmentTotalStandardQuestionsCount table(AssessmentId INT, TotalStandardQuestionsCount INT)
	declare @AssessmentTotalDiagramQuestionsCount table(AssessmentId INT, TotalDiagramQuestionsCount INT)

	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(ans.Answer_Id)
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and ans.Answer_Text != 'U' and
			(ans.Question_Or_Requirement_Id in (
				select
					mq.Mat_Question_Id
					from MATURITY_QUESTIONS mq
					join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
						full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
						join USERS u on a.AssessmentCreatorId = u.UserId
						join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
						where u.UserId = @User_Id and a.UseMaturity = 1 and amm.model_id != 1 and amm.model_id != 2 and amm.model_id != 6
			)
			or
			ans.Question_Or_Requirement_Id in (
					select
						mq.Mat_Question_Id
						from MATURITY_QUESTIONS mq
							join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
							full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
							join USERS u on a.AssessmentCreatorId = u.UserId
							join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
							join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
							join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level
							where u.UserId = @User_Id
							and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level
			)
			or
			ans.Question_Or_Requirement_Id in (
				select
					q.Question_Id
					from NEW_QUESTION q
						join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
						join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
						join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
						join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
						join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
						join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
						full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
						join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
						join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
						join USERS u on a.AssessmentCreatorId = u.UserId
						join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
						where u.UserId = @User_Id and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level and a.UseStandard = 1
			)
			or
			ans.Question_Or_Requirement_Id in (
				select
					r.Requirement_Id
					from REQUIREMENT_SETS rs
						join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
						join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
						full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
						join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
						join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
						join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
						join USERS u on a.AssessmentCreatorId = u.UserId
						join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
						where u.UserId = @User_Id and rl.Standard_Level = usl.Universal_Sal_Level
			)
			or
			ans.Question_Or_Requirement_Id in (
					select                  
					q.Question_Id
					from STANDARD_SELECTION ss
						join 
						(select q.question_id, adc.assessment_id
							from ASSESSMENT_DIAGRAM_COMPONENTS adc 			
							join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
							join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
							join new_question nq on q.question_id = nq.question_id		
							join new_question_sets qs on nq.question_id = qs.question_id	
							join DIAGRAM_CONTAINER l on adc.Layer_id = l.Container_Id
							left join DIAGRAM_CONTAINER z on adc.Zone_Id = z.Container_Id
							join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
							where l.visible = 1) f on ss.assessment_id = f.assessment_id							
						join NEW_QUESTION q on f.Question_Id = q.Question_Id 
						join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
						join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
						join Answer_Components ac on f.Question_Id = ac.Question_Or_Requirement_Id and f.assessment_id = ac.assessment_id
						full join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
						join USERS u on a.AssessmentCreatorId = u.UserId
						join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
						where u.UserId = @User_Id and a.UseDiagram = 1
			))
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = Assessment_Id,
		CompletedCount = 0
		from ASSESSMENTS where Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
		and 
		AssessmentCreatorId = @User_Id
	

	--Maturity questions count (For maturity models with level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = a.Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(mq.Mat_Question_Id))
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level
			where u.UserId = @User_Id
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level
			group by a.Assessment_Id

	--Total Maturity questions count (for maturity models without levels) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = a.Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(mq.Mat_Question_Id))
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and mq.Mat_Question_Id not in (
				select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null
			)
			and amm.model_id != 2 and amm.model_id != 6 and amm.model_id != 1
			group by a.Assessment_Id
	

	--Requirements based questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = a.Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(r.Requirement_Id))
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and rl.Standard_Level = usl.Universal_Sal_Level
			group by a.Assessment_Id


	--Questions based standards questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = a.Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(q.Question_Id))
		from NEW_QUESTION q
			join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
			join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
			join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
			join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
			join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
			join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level
			group by a.Assessment_Id
	

	--Total diagram questions count
	insert into @AssessmentTotalDiagramQuestionsCount
	select                  
		AssessmentId = a.Assessment_Id,
		TotalDiagramQuestionsCount = COUNT(ans.Answer_Id)
		from ANSWER ans
			join ASSESSMENTS a on a.Assessment_Id = ans.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseDiagram = 1 and ans.Question_Type = 'Component'
			group by a.Assessment_Id
		

	select
		AssessmentId = acq.AssessmentId,
		CompletedCount = acq.CompletedCount,
		TotalMaturityQuestionsCount = atmq.TotalMaturityQuestionsCount,
		TotalStandardQuestionsCount = atsq.TotalStandardQuestionsCount,
		TotalDiagramQuestionsCount = atdq.TotalDiagramQuestionsCount
		from @AssessmentCompletedQuestions acq
			full join @AssessmentTotalMaturityQuestionsCount atmq on atmq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalStandardQuestionsCount atsq on atsq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalDiagramQuestionsCount atdq on atdq.AssessmentId = acq.AssessmentId
END	
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Analytics_Answers]'
GO

CREATE VIEW [dbo].[Analytics_Answers]
AS
SELECT
Assessment_Id,
Question_Or_Requirement_Id,
Question_Type,
CASE WHEN ANSWER.Answer_Text = 'U' OR ANSWER.Answer_Text = 'N' THEN 'N'
WHEN ANSWER.Answer_Text = 'A' OR ANSWER.Answer_Text = 'Y' THEN 'Y' END
AS Answer_Text
FROM [dbo].[ANSWER]
WHERE ANSWER.Answer_Text != 'NA'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_Compute_MaturityAll]'
GO
-- =============================================
-- Author:		Luke G, Lilly, Barry
-- Create date: 4-6-2022
-- Description:	18 stored procedures for analytics. 
-- This procedure returns the AVG, MIN, MAX, MEDIAN Question Group Heading for the Question_Type 'Maturity' for all sectory and industry. 
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturityAll]
@maturity_model_id int,
@sector_id int,
@industry_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--test base case where there is no data in db at all
--test case where the data is ther
--need to address the cases where all no, all yes, and mixed
--next steps the base data is there but the lower data(median) is not
--need to determine why it is not there
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2
	IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL DROP TABLE #Temp3

--step 1 get the base data
select a.Assessment_Id,Question_Group, Answer_Text, isnull(COUNT(a.answer_text),0) Answer_Count, 
		sum(isnull(count(answer_text),0)) OVER(PARTITION BY a.assessment_id,question_group) AS Total	
		,cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY a.assessment_id,question_group),0),1)))*100,0),0) as int)  as [Percentage] 
		into #temp
		from [Analytics_Answers] a	
		join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
		join ANALYTICS_MATURITY_GROUPINGS g on q.Mat_Question_Id=g.Maturity_Question_Id
		left join demographics d on a.assessment_id = d.assessment_id
		where a.question_type = 'Maturity' and q.Maturity_Model_Id=@maturity_model_id and g.Maturity_Model_Id=@maturity_model_id
			and nullif(@sector_id,sectorid) is null
			and nullif(@industry_id,industryid) is null
		group by a.assessment_id, Question_Group, Answer_Text
--step 2 handle the cases where we have all yes, all no, and mixed
	--get the yes and mixed case
	select * into #temp2 from #temp where answer_text='Y'
	--get the all no case
	insert #temp2
	select assessment_id,QUESTION_GROUP,Answer_Text='Y',Answer_Count,total, [percentage]=0 from #temp where Answer_Text = 'N' and Answer_Count=total
--step 3 calculate the min,max,avg
	select G1.Question_Group as Question_Group_Heading, min(isnull([percentage],0)) [minimum],max(isnull([percentage],0)) [maximum],avg(isnull([percentage],0)) [average] 
	into #temp3
	from
	(	
		select distinct Question_Group from ANALYTICS_MATURITY_GROUPINGS where Maturity_Model_Id = @maturity_model_id
	) G1 LEFT OUTER JOIN #temp2 G2 ON G1.Question_Group = G2.Question_Group 
	group by G1.Question_Group
--step 4 add median
	select a.Question_Group_Heading,cast(a.minimum as float) as minimum,cast(a.maximum as float) as maximum,cast(a.average as float) as average,isnull(b.median,0) as median from
	#temp3 a left join 
	(
	select distinct Question_Group as Question_Group_Heading		
	,isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [Percentage]) OVER (PARTITION BY question_group),0) AS median	
	from #temp2) b on a.Question_Group_Heading=b.Question_Group_Heading
	order by a.Question_Group_Heading
end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_compute_single_averages_maturity]'
GO
-- =============================================
-- Author:		Barry
-- Create date: 4/6/2022
-- Description:	average for maturity model
-- =============================================
CREATE PROCEDURE [dbo].[analytics_compute_single_averages_maturity]
	@assessment_id int,
	@maturity_model_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	select G1.Title, G1.Answer_Text,isnull(G2.Answer_Count,0) as Answer_Count, isnull(G2.Total,0) as Total, isnull(G2.Percentage, 0) as [Percentage]
	from
	(
		select distinct Assessment_Id= @assessment_id,
		Question_Group as Title, Answer_Text = 'Y'
		from ANALYTICS_MATURITY_GROUPINGS		
		where Maturity_Model_Id= @maturity_model_id			
	) G1 LEFT OUTER JOIN
	(
		select
		Question_Group as Title,answer_text, count(answer_text) answer_count,
		sum(count(answer_text)) OVER(PARTITION BY Question_Group) AS Total,
		cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY Question_Group),0),1)))*100,0),0) as int)  as [Percentage] 
		from Analytics_Answers a
		join ANALYTICS_MATURITY_GROUPINGS g on a.Question_Or_Requirement_Id=g.Maturity_Question_Id
		where assessment_id = @assessment_id
		group by Question_Group, Answer_Text
	) G2 ON G1.Title = G2.Title AND G1.Answer_Text = G2.Answer_Text		
	where g1.answer_text = 'Y'
	order by Title
END

--update ANSWER set Answer_Text = 'NA' where Assessment_Id = 9
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_Compute_standard_all]'
GO
-- =============================================
-- Author:		Barry H
-- Create date: 4-19-2022
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_standard_all]
	@assessment_id int, --default assessment_id the mode will be pulled from this assessment
	@set_name varchar(20), --this is the standard set name key
	@sector_id int,
	@industry_id int	
AS
BEGIN
	SET NOCOUNT ON;
	declare @ApplicationMode varchar(20)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

if(@ApplicationMode = 'Questions Based')	
begin
	
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2

	---This is step 1 get the base data
	
	select a.Assessment_Id,Question_Group_Heading, Answer_Text,count(answer_text) qc into #temp
	FROM Analytics_Answers a 
	join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
	join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
	join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id			
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Question' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name
		and nullif(@sector_id,sectorid) is null
		and nullif(@industry_id,industryid) is null
	group by a.assessment_id, Question_Group_Heading, Answer_Text 
	order by Question_Group_Heading, Assessment_Id

	insert #temp
	select	assessment_id=@assessment_id,
	a.Question_Group_Heading,Answer_Text='Y',qc=0
	from (
	select Question_Group_Heading	FROM  
	NEW_QUESTION c 
	join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
	join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id			
	where  s.Set_Name = @set_name
	group by Question_Group_Heading) A left join #temp b on a.Question_Group_Heading=b.Question_Group_Heading
	where b.Question_Group_Heading is null

	--this is step 2 calculate percentages and group up by assessment id and question group
	select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage] into #temp2
	from (		
		select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
		from #temp
		group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a

	--this is step 3 fix the outside cases where the answers are either all no or all yes
	--case 100% No
	--case 100% Yes
	--case mixed yes and no
	insert #temp2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage]=0 from #temp2 where Answer_Text = 'N' and qc=total
	insert #temp2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage] from #temp2 where Answer_Text = 'Y' 


	--finally step 4 give me the answers with the calculated median
	 select a.QUESTION_GROUP_HEADING, a.minimum, a.maximum, a.average, b.median--, b.rown 
          from 
          (
                 select QUESTION_GROUP_HEADING, minimum, maximum, average 
                 from (
                                    select question_group_heading, round((ISNULL(min([percentage]),0) *100),1) minimum, 
                                       round((ISNULL(max(percentage),0) *100),1) maximum, 
                                       round((ISNULL(AVG(percentage),0) *100),1) average
                                       from #Temp2
                                       group by Question_Group_Heading
                 ) qryA
          ) a
          join
          (
                 select QUESTION_GROUP_HEADING, median, rown 
                 from 
                 (
                         select QUESTION_GROUP_HEADING, 
                                    isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [percentage]) OVER (PARTITION BY Question_Group_Heading),0) AS median,
                                    ROW_NUMBER() OVER (PARTITION BY question_group_heading ORDER BY question_group_heading) rown
                         from (
                                           select question_group_heading, 
                                                  round((ISNULL([percentage],0) *100),0) [percentage]
                                              from #Temp2
                         ) qry
                 ) qryB
                 where rown = 1
          ) b ON a.QUESTION_GROUP_HEADING = b.QUESTION_GROUP_HEADING
end
else 
begin 
	IF OBJECT_ID('tempdb..#tempR') IS NOT NULL DROP TABLE #tempR	 
	IF OBJECT_ID('tempdb..#tempR2') IS NOT NULL DROP TABLE #tempR2	 

	
	select a.Assessment_Id,Standard_Category as Question_Group_Heading, Answer_Text
	,count(answer_text) qc into #tempR
	FROM Analytics_Answers a 
	join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id	
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Requirement' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name
			and nullif(@sector_id,sectorid) is null
			and nullif(@industry_id,industryid) is null
	group by a.assessment_id, Standard_Category, Answer_Text
	order by Question_Group_Heading, Assessment_Id

	insert #tempR
	select	assessment_id=@assessment_id,
	a.Question_Group_Heading,Answer_Text='Y',qc=0
	from (
	select distinct STANDARD_CATEGORY as Question_Group_Heading	FROM  
	NEW_REQUIREMENT c
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id			
	where  s.Set_Name = @set_name
	group by Standard_Category) A left join #tempR b on a.Question_Group_Heading=b.Question_Group_Heading
	where b.Question_Group_Heading is null






	select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage] into #tempR2
	from (		
		select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
		from #tempR
		group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a

	--case 100% No
	--case 100% Yes
	--case mixed yes and no
	insert #tempR2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage]=0 from #tempR2 where Answer_Text = 'N' and qc=total
	insert #tempR2
	select assessment_id,QUESTION_GROUP_HEADING,'Y',qc,total, [percentage] from #tempR2 where Answer_Text = 'Y' 


  select a.QUESTION_GROUP_HEADING, a.minimum, a.maximum, a.average, b.median--, b.rown 
          from 
          (
				select question_group_heading, round((ISNULL(min([percentage]),0) *100),1) minimum, 
                round((ISNULL(max(percentage),0) *100),1) maximum, 
                round((ISNULL(AVG(percentage),0) *100),1) average
                from #tempR2
                group by Question_Group_Heading          
          ) a
          left join
          (
                 select QUESTION_GROUP_HEADING, median, rown 
                 from 
                 (
                         select QUESTION_GROUP_HEADING, 
                                    isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [percentage]) OVER (PARTITION BY Question_Group_Heading),0) AS median,
                                    ROW_NUMBER() OVER (PARTITION BY question_group_heading ORDER BY question_group_heading) rown
                         from (
                                           select question_group_heading, 
                                                  round((ISNULL([percentage],0) *100),0) [percentage]
                                              from #tempR2
                         ) qry
                 ) qryB
                 where rown = 1
          ) b ON a.QUESTION_GROUP_HEADING = b.QUESTION_GROUP_HEADING
end
END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_compute_single_averages_standard]'
GO
-- =============================================
-- Author:		Barry
-- Create date: 4/21/2022
-- Description:	average for maturity model
-- =============================================
CREATE PROCEDURE [dbo].[analytics_compute_single_averages_standard]
	@assessment_id int,
	@set_name varchar(20)
AS
BEGIN
SET NOCOUNT ON;
	declare @ApplicationMode varchar(20)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

if(@ApplicationMode = 'Questions Based')	
begin
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp	 
	
	select a.Assessment_Id,Question_Group_Heading, Answer_Text,count(answer_text) qc into #temp
	FROM Analytics_Answers a 
	join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
	join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
	join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id			
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Question' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name
			and a.Assessment_Id = @assessment_id
	group by a.assessment_id, Question_Group_Heading, Answer_Text 
	order by Question_Group_Heading, Assessment_Id

	select 
	all1.Question_Group_Heading,	
	round((ISNULL(all2.percentage,0) *100),0) average 
	from (
	select distinct Question_Group_Heading,[percentage] = 0
	FROM NEW_QUESTION c 
	join vQUESTION_HEADINGS h on c.Heading_Pair_Id=h.Heading_Pair_Id
	join NEW_QUESTION_SETS s on c.Question_Id=s.Question_Id
	where Set_Name = @set_name)
		all1 left join (		
			select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage]
			from (		
				select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
				from #temp
				group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a
		where answer_text = 'Y'		
	) all2 on all1.Question_Group_Heading=all2.Question_Group_Heading
end
else 
begin 
	IF OBJECT_ID('tempdb..#tempR') IS NOT NULL DROP TABLE #tempR	 

	
	select a.Assessment_Id,Standard_Category as Question_Group_Heading, Answer_Text
	,count(answer_text) qc into #tempR
	FROM Analytics_Answers a 
	join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id	
	join AVAILABLE_STANDARDS avs on a.Assessment_Id=avs.Assessment_Id		
	left join DEMOGRAPHICS d on a.Assessment_Id = d.Assessment_Id
	where a.Answer_Text != 'NA' and a.question_type = 'Requirement' 												
			and s.Set_Name = @set_name
			and avs.Set_Name = @set_name			
			and a.assessment_id= @assessment_id
	group by a.assessment_id, Standard_Category, Answer_Text
	order by Question_Group_Heading, Assessment_Id

	select 
	all1.Question_Group_Heading,	
	round((ISNULL(all2.[percentage],0) *100),0) [percentage]
	from (
	select distinct Standard_Category as Question_Group_Heading, [Percentage] = 0
	FROM NEW_REQUIREMENT c 
	join REQUIREMENT_SETS s on c.Requirement_Id=s.Requirement_Id	
	where Set_Name = @set_name)
		all1 left join (		
			select *, cast(qc as float)/cast( ISNULL(nullif(total,0),1) as float) [percentage]
			from (		
				select Assessment_Id, Question_Group_Heading, answer_text,qc, sum(qc) over(partition by assessment_id,question_group_heading) as total
				from #tempR
				group by Assessment_Id,Question_Group_Heading, answer_text, qc)  a
		where answer_text = 'Y')
	 all2 on all1.Question_Group_Heading=all2.Question_Group_Heading
end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_selectedStandardList]'
GO
-- =============================================
-- Author:		Lilly
-- Create date: 3/29/2022
-- Description:	retrieve the median overall
-- =============================================
CREATE PROCEDURE [dbo].[analytics_selectedStandardList]	
@standard_assessment_id int
AS
BEGIN
SELECT  
      Full_Name,
    [SETS].[Set_Name],
     [SETS].[Short_Name]
   
  FROM [dbo].[SETS] 


INNER JOIN AVAILABLE_STANDARDS ON [SETS].[Set_Name]= [AVAILABLE_STANDARDS].[Set_Name] where AVAILABLE_STANDARDS.Assessment_Id=@standard_assessment_id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_GetTop5Areas]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 1/27/2020
-- Description:	get the percentages for each area
-- line up the assessments 
-- =============================================
ALTER PROCEDURE [dbo].[usp_GetTop5Areas]
	@Aggregation_id int
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*
set the sequence based on assessment date
get the last two assessments.   Then compute
the percentages for all areas and take the difference
between the two assessments
once the difference is determined sort the the difference
get the top 5 for most improved and the bottom 5 for least improved.
*/
	SET NOCOUNT ON;
	exec usp_setTrendOrder @aggregation_id
    
	

	declare @assessment1 int, @assessment2 int
	set @assessment1 = null;
	set @assessment2 = null; 
	


	--declare @aggregation_id int
	--set @Aggregation_id = 2

	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers
	IF OBJECT_ID('tempdb..#TopBottomType') IS NOT NULL DROP TABLE #TopBottomType
	
	CREATE TABLE #TopBottomType(
	[Question_Group_Heading] [varchar](100) NOT NULL,
	[pdifference] [float] NULL,
	[TopBottomType] [varchar](10) NOT NULL
	)

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	declare sse cursor for select Assessment_Id from AGGREGATION_ASSESSMENT where Aggregation_Id = @Aggregation_id
	order by Sequence desc
	Declare @assessment_id int

	open sse
	fetch next from sse into @assessment_id 
	while(@@FETCH_STATUS = 0)
	begin
		if (@assessment1 is null) set @assessment1 = @assessment_id 

		insert into #answers exec [GetRelevantAnswers] @assessment_id		
		fetch next from sse into @assessment_id 
		if(@assessment2 is null ) set @assessment2 = @assessment_id
	end
	close sse 
	deallocate sse
	
	insert into #TopBottomType(Question_Group_Heading,pdifference,TopBottomType)
	select  
	 assessment1.Question_Group_Heading Question_Group_Heading,
	 assessment1.percentage-assessment2.percentage as pdifference,
	 [TopBottomType] = 'None'
	 from (
	select a.*,b.Total, (isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float) as percentage  from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA' and assessment_id= @assessment1
	group by  Assessment_Id, h.Question_Group_Heading) b on a.assessment_id = b.assessment_id 
	and a.Question_Group_Heading=b.Question_Group_Heading ) assessment1 join (
	
	select a.*,b.Total, (isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float) as percentage  from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA' and assessment_id= @assessment2
	group by  Assessment_Id, h.Question_Group_Heading) b on a.assessment_id = b.assessment_id 
	and a.Question_Group_Heading=b.Question_Group_Heading) assessment2 on assessment1.Question_Group_Heading = assessment2.Question_Group_Heading
	order by pdifference desc

	----------------------------------------------------------
	
		
	update #TopBottomType set TopBottomType = 'BOTTOM' from (
	select top 5 Question_Group_Heading from #TopBottomType order by pdifference) a
	where #TopBottomType.Question_Group_Heading = a.Question_Group_Heading

	update #TopBottomType set TopBottomType = 'TOP' from (
	select top 5 Question_Group_Heading from #TopBottomType 
	where pdifference>=0
	order by pdifference desc) a
	where #TopBottomType.Question_Group_Heading = a.Question_Group_Heading


	select a.*,b.Total, ((isnull(YesCount,0)+isnull(AlternateCount,0))/CAST(Total as float))*100 as percentage
	, #TopBottomType.pdifference, TopBottomType , Assessment_Date
	from (
	SELECT Assessment_Id, Question_Group_Heading,
			[Y] as [YesCount],			
			[N] as [NoCount],
			[NA] as [NaCount],
			[A] as [AlternateCount],
			[U] as [UnansweredCount]			
		FROM 
		(
			select Assessment_Id, h.Question_Group_Heading, Answer_Text			 
			from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			where answer_text <> 'NA'
			
		) p
		PIVOT
		(
		  count(Answer_Text)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt 
		where Assessment_Id is not null) a join (
	select Assessment_Id, h.Question_Group_Heading, count(answer_text) Total 	
	from #answers a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
	where answer_text <> 'NA'
	group by  Assessment_Id, h.Question_Group_Heading) b 
	on a.assessment_id = b.assessment_id and a.Question_Group_Heading=b.Question_Group_Heading 
	join #TopBottomType on b.Question_Group_Heading = #TopBottomType.Question_Group_Heading
	join ASSESSMENTS on a.assessment_id = assessments.Assessment_Id
	where #TopBottomType.TopBottomType in ('Top','Bottom')
	order by TopBottomType desc, pdifference desc,Question_Group_Heading, Assessment_Date, Assessment_Id
	
	
	
		
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_For_User]'
GO

ALTER PROCEDURE [dbo].[usp_Assessments_For_User]
@User_Id int
AS
SET NOCOUNT ON;

-- Replaces view Assessments_For_User.  Gathering missing alt justification is
-- more straightforward using a procedure than a view.

-- build a table variable with ALT answers without justification
declare @ATM table(assessment_id INT)

insert into @ATM
select distinct assessment_id 
from Answer_Standards_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Maturity
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Components_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,
	CreatorName = u.FirstName + ' ' + u.LastName,
	LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	UseDiagram,
	UseStandard,
	UseMaturity,
	UseCyote,
	workflow,
	SelectedMaturityModel = m.Model_Name,
	SelectedStandards = string_agg(s.Short_Name, ', '),
	case when a.assessment_id in (select assessment_id from @ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		left join AVAILABLE_MATURITY_MODELS amm on amm.Assessment_Id = a.Assessment_Id
		left join MATURITY_MODELS m on m.Maturity_Model_Id = amm.model_id
		left join AVAILABLE_STANDARDS astd on astd.Assessment_Id = a.Assessment_Id
		left join SETS s on s.Set_Name = astd.Set_Name
		join USERS u on a.AssessmentCreatorId = u.UserId
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
		left join (
			select distinct a.Assessment_Id, v.Mark_For_Review
			from ASSESSMENTS a 
			join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1 

			union

			select distinct a.Assessment_Id, Mark_For_Review
			from ASSESSMENTS a
			join Answer_Maturity v on a.Assessment_id = v.Assessment_Id
			where v.Mark_For_Review = 1

			union 

			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b 
			
		on a.Assessment_Id = b.Assessment_Id
		where u.UserId = @User_Id
		group by a.Assessment_Id, Assessment_Name, Assessment_Date, AssessmentCreatedDate, 
					LastModifiedDate, u.FirstName, u.LastName, mark_for_review, UseCyote, UseDiagram,
					UseStandard, UseMaturity, Workflow, Model_Name, c.UserId
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_PATH_QUESTION]'
GO
CREATE TABLE [dbo].[CYOTE_PATH_QUESTION]
(
[Question_Id] [int] NOT NULL,
[Path_Id] [int] NOT NULL,
[Sequence] [int] NULL CONSTRAINT [DF_CYOTE_PATH_QUESTION_Sequence] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CYOTE_PATH_QUESTION] on [dbo].[CYOTE_PATH_QUESTION]'
GO
ALTER TABLE [dbo].[CYOTE_PATH_QUESTION] ADD CONSTRAINT [PK_CYOTE_PATH_QUESTION] PRIMARY KEY CLUSTERED ([Question_Id], [Path_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CYOTE_QUESTIONS]'
GO
CREATE TABLE [dbo].[CYOTE_QUESTIONS]
(
[Question_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Intro] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Symptom] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Techniques] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recommendation] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__CYOTE_QU__B0B2E4E65627EA23] on [dbo].[CYOTE_QUESTIONS]'
GO
ALTER TABLE [dbo].[CYOTE_QUESTIONS] ADD CONSTRAINT [PK__CYOTE_QU__B0B2E4E65627EA23] PRIMARY KEY CLUSTERED ([Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_POSSIBLE_ANSWERS]'
GO
CREATE TABLE [dbo].[MATURITY_POSSIBLE_ANSWERS]
(
[Maturity_Model_Id] [int] NOT NULL,
[Maturity_Answer] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_POSSIBLE_ANSWERS] on [dbo].[MATURITY_POSSIBLE_ANSWERS]'
GO
ALTER TABLE [dbo].[MATURITY_POSSIBLE_ANSWERS] ADD CONSTRAINT [PK_MATURITY_POSSIBLE_ANSWERS] PRIMARY KEY CLUSTERED ([Maturity_Model_Id], [Maturity_Answer])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id]) ON DELETE CASCADE ON UPDATE CASCADE NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS] FOREIGN KEY ([Parent_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] WITH NOCHECK  ADD CONSTRAINT [FK_ANSWER_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANALYTICS_MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] ADD CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1] FOREIGN KEY ([Mat_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [FK_ANSWER_ANSWER_QUESTION_TYPES] FOREIGN KEY ([Question_Type]) REFERENCES [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER_CLONE]'
GO
ALTER TABLE [dbo].[ANSWER_CLONE] ADD CONSTRAINT [FK_ANSWER_CLONE_ANSWER_PROFILE] FOREIGN KEY ([Profile_Id]) REFERENCES [dbo].[ANSWER_PROFILE] ([Profile_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER_PROFILE]'
GO
ALTER TABLE [dbo].[ANSWER_PROFILE] ADD CONSTRAINT [FK_ANSWER_PROFILE_ASSESSMENTS] FOREIGN KEY ([Asessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_BUDGET_BASES] FOREIGN KEY ([Budget_Basis]) REFERENCES [dbo].[CIST_CSI_BUDGET_BASES] ([Budget_Basis]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_CUSTOMER_COUNTS] FOREIGN KEY ([Customers_Count]) REFERENCES [dbo].[CIST_CSI_CUSTOMER_COUNTS] ([Customer_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CS_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_USER_COUNTS] FOREIGN KEY ([Authorized_Non_Organizational_User_Count]) REFERENCES [dbo].[CIST_CSI_USER_COUNTS] ([User_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIST_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS_2] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIST_CSI_STAFF_COUNTS] ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIST_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_CIST_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Primary_Defining_System]) REFERENCES [dbo].[CIST_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIST_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Defining_System_Id]) REFERENCES [dbo].[CIST_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIST_CSI_SERVICE_COMPOSITION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[CIST_CSI_SERVICE_COMPOSITION] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CS_SITE_INFORMATION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_ORGANIZATION_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS_2] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIST_CSI_STAFF_COUNTS] ([Staff_Count])
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIST_CSI_ORGANIZATION_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIST_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CYOTE_ANSWERS]'
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [FK_CYOTE_ANSWERS_ASSESSMENT] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [FK_CYOTE_ANSWERS_OBS] FOREIGN KEY ([Observable_Id]) REFERENCES [dbo].[CYOTE_OBSERVABLES] ([Observable_Id])
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [FK_CYOTE_ANSWERS_CYOTE_ANSWERS] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[CYOTE_ANSWERS] ([Answer_Id])
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [FK_CYOTE_ANSWERS_PATH] FOREIGN KEY ([Path_Id]) REFERENCES [dbo].[CYOTE_PATHS] ([Path_Id])
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] ADD CONSTRAINT [FK_CYOTE_ANSWERS_OPTION] FOREIGN KEY ([Option_Id]) REFERENCES [dbo].[CYOTE_OPTIONS] ([Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS] FOREIGN KEY ([Parent_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES] FOREIGN KEY ([Mat_Question_Type]) REFERENCES [dbo].[MATURITY_QUESTION_TYPES] ([Mat_Question_Type]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS] FOREIGN KEY ([Grouping_Id]) REFERENCES [dbo].[MATURITY_GROUPINGS] ([Grouping_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_ANSWER_OPTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] ADD CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MODES_SETS_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] ADD CONSTRAINT [FK_MODES_MATURITY_MODELS_APP_CODE] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[APP_CODE] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] ADD CONSTRAINT [FK_MODES_MATURITY_MODELS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] ADD CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS] FOREIGN KEY ([Model_Name]) REFERENCES [dbo].[MATURITY_MODELS] ([Model_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]
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
