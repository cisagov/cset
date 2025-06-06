/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb    -  This database will be modified

to synchronize it with:

        nhswebdev2.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/6/2025 2:05:21 PM

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
PRINT N'Creating sequences'
GO
CREATE SEQUENCE [dbo].[MaturityNodeSequence]
AS int
START WITH 1
INCREMENT BY 1
MINVALUE -2147483648
MAXVALUE 2147483647
NO CYCLE
CACHE 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_GROUPINGS]'
GO
CREATE TABLE [dbo].[MATURITY_GROUPINGS]
(
[Grouping_Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Model_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Parent_Id] [int] NULL,
[Group_Level] [int] NULL,
[Type_Id] [int] NOT NULL,
[Title_Id] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MATURITY_GROUPINGS_Unique_Node_Id] DEFAULT (NEXT VALUE FOR [MaturityNodeSequence]),
[Abbreviation] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title_Prefix] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description_Extended] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_ELEMENT] on [dbo].[MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ADD CONSTRAINT [PK_MATURITY_ELEMENT] PRIMARY KEY CLUSTERED ([Grouping_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTIONS]
(
[Mat_Question_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Supplemental_Info] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Text_Hash] AS (CONVERT([varbinary](20),hashbytes('SHA1',[Question_Text]),(0))) PERSISTED,
[Maturity_Model_Id] [int] NOT NULL,
[Parent_Question_Id] [int] NULL,
[Ranking] [int] NULL,
[Grouping_Id] [int] NULL,
[Examination_Approach] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Short_Name] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mat_Question_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Option_Id] [int] NULL,
[Supplemental_Fact] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scope] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recommend_Action] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_Addressed] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Services] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Outcome] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_Practice] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Implementation_Guides] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__MATURITY__EBDCEAE635AFA091] on [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [PK__MATURITY__EBDCEAE635AFA091] PRIMARY KEY CLUSTERED ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[MATURITY_MODELS]
(
[Model_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Maturity_Model_Id] [int] NOT NULL IDENTITY(1, 1),
[Answer_Options] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Questions_Alias] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Analytics_Rollup_Level] [int] NOT NULL CONSTRAINT [DF_MATURITY_MODELS_Analytics_Rollup_Level] DEFAULT ((1)),
[Model_Title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level_Usage_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_MODELS] on [dbo].[MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[MATURITY_MODELS] ADD CONSTRAINT [PK_MATURITY_MODELS] PRIMARY KEY CLUSTERED ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_MATURITY_MODELS] on [dbo].[MATURITY_MODELS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MATURITY_MODELS] ON [dbo].[MATURITY_MODELS] ([Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_GLOBAL_SEQUENCES]'
GO
CREATE TABLE [dbo].[MATURITY_GLOBAL_SEQUENCES]
(
[Maturity_Model_Id] [int] NOT NULL,
[global_sequence] [bigint] NOT NULL,
[g1] [int] NOT NULL,
[g2] [int] NULL,
[g3] [int] NULL,
[g4] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Global_Sequence] on [dbo].[MATURITY_GLOBAL_SEQUENCES]'
GO
ALTER TABLE [dbo].[MATURITY_GLOBAL_SEQUENCES] ADD CONSTRAINT [PK_Global_Sequence] PRIMARY KEY CLUSTERED ([global_sequence])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_SequenceMaturityGroups]'
GO

-- =============================================
-- Author:		Randy
-- Create date: 19-NOV-2024
-- Description:	Determine a "global" sequence for all maturity groupings in context.
-- This is needed because a child grouping may start its sequencing at 1, which would
-- put it ahead of its parent with a simple sort by sequence.
--
-- All groupings with their global sequence are stored in [MATURITY_GLOBAL_SEQUENCES].
--
-- It can currently handle a grouping structure depth of 4.  This can be expanded in the future if needed.
-- =============================================
CREATE PROCEDURE [dbo].[analytics_SequenceMaturityGroups]
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM [MATURITY_GLOBAL_SEQUENCES]


	DECLARE seq_cursor CURSOR FOR
		select g1.Maturity_Model_Id, 
			ROW_NUMBER() over (order by (select null)) as global_sequence, 
			g1.grouping_Id as [g1], g2.grouping_id as [g2], g3.grouping_id as [g3], g4.grouping_id as [g4]
		from [MATURITY_GROUPINGS] g1
		left join [MATURITY_GROUPINGS] g2 on g2.parent_id = g1.grouping_id
		left join [MATURITY_GROUPINGS] g3 on g3.parent_id = g2.grouping_id
		left join [MATURITY_GROUPINGS] g4 on g4.parent_id = g3.grouping_id
		where g1.parent_id is null
			and (g1.Maturity_Model_Id = g2.Maturity_Model_Id or g2.Maturity_Model_Id is null)
			and (g2.Maturity_Model_Id = g3.Maturity_Model_Id or g3.Maturity_Model_Id is null)
			and (g3.Maturity_Model_Id = g4.Maturity_Model_Id or g4.Maturity_Model_Id is null)
		order by g1.maturity_model_id, g1.sequence, g2.sequence, g3.sequence, g4.sequence;


	DECLARE @Maturity_Model_Id int, @global_sequence int, @g1 int, @g2 int, @g3 int, @g4 int;

	OPEN seq_cursor;

	FETCH NEXT FROM seq_cursor INTO @Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [MATURITY_GLOBAL_SEQUENCES](
		[Maturity_Model_Id], [global_sequence], [g1], [g2], [g3], [g4])
		values (@Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4)

		FETCH NEXT FROM seq_cursor into @Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4
	END

	CLOSE seq_cursor;
	DEALLOCATE seq_cursor;
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANALYTICS_MATURITY_GROUPINGS]'
GO
CREATE TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS]
(
[Maturity_Model_Id] [int] NOT NULL,
[Maturity_Question_Id] [int] NOT NULL,
[Question_Group] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Group_Sequence] [int] NULL,
[Global_Sequence] [int] NULL,
[Group_id] [int] NULL
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
	INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] 
	([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group], [Group_Id], [Group_Sequence], [Global_Sequence])

	select distinct q.Maturity_Model_Id, q.Mat_Question_Id, title, g.Grouping_Id as [Group_Id], g.sequence, null
	from [MATURITY_GROUPINGS] g 
	join [MATURITY_QUESTIONS] q on g.Grouping_Id = q.Grouping_Id 
	where g.Maturity_Model_Id = @maturity_model_id and g.Maturity_Model_Id=@maturity_model_id 
	and Group_Level = @analytics_rollup_level
    
    FETCH NEXT FROM maturity_cursor   
    into @maturity_model_id, @analytics_rollup_level
END   
CLOSE maturity_cursor;  
DEALLOCATE maturity_cursor;  


-- define a 'global' sequence for all groupings in all models
EXEC [analytics_SequenceMaturityGroups]

-- include the global sequence on the ANALYTICS_MATURITY_GROUPINGS work table
update ANALYTICS_MATURITY_GROUPINGS
set Global_Sequence = (
	select top 1 global_sequence from [MATURITY_GLOBAL_SEQUENCES]
	where group_id = g1 or group_id = g2 or group_id = g3 or group_id = g4
)
	
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
PRINT N'Creating [dbo].[ASSESSMENTS]'
GO
CREATE TABLE [dbo].[ASSESSMENTS]
(
[Assessment_Id] [int] NOT NULL IDENTITY(1, 1),
[AssessmentCreatedDate] [datetime2] NOT NULL CONSTRAINT [DF_ASSESSMENTS_AssessmentCreatedDate] DEFAULT (getdate()),
[AssessmentCreatorId] [int] NULL,
[LastModifiedDate] [datetime2] NULL,
[Alias] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessment_GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ASSESSMENTS_Assessment_GUID] DEFAULT (newid()),
[Assessment_Date] [datetime2] NOT NULL CONSTRAINT [DF_ASSESSMENTS_Assessment_Date] DEFAULT (getdate()),
[CreditUnionName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charter] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assets] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IRPTotalOverride] [int] NULL,
[IRPTotalOverrideReason] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatDetail_targetBandOnly] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_MatDetail_targetBandOnly] DEFAULT ((1)),
[Diagram_Markup] [xml] NULL,
[LastUsedComponentNumber] [int] NOT NULL CONSTRAINT [DF_ASSESSMENTS_LastUsedComponentNumber] DEFAULT ((0)),
[Diagram_Image] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalyzeDiagram] [bit] NOT NULL CONSTRAINT [DF__ASSESSMEN__Analy__188C8DD6] DEFAULT ((0)),
[UseDiagram] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseDiagram] DEFAULT ((0)),
[UseStandard] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseStandard] DEFAULT ((0)),
[UseMaturity] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseMaturity] DEFAULT ((0)),
[AssessmentEffectiveDate] [datetime2] NULL,
[GalleryItemGuid] [uniqueidentifier] NULL,
[ISE_StateLed] [bit] NULL CONSTRAINT [DF_ASSESSMENTS_ISE_StateLed] DEFAULT ((0)),
[Is_PCII] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_PCII] DEFAULT ((0)),
[PCII_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedSinceLastExport] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_ModifiedSinceLastExport] DEFAULT ((1)),
[AssessorMode] [bit] NOT NULL CONSTRAINT [DF__ASSESSMEN__Asses__62307D25] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Aggregation_1] on [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD CONSTRAINT [PK_Aggregation_1] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DOCUMENT_FILE]'
GO
CREATE TABLE [dbo].[DOCUMENT_FILE]
(
[Assessment_Id] [int] NOT NULL,
[Document_Id] [int] NOT NULL IDENTITY(1, 1),
[Path] [nvarchar] (3990) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (3990) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileMd5] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContentType] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedTimestamp] [datetime] NOT NULL CONSTRAINT [DF_DOCUMENT_FILE_CreatedTimestamp] DEFAULT (getdate()),
[UpdatedTimestamp] [datetime] NOT NULL CONSTRAINT [DF_DOCUMENT_FILE_UpdatedTimestamp] DEFAULT (getdate()),
[Name] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data] [varbinary] (max) NULL,
[IsGlobal] [bit] NOT NULL CONSTRAINT [DF__DOCUMENT___IsGlo__7F01C5FD] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__document_file__00000000000001C8] on [dbo].[DOCUMENT_FILE]'
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ADD CONSTRAINT [PK__document_file__00000000000001C8] PRIMARY KEY CLUSTERED ([Document_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating trigger [dbo].[document_cascade_delete] on [dbo].[ASSESSMENTS]'
GO

CREATE TRIGGER [dbo].[document_cascade_delete] ON [dbo].[ASSESSMENTS]
FOR DELETE
AS

	DELETE FROM DOCUMENT_FILE
	WHERE  Assessment_Id IN (  SELECT Assessment_Id
	                        FROM deleted )
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
CREATE TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]
(
[Assessment_Id] [int] NOT NULL,
[Component_Guid] [uniqueidentifier] NOT NULL,
[Component_Symbol_Id] [int] NOT NULL,
[label] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DrawIO_id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zone_Id] [int] NULL,
[Layer_Id] [int] NULL,
[Parent_DrawIO_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_DIAGRAM_COMPONENTS_1] on [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [PK_ASSESSMENT_DIAGRAM_COMPONENTS_1] PRIMARY KEY CLUSTERED ([Assessment_Id], [Component_Guid])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER]'
GO
CREATE TABLE [dbo].[ANSWER]
(
[Assessment_Id] [int] NOT NULL,
[Answer_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Or_Requirement_Id] [int] NOT NULL,
[Mark_For_Review] [bit] NULL,
[Comment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alternate_Justification] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Number] [int] NULL,
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ANSWER_Answer_Text] DEFAULT ('U'),
[Component_Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ANSWER_Component_Guid] DEFAULT ('00000000-0000-0000-0000-000000000000'),
[Custom_Question_Guid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Old_Answer_Id] [int] NULL,
[Reviewed] [bit] NOT NULL CONSTRAINT [DF_ANSWER_Reviewed] DEFAULT ((0)),
[FeedBack] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_Requirement] AS (CONVERT([bit],case [Question_Type] when 'Requirement' then (1) else (0) end,(0))),
[Is_Component] AS (CONVERT([bit],case [Question_Type] when 'Component' then (1) else (0) end,(0))),
[Is_Framework] AS (CONVERT([bit],case [Question_Type] when 'Framework' then (1) else (0) end,(0))),
[Is_Maturity] AS (CONVERT([bit],case [Question_Type] when 'Maturity' then (1) else (0) end,(0))),
[Free_Response_Answer] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mat_Option_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ANSWER_1] on [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [PK_ANSWER_1] PRIMARY KEY CLUSTERED ([Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [NonClusteredIndex-Answers_Assessment_Id] on [dbo].[ANSWER]'
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Answers_Assessment_Id] ON [dbo].[ANSWER] ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [IX_ANSWER] UNIQUE NONCLUSTERED ([Assessment_Id], [Question_Or_Requirement_Id], [Question_Type], [Component_Guid], [Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating trigger [dbo].[ASSESSMENT_DIAGRAM_COMPONENT_DELETE_Trigger] on [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[ASSESSMENT_DIAGRAM_COMPONENT_DELETE_Trigger]
   ON  [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]
   For DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 DELETE dbo.answer FROM deleted
		WHERE answer.Assessment_Id = deleted.Assessment_Id and answer.Component_Guid = deleted.Component_Guid

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GEN_FILE]'
GO
CREATE TABLE [dbo].[GEN_FILE]
(
[Gen_File_Id] [int] NOT NULL IDENTITY(2609, 1),
[File_Type_Id] [numeric] (38, 0) NULL,
[File_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[File_Size] [float] NULL,
[Doc_Num] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_GEN_FILE_Doc_Num] DEFAULT ('NONE'),
[Comments] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Short_Name] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Publish_Date] [datetime] NULL,
[Doc_Version] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Summary] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data] [varbinary] (max) NULL,
[Is_Uploaded] [bit] NOT NULL CONSTRAINT [DF_GEN_FILE_Is_Uploaded] DEFAULT ((1)),
[Language] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [SYS_C0014438] on [dbo].[GEN_FILE]'
GO
ALTER TABLE [dbo].[GEN_FILE] ADD CONSTRAINT [SYS_C0014438] PRIMARY KEY CLUSTERED ([Gen_File_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FILE_KEYWORDS]'
GO
CREATE TABLE [dbo].[FILE_KEYWORDS]
(
[Gen_File_Id] [int] NOT NULL,
[Keyword] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [FILE_KEYWORDS_PK] on [dbo].[FILE_KEYWORDS]'
GO
ALTER TABLE [dbo].[FILE_KEYWORDS] ADD CONSTRAINT [FILE_KEYWORDS_PK] PRIMARY KEY CLUSTERED ([Gen_File_Id], [Keyword])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AGGREGATION_INFORMATION]'
GO
CREATE TABLE [dbo].[AGGREGATION_INFORMATION]
(
[AggregationID] [int] NOT NULL IDENTITY(1, 1),
[Aggregation_Date] [datetime] NULL,
[Aggregation_Mode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Aggregation_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Facility_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State_Province_Or_Region] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Phone] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessment_Description] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Notes_And_Comments] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enterprise_Evaluation_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__AggregationInformation] on [dbo].[AGGREGATION_INFORMATION]'
GO
ALTER TABLE [dbo].[AGGREGATION_INFORMATION] ADD CONSTRAINT [PK__AggregationInformation] PRIMARY KEY CLUSTERED ([AggregationID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AGGREGATION_ASSESSMENT]'
GO
CREATE TABLE [dbo].[AGGREGATION_ASSESSMENT]
(
[Assessment_Id] [int] NOT NULL,
[Aggregation_Id] [int] NOT NULL,
[Sequence] [int] NULL,
[Alias] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__AGGREGAT__985B1205C06FF728] on [dbo].[AGGREGATION_ASSESSMENT]'
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [PK__AGGREGAT__985B1205C06FF728] PRIMARY KEY CLUSTERED ([Assessment_Id], [Aggregation_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_IRP]'
GO
CREATE TABLE [dbo].[ASSESSMENT_IRP]
(
[Answer_Id] [int] NOT NULL IDENTITY(1, 1),
[Assessment_Id] [int] NOT NULL,
[IRP_Id] [int] NOT NULL,
[Response] [int] NULL,
[Comment] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Assessment_IRP] on [dbo].[ASSESSMENT_IRP]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP] ADD CONSTRAINT [PK_Assessment_IRP] PRIMARY KEY CLUSTERED ([Assessment_Id], [IRP_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_IRP_HEADER]'
GO
CREATE TABLE [dbo].[ASSESSMENT_IRP_HEADER]
(
[HEADER_RISK_LEVEL_ID] [int] NULL,
[ASSESSMENT_ID] [int] NOT NULL,
[IRP_HEADER_ID] [int] NOT NULL,
[RISK_LEVEL] [int] NULL,
[COMMENT] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_IRP_HEADER] on [dbo].[ASSESSMENT_IRP_HEADER]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP_HEADER] ADD CONSTRAINT [PK_ASSESSMENT_IRP_HEADER] PRIMARY KEY CLUSTERED ([ASSESSMENT_ID], [IRP_HEADER_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[IRP_HEADER]'
GO
CREATE TABLE [dbo].[IRP_HEADER]
(
[IRP_Header_Id] [int] NOT NULL,
[Header] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_IRP_HEADER] on [dbo].[IRP_HEADER]'
GO
ALTER TABLE [dbo].[IRP_HEADER] ADD CONSTRAINT [PK_IRP_HEADER] PRIMARY KEY CLUSTERED ([IRP_Header_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[IRP]'
GO
CREATE TABLE [dbo].[IRP]
(
[IRP_ID] [int] NOT NULL,
[Item_Number] [int] NULL,
[Risk_1_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_2_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_3_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_4_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_5_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Validation_Approach] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Header_Id] [int] NOT NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DescriptionComment] [nvarchar] (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_Type] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [df_Risk_Type] DEFAULT ('IRP')
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_IRP] on [dbo].[IRP]'
GO
ALTER TABLE [dbo].[IRP] ADD CONSTRAINT [PK_IRP] PRIMARY KEY CLUSTERED ([IRP_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[AVAILABLE_MATURITY_MODELS]
(
[Assessment_Id] [int] NOT NULL,
[Selected] [bit] NOT NULL CONSTRAINT [DF_AVAILABLE_MATURITY_MODELS_Selected] DEFAULT ((0)),
[model_id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AVAILABLE_MATURITY_MODELS] on [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [PK_AVAILABLE_MATURITY_MODELS] PRIMARY KEY CLUSTERED ([Assessment_Id], [model_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_ANSWER_OPTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_ANSWER_OPTIONS]
(
[Mat_Option_Id] [int] NOT NULL IDENTITY(1, 1),
[Option_Text] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Answer_Sequence] [int] NOT NULL CONSTRAINT [DF_MATURITY_ANSWER_OPTIONS_Answer_Sequence_1] DEFAULT ((0)),
[ElementId] [int] NULL,
[Weight] [decimal] (18, 2) NULL,
[Mat_Option_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Option_Id] [int] NULL,
[Has_Answer_Text] [bit] NOT NULL CONSTRAINT [DF__MATURITY___Has_A__7266E4EE] DEFAULT ((0)),
[Formula] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Threshold] [decimal] (18, 2) NULL,
[RiFormula] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ThreatType] [int] NULL,
[Is_None] [bit] NOT NULL CONSTRAINT [DF__MATURITY___Is_No__259C7031] DEFAULT ((0))
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
PRINT N'Creating [dbo].[HYDRO_DATA]'
GO
CREATE TABLE [dbo].[HYDRO_DATA]
(
[Mat_Option_Id] [int] NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Feasibility] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Feasibility_Limit] [int] NULL,
[Impact] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Impact_Limit] [int] NULL,
[Action_Item_Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action_Items] [nchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Severity] [int] NULL,
[Sequence] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [IX_HYDRO_DATA] UNIQUE CLUSTERED ([Mat_Question_Id], [Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_HYDRO_DATA] on [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [PK_HYDRO_DATA] PRIMARY KEY NONCLUSTERED ([Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[HYDRO_PROGRESS]'
GO
CREATE TABLE [dbo].[HYDRO_PROGRESS]
(
[Progress_Id] [int] NOT NULL,
[Progress_Text] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__HYDRO_PR__D558797A8254CF40] on [dbo].[HYDRO_PROGRESS]'
GO
ALTER TABLE [dbo].[HYDRO_PROGRESS] ADD CONSTRAINT [PK__HYDRO_PR__D558797A8254CF40] PRIMARY KEY CLUSTERED ([Progress_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[HYDRO_DATA_ACTIONS]'
GO
CREATE TABLE [dbo].[HYDRO_DATA_ACTIONS]
(
[Answer_Id] [int] NOT NULL,
[Progress_Id] [int] NOT NULL,
[Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__HYDRO_DA__36918F3818A6E56C] on [dbo].[HYDRO_DATA_ACTIONS]'
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [PK__HYDRO_DA__36918F3818A6E56C] PRIMARY KEY CLUSTERED ([Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_LEVELS]'
GO
CREATE TABLE [dbo].[MATURITY_LEVELS]
(
[Level] [int] NOT NULL,
[Level_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level_Id] [int] NOT NULL IDENTITY(1, 1),
[Maturity_Model_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_LEVELS] on [dbo].[MATURITY_LEVELS]'
GO
ALTER TABLE [dbo].[MATURITY_LEVELS] ADD CONSTRAINT [PK_MATURITY_LEVELS] PRIMARY KEY CLUSTERED ([Maturity_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ACCESS_KEY]'
GO
CREATE TABLE [dbo].[ACCESS_KEY]
(
[AccessKey] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GeneratedDate] [datetime2] NOT NULL,
[Encryption] [bit] NOT NULL CONSTRAINT [DF_ACCESS_KEY_PreventEncrypt] DEFAULT ((1)),
[CisaAssessorWorkflow] [bit] NOT NULL CONSTRAINT [DF_ACCESS_KEY_CisaAssessorWorkflow] DEFAULT ((0)),
[Lang] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ACCESS_KEY_Lang] DEFAULT ('en')
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ACCESS_KEY] on [dbo].[ACCESS_KEY]'
GO
ALTER TABLE [dbo].[ACCESS_KEY] ADD CONSTRAINT [PK_ACCESS_KEY] PRIMARY KEY CLUSTERED ([AccessKey])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
CREATE TABLE [dbo].[ACCESS_KEY_ASSESSMENT]
(
[AccessKey] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assessment_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ACCESS_KEY_ASSESSMENT] on [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [PK_ACCESS_KEY_ASSESSMENT] PRIMARY KEY CLUSTERED ([AccessKey], [Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USER_DETAIL_INFORMATION]'
GO
CREATE TABLE [dbo].[USER_DETAIL_INFORMATION]
(
[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_USER_DETAIL_INFORMATION_Id] DEFAULT (newid()),
[CellPhone] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficePhone] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImagePath] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USER_DETAIL_INFORMATION] on [dbo].[USER_DETAIL_INFORMATION]'
GO
ALTER TABLE [dbo].[USER_DETAIL_INFORMATION] ADD CONSTRAINT [PK_USER_DETAIL_INFORMATION] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_USER_DETAIL_INFORMATION] on [dbo].[USER_DETAIL_INFORMATION]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_USER_DETAIL_INFORMATION] ON [dbo].[USER_DETAIL_INFORMATION] ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ADDRESS]'
GO
CREATE TABLE [dbo].[ADDRESS]
(
[PrimaryEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Id] [uniqueidentifier] NOT NULL,
[City] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line1] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line2] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ADDRESS_1] on [dbo].[ADDRESS]'
GO
ALTER TABLE [dbo].[ADDRESS] ADD CONSTRAINT [PK_ADDRESS_1] PRIMARY KEY CLUSTERED ([AddressType], [Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AGGREGATION_TYPES]'
GO
CREATE TABLE [dbo].[AGGREGATION_TYPES]
(
[Aggregation_Mode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AGGREGATION_TYPES] on [dbo].[AGGREGATION_TYPES]'
GO
ALTER TABLE [dbo].[AGGREGATION_TYPES] ADD CONSTRAINT [PK_AGGREGATION_TYPES] PRIMARY KEY CLUSTERED ([Aggregation_Mode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_LOOKUP]'
GO
CREATE TABLE [dbo].[ANSWER_LOOKUP]
(
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Answer_Full_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Answer_Lookup] on [dbo].[ANSWER_LOOKUP]'
GO
ALTER TABLE [dbo].[ANSWER_LOOKUP] ADD CONSTRAINT [PK_Answer_Lookup] PRIMARY KEY CLUSTERED ([Answer_Text])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_QUESTION_TYPES]'
GO
CREATE TABLE [dbo].[ANSWER_QUESTION_TYPES]
(
[Question_Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
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
[Assessment_Id] [int] NOT NULL,
[Profile_Id] [int] NOT NULL IDENTITY(1, 1),
[ProfileName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[Comment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alternate_Justification] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Number] [int] NULL,
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Component_Guid] [uniqueidentifier] NOT NULL,
[Custom_Question_Guid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Old_Answer_Id] [int] NULL,
[Reviewed] [bit] NOT NULL,
[FeedBack] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_Requirement] [bit] NULL,
[Is_Component] [bit] NULL,
[Is_Framework] [bit] NULL,
[Is_Maturity] [bit] NULL,
[Free_Response_Answer] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
PRINT N'Creating [dbo].[ASSESSMENT_ROLES]'
GO
CREATE TABLE [dbo].[ASSESSMENT_ROLES]
(
[AssessmentRoleId] [int] NOT NULL IDENTITY(1, 1),
[AssessmentRole] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_ROLES_1] on [dbo].[ASSESSMENT_ROLES]'
GO
ALTER TABLE [dbo].[ASSESSMENT_ROLES] ADD CONSTRAINT [PK_ASSESSMENT_ROLES_1] PRIMARY KEY CLUSTERED ([AssessmentRoleId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_CONTACTS]'
GO
CREATE TABLE [dbo].[ASSESSMENT_CONTACTS]
(
[Assessment_Id] [int] NOT NULL,
[PrimaryEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Invited] [bit] NOT NULL,
[AssessmentRoleId] [int] NOT NULL CONSTRAINT [DF_ASSESSMENT_CONTACTS_AssessmentRole] DEFAULT ((0)),
[UserId] [int] NULL,
[Assessment_Contact_Id] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Primary_POC] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENT_CONTACTS_Is_Primary_POC] DEFAULT ((0)),
[Site_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cell_Phone] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reports_To] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Emergency_Communications_Protocol] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Site_Participant] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENT_CONTACTS_Is_Site_Participant] DEFAULT ((0)),
[Last_Q_Answered] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_CONTACTS] on [dbo].[ASSESSMENT_CONTACTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD CONSTRAINT [PK_ASSESSMENT_CONTACTS] PRIMARY KEY CLUSTERED ([Assessment_Contact_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USERS]'
GO
CREATE TABLE [dbo].[USERS]
(
[PrimaryEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserId] [int] NOT NULL IDENTITY(1, 1),
[Password] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salt] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSuperUser] [bit] NOT NULL CONSTRAINT [DF_USERS_IsSuperUser] DEFAULT ((0)),
[PasswordResetRequired] [bit] NOT NULL CONSTRAINT [DF_USERS_PasswordResetRequired] DEFAULT ((1)),
[FirstName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Id] [uniqueidentifier] NULL,
[EmailSentCount] [int] NOT NULL CONSTRAINT [DF_USERS_EmailSentCount] DEFAULT ((0)),
[IsActive] [bit] NOT NULL CONSTRAINT [DF__USERS__IsActive__6849492E] DEFAULT ((1)),
[Encryption] [bit] NOT NULL CONSTRAINT [DF_USERS_PreventEncryption] DEFAULT ((1)),
[CisaAssessorWorkflow] [bit] NOT NULL CONSTRAINT [DF_USERS_CisaAssessorWorkflow] DEFAULT ((0)),
[Lang] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_USERS_Lang] DEFAULT ('en'),
[IsFirstLogin] [bit] NOT NULL CONSTRAINT [DF_USERS_IsFirstLogin] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USERS_1] on [dbo].[USERS]'
GO
ALTER TABLE [dbo].[USERS] ADD CONSTRAINT [PK_USERS_1] PRIMARY KEY CLUSTERED ([UserId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[USERS]'
GO
ALTER TABLE [dbo].[USERS] ADD CONSTRAINT [IX_USERS] UNIQUE NONCLUSTERED ([PrimaryEmail])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_SYMBOLS]'
GO
CREATE TABLE [dbo].[COMPONENT_SYMBOLS]
(
[Component_Symbol_Id] [int] NOT NULL IDENTITY(1, 1),
[File_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Component_Family_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Symbol_Group_Id] [int] NOT NULL,
[Abbreviation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsService] [bit] NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_HasService] DEFAULT ((0)),
[Symbol_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_Long_Name] DEFAULT (''),
[Width] [int] NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_WIdth] DEFAULT ((60)),
[Height] [int] NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_Height] DEFAULT ((60)),
[Search_Tags] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_SYMBOLS] on [dbo].[COMPONENT_SYMBOLS]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS] ADD CONSTRAINT [PK_COMPONENT_SYMBOLS] PRIMARY KEY CLUSTERED ([Component_Symbol_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_COMPONENT_SYMBOLS_1] on [dbo].[COMPONENT_SYMBOLS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_COMPONENT_SYMBOLS_1] ON [dbo].[COMPONENT_SYMBOLS] ([Abbreviation])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_COMPONENT_SYMBOLS] on [dbo].[COMPONENT_SYMBOLS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_COMPONENT_SYMBOLS] ON [dbo].[COMPONENT_SYMBOLS] ([File_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_CONTAINER]'
GO
CREATE TABLE [dbo].[DIAGRAM_CONTAINER]
(
[Container_Id] [int] NOT NULL IDENTITY(1, 1),
[ContainerType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Visible] DEFAULT ((1)),
[DrawIO_id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Assessment_Id] [int] NOT NULL,
[Universal_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Universal_Sal_Level] DEFAULT ('L'),
[Parent_Id] [int] NOT NULL CONSTRAINT [DF_DIAGRAM_CONTAINER_Parent_Id] DEFAULT ((0)),
[Parent_Draw_IO_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_CONTAINER] on [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] ADD CONSTRAINT [PK_DIAGRAM_CONTAINER] PRIMARY KEY CLUSTERED ([Container_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PARAMETER_ASSESSMENT]'
GO
CREATE TABLE [dbo].[PARAMETER_ASSESSMENT]
(
[Parameter_ID] [int] NOT NULL,
[Assessment_ID] [int] NOT NULL,
[Parameter_Value_Assessment] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_PARAMETERS] on [dbo].[PARAMETER_ASSESSMENT]'
GO
ALTER TABLE [dbo].[PARAMETER_ASSESSMENT] ADD CONSTRAINT [PK_ASSESSMENT_PARAMETERS] PRIMARY KEY CLUSTERED ([Parameter_ID], [Assessment_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PARAMETERS]'
GO
CREATE TABLE [dbo].[PARAMETERS]
(
[Parameter_ID] [int] NOT NULL IDENTITY(1, 1),
[Parameter_Name] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Parameters] on [dbo].[PARAMETERS]'
GO
ALTER TABLE [dbo].[PARAMETERS] ADD CONSTRAINT [PK_Parameters] PRIMARY KEY CLUSTERED ([Parameter_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[LEVEL_NAMES]'
GO
CREATE TABLE [dbo].[LEVEL_NAMES]
(
[Level_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Level_Names] on [dbo].[LEVEL_NAMES]'
GO
ALTER TABLE [dbo].[LEVEL_NAMES] ADD CONSTRAINT [PK_Level_Names] PRIMARY KEY CLUSTERED ([Level_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_SELECTED_LEVELS]'
GO
CREATE TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS]
(
[Assessment_Id] [int] NOT NULL,
[Level_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard_Specific_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_SELECTED_LEVELS] on [dbo].[ASSESSMENT_SELECTED_LEVELS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS] ADD CONSTRAINT [PK_ASSESSMENT_SELECTED_LEVELS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Level_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_SELECTION]'
GO
CREATE TABLE [dbo].[STANDARD_SELECTION]
(
[Assessment_Id] [int] NOT NULL,
[Application_Mode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_STANDARD_SELECTION_Application_Mode] DEFAULT ('Questions Based'),
[Selected_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_STANDARD_SELECTION_Selected_Sal_Level] DEFAULT ('Low'),
[Last_Sal_Determination_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sort_Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Advanced] [bit] NOT NULL CONSTRAINT [DF_STANDARD_SELECTION_Is_Instructions] DEFAULT ((0)),
[Only_Mode] [bit] NOT NULL CONSTRAINT [DF_STANDARD_SELECTION_Only_Mode] DEFAULT ((0)),
[Hidden_Screens] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STANDARD_SELECTION] on [dbo].[STANDARD_SELECTION]'
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD CONSTRAINT [PK_STANDARD_SELECTION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GALLERY_ITEM]'
GO
CREATE TABLE [dbo].[GALLERY_ITEM]
(
[Icon_File_Name_Small] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Icon_File_Name_Large] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration_Setup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Configuration_Setup_Client] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Visible] [bit] NOT NULL CONSTRAINT [DF__GALLERY_I__Is_Vi__3627DDB5] DEFAULT ((1)),
[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_GALLERY_ITEM_CreationDate] DEFAULT (getdate()),
[Gallery_Item_Guid] [uniqueidentifier] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GALLERY_ITEM] on [dbo].[GALLERY_ITEM]'
GO
ALTER TABLE [dbo].[GALLERY_ITEM] ADD CONSTRAINT [PK_GALLERY_ITEM] PRIMARY KEY CLUSTERED ([Gallery_Item_Guid])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
CREATE TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]
(
[Assessment_Id] [int] NOT NULL,
[Documentation_Id] [int] NOT NULL,
[Answer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ASSESSMENTS_REQUIRED_DOCUMENTATION_Answer] DEFAULT ('U'),
[Comment] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENTS_REQUIRED_DOCUMENTATION] on [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [PK_ASSESSMENTS_REQUIRED_DOCUMENTATION] PRIMARY KEY CLUSTERED ([Assessment_Id], [Documentation_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIRED_DOCUMENTATION]'
GO
CREATE TABLE [dbo].[REQUIRED_DOCUMENTATION]
(
[Documentation_Id] [int] NOT NULL IDENTITY(1, 1),
[Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Document_Description] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RDH_Id] [int] NOT NULL,
[Document_Order] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIRED_DOCUMENTATION] on [dbo].[REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[REQUIRED_DOCUMENTATION] ADD CONSTRAINT [PK_REQUIRED_DOCUMENTATION] PRIMARY KEY CLUSTERED ([Documentation_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AVAILABLE_STANDARDS]'
GO
CREATE TABLE [dbo].[AVAILABLE_STANDARDS]
(
[Assessment_Id] [int] NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Selected] [bit] NOT NULL CONSTRAINT [DF_AVAILABLE_STANDARDS_Selected] DEFAULT ((0)),
[Suppress_Mode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AVAILABLE_STANDARDS] on [dbo].[AVAILABLE_STANDARDS]'
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] ADD CONSTRAINT [PK_AVAILABLE_STANDARDS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SETS]'
GO
CREATE TABLE [dbo].[SETS]
(
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Full_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Short_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SETS_Short_Name] DEFAULT ('NO SHORT NAME'),
[Is_Displayed] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Displayed] DEFAULT ((1)),
[Is_Pass_Fail] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Pass_Fail] DEFAULT ((0)),
[Old_Std_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Set_Category_Id] [int] NULL,
[Order_In_Category] [int] NULL,
[Report_Order_Section_Number] [int] NULL,
[Aggregation_Standard_Number] [int] NULL,
[Is_Question] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Question] DEFAULT ((0)),
[Is_Requirement] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Requirement] DEFAULT ((0)),
[Order_Framework_Standards] [int] NOT NULL,
[Standard_ToolTip] [nvarchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Deprecated] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Deprecated] DEFAULT ((0)),
[Upgrade_Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Custom] [bit] NOT NULL CONSTRAINT [DF_SETS_Is_Custom] DEFAULT ((0)),
[Date] [datetime] NULL,
[IsEncryptedModule] [bit] NOT NULL CONSTRAINT [DF_SETS_IsEncryptedModuleClosed] DEFAULT ((0)),
[IsEncryptedModuleOpen] [bit] NOT NULL CONSTRAINT [DF_SETS_IsEncryptedModuleOpen] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SETS] on [dbo].[SETS]'
GO
ALTER TABLE [dbo].[SETS] ADD CONSTRAINT [PK_SETS] PRIMARY KEY CLUSTERED ([Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS]'
GO
CREATE TABLE [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Heading_Num] [int] NOT NULL,
[Heading_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CATALOG_RECOMMENDATIONS_HEADINGS] on [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS]'
GO
ALTER TABLE [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ADD CONSTRAINT [PK_CATALOG_RECOMMENDATIONS_HEADINGS] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CATALOG_RECOMMENDATIONS_DATA]'
GO
CREATE TABLE [dbo].[CATALOG_RECOMMENDATIONS_DATA]
(
[Data_Id] [int] NOT NULL IDENTITY(1, 1),
[Req_Oracle_Id] [int] NULL,
[Parent_Heading_Id] [int] NULL,
[Heading] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Heading_Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section_Long_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section_Short_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Topic_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section_Short_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requirement_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supplemental_Guidance] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supplemental_Guidance_Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requirement] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requirement_Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enhancement] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enhancement_Html] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flow_Document] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Catalog_Recommendations_Data] on [dbo].[CATALOG_RECOMMENDATIONS_DATA]'
GO
ALTER TABLE [dbo].[CATALOG_RECOMMENDATIONS_DATA] ADD CONSTRAINT [PK_Catalog_Recommendations_Data] PRIMARY KEY CLUSTERED ([Data_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[Critical_Service_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Critical_Service_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Multi_Site] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_DEMOGRAPHICS_Multi_Site] DEFAULT ((0)),
[Multi_Site_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Budget_Basis] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Authorized_Organizational_User_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Authorized_Non_Organizational_User_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customers_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Staff_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cybersecurity_IT_ICS_Staff_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CS_DEMOGRAPHICS] on [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIS_CS_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[Motivation_CRR] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_CRR] DEFAULT ((0)),
[Motivation_CRR_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_RRAP] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_RRAP] DEFAULT ((0)),
[Motivation_RRAP_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Organization_Request] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Organization_Request] DEFAULT ((0)),
[Motivation_Organization_Request_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Law_Enforcement_Request] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Law_Enforcement_Request] DEFAULT ((0)),
[Motivation_Law_Enforcement_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Direct_Threats] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Direct_Threats] DEFAULT ((0)),
[Motivation_Direct_Threats_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Special_Event] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Special_Event] DEFAULT ((0)),
[Motivation_Special_Event_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Motivation_Other] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Other] DEFAULT ((0)),
[Motivation_Other_Description] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Organization] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Site_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street_Address] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Visit_Date] [date] NULL,
[Completed_For_SLTT] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_SLTT] DEFAULT ((0)),
[Completed_For_Federal] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_Federal] DEFAULT ((0)),
[Completed_For_National_Special_Event] [bit] NOT NULL CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_National_Special_Event] DEFAULT ((0)),
[CIKR_Sector] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Sector] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IT_ICS_Staff_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cybersecurity_IT_ICS_Staff_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CS_SITE_INFORMATION] on [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIS_CS_SITE_INFORMATION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_STAFF_COUNTS]'
GO
CREATE TABLE [dbo].[CIS_CSI_STAFF_COUNTS]
(
[Staff_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_STAFF_AMOUNTS] on [dbo].[CIS_CSI_STAFF_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_STAFF_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_STAFF_AMOUNTS] PRIMARY KEY CLUSTERED ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_SERVICE_COMPOSITION]'
GO
CREATE TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION]
(
[Assessment_Id] [int] NOT NULL,
[Networks_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Services_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Applications_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Connections_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Personnel_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other_Defining_System_Description] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Defining_System] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_SERVICE_COMPOSITION] on [dbo].[CIS_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [PK_CIS_CSI_SERVICE_COMPOSITION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_DEFINING_SYSTEMS]'
GO
CREATE TABLE [dbo].[CIS_CSI_DEFINING_SYSTEMS]
(
[Defining_System_Id] [int] NOT NULL IDENTITY(1, 1),
[Defining_System] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIS_CSI_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_CIS_CSI_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_DEFINING_SYSTEMS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CIS_CSI_DEFINING_SYSTEMS] ON [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
CREATE TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]
(
[Assessment_Id] [int] NOT NULL,
[Defining_System_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_BUDGET_BASES]'
GO
CREATE TABLE [dbo].[CIS_CSI_BUDGET_BASES]
(
[Budget_Basis] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_BUDGET_BASES] on [dbo].[CIS_CSI_BUDGET_BASES]'
GO
ALTER TABLE [dbo].[CIS_CSI_BUDGET_BASES] ADD CONSTRAINT [PK_CIS_CSI_BUDGET_BASES] PRIMARY KEY CLUSTERED ([Budget_Basis])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_CUSTOMER_COUNTS]'
GO
CREATE TABLE [dbo].[CIS_CSI_CUSTOMER_COUNTS]
(
[Customer_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_CIS_CSI_CUSTOMER_COUNTS_Sequence] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_CUSTOMER_AMOUNTS] on [dbo].[CIS_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_CUSTOMER_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_CUSTOMER_AMOUNTS] PRIMARY KEY CLUSTERED ([Customer_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CIS_CSI_USER_COUNTS]'
GO
CREATE TABLE [dbo].[CIS_CSI_USER_COUNTS]
(
[User_Count] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL CONSTRAINT [DF_CIS_CSI_USER_COUNTS_Sequence] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_USER_AMOUNTS] on [dbo].[CIS_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_USER_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_USER_AMOUNTS] PRIMARY KEY CLUSTERED ([User_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CNSS_CIA_JUSTIFICATIONS]'
GO
CREATE TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS]
(
[Assessment_Id] [int] NOT NULL,
[CIA_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DropDownValueLevel] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Justification] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CNSS_CIA_JUSTIFICATIONS] on [dbo].[CNSS_CIA_JUSTIFICATIONS]'
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS] ADD CONSTRAINT [PK_CNSS_CIA_JUSTIFICATIONS] PRIMARY KEY CLUSTERED ([Assessment_Id], [CIA_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CNSS_CIA_TYPES]'
GO
CREATE TABLE [dbo].[CNSS_CIA_TYPES]
(
[CIA_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CNSS_CIA_TYPES] on [dbo].[CNSS_CIA_TYPES]'
GO
ALTER TABLE [dbo].[CNSS_CIA_TYPES] ADD CONSTRAINT [PK_CNSS_CIA_TYPES] PRIMARY KEY CLUSTERED ([CIA_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_NAMES_LEGACY]'
GO
CREATE TABLE [dbo].[COMPONENT_NAMES_LEGACY]
(
[Component_Symbol_id] [int] NOT NULL,
[Old_Symbol_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_NAMES_LEGACY] on [dbo].[COMPONENT_NAMES_LEGACY]'
GO
ALTER TABLE [dbo].[COMPONENT_NAMES_LEGACY] ADD CONSTRAINT [PK_COMPONENT_NAMES_LEGACY] PRIMARY KEY CLUSTERED ([Old_Symbol_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_QUESTIONS]'
GO
CREATE TABLE [dbo].[COMPONENT_QUESTIONS]
(
[Question_Id] [int] NOT NULL,
[Component_Symbol_Id] [int] NOT NULL,
[Weight] [int] NOT NULL,
[Rank] [int] NOT NULL,
[Seq] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_QUESTIONS] on [dbo].[COMPONENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] ADD CONSTRAINT [PK_COMPONENT_QUESTIONS] PRIMARY KEY CLUSTERED ([Question_Id], [Component_Symbol_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NEW_QUESTION]'
GO
CREATE TABLE [dbo].[NEW_QUESTION]
(
[Question_Id] [int] NOT NULL IDENTITY(1, 1),
[Std_Ref] [nvarchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Std_Ref_Number] [int] NOT NULL,
[Simple_Question] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Universal_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_NEW_QUESTION_Universal_Sal_Level] DEFAULT ('none'),
[Weight] [int] NULL,
[Question_Group_Id] [int] NULL,
[Question_Group_Number] [int] NULL,
[Original_Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Hash] AS (CONVERT([varbinary](32),hashbytes('SHA1',left([Simple_Question],(8000))),(0))) PERSISTED,
[Ranking] [int] NULL,
[Heading_Pair_Id] [int] NOT NULL,
[Std_Ref_Id] AS (case  when [std_ref]=NULL then NULL else ([Std_Ref]+'.')+CONVERT([nvarchar](50),[Std_Ref_Number],(0)) end)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_All_Question_TEMP] on [dbo].[NEW_QUESTION]'
GO
ALTER TABLE [dbo].[NEW_QUESTION] ADD CONSTRAINT [PK_All_Question_TEMP] PRIMARY KEY CLUSTERED ([Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_NEW_QUESTION_1] on [dbo].[NEW_QUESTION]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NEW_QUESTION_1] ON [dbo].[NEW_QUESTION] ([Question_Hash])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_NEW_QUESTION] on [dbo].[NEW_QUESTION]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NEW_QUESTION] ON [dbo].[NEW_QUESTION] ([Std_Ref], [Std_Ref_Number])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_FAMILY]'
GO
CREATE TABLE [dbo].[COMPONENT_FAMILY]
(
[Component_Family_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ComponentFamily] on [dbo].[COMPONENT_FAMILY]'
GO
ALTER TABLE [dbo].[COMPONENT_FAMILY] ADD CONSTRAINT [PK_ComponentFamily] PRIMARY KEY CLUSTERED ([Component_Family_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_SYMBOLS_MAPPINGS]'
GO
CREATE TABLE [dbo].[COMPONENT_SYMBOLS_MAPPINGS]
(
[Component_Symbol_Id] [int] NOT NULL,
[Application] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Malcolm_Role] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mapping_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_SYMBOLS_MAPPINGS] on [dbo].[COMPONENT_SYMBOLS_MAPPINGS]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS_MAPPINGS] ADD CONSTRAINT [PK_COMPONENT_SYMBOLS_MAPPINGS] PRIMARY KEY CLUSTERED ([Mapping_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SYMBOL_GROUPS]'
GO
CREATE TABLE [dbo].[SYMBOL_GROUPS]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Symbol_Group_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Symbol_Group_Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SYMBOL_GROUPS] on [dbo].[SYMBOL_GROUPS]'
GO
ALTER TABLE [dbo].[SYMBOL_GROUPS] ADD CONSTRAINT [PK_SYMBOL_GROUPS] PRIMARY KEY CLUSTERED ([Id])
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
PRINT N'Creating [dbo].[CUSTOM_QUESTIONAIRES]'
GO
CREATE TABLE [dbo].[CUSTOM_QUESTIONAIRES]
(
[Custom_Questionaire_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CUSTOM_QUESTIONAIRES] on [dbo].[CUSTOM_QUESTIONAIRES]'
GO
ALTER TABLE [dbo].[CUSTOM_QUESTIONAIRES] ADD CONSTRAINT [PK_CUSTOM_QUESTIONAIRES] PRIMARY KEY CLUSTERED ([Custom_Questionaire_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CUSTOM_BASE_STANDARDS]'
GO
CREATE TABLE [dbo].[CUSTOM_BASE_STANDARDS]
(
[Custom_Questionaire_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Base_Standard] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CUSTOM_BASE_STANDARDS_1] on [dbo].[CUSTOM_BASE_STANDARDS]'
GO
ALTER TABLE [dbo].[CUSTOM_BASE_STANDARDS] ADD CONSTRAINT [PK_CUSTOM_BASE_STANDARDS_1] PRIMARY KEY CLUSTERED ([Custom_Questionaire_Name], [Base_Standard])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CUSTOM_STANDARD_BASE_STANDARD]'
GO
CREATE TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD]
(
[Custom_Questionaire_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Base_Standard] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Custom_Standard_Base_Standard_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CUSTOM_STANDARD_BASE_STANDARD] on [dbo].[CUSTOM_STANDARD_BASE_STANDARD]'
GO
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] ADD CONSTRAINT [PK_CUSTOM_STANDARD_BASE_STANDARD] PRIMARY KEY CLUSTERED ([Custom_Standard_Base_Standard_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS]'
GO
CREATE TABLE [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS]
(
[Custom_Questionaire_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CUSTOM_QUESTIONAIRE_QUESTIONS] on [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS]'
GO
ALTER TABLE [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS] ADD CONSTRAINT [PK_CUSTOM_QUESTIONAIRE_QUESTIONS] PRIMARY KEY CLUSTERED ([Custom_Questionaire_Name], [Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[SectorId] [int] NULL,
[IndustryId] [int] NULL,
[Size] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssetValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeedsPrivacy] [bit] NOT NULL CONSTRAINT [DF_DEMOGRAPHICS_NeedsPrivacy] DEFAULT ((0)),
[NeedsSupplyChain] [bit] NOT NULL CONSTRAINT [DF_DEMOGRAPHICS_NeedsSupplyChain] DEFAULT ((0)),
[NeedsICS] [bit] NOT NULL CONSTRAINT [DF_DEMOGRAPHICS_NeedsICS] DEFAULT ((0)),
[OrganizationName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agency] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrganizationType] [int] NULL,
[Facilitator] [int] NULL,
[PointOfContact] [int] NULL,
[IsScoped] [bit] NULL CONSTRAINT [DF_DEMOGRAPHICS_IsScoped] DEFAULT ((0)),
[CriticalService] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DEMOGRAPHICS] on [dbo].[DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [PK_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[APP_CODE]'
GO
CREATE TABLE [dbo].[APP_CODE]
(
[AppCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_APP_CODE] on [dbo].[APP_CODE]'
GO
ALTER TABLE [dbo].[APP_CODE] ADD CONSTRAINT [PK_APP_CODE] PRIMARY KEY CLUSTERED ([AppCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DEMOGRAPHICS_ASSET_VALUES]'
GO
CREATE TABLE [dbo].[DEMOGRAPHICS_ASSET_VALUES]
(
[DemographicsAssetId] [int] NOT NULL IDENTITY(1, 1),
[AssetValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValueOrder] [int] NULL,
[AppCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DEMOGRAPHICS_ASSET_VALUES_AppCode] DEFAULT ('CSET')
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DEMOGRAPHICS_ASSET_VALUES] on [dbo].[DEMOGRAPHICS_ASSET_VALUES]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS_ASSET_VALUES] ADD CONSTRAINT [PK_DEMOGRAPHICS_ASSET_VALUES] PRIMARY KEY CLUSTERED ([AssetValue])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DEMOGRAPHICS_ORGANIZATION_TYPE]'
GO
CREATE TABLE [dbo].[DEMOGRAPHICS_ORGANIZATION_TYPE]
(
[OrganizationTypeId] [int] NOT NULL,
[OrganizationType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DEMOGRAPHICS_ORGANIZATION_TYPE] on [dbo].[DEMOGRAPHICS_ORGANIZATION_TYPE]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS_ORGANIZATION_TYPE] ADD CONSTRAINT [PK_DEMOGRAPHICS_ORGANIZATION_TYPE] PRIMARY KEY CLUSTERED ([OrganizationTypeId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DEMOGRAPHICS_SIZE]'
GO
CREATE TABLE [dbo].[DEMOGRAPHICS_SIZE]
(
[DemographicId] [int] NOT NULL IDENTITY(1, 1),
[Size] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueOrder] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DemographicsSize] on [dbo].[DEMOGRAPHICS_SIZE]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS_SIZE] ADD CONSTRAINT [PK_DemographicsSize] PRIMARY KEY CLUSTERED ([Size])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SECTOR]'
GO
CREATE TABLE [dbo].[SECTOR]
(
[SectorId] [int] NOT NULL IDENTITY(1, 1),
[SectorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_NIPP] [bit] NOT NULL CONSTRAINT [DF__SECTOR__Is_NIPP__4C214075] DEFAULT ((0)),
[NIPP_sector] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SECTOR_1] on [dbo].[SECTOR]'
GO
ALTER TABLE [dbo].[SECTOR] ADD CONSTRAINT [PK_SECTOR_1] PRIMARY KEY CLUSTERED ([SectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_SECTOR] on [dbo].[SECTOR]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SECTOR] ON [dbo].[SECTOR] ([SectorName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SECTOR_INDUSTRY]'
GO
CREATE TABLE [dbo].[SECTOR_INDUSTRY]
(
[SectorId] [int] NOT NULL,
[IndustryId] [int] NOT NULL,
[IndustryName] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_NIPP] [bit] NOT NULL CONSTRAINT [DF__SECTOR_IN__Is_NI__4D1564AE] DEFAULT ((0)),
[Is_Other] [bit] NOT NULL CONSTRAINT [DF__SECTOR_IN__Is_Ot__4E0988E7] DEFAULT ((0)),
[NIPP_subsector] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SECTOR_INDUSTRY] on [dbo].[SECTOR_INDUSTRY]'
GO
ALTER TABLE [dbo].[SECTOR_INDUSTRY] ADD CONSTRAINT [PK_SECTOR_INDUSTRY] PRIMARY KEY CLUSTERED ([SectorId], [IndustryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_SECTOR_INDUSTRY] on [dbo].[SECTOR_INDUSTRY]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SECTOR_INDUSTRY] ON [dbo].[SECTOR_INDUSTRY] ([IndustryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DETAILS_DEMOGRAPHICS]'
GO
CREATE TABLE [dbo].[DETAILS_DEMOGRAPHICS]
(
[Assessment_Id] [int] NOT NULL,
[DataItemName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StringValue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntValue] [int] NULL,
[FloatValue] [float] NULL,
[BoolValue] [bit] NULL,
[DateTimeValue] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DETAILS_DEMOGRAPHICS] on [dbo].[DETAILS_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[DETAILS_DEMOGRAPHICS] ADD CONSTRAINT [PK_DETAILS_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id], [DataItemName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_CONTAINER_TYPES]'
GO
CREATE TABLE [dbo].[DIAGRAM_CONTAINER_TYPES]
(
[ContainerType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_CONTAINER_TYPES] on [dbo].[DIAGRAM_CONTAINER_TYPES]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER_TYPES] ADD CONSTRAINT [PK_DIAGRAM_CONTAINER_TYPES] PRIMARY KEY CLUSTERED ([ContainerType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_OBJECT_TYPES]'
GO
CREATE TABLE [dbo].[DIAGRAM_OBJECT_TYPES]
(
[Object_Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Object_Type_Order] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_OBJECT_TYPES] on [dbo].[DIAGRAM_OBJECT_TYPES]'
GO
ALTER TABLE [dbo].[DIAGRAM_OBJECT_TYPES] ADD CONSTRAINT [PK_DIAGRAM_OBJECT_TYPES] PRIMARY KEY CLUSTERED ([Object_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_TYPES]'
GO
CREATE TABLE [dbo].[DIAGRAM_TYPES]
(
[Specific_Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Diagram_Type_XML] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Object_Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_TYPES] on [dbo].[DIAGRAM_TYPES]'
GO
ALTER TABLE [dbo].[DIAGRAM_TYPES] ADD CONSTRAINT [PK_DIAGRAM_TYPES] PRIMARY KEY CLUSTERED ([Specific_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DOCUMENT_ANSWERS]'
GO
CREATE TABLE [dbo].[DOCUMENT_ANSWERS]
(
[Document_Id] [int] NOT NULL,
[Answer_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DOCUMENT_ANSWERS] on [dbo].[DOCUMENT_ANSWERS]'
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS] ADD CONSTRAINT [PK_DOCUMENT_ANSWERS] PRIMARY KEY CLUSTERED ([Document_Id], [Answer_Id])
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
[SubSectorId] [int] NULL,
[CyberRiskService] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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
PRINT N'Creating [dbo].[FINANCIAL_ASSESSMENT_VALUES]'
GO
CREATE TABLE [dbo].[FINANCIAL_ASSESSMENT_VALUES]
(
[Assessment_Id] [int] NOT NULL,
[AttributeName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AttributeValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_ASSESSMENT_VALUES] on [dbo].[FINANCIAL_ASSESSMENT_VALUES]'
GO
ALTER TABLE [dbo].[FINANCIAL_ASSESSMENT_VALUES] ADD CONSTRAINT [PK_FINANCIAL_ASSESSMENT_VALUES] PRIMARY KEY CLUSTERED ([Assessment_Id], [AttributeName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_ATTRIBUTES]'
GO
CREATE TABLE [dbo].[FINANCIAL_ATTRIBUTES]
(
[AttributeName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_ATTRIBUTES] on [dbo].[FINANCIAL_ATTRIBUTES]'
GO
ALTER TABLE [dbo].[FINANCIAL_ATTRIBUTES] ADD CONSTRAINT [PK_FINANCIAL_ATTRIBUTES] PRIMARY KEY CLUSTERED ([AttributeName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_GROUPS]'
GO
CREATE TABLE [dbo].[FINANCIAL_GROUPS]
(
[FinancialGroupId] [int] NOT NULL IDENTITY(1, 1),
[DomainId] [int] NOT NULL,
[AssessmentFactorId] [int] NOT NULL,
[FinComponentId] [int] NOT NULL,
[Financial_Level_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_GROUPS] on [dbo].[FINANCIAL_GROUPS]'
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [PK_FINANCIAL_GROUPS] PRIMARY KEY CLUSTERED ([FinancialGroupId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_GROUPS] on [dbo].[FINANCIAL_GROUPS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_GROUPS] ON [dbo].[FINANCIAL_GROUPS] ([DomainId], [AssessmentFactorId], [FinComponentId], [Financial_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_DETAILS]'
GO
CREATE TABLE [dbo].[FINANCIAL_DETAILS]
(
[Label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StmtNumber] [int] NOT NULL,
[FinancialGroupId] [int] NOT NULL,
[Binary Criteria ID] [float] NULL,
[Maturity Target] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSC Organizational (17-20)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSC Foundational  (7-16)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSC Basic (1-6)] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CSC Mapping] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCUA R&R 748 Mapping] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCUA R&R 749 Mapping] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FFIEC Booklets Mapping] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_TIERS] on [dbo].[FINANCIAL_DETAILS]'
GO
ALTER TABLE [dbo].[FINANCIAL_DETAILS] ADD CONSTRAINT [PK_FINANCIAL_TIERS] PRIMARY KEY CLUSTERED ([StmtNumber])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_DOMAIN_FILTERS]'
GO
CREATE TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS]
(
[Assessment_Id] [int] NOT NULL,
[DomainId] [int] NOT NULL,
[B] [bit] NOT NULL CONSTRAINT [DF_FINANCIAL_DOMAIN_FILTERS_B] DEFAULT ((0)),
[E] [bit] NOT NULL CONSTRAINT [DF_FINANCIAL_DOMAIN_FILTERS_E] DEFAULT ((0)),
[Int] [bit] NOT NULL CONSTRAINT [DF_FINANCIAL_DOMAIN_FILTERS_Int] DEFAULT ((0)),
[A] [bit] NOT NULL CONSTRAINT [DF_FINANCIAL_DOMAIN_FILTERS_A] DEFAULT ((0)),
[Inn] [bit] NOT NULL CONSTRAINT [DF_FINANCIAL_DOMAIN_FILTERS_Inn] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_DOMAIN_FILTERS] on [dbo].[FINANCIAL_DOMAIN_FILTERS]'
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS] ADD CONSTRAINT [PK_FINANCIAL_DOMAIN_FILTERS] PRIMARY KEY CLUSTERED ([Assessment_Id], [DomainId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_DOMAINS]'
GO
CREATE TABLE [dbo].[FINANCIAL_DOMAINS]
(
[Domain] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DomainId] [int] NOT NULL,
[Acronym] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_DOMAINS] on [dbo].[FINANCIAL_DOMAINS]'
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAINS] ADD CONSTRAINT [PK_FINANCIAL_DOMAINS] PRIMARY KEY CLUSTERED ([DomainId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_DOMAINS] on [dbo].[FINANCIAL_DOMAINS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_DOMAINS] ON [dbo].[FINANCIAL_DOMAINS] ([Domain])
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
PRINT N'Creating [dbo].[FINANCIAL_MATURITY]'
GO
CREATE TABLE [dbo].[FINANCIAL_MATURITY]
(
[Financial_Level_Id] [int] NOT NULL,
[MaturityLevel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Acronym] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_MATURITY] on [dbo].[FINANCIAL_MATURITY]'
GO
ALTER TABLE [dbo].[FINANCIAL_MATURITY] ADD CONSTRAINT [PK_FINANCIAL_MATURITY] PRIMARY KEY CLUSTERED ([Financial_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_MATURITY] on [dbo].[FINANCIAL_MATURITY]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_MATURITY] ON [dbo].[FINANCIAL_MATURITY] ([MaturityLevel])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_FFIEC_MAPPINGS]'
GO
CREATE TABLE [dbo].[FINANCIAL_FFIEC_MAPPINGS]
(
[StmtNumber] [int] NOT NULL,
[FFIECBookletsMapping] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_FFIEC_MAPPINGS_1] on [dbo].[FINANCIAL_FFIEC_MAPPINGS]'
GO
ALTER TABLE [dbo].[FINANCIAL_FFIEC_MAPPINGS] ADD CONSTRAINT [PK_FINANCIAL_FFIEC_MAPPINGS_1] PRIMARY KEY CLUSTERED ([StmtNumber], [FFIECBookletsMapping])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_ASSESSMENT_FACTORS]'
GO
CREATE TABLE [dbo].[FINANCIAL_ASSESSMENT_FACTORS]
(
[AssessmentFactorId] [int] NOT NULL,
[AssessmentFactor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssessmentFactorWeight] [int] NOT NULL,
[Acronym] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_ASSESSMENT_FACTORS] on [dbo].[FINANCIAL_ASSESSMENT_FACTORS]'
GO
ALTER TABLE [dbo].[FINANCIAL_ASSESSMENT_FACTORS] ADD CONSTRAINT [PK_FINANCIAL_ASSESSMENT_FACTORS] PRIMARY KEY CLUSTERED ([AssessmentFactorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_ASSESSMENT_FACTORS] on [dbo].[FINANCIAL_ASSESSMENT_FACTORS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_ASSESSMENT_FACTORS] ON [dbo].[FINANCIAL_ASSESSMENT_FACTORS] ([AssessmentFactor])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_COMPONENTS]'
GO
CREATE TABLE [dbo].[FINANCIAL_COMPONENTS]
(
[FinComponentId] [int] NOT NULL,
[FinComponent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Acronym] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_COMPONENTS] on [dbo].[FINANCIAL_COMPONENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_COMPONENTS] ADD CONSTRAINT [PK_FINANCIAL_COMPONENTS] PRIMARY KEY CLUSTERED ([FinComponentId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_FINANCIAL_COMPONENTS] on [dbo].[FINANCIAL_COMPONENTS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_FINANCIAL_COMPONENTS] ON [dbo].[FINANCIAL_COMPONENTS] ([FinComponent])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_HOURS]'
GO
CREATE TABLE [dbo].[FINANCIAL_HOURS]
(
[Assessment_Id] [int] NOT NULL,
[Component] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReviewType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Hours] [decimal] (9, 2) NOT NULL CONSTRAINT [DF_FINANCIAL_ASSESSMENT_HOURS_Hours] DEFAULT ((0)),
[OtherSpecifyValue] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_ASSESSMENT_HOURS] on [dbo].[FINANCIAL_HOURS]'
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS] ADD CONSTRAINT [PK_FINANCIAL_ASSESSMENT_HOURS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Component], [ReviewType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_HOURS_COMPONENT]'
GO
CREATE TABLE [dbo].[FINANCIAL_HOURS_COMPONENT]
(
[Component] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DomainId] [int] NULL,
[PresentationOrder] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_HOURS_COMPONENT] on [dbo].[FINANCIAL_HOURS_COMPONENT]'
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS_COMPONENT] ADD CONSTRAINT [PK_FINANCIAL_HOURS_COMPONENT] PRIMARY KEY CLUSTERED ([Component])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_REVIEWTYPE]'
GO
CREATE TABLE [dbo].[FINANCIAL_REVIEWTYPE]
(
[ReviewType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_REVIEWTYPE] on [dbo].[FINANCIAL_REVIEWTYPE]'
GO
ALTER TABLE [dbo].[FINANCIAL_REVIEWTYPE] ADD CONSTRAINT [PK_FINANCIAL_REVIEWTYPE] PRIMARY KEY CLUSTERED ([ReviewType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_QUESTIONS]'
GO
CREATE TABLE [dbo].[FINANCIAL_QUESTIONS]
(
[StmtNumber] [int] NOT NULL,
[Question_Id] [int] NOT NULL,
[Maturity_Question_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_QUESTIONS_1] on [dbo].[FINANCIAL_QUESTIONS]'
GO
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] ADD CONSTRAINT [PK_FINANCIAL_QUESTIONS_1] PRIMARY KEY CLUSTERED ([StmtNumber], [Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_REQUIREMENTS]'
GO
CREATE TABLE [dbo].[FINANCIAL_REQUIREMENTS]
(
[StmtNumber] [int] NOT NULL,
[Requirement_Id] [int] NOT NULL,
[maturity_question_id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_REQUIREMENTS] on [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] ADD CONSTRAINT [PK_FINANCIAL_REQUIREMENTS] PRIMARY KEY CLUSTERED ([StmtNumber], [Requirement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NEW_REQUIREMENT]'
GO
CREATE TABLE [dbo].[NEW_REQUIREMENT]
(
[Requirement_Id] [int] NOT NULL IDENTITY(1, 1),
[Requirement_Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requirement_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Supplemental_Info] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Standard_Sub_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weight] [int] NULL,
[Implementation_Recommendations] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Original_Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Text_Hash] AS (CONVERT([varbinary](20),hashbytes('SHA1',[Requirement_Text]),(0))) PERSISTED,
[NCSF_Cat_Id] [int] NULL,
[NCSF_Number] [int] NULL,
[Supp_Hash] AS (CONVERT([varbinary](32),hashbytes('SHA1',left([Supplemental_Info],(8000))),(0))) PERSISTED,
[Ranking] [int] NULL,
[Question_Group_Heading_Id] [int] NOT NULL,
[ExaminationApproach] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Old_Id_For_Copy] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NEW_REQUIREMENT] on [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [PK_NEW_REQUIREMENT] PRIMARY KEY CLUSTERED ([Requirement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINANCIAL_TIERS]'
GO
CREATE TABLE [dbo].[FINANCIAL_TIERS]
(
[StmtNumber] [int] NOT NULL,
[Label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINANCIAL_TIERS_1] on [dbo].[FINANCIAL_TIERS]'
GO
ALTER TABLE [dbo].[FINANCIAL_TIERS] ADD CONSTRAINT [PK_FINANCIAL_TIERS_1] PRIMARY KEY CLUSTERED ([StmtNumber], [Label])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINDING]'
GO
CREATE TABLE [dbo].[FINDING]
(
[Answer_Id] [int] NOT NULL,
[Finding_Id] [int] NOT NULL IDENTITY(1, 1),
[Summary] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Issue] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Impact] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recommendations] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vulnerabilities] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Resolution_Date] [datetime2] NULL,
[Importance_Id] [int] NULL,
[Title] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Auto_Generated] [int] NULL,
[Citations] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Risk_Area] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Risk] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionItems] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supp_Guidance] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINDING] on [dbo].[FINDING]'
GO
ALTER TABLE [dbo].[FINDING] ADD CONSTRAINT [PK_FINDING] PRIMARY KEY CLUSTERED ([Finding_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FINDING_CONTACT]'
GO
CREATE TABLE [dbo].[FINDING_CONTACT]
(
[Finding_Id] [int] NOT NULL,
[Assessment_Contact_Id] [int] NOT NULL,
[IgnoreThis] [int] NULL,
[Id] [uniqueidentifier] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FINDING_CONTACT_1] on [dbo].[FINDING_CONTACT]'
GO
ALTER TABLE [dbo].[FINDING_CONTACT] ADD CONSTRAINT [PK_FINDING_CONTACT_1] PRIMARY KEY CLUSTERED ([Finding_Id], [Assessment_Contact_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[IMPORTANCE]'
GO
CREATE TABLE [dbo].[IMPORTANCE]
(
[Importance_Id] [int] NOT NULL IDENTITY(1, 1),
[Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_IMPORTANCE_1] on [dbo].[IMPORTANCE]'
GO
ALTER TABLE [dbo].[IMPORTANCE] ADD CONSTRAINT [PK_IMPORTANCE_1] PRIMARY KEY CLUSTERED ([Importance_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FRAMEWORK_TIERS]'
GO
CREATE TABLE [dbo].[FRAMEWORK_TIERS]
(
[Tier] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FullName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TierOrder] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FRAMEWORK_TIERS] on [dbo].[FRAMEWORK_TIERS]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIERS] ADD CONSTRAINT [PK_FRAMEWORK_TIERS] PRIMARY KEY CLUSTERED ([Tier])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FRAMEWORK_TIER_DEFINITIONS]'
GO
CREATE TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS]
(
[Tier] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TierType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TierQuestion] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FRAMEWORK_TIER_DEFINITIONS] on [dbo].[FRAMEWORK_TIER_DEFINITIONS]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS] ADD CONSTRAINT [PK_FRAMEWORK_TIER_DEFINITIONS] PRIMARY KEY CLUSTERED ([Tier], [TierType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]'
GO
CREATE TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]
(
[Assessment_Id] [int] NOT NULL,
[TierType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tier] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FRAMEWORK_TIER_TYPE_ANSWER] on [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ADD CONSTRAINT [PK_FRAMEWORK_TIER_TYPE_ANSWER] PRIMARY KEY CLUSTERED ([Assessment_Id], [TierType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FRAMEWORK_TIER_TYPE]'
GO
CREATE TABLE [dbo].[FRAMEWORK_TIER_TYPE]
(
[TierType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FRAMEWORK_TIER_TYPE] on [dbo].[FRAMEWORK_TIER_TYPE]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE] ADD CONSTRAINT [PK_FRAMEWORK_TIER_TYPE] PRIMARY KEY CLUSTERED ([TierType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GALLERY_GROUP]'
GO
CREATE TABLE [dbo].[GALLERY_GROUP]
(
[Group_Id] [int] NOT NULL IDENTITY(1, 1),
[Group_Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GALLERY_GROUP_1] on [dbo].[GALLERY_GROUP]'
GO
ALTER TABLE [dbo].[GALLERY_GROUP] ADD CONSTRAINT [PK_GALLERY_GROUP_1] PRIMARY KEY CLUSTERED ([Group_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GALLERY_GROUP_DETAILS]'
GO
CREATE TABLE [dbo].[GALLERY_GROUP_DETAILS]
(
[Group_Id] [int] NOT NULL,
[Column_Index] [int] NOT NULL,
[Click_Count] [int] NOT NULL CONSTRAINT [DF_GALLERY_GROUP_DETAILS_Click_Count] DEFAULT ((0)),
[Group_Detail_Id] [int] NOT NULL IDENTITY(1, 1),
[Gallery_Item_Guid] [uniqueidentifier] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GALLERY_GROUP_DETAILS_1] on [dbo].[GALLERY_GROUP_DETAILS]'
GO
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] ADD CONSTRAINT [PK_GALLERY_GROUP_DETAILS_1] PRIMARY KEY CLUSTERED ([Group_Detail_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GALLERY_ROWS]'
GO
CREATE TABLE [dbo].[GALLERY_ROWS]
(
[Layout_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Row_Index] [int] NOT NULL,
[Group_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GALLERY_ROWS] on [dbo].[GALLERY_ROWS]'
GO
ALTER TABLE [dbo].[GALLERY_ROWS] ADD CONSTRAINT [PK_GALLERY_ROWS] PRIMARY KEY CLUSTERED ([Layout_Name], [Row_Index])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GALLERY_LAYOUT]'
GO
CREATE TABLE [dbo].[GALLERY_LAYOUT]
(
[Layout_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GALLERY_LAYOUT] on [dbo].[GALLERY_LAYOUT]'
GO
ALTER TABLE [dbo].[GALLERY_LAYOUT] ADD CONSTRAINT [PK_GALLERY_LAYOUT] PRIMARY KEY CLUSTERED ([Layout_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FILE_REF_KEYS]'
GO
CREATE TABLE [dbo].[FILE_REF_KEYS]
(
[Doc_Num] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FILE_REF_KEYS] on [dbo].[FILE_REF_KEYS]'
GO
ALTER TABLE [dbo].[FILE_REF_KEYS] ADD CONSTRAINT [PK_FILE_REF_KEYS] PRIMARY KEY CLUSTERED ([Doc_Num])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FILE_TYPE]'
GO
CREATE TABLE [dbo].[FILE_TYPE]
(
[File_Type_Id] [numeric] (38, 0) NOT NULL,
[File_Type] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mime_Type] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [SYS_C0014416] on [dbo].[FILE_TYPE]'
GO
ALTER TABLE [dbo].[FILE_TYPE] ADD CONSTRAINT [SYS_C0014416] PRIMARY KEY CLUSTERED ([File_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GEN_FILE_LIB_PATH_CORL]'
GO
CREATE TABLE [dbo].[GEN_FILE_LIB_PATH_CORL]
(
[Gen_File_Id] [int] NOT NULL,
[Lib_Path_Id] [numeric] (38, 0) NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [TABLE3_PK] on [dbo].[GEN_FILE_LIB_PATH_CORL]'
GO
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] ADD CONSTRAINT [TABLE3_PK] PRIMARY KEY CLUSTERED ([Gen_File_Id], [Lib_Path_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REF_LIBRARY_PATH]'
GO
CREATE TABLE [dbo].[REF_LIBRARY_PATH]
(
[Lib_Path_Id] [numeric] (38, 0) NOT NULL,
[Parent_Path_Id] [numeric] (38, 0) NULL,
[Path_Name] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [REF_LIBRARY_PATH_PK] on [dbo].[REF_LIBRARY_PATH]'
GO
ALTER TABLE [dbo].[REF_LIBRARY_PATH] ADD CONSTRAINT [REF_LIBRARY_PATH_PK] PRIMARY KEY CLUSTERED ([Lib_Path_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GEN_SAL_NAMES]'
GO
CREATE TABLE [dbo].[GEN_SAL_NAMES]
(
[Sal_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GEN_SAL_NAMES] on [dbo].[GEN_SAL_NAMES]'
GO
ALTER TABLE [dbo].[GEN_SAL_NAMES] ADD CONSTRAINT [PK_GEN_SAL_NAMES] PRIMARY KEY CLUSTERED ([Sal_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GEN_SAL_WEIGHTS]'
GO
CREATE TABLE [dbo].[GEN_SAL_WEIGHTS]
(
[Sal_Weight_Id] [int] NOT NULL,
[Sal_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Slider_Value] [int] NOT NULL,
[Weight] [decimal] (18, 0) NOT NULL,
[Display] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GEN_SAL_WEIGHTS] on [dbo].[GEN_SAL_WEIGHTS]'
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS] ADD CONSTRAINT [PK_GEN_SAL_WEIGHTS] PRIMARY KEY CLUSTERED ([Sal_Name], [Slider_Value])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_GEN_SAL_WEIGHTS] on [dbo].[GEN_SAL_WEIGHTS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_GEN_SAL_WEIGHTS] ON [dbo].[GEN_SAL_WEIGHTS] ([Sal_Name], [Slider_Value])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GENERAL_SAL_DESCRIPTIONS]'
GO
CREATE TABLE [dbo].[GENERAL_SAL_DESCRIPTIONS]
(
[Sal_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sal_Description] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sal_Order] [int] NOT NULL,
[min] [int] NULL,
[max] [int] NULL,
[step] [int] NULL,
[prefix] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postfix] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GENERAL_SAL_DESCRIPTIONS] on [dbo].[GENERAL_SAL_DESCRIPTIONS]'
GO
ALTER TABLE [dbo].[GENERAL_SAL_DESCRIPTIONS] ADD CONSTRAINT [PK_GENERAL_SAL_DESCRIPTIONS] PRIMARY KEY CLUSTERED ([Sal_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GENERAL_SAL]'
GO
CREATE TABLE [dbo].[GENERAL_SAL]
(
[Assessment_Id] [int] NOT NULL,
[Sal_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Slider_Value] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GENERAL_SAL_1] on [dbo].[GENERAL_SAL]'
GO
ALTER TABLE [dbo].[GENERAL_SAL] ADD CONSTRAINT [PK_GENERAL_SAL_1] PRIMARY KEY CLUSTERED ([Assessment_Id], [Sal_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[INFORMATION]'
GO
CREATE TABLE [dbo].[INFORMATION]
(
[Id] [int] NOT NULL,
[Assessment_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Facility_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City_Or_Site_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State_Province_Or_Region] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessor_Phone] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assessment_Description] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Notes_And_Comments] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Contacts] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enterprise_Evaluation_Summary] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Real_Property_Unique_Id] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eMass_Document_Id] [int] NULL,
[IsAcetOnly] [bit] NULL CONSTRAINT [DF_INFORMATION_IsAcetOnly] DEFAULT ((0)),
[Workflow] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Baseline_Assessment_Id] [int] NULL,
[Origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Postal_Code] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region_Code] [int] NULL,
[Ise_Submitted] [bit] NULL,
[Submitted_Date] [date] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__Information__000000000000023C] on [dbo].[INFORMATION]'
GO
ALTER TABLE [dbo].[INFORMATION] ADD CONSTRAINT [PK__Information__000000000000023C] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ISE_ACTIONS_FINDINGS]'
GO
CREATE TABLE [dbo].[ISE_ACTIONS_FINDINGS]
(
[Finding_Id] [int] NOT NULL,
[Mat_Question_Id] [int] NOT NULL,
[Action_Items_Override] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ISE_ACTIONS_FINDINGS] on [dbo].[ISE_ACTIONS_FINDINGS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] ADD CONSTRAINT [PK_ISE_ACTIONS_FINDINGS] PRIMARY KEY CLUSTERED ([Finding_Id], [Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MALCOLM_ANSWERS]'
GO
CREATE TABLE [dbo].[MALCOLM_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Question_Or_Requirement_Id] [int] NOT NULL,
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Malcolm_Id] [int] NOT NULL,
[Malcolm_Answer_Id] [int] NOT NULL IDENTITY(1, 1),
[Mat_Option_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MALCOLM_ANSWERS] on [dbo].[MALCOLM_ANSWERS]'
GO
ALTER TABLE [dbo].[MALCOLM_ANSWERS] ADD CONSTRAINT [PK_MALCOLM_ANSWERS] PRIMARY KEY CLUSTERED ([Malcolm_Answer_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_MALCOLM_ANSWERS] on [dbo].[MALCOLM_ANSWERS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MALCOLM_ANSWERS] ON [dbo].[MALCOLM_ANSWERS] ([Assessment_Id], [Question_Or_Requirement_Id], [Malcolm_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_EXTRA]'
GO
CREATE TABLE [dbo].[MATURITY_EXTRA]
(
[Maturity_Question_Id] [int] NOT NULL,
[NIST171_Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_text] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPRSValue] [int] NULL,
[Comment for Guidance Field] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMMC1_Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CMMC2_Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Answer_Options] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_EXTRA] on [dbo].[MATURITY_EXTRA]'
GO
ALTER TABLE [dbo].[MATURITY_EXTRA] ADD CONSTRAINT [PK_MATURITY_EXTRA] PRIMARY KEY CLUSTERED ([Maturity_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]'
GO
CREATE TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]
(
[Mat_Option_Id_1] [int] NOT NULL,
[Mat_Option_Id_2] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS] on [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]'
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] ADD CONSTRAINT [PK_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS] PRIMARY KEY CLUSTERED ([Mat_Option_Id_1], [Mat_Option_Id_2])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_DOMAIN_REMARKS]'
GO
CREATE TABLE [dbo].[MATURITY_DOMAIN_REMARKS]
(
[Grouping_ID] [int] NOT NULL,
[Assessment_Id] [int] NOT NULL,
[DomainRemarks] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_DOMAIN_REMARKS] on [dbo].[MATURITY_DOMAIN_REMARKS]'
GO
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] ADD CONSTRAINT [PK_MATURITY_DOMAIN_REMARKS] PRIMARY KEY CLUSTERED ([Grouping_ID], [Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_GROUPING_TYPES]'
GO
CREATE TABLE [dbo].[MATURITY_GROUPING_TYPES]
(
[Type_Id] [int] NOT NULL IDENTITY(1, 1),
[Grouping_Type_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_GROUPING_TYPES] on [dbo].[MATURITY_GROUPING_TYPES]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPING_TYPES] ADD CONSTRAINT [PK_MATURITY_GROUPING_TYPES] PRIMARY KEY CLUSTERED ([Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_LEVEL_USAGE_TYPES]'
GO
CREATE TABLE [dbo].[MATURITY_LEVEL_USAGE_TYPES]
(
[Maturity_Level_Usage_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_LEVEL_USAGE_TYPES] on [dbo].[MATURITY_LEVEL_USAGE_TYPES]'
GO
ALTER TABLE [dbo].[MATURITY_LEVEL_USAGE_TYPES] ADD CONSTRAINT [PK_MATURITY_LEVEL_USAGE_TYPES] PRIMARY KEY CLUSTERED ([Maturity_Level_Usage_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTION_PROPS]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTION_PROPS]
(
[Mat_Question_Id] [int] NOT NULL,
[PropertyName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PropertyValue] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_QUESTION_PROPS] on [dbo].[MATURITY_QUESTION_PROPS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] ADD CONSTRAINT [PK_MATURITY_QUESTION_PROPS] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [PropertyName])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ISE_ACTIONS]'
GO
CREATE TABLE [dbo].[ISE_ACTIONS]
(
[Mat_Question_Id] [int] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action_Items] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regulatory_Citation] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parent_Id] [int] NULL,
[Action_Item_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ISE_ACTIONS] on [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [PK_ISE_ACTIONS] PRIMARY KEY CLUSTERED ([Action_Item_Id], [Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTION_TYPES]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTION_TYPES]
(
[Mat_Question_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
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
PRINT N'Creating [dbo].[MATURITY_REFERENCE_TEXT]'
GO
CREATE TABLE [dbo].[MATURITY_REFERENCE_TEXT]
(
[Mat_Question_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Reference_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_REFERENCE_TEXT] on [dbo].[MATURITY_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] ADD CONSTRAINT [PK_MATURITY_REFERENCE_TEXT] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [Sequence])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_REFERENCES]'
GO
CREATE TABLE [dbo].[MATURITY_REFERENCES]
(
[Mat_Question_Id] [int] NOT NULL,
[Gen_File_Id] [int] NOT NULL,
[Section_Ref] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Page_Number] [int] NULL,
[Destination_String] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sequence] [int] NULL,
[Source] [bit] NOT NULL CONSTRAINT [DF__MATURITY___Sourc__25276EE5] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_REFERENCES] on [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD CONSTRAINT [PK_MATURITY_REFERENCES] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Source])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS]
(
[Mat_Question_Id] [int] NOT NULL,
[Sub_Model_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_SUB_MODEL_QUESTIONS] on [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [PK_MATURITY_SUB_MODEL_QUESTIONS] PRIMARY KEY CLUSTERED ([Mat_Question_Id], [Sub_Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_SUB_MODELS]'
GO
CREATE TABLE [dbo].[MATURITY_SUB_MODELS]
(
[Sub_Model_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_SUB_MODELS] on [dbo].[MATURITY_SUB_MODELS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODELS] ADD CONSTRAINT [PK_MATURITY_SUB_MODELS] PRIMARY KEY CLUSTERED ([Sub_Model_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MODES_SETS_MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[MODES_SETS_MATURITY_MODELS]
(
[App_Code_Id] [int] NOT NULL IDENTITY(1, 1),
[AppCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
PRINT N'Creating [dbo].[NCSF_FUNCTIONS]'
GO
CREATE TABLE [dbo].[NCSF_FUNCTIONS]
(
[NCSF_Function_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NCSF_Function_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NCSF_Function_Order] [int] NULL,
[NCSF_ID] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_FUNCTIONS] on [dbo].[NCSF_FUNCTIONS]'
GO
ALTER TABLE [dbo].[NCSF_FUNCTIONS] ADD CONSTRAINT [PK_NCSF_FUNCTIONS] PRIMARY KEY CLUSTERED ([NCSF_Function_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CATEGORY]'
GO
CREATE TABLE [dbo].[NCSF_CATEGORY]
(
[NCSF_Function_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NCSF_Category_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NCSF_Category_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NCSF_Category_Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NCSF_Cat_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Group_Heading_Id] [int] NOT NULL CONSTRAINT [DF_NCSF_CATEGORY_Question_Group_Heading_Id] DEFAULT ((50))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_Category] on [dbo].[NCSF_CATEGORY]'
GO
ALTER TABLE [dbo].[NCSF_CATEGORY] ADD CONSTRAINT [PK_NCSF_Category] PRIMARY KEY CLUSTERED ([NCSF_Cat_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_NCSF_Category] on [dbo].[NCSF_CATEGORY]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NCSF_Category] ON [dbo].[NCSF_CATEGORY] ([NCSF_Function_Id], [NCSF_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]
(
[Entry_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Requirement_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_ENTRY] on [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_ENTRY] PRIMARY KEY CLUSTERED ([Entry_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_ENTRY_TO_MID]'
GO
CREATE TABLE [dbo].[NCSF_ENTRY_TO_MID]
(
[Entry_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_ENTRY_TO_MID] on [dbo].[NCSF_ENTRY_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [PK_NCSF_ENTRY_TO_MID] PRIMARY KEY CLUSTERED ([Entry_Level_Titles], [Mid_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_MID]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_MID]
(
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mat_Question_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_MID] on [dbo].[NCSF_CONVERSION_MAPPINGS_MID]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_MID] PRIMARY KEY CLUSTERED ([Mid_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]
(
[Full_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Requirement_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_CONVERSION_MAPPINGS_FULL] on [dbo].[NCSF_CONVERSION_MAPPINGS_FULL]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS_FULL] ADD CONSTRAINT [PK_NCSF_CONVERSION_MAPPINGS_FULL] PRIMARY KEY CLUSTERED ([Full_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_FULL_TO_MID]'
GO
CREATE TABLE [dbo].[NCSF_FULL_TO_MID]
(
[Full_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_FULL_TO_MID] on [dbo].[NCSF_FULL_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [PK_NCSF_FULL_TO_MID] PRIMARY KEY CLUSTERED ([Full_Level_Titles], [Mid_Level_Titles])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NERC_RISK_RANKING]'
GO
CREATE TABLE [dbo].[NERC_RISK_RANKING]
(
[Question_id] [int] NULL,
[Requirement_Id] [int] NULL,
[Compliance_Risk_Rank] [int] NOT NULL,
[Violation_Risk_Factor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NERC_RISK_RANKING] on [dbo].[NERC_RISK_RANKING]'
GO
ALTER TABLE [dbo].[NERC_RISK_RANKING] ADD CONSTRAINT [PK_NERC_RISK_RANKING] PRIMARY KEY CLUSTERED ([Compliance_Risk_Rank])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NETWORK_WARNINGS]'
GO
CREATE TABLE [dbo].[NETWORK_WARNINGS]
(
[Assessment_Id] [int] NOT NULL,
[Id] [int] NOT NULL,
[WarningText] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rule_Violated] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__network_warnings_001] on [dbo].[NETWORK_WARNINGS]'
GO
ALTER TABLE [dbo].[NETWORK_WARNINGS] ADD CONSTRAINT [PK__network_warnings_001] PRIMARY KEY CLUSTERED ([Assessment_Id], [Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NEW_QUESTION_SETS]'
GO
CREATE TABLE [dbo].[NEW_QUESTION_SETS]
(
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Id] [int] NOT NULL,
[New_Question_Set_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NEW_QUESTION_SETS_1] on [dbo].[NEW_QUESTION_SETS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_SETS] ADD CONSTRAINT [PK_NEW_QUESTION_SETS_1] PRIMARY KEY CLUSTERED ([New_Question_Set_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_NEW_QUESTION_SETS] on [dbo].[NEW_QUESTION_SETS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NEW_QUESTION_SETS] ON [dbo].[NEW_QUESTION_SETS] ([Question_Id], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NEW_QUESTION_LEVELS]'
GO
CREATE TABLE [dbo].[NEW_QUESTION_LEVELS]
(
[New_Question_Set_Id] [int] NOT NULL,
[Universal_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IgnoreMe] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NEW_QUESTION_LEVELS_1] on [dbo].[NEW_QUESTION_LEVELS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] ADD CONSTRAINT [PK_NEW_QUESTION_LEVELS_1] PRIMARY KEY CLUSTERED ([Universal_Sal_Level], [New_Question_Set_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UNIVERSAL_SAL_LEVEL]'
GO
CREATE TABLE [dbo].[UNIVERSAL_SAL_LEVEL]
(
[Universal_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sal_Level_Order] [int] NOT NULL,
[Full_Name_Sal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UNIVERSAL_SAL_LEVEL] on [dbo].[UNIVERSAL_SAL_LEVEL]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SAL_LEVEL] ADD CONSTRAINT [PK_UNIVERSAL_SAL_LEVEL] PRIMARY KEY CLUSTERED ([Universal_Sal_Level])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_UNIVERSAL_SAL_LEVEL] on [dbo].[UNIVERSAL_SAL_LEVEL]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UNIVERSAL_SAL_LEVEL] ON [dbo].[UNIVERSAL_SAL_LEVEL] ([Full_Name_Sal])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]'
GO
CREATE TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]
(
[Sub_Heading_Question_Description] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Display_Radio_Buttons] AS (CONVERT([bit],case  when [sub_heading_question_description] IS NULL OR len(rtrim(ltrim([sub_heading_question_description])))=(0) OR charindex('?',[sub_heading_question_description])=(0) then (0) else (1) end,(0))),
[Question_Group_Heading_Id] [int] NOT NULL,
[Universal_Sub_Category_Id] [int] NOT NULL,
[Heading_Pair_Id] [int] NOT NULL IDENTITY(1, 1),
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_UNIVERSAL_SUB_CATEGORY_HEADINGS_Set_Name] DEFAULT ('Standards')
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UNIVERSAL_SUB_CATEGORY_HEADINGS_1] on [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ADD CONSTRAINT [PK_UNIVERSAL_SUB_CATEGORY_HEADINGS_1] PRIMARY KEY CLUSTERED ([Question_Group_Heading_Id], [Universal_Sub_Category_Id], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ADD CONSTRAINT [IX_UNIVERSAL_SUB_CATEGORY_HEADINGS] UNIQUE NONCLUSTERED ([Heading_Pair_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[QUESTION_GROUP_HEADING]'
GO
CREATE TABLE [dbo].[QUESTION_GROUP_HEADING]
(
[Question_Group_Heading] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Std_Ref] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Universal_Weight] [int] NOT NULL,
[Question_Group_Heading_Id] [int] NOT NULL IDENTITY(1, 1),
[Is_Custom] [bit] NOT NULL CONSTRAINT [DF_QUESTION_GROUP_HEADING_Is_Custom] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_QUESTION_GROUP_HEADING] on [dbo].[QUESTION_GROUP_HEADING]'
GO
ALTER TABLE [dbo].[QUESTION_GROUP_HEADING] ADD CONSTRAINT [PK_QUESTION_GROUP_HEADING] PRIMARY KEY CLUSTERED ([Question_Group_Heading])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_Question_Group_Heading] on [dbo].[QUESTION_GROUP_HEADING]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Question_Group_Heading] ON [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[QUESTION_GROUP_HEADING]'
GO
ALTER TABLE [dbo].[QUESTION_GROUP_HEADING] ADD CONSTRAINT [IX_QUESTION_GROUP_HEADING_1] UNIQUE NONCLUSTERED ([Question_Group_Heading_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_CATEGORY]'
GO
CREATE TABLE [dbo].[STANDARD_CATEGORY]
(
[Standard_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STANDARD_CATEGORY] on [dbo].[STANDARD_CATEGORY]'
GO
ALTER TABLE [dbo].[STANDARD_CATEGORY] ADD CONSTRAINT [PK_STANDARD_CATEGORY] PRIMARY KEY CLUSTERED ([Standard_Category])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NIST_SAL_QUESTIONS]'
GO
CREATE TABLE [dbo].[NIST_SAL_QUESTIONS]
(
[Question_Id] [int] NOT NULL,
[Question_Number] [int] NOT NULL,
[Question_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NIST_SAL_QUESTIONS_1] on [dbo].[NIST_SAL_QUESTIONS]'
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTIONS] ADD CONSTRAINT [PK_NIST_SAL_QUESTIONS_1] PRIMARY KEY CLUSTERED ([Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NIST_SAL_QUESTION_ANSWERS]'
GO
CREATE TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Question_Id] [int] NOT NULL,
[Question_Answer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_NIST_SAL_QUESTION_ANSWERS_Question_Answer] DEFAULT ('No')
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NIST_SAL_QUESTION_ANSWERS] on [dbo].[NIST_SAL_QUESTION_ANSWERS]'
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] ADD CONSTRAINT [PK_NIST_SAL_QUESTION_ANSWERS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NIST_SAL_INFO_TYPES]'
GO
CREATE TABLE [dbo].[NIST_SAL_INFO_TYPES]
(
[Assessment_Id] [int] NOT NULL,
[Type_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Selected] [bit] NOT NULL CONSTRAINT [DF_NIST_SAL_INFO_TYPES_Selected] DEFAULT ((0)),
[Confidentiality_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Confidentiality_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Integrity_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Integrity_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Availability_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Availability_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Area] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NIST_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NIST_SAL] on [dbo].[NIST_SAL_INFO_TYPES]'
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES] ADD CONSTRAINT [PK_NIST_SAL] PRIMARY KEY CLUSTERED ([Assessment_Id], [Type_Value])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PARAMETER_REQUIREMENTS]'
GO
CREATE TABLE [dbo].[PARAMETER_REQUIREMENTS]
(
[Requirement_Id] [int] NOT NULL,
[Parameter_Id] [int] NOT NULL,
[ID] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Parameter_Requirements] on [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] ADD CONSTRAINT [PK_Parameter_Requirements] PRIMARY KEY CLUSTERED ([Requirement_Id], [Parameter_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PARAMETER_VALUES]'
GO
CREATE TABLE [dbo].[PARAMETER_VALUES]
(
[Answer_Id] [int] NOT NULL,
[Parameter_Id] [int] NOT NULL,
[Parameter_Value] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameter_Is_Default] [bit] NOT NULL CONSTRAINT [DF_PARAMETER_VALUES_Parameter_Is_Default_1] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_PARAMETER_VALUES] on [dbo].[PARAMETER_VALUES]'
GO
ALTER TABLE [dbo].[PARAMETER_VALUES] ADD CONSTRAINT [PK_PARAMETER_VALUES] PRIMARY KEY CLUSTERED ([Answer_Id], [Parameter_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PASSWORD_HISTORY]'
GO
CREATE TABLE [dbo].[PASSWORD_HISTORY]
(
[UserId] [int] NOT NULL,
[Created] [datetime] NOT NULL,
[Password] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Salt] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Is_Temp] [bit] NOT NULL CONSTRAINT [DF_PASSWORD_HISTORY_Is_Temp] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_PASSWORD_HISTORY] on [dbo].[PASSWORD_HISTORY]'
GO
ALTER TABLE [dbo].[PASSWORD_HISTORY] ADD CONSTRAINT [PK_PASSWORD_HISTORY] PRIMARY KEY CLUSTERED ([UserId], [Created])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PROCUREMENT_LANGUAGE_DATA]'
GO
CREATE TABLE [dbo].[PROCUREMENT_LANGUAGE_DATA]
(
[Procurement_Id] [int] NOT NULL IDENTITY(1, 1),
[Parent_Heading_Id] [int] NULL,
[Section_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Topic_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Heading] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Basis] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_Guidance] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Procurement_Language] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fatmeasures] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Satmeasures] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maintenance_Guidance] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[References_Doc] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Flow_Document] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Procurement_Language_Data] on [dbo].[PROCUREMENT_LANGUAGE_DATA]'
GO
ALTER TABLE [dbo].[PROCUREMENT_LANGUAGE_DATA] ADD CONSTRAINT [PK_Procurement_Language_Data] PRIMARY KEY CLUSTERED ([Procurement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PROCUREMENT_DEPENDENCY]'
GO
CREATE TABLE [dbo].[PROCUREMENT_DEPENDENCY]
(
[Procurement_Id] [int] NOT NULL,
[Dependencies_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_PROCUREMENT_DEPENDENCY] on [dbo].[PROCUREMENT_DEPENDENCY]'
GO
ALTER TABLE [dbo].[PROCUREMENT_DEPENDENCY] ADD CONSTRAINT [PK_PROCUREMENT_DEPENDENCY] PRIMARY KEY CLUSTERED ([Procurement_Id], [Dependencies_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PROCUREMENT_LANGUAGE_HEADINGS]'
GO
CREATE TABLE [dbo].[PROCUREMENT_LANGUAGE_HEADINGS]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Heading_Num] [int] NULL,
[Heading_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_PROCUREMENT_LANGUAGE_HEADINGS] on [dbo].[PROCUREMENT_LANGUAGE_HEADINGS]'
GO
ALTER TABLE [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ADD CONSTRAINT [PK_PROCUREMENT_LANGUAGE_HEADINGS] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[PROCUREMENT_REFERENCES]'
GO
CREATE TABLE [dbo].[PROCUREMENT_REFERENCES]
(
[Procurement_Id] [int] NOT NULL,
[Reference_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Procurement_References] on [dbo].[PROCUREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[PROCUREMENT_REFERENCES] ADD CONSTRAINT [PK_Procurement_References] PRIMARY KEY CLUSTERED ([Procurement_Id], [Reference_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REFERENCES_DATA]'
GO
CREATE TABLE [dbo].[REFERENCES_DATA]
(
[Reference_Id] [int] NOT NULL IDENTITY(1, 1),
[Reference_Doc_Id] [int] NULL,
[Reference_Sections] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_References_Data] on [dbo].[REFERENCES_DATA]'
GO
ALTER TABLE [dbo].[REFERENCES_DATA] ADD CONSTRAINT [PK_References_Data] PRIMARY KEY CLUSTERED ([Reference_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_SETS]'
GO
CREATE TABLE [dbo].[REQUIREMENT_SETS]
(
[Requirement_Id] [int] NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Requirement_Sequence] [int] NOT NULL CONSTRAINT [DF_REQUIREMENT_SETS_Requirement_Sequence] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_QUESTION_SETS] on [dbo].[REQUIREMENT_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SETS] ADD CONSTRAINT [PK_QUESTION_SETS] PRIMARY KEY CLUSTERED ([Requirement_Id], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RECOMMENDATIONS_REFERENCES]'
GO
CREATE TABLE [dbo].[RECOMMENDATIONS_REFERENCES]
(
[Data_Id] [int] NOT NULL,
[Reference_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Recommendations_References] on [dbo].[RECOMMENDATIONS_REFERENCES]'
GO
ALTER TABLE [dbo].[RECOMMENDATIONS_REFERENCES] ADD CONSTRAINT [PK_Recommendations_References] PRIMARY KEY CLUSTERED ([Data_Id], [Reference_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REFERENCE_DOCS]'
GO
CREATE TABLE [dbo].[REFERENCE_DOCS]
(
[Reference_Doc_Id] [int] NOT NULL IDENTITY(1, 1),
[Doc_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc_Link] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc_Short] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date_Updated] [datetime] NULL,
[Date_Last_Checked] [datetime] NULL,
[Doc_Url] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Doc_Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Reference_Docs] on [dbo].[REFERENCE_DOCS]'
GO
ALTER TABLE [dbo].[REFERENCE_DOCS] ADD CONSTRAINT [PK_Reference_Docs] PRIMARY KEY CLUSTERED ([Reference_Doc_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REPORT_DETAIL_SECTION_SELECTION]'
GO
CREATE TABLE [dbo].[REPORT_DETAIL_SECTION_SELECTION]
(
[Assessment_Id] [int] NOT NULL,
[Report_Section_Id] [int] NOT NULL,
[Report_Section_Order] [int] NOT NULL,
[Is_Selected] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REPORT_DETAIL_SECTION_SELECTION] on [dbo].[REPORT_DETAIL_SECTION_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_DETAIL_SECTION_SELECTION] ADD CONSTRAINT [PK_REPORT_DETAIL_SECTION_SELECTION] PRIMARY KEY CLUSTERED ([Assessment_Id], [Report_Section_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REPORT_DETAIL_SECTIONS]'
GO
CREATE TABLE [dbo].[REPORT_DETAIL_SECTIONS]
(
[Report_Section_Id] [int] NOT NULL,
[Display_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Display_Order] [int] NOT NULL,
[Report_Order] [int] NOT NULL,
[Tool_Tip] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REPORT_DETAIL_SECTIONS] on [dbo].[REPORT_DETAIL_SECTIONS]'
GO
ALTER TABLE [dbo].[REPORT_DETAIL_SECTIONS] ADD CONSTRAINT [PK_REPORT_DETAIL_SECTIONS] PRIMARY KEY CLUSTERED ([Report_Section_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REPORT_OPTIONS_SELECTION]'
GO
CREATE TABLE [dbo].[REPORT_OPTIONS_SELECTION]
(
[Assessment_Id] [int] NOT NULL,
[Report_Option_Id] [int] NOT NULL,
[Is_Selected] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REPORT_OPTIONS_SELECTION] on [dbo].[REPORT_OPTIONS_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_OPTIONS_SELECTION] ADD CONSTRAINT [PK_REPORT_OPTIONS_SELECTION] PRIMARY KEY CLUSTERED ([Assessment_Id], [Report_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REPORT_OPTIONS]'
GO
CREATE TABLE [dbo].[REPORT_OPTIONS]
(
[Report_Option_Id] [int] NOT NULL,
[Display_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REPORT_OPTIONS] on [dbo].[REPORT_OPTIONS]'
GO
ALTER TABLE [dbo].[REPORT_OPTIONS] ADD CONSTRAINT [PK_REPORT_OPTIONS] PRIMARY KEY CLUSTERED ([Report_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REPORT_STANDARDS_SELECTION]'
GO
CREATE TABLE [dbo].[REPORT_STANDARDS_SELECTION]
(
[Assesment_Id] [int] NOT NULL,
[Report_Set_Entity_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Report_Section_Order] [int] NOT NULL,
[Is_Selected] [bit] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REPORT_STANDARDS_SELECTION] on [dbo].[REPORT_STANDARDS_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] ADD CONSTRAINT [PK_REPORT_STANDARDS_SELECTION] PRIMARY KEY CLUSTERED ([Assesment_Id], [Report_Set_Entity_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIRED_DOCUMENTATION_HEADERS]'
GO
CREATE TABLE [dbo].[REQUIRED_DOCUMENTATION_HEADERS]
(
[RDH_Id] [int] NOT NULL IDENTITY(1, 1),
[Requirement_Documentation_Header] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Header_Order] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIRED_DOCUMENTATION_HEADERS] on [dbo].[REQUIRED_DOCUMENTATION_HEADERS]'
GO
ALTER TABLE [dbo].[REQUIRED_DOCUMENTATION_HEADERS] ADD CONSTRAINT [PK_REQUIRED_DOCUMENTATION_HEADERS] PRIMARY KEY CLUSTERED ([RDH_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_REQUIRED_DOCUMENTATION_HEADERS] on [dbo].[REQUIRED_DOCUMENTATION_HEADERS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_REQUIRED_DOCUMENTATION_HEADERS] ON [dbo].[REQUIRED_DOCUMENTATION_HEADERS] ([Requirement_Documentation_Header])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_LEVELS]'
GO
CREATE TABLE [dbo].[REQUIREMENT_LEVELS]
(
[Requirement_Id] [int] NOT NULL,
[Standard_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_LEVELS] on [dbo].[REQUIREMENT_LEVELS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] ADD CONSTRAINT [PK_REQUIREMENT_LEVELS] PRIMARY KEY CLUSTERED ([Requirement_Id], [Standard_Level], [Level_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_LEVEL_TYPE]'
GO
CREATE TABLE [dbo].[REQUIREMENT_LEVEL_TYPE]
(
[Level_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level_Type_Full_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_LEVEL_TYPE] on [dbo].[REQUIREMENT_LEVEL_TYPE]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVEL_TYPE] ADD CONSTRAINT [PK_REQUIREMENT_LEVEL_TYPE] PRIMARY KEY CLUSTERED ([Level_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_SPECIFIC_LEVEL]'
GO
CREATE TABLE [dbo].[STANDARD_SPECIFIC_LEVEL]
(
[Standard_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level_Order] [int] NOT NULL CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Level_Order] DEFAULT ((0)),
[Full_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Standard] DEFAULT ('No Standard'),
[Display_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Display_Name] DEFAULT ('No Display Name'),
[Display_Order] [int] NULL,
[Is_Default_Value] [bit] NOT NULL CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Is_Default_Value] DEFAULT ((0)),
[Is_Mapping_Link] [bit] NOT NULL CONSTRAINT [DF_STANDARD_SPECIFIC_LEVEL_Is_Mapping_Link] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STANDARD_SPECIFIC_LEVEL] on [dbo].[STANDARD_SPECIFIC_LEVEL]'
GO
ALTER TABLE [dbo].[STANDARD_SPECIFIC_LEVEL] ADD CONSTRAINT [PK_STANDARD_SPECIFIC_LEVEL] PRIMARY KEY CLUSTERED ([Standard_Level])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
CREATE TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS]
(
[Question_Id] [int] NOT NULL,
[Requirement_Id] [int] NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_QUESTIONS_SETS_1] on [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [PK_REQUIREMENT_QUESTIONS_SETS_1] PRIMARY KEY CLUSTERED ([Question_Id], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
CREATE TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT]
(
[Requirement_Id] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Reference_Text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_REFERENCE_TEXT] on [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] ADD CONSTRAINT [PK_REQUIREMENT_REFERENCE_TEXT] PRIMARY KEY CLUSTERED ([Requirement_Id], [Sequence])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[REQUIREMENT_REFERENCES]'
GO
CREATE TABLE [dbo].[REQUIREMENT_REFERENCES]
(
[Requirement_Id] [int] NOT NULL,
[Gen_File_Id] [int] NOT NULL,
[Section_Ref] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Page_Number] [int] NULL,
[Destination_String] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sequence] [int] NULL,
[Source] [bit] NOT NULL CONSTRAINT [DF__REQUIREME__Sourc__7F01C5FD] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_REQUIREMENT_REFERENCES] on [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] ADD CONSTRAINT [PK_REQUIREMENT_REFERENCES] PRIMARY KEY CLUSTERED ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]'
GO
CREATE TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]
(
[Sector_Id] [int] NOT NULL,
[Industry_Id] [int] NOT NULL,
[Organization_Size] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Asset_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SECTOR_STANDARD_RECOMMENDATIONS] on [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]'
GO
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] ADD CONSTRAINT [PK_SECTOR_STANDARD_RECOMMENDATIONS] PRIMARY KEY CLUSTERED ([Sector_Id], [Industry_Id], [Organization_Size], [Asset_Value], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SET_FILES]'
GO
CREATE TABLE [dbo].[SET_FILES]
(
[SetName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Gen_File_Id] [int] NOT NULL,
[Comment] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SET_FILES] on [dbo].[SET_FILES]'
GO
ALTER TABLE [dbo].[SET_FILES] ADD CONSTRAINT [PK_SET_FILES] PRIMARY KEY CLUSTERED ([SetName], [Gen_File_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SETS_CATEGORY]'
GO
CREATE TABLE [dbo].[SETS_CATEGORY]
(
[Set_Category_Id] [int] NOT NULL,
[Set_Category_Name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Sets_Category] on [dbo].[SETS_CATEGORY]'
GO
ALTER TABLE [dbo].[SETS_CATEGORY] ADD CONSTRAINT [PK_Sets_Category] PRIMARY KEY CLUSTERED ([Set_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_CATEGORY_SEQUENCE]'
GO
CREATE TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE]
(
[Standard_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard_Category_Sequence] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STANDARD_CATEGORY_SEQUENCE] on [dbo].[STANDARD_CATEGORY_SEQUENCE]'
GO
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] ADD CONSTRAINT [PK_STANDARD_CATEGORY_SEQUENCE] PRIMARY KEY CLUSTERED ([Standard_Category], [Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SAL_DETERMINATION_TYPES]'
GO
CREATE TABLE [dbo].[SAL_DETERMINATION_TYPES]
(
[Sal_Determination_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SAL_DETERMINATION_TYPES_1] on [dbo].[SAL_DETERMINATION_TYPES]'
GO
ALTER TABLE [dbo].[SAL_DETERMINATION_TYPES] ADD CONSTRAINT [PK_SAL_DETERMINATION_TYPES_1] PRIMARY KEY CLUSTERED ([Sal_Determination_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_SOURCE_FILE]'
GO
CREATE TABLE [dbo].[STANDARD_SOURCE_FILE]
(
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Doc_Num] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Standard_Source_File] on [dbo].[STANDARD_SOURCE_FILE]'
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] ADD CONSTRAINT [PK_Standard_Source_File] PRIMARY KEY CLUSTERED ([Set_Name], [Doc_Num])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STANDARD_TO_UNIVERSAL_MAP]'
GO
CREATE TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP]
(
[Universal_Sal_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STANDARD_TO_UNIVERSAL_MAP] on [dbo].[STANDARD_TO_UNIVERSAL_MAP]'
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP] ADD CONSTRAINT [PK_STANDARD_TO_UNIVERSAL_MAP] PRIMARY KEY CLUSTERED ([Universal_Sal_Level], [Standard_Level])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COUNTRIES]'
GO
CREATE TABLE [dbo].[COUNTRIES]
(
[ISO_code] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Name] [nvarchar] (58) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[COUNTRIES_ID] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COUNTRIES] on [dbo].[COUNTRIES]'
GO
ALTER TABLE [dbo].[COUNTRIES] ADD CONSTRAINT [PK_COUNTRIES] PRIMARY KEY CLUSTERED ([COUNTRIES_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_COUNTRIES] on [dbo].[COUNTRIES]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_COUNTRIES] ON [dbo].[COUNTRIES] ([ISO_code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[STATES_AND_PROVINCES]'
GO
CREATE TABLE [dbo].[STATES_AND_PROVINCES]
(
[ISO_code] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[STATES_AND_PROVINCES_ID] [int] NOT NULL IDENTITY(1, 1),
[Country_Code] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_STATES_AND_PROVINCES] on [dbo].[STATES_AND_PROVINCES]'
GO
ALTER TABLE [dbo].[STATES_AND_PROVINCES] ADD CONSTRAINT [PK_STATES_AND_PROVINCES] PRIMARY KEY CLUSTERED ([STATES_AND_PROVINCES_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SUB_CATEGORY_ANSWERS]'
GO
CREATE TABLE [dbo].[SUB_CATEGORY_ANSWERS]
(
[Assessment_Id] [int] NOT NULL,
[Heading_Pair_Id] [int] NOT NULL,
[Is_Component] [bit] NOT NULL CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Is_Component] DEFAULT ((0)),
[Is_Override] [bit] NOT NULL CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Is_Override] DEFAULT ((0)),
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Component_Guid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_SUB_CATEGORY_ANSWERS_Component_Id] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SUB_CATEGORY_ANSWERS] on [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] ADD CONSTRAINT [PK_SUB_CATEGORY_ANSWERS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Heading_Pair_Id], [Component_Guid], [Is_Component])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[TTP_MAT_QUESTION]'
GO
CREATE TABLE [dbo].[TTP_MAT_QUESTION]
(
[TTP_Code] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mat_Question_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_TTP_MAT_QUESTION] on [dbo].[TTP_MAT_QUESTION]'
GO
ALTER TABLE [dbo].[TTP_MAT_QUESTION] ADD CONSTRAINT [PK_TTP_MAT_QUESTION] PRIMARY KEY CLUSTERED ([TTP_Code], [Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_TTP_MAT_QUESTION] on [dbo].[TTP_MAT_QUESTION]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TTP_MAT_QUESTION] ON [dbo].[TTP_MAT_QUESTION] ([TTP_Code], [Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[TTP]'
GO
CREATE TABLE [dbo].[TTP]
(
[TTP_Code] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[URL] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_TTP] on [dbo].[TTP]'
GO
ALTER TABLE [dbo].[TTP] ADD CONSTRAINT [PK_TTP] PRIMARY KEY CLUSTERED ([TTP_Code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
CREATE TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES]
(
[Universal_Sub_Category] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Universal_Sub_Category_Id] [int] NOT NULL IDENTITY(1, 1),
[Is_Custom] [bit] NOT NULL CONSTRAINT [DF_UNIVERSAL_SUB_CATEGORIES_Is_Custom] DEFAULT ((0))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UNIVERSAL_SUB_CATEGORIES] on [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES] ADD CONSTRAINT [PK_UNIVERSAL_SUB_CATEGORIES] PRIMARY KEY CLUSTERED ([Universal_Sub_Category])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES] ADD CONSTRAINT [IX_UNIVERSAL_SUB_CATEGORIES] UNIQUE NONCLUSTERED ([Universal_Sub_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USER_EMAIL_HISTORY]'
GO
CREATE TABLE [dbo].[USER_EMAIL_HISTORY]
(
[UserId] [int] NOT NULL,
[EmailSentDate] [datetime2] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USER_EMAIL_HISTORY] on [dbo].[USER_EMAIL_HISTORY]'
GO
ALTER TABLE [dbo].[USER_EMAIL_HISTORY] ADD CONSTRAINT [PK_USER_EMAIL_HISTORY] PRIMARY KEY CLUSTERED ([UserId], [EmailSentDate])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USER_SECURITY_QUESTIONS]'
GO
CREATE TABLE [dbo].[USER_SECURITY_QUESTIONS]
(
[UserId] [int] NOT NULL,
[SecurityQuestion1] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityAnswer1] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityQuestion2] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityAnswer2] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USER_SECURITY_QUESTIONS_1] on [dbo].[USER_SECURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[USER_SECURITY_QUESTIONS] ADD CONSTRAINT [PK_USER_SECURITY_QUESTIONS_1] PRIMARY KEY CLUSTERED ([UserId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[VISIO_MAPPING]'
GO
CREATE TABLE [dbo].[VISIO_MAPPING]
(
[Specific_Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Stencil_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_VISIO_MAPPING] on [dbo].[VISIO_MAPPING]'
GO
ALTER TABLE [dbo].[VISIO_MAPPING] ADD CONSTRAINT [PK_VISIO_MAPPING] PRIMARY KEY CLUSTERED ([Specific_Type], [Stencil_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vQUESTION_HEADINGS]'
GO

CREATE VIEW [dbo].[vQUESTION_HEADINGS]
AS
SELECT dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Heading_Pair_Id, dbo.QUESTION_GROUP_HEADING.Question_Group_Heading, dbo.QUESTION_GROUP_HEADING.Question_Group_Heading_Id, 
                  dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category, dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Sub_Heading_Question_Description, dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id
FROM     dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS INNER JOIN
                  dbo.UNIVERSAL_SUB_CATEGORIES ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Universal_Sub_Category_Id = dbo.UNIVERSAL_SUB_CATEGORIES.Universal_Sub_Category_Id INNER JOIN
                  dbo.QUESTION_GROUP_HEADING ON dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS.Question_Group_Heading_Id = dbo.QUESTION_GROUP_HEADING.Question_Group_Heading_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetApplicationModeDefault]'
GO
CREATE PROCEDURE [dbo].[GetApplicationModeDefault]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int,
	@Application_Mode nvarchar(100) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

	SELECT @Application_Mode = Application_Mode
	  FROM STANDARD_SELECTION where Assessment_Id = @Assessment_Id

	  if @Application_Mode is null
		Set @Application_Mode = 'Questions Based'

	

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[convert_sal]'
GO
-- =============================================
-- Author:		WOODRK
-- Create date: 9/12/2019
-- Description:	function to convert the SAL from 
-- word to letter or vice versa
-- =============================================
CREATE FUNCTION [dbo].[convert_sal]
(
	@SAL nvarchar(10)
)
RETURNS nvarchar(10)
AS
BEGIN
	declare @rval nvarchar(10)
	
	select @rval = UNIVERSAL_SAL_LEVEL from UNIVERSAL_SAL_LEVEL where Full_Name_Sal = @SAL;	
	if (@rval is null)
		select @rval = Full_Name_Sal from UNIVERSAL_SAL_LEVEL where Universal_Sal_Level = @SAL;	

	RETURN @rval;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Requirements]'
GO

CREATE VIEW [dbo].[Answer_Requirements]
AS
SELECT        Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, Is_Framework, 
                         Custom_Question_Guid, Old_Answer_Id, Reviewed, FeedBack
FROM            dbo.ANSWER
WHERE        (Is_Requirement = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Questions_No_Components]'
GO


CREATE VIEW [dbo].[Answer_Questions_No_Components]
AS
SELECT       Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
			 Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, Is_Framework, Reviewed, 
                   FeedBack, Custom_Question_Guid, Old_Answer_Id
FROM         dbo.ANSWER
WHERE        (Is_Requirement = 0) AND (Is_Component = 0)

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Standards_InScope]'
GO



CREATE VIEW [dbo].[Answer_Standards_InScope]
AS
		select distinct mode=N'Q', a.assessment_id, a.answer_id, is_requirement=0, a.question_or_requirement_id, a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid,a.is_framework,a.old_answer_id, a.reviewed, a.FeedBack
			,c.Simple_Question as Question_Text
			FROM Answer_Questions_No_Components a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id			
			join (
				select distinct s.Question_Id, v.Assessment_Id as std_assessment_id
					from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
					where v.Selected = 1 
					and l.Universal_Sal_Level = (
						select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
						where Assessment_Id = v.Assessment_Id
					)
			)	s on c.Question_Id = s.Question_Id and s.std_assessment_id = a.Assessment_Id			
		union	
		select distinct mode=N'R', a.assessment_id, a.answer_id, is_requirement=1, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed, a.FeedBack
			,req.Requirement_Text as Question_Text
			from Answer_Requirements a
				join REQUIREMENT_SETS rs on a.Question_Or_Requirement_Id = rs.Requirement_Id and a.is_requirement= 1
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.assessment_id		
				join [SETS] s on rs.Set_Name = s.Set_Name
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and ss.assessment_id = v.assessment_id
				join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id and rl.Standard_Level=dbo.convert_sal(ss.Selected_Sal_Level)
			where v.selected=1 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Questions]'
GO



CREATE VIEW [dbo].[Answer_Questions]
AS
SELECT	Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
              Question_Or_Requirement_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, 
              Is_Framework, FeedBack
FROM	Answer_Standards_InScope
WHERE	mode = 'Q'

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRankedStandardCategories]'
GO
-- =============================================
-- Author:		barry
-- Create date: 7/31/2018
-- Description:	returns the ranked categories
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRankedStandardCategories]
	@assessment_id int	
AS
BEGIN
	SET NOCOUNT ON;
	-- ranked category calculation is 
	-- sum up the total category risk
	-- for the questions on this assessment
	-- then take the number of questions - the question rank 

/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id,Assessment_Id from NEW_QUESTION_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Question_Id = s.Question_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT v.Set_Name, h.Question_Group_Heading,isnull(count(c.question_id),0) qc,  isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and a.Assessment_Id = v.Assessment_Id 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and v.Selected = 1 and v.Assessment_Id = @assessment_id 
		group by v.set_name, Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, isnull(count(c.question_id),0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and a.Assessment_Id = v.Assessment_Id 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U') and v.Selected = 1 and v.Assessment_Id = @assessment_id 
		group by v.Set_Name, h.Question_Group_Heading

	select t.*, isnull(a.nuCount,0) nuCount, isnull(a.cr,0) Actualcr, isnull(cast(a.cr as decimal(18,3))/Total,0) [prc],  isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
else 
begin 
	select @maxRank = max(c.Ranking) 
		FROM NEW_REQUIREMENT c 
		join (select distinct requirement_id,Assessment_Id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id=s.Requirement_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR

	SELECT h.Question_Group_Heading,count(c.Requirement_Id) qc,  SUM(@maxRank-c.Ranking) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #tempR
		FROM Answer_Questions a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id 
		group by Question_Group_Heading

	select *, cast(cr as decimal(18,3))/Total prc from #tempR
	order by prc desc
end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DeleteUser]'
GO
-- =============================================
-- Author:		CSET Team
-- Create date: 2021-04-08
-- Description:	Deletes a user from the CSET database.  
--              Supply a user ID argument to delete a single user, or
--              use an argument of -1 to delete all users.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUser]
	@userid nvarchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @userid < 0
		BEGIN
			delete from [ASSESSMENT_CONTACTS];
			delete from [FINDING_CONTACT];
			delete from [USER_SECURITY_QUESTIONS];
			delete from [USERS];
		END
	ELSE
		BEGIN
			select [assessment_contact_id] into #xyz from [ASSESSMENT_CONTACTS] where [userid] = @userid;
			delete from [FINDING_CONTACT] where [Assessment_Contact_Id] in (select [assessment_contact_id] from #xyz);
			delete from [ASSESSMENT_CONTACTS] where [Assessment_Contact_Id] in (select [assessment_contact_id] from #xyz);

			delete from [USER_SECURITY_QUESTIONS] where [userid] = @userid;

			delete from [USERS] where [UserId] = @userid;
		END
END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DeleteAssessment]'
GO
-- =============================================
-- Author:		CSET Team
-- Create date: 2021-04-08
-- Description:	Deletes a user from the CSET database
--              Supply an assessment ID argument to delete a single assessment, or
--              use an argument of -1 to delete all assessments.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAssessment]
	@assessmentid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @assessmentid < 0
		BEGIN
			delete from [DIAGRAM_CONTAINER]
			delete from [MATURITY_DOMAIN_REMARKS]
			delete from [DOCUMENT_FILE]
			delete from ASSESSMENTS;
		END
	ELSE
		BEGIN
			delete from [DIAGRAM_CONTAINER] where [Assessment_Id] = @assessmentid;
			delete from [MATURITY_DOMAIN_REMARKS] where [Assessment_Id] = @assessmentid;
			delete from [DOCUMENT_FILE] where [Assessment_Id] = @assessmentid;
			delete from [ASSESSMENTS] where [Assessment_Id] = @assessmentid;
		END
END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_InScope]'
GO


CREATE VIEW [dbo].[Answer_Components_InScope]
AS
SELECT DISTINCT 
                a.Assessment_Id, a.Answer_Id, a.Question_Or_Requirement_Id, a.Answer_Text, CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
                a.Question_Number, q.Simple_Question AS QuestionText, adc.label AS ComponentName, adc.Component_Symbol_Id, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
                z.Name AS ZoneName, z.Universal_Sal_Level AS SAL, a.Is_Component, a.Component_Guid, a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.Mark_For_Review, a.Is_Requirement, 
                a.Is_Framework
FROM            dbo.ANSWER AS a 
					INNER JOIN dbo.COMPONENT_QUESTIONS AS cq ON cq.Question_Id = a.Question_Or_Requirement_Id 
					INNER JOIN dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 
					INNER JOIN dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc ON a.Assessment_Id = adc.Assessment_Id AND adc.Component_Symbol_Id = cq.Component_Symbol_Id 
					LEFT OUTER JOIN dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id 
					LEFT OUTER JOIN dbo.DIAGRAM_CONTAINER AS z ON z.Assessment_Id = adc.Assessment_Id AND z.Container_Id = adc.Zone_Id
					INNER JOIN STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
					INNER JOIN NEW_QUESTION_SETS qs on q.question_id = qs.question_id and qs.Set_Name = 'Components'		
					INNER JOIN NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
						and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))

WHERE        (a.Is_Component = 1) AND (COALESCE (l.Visible, 1) = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getComponentsSummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select l.Answer_Text, l.Answer_Full_Name, isnull(b.vcount, 0) vcount, round(isnull(b.value, 0),0) [value] 
	from ANSWER_LOOKUP l 
	left join (select Answer_Text, count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] 
		from (select distinct answer_text, assessment_id, answer_id from Answer_Components_InScope
	where assessment_id = @assessment_id) ac
	group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_BuildCatNumbers]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	number stored proc
-- =============================================
CREATE PROCEDURE [dbo].[usp_BuildCatNumbers]
	@assessment_id int
AS
BEGIN
	--SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  --SELECT @NumRowsChanged = @@ROWCOUNT only call
  --if rowcount from the previous was actually greater than zeror
  --to eliminate unnecessary calls
  declare @ApplicationMode nvarchar(100)  
  declare @answer_id int, @question_group_heading_id int, @next int, @previousH int

	exec GetApplicationModeDefault @assessment_id,@applicationmode output
	if(@ApplicationMode = 'Questions Based')
		begin					
		set @next = 1; 
		set @previousH = 0; 
		declare me cursor Fast_forward
		for select a.Answer_Id,h.Question_Group_Heading_Id
			from Answer_Questions a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id			
			join vQUESTION_HEADINGS hh on h.Heading_Pair_Id = hh.Heading_Pair_Id
			where a.Assessment_Id = @assessment_id
			order by hh.Question_Group_Heading,hh.Universal_Sub_Category,q.Question_Id		

		OPEN me
		FETCH NEXT FROM me into @answer_id,@question_group_heading_id

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			  if(@question_group_heading_id <> @previousH) set @next = 1
			  update ANSWER set Question_Number = @next where Answer_Id=@answer_id
			  
			  set @next = @next +1
			  set @previousH = @question_group_heading_id
			  FETCH NEXT FROM me into @answer_id,@question_group_heading_id
		END 

		close me
		deallocate me
		end
	else
	begin
		
		declare @standard_category nvarchar(250), @previous_std nvarchar(250)
		set @next = 1; 
		set @previousH = 0; 
		declare me cursor Fast_forward
		for select a.Answer_Id, q.Standard_Category
			from Answer_Requirements a join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id			
		--	join REQUIREMENT_SETS r on q.Requirement_Id = r.Requirement_Id
			where a.Assessment_Id = @assessment_id
			order by q.Standard_Category,q.Standard_Sub_Category--,r.Requirement_Sequence

		OPEN me
		FETCH NEXT FROM me into @answer_id,@standard_category

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			  if(@standard_category <> @previous_std) set @next = 1
			  update ANSWER set Question_Number = @next where Answer_Id=@answer_id
			  
			  set @next = @next +1
			  set @previous_std = @standard_category
			  FETCH NEXT FROM me into @answer_id,@standard_category
		END 

		close me
		deallocate me
	end   
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillEmptyQuestionsForAnalysis]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	CopyData
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyQuestionsForAnalysis]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int	
AS
BEGIN	
	--SET NOCOUNT ON;
	--get the list of selected standards
	--get the mode
	--for the given mode 
	--select the new_questions_sets or requirement_sets table with left join answers (possibly on the view)
	-- and do the insert
	declare @ApplicationMode nvarchar(100)
	declare @SALevel nvarchar(10)
	declare @NumRowsChanged int

	select @SALevel = ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where @Assessment_Id = @Assessment_Id 

	DECLARE @result int;  
	exec GetApplicationModeDefault @assessment_id, @applicationmode output
	if(@ApplicationMode = 'Questions Based')
		BEGIN
			BEGIN TRANSACTION;  
		
			EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';  
				INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id], [Answer_Text], [Question_Type], [Assessment_Id])     
			select s.Question_id, Answer_Text = 'U', Question_Type='Question', Assessment_Id = @Assessment_Id
				from (select distinct s.Question_Id from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = @SALevel) s
				left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Is_Requirement = 0) a on s.Question_Id = a.Question_Or_Requirement_Id
			where a.Question_Or_Requirement_Id is null
			IF @result = -3  
			BEGIN  
				ROLLBACK TRANSACTION;  
			END  
			ELSE  
			BEGIN  
				EXEC sp_releaseapplock @Resource = '[Answer]'; 	
				COMMIT TRANSACTION;  
			END;  

			EXEC usp_BuildCatNumbers @assessment_id
		END
	else
	BEGIN
		BEGIN TRANSACTION;  		
		EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';  
		INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id], 
           [Answer_Text], [Question_Type], [Assessment_Id])     
		select distinct s.Requirement_Id, Answer_Text = 'U', Question_Type='Requirement', av.Assessment_Id 
			from requirement_sets s 
			join AVAILABLE_STANDARDS av on s.Set_Name = av.Set_Name
			join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
			left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Question_Type='Requirement') a on s.Requirement_Id = a.Question_Or_Requirement_Id
		where av.Selected = 1 and av.Assessment_Id = @Assessment_Id and a.Question_Or_Requirement_Id is null and rl.Standard_Level = @SALevel and rl.Level_Type = 'NST'
			IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END;  
		
		EXEC usp_BuildCatNumbers @assessment_id
	END   
	
END
/****** Object:  StoredProcedure [dbo].[FillNetworkDiagramQuestions]    Script Date: 12/16/2020 11:01:45 AM ******/
SET ANSI_NULLS ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetComponentsSummaryPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/30/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetComponentsSummaryPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getComponentsSummary] @assessment_id

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
   WHERE ([Parent_Question_Id] = @Parent_Id) AND ([Assessment_Id] = @Assess_Id)
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillEmptyMaturityQuestionsForAnalysis]'
GO

-- =============================================
-- Author:		Dylan Johnson
-- Create date: 10/04/2020
-- Description:	Create empty data for questions that have not been filled out to ensure correct reporting values
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyMaturityQuestionsForAnalysis]
	@Assessment_Id int	
AS
BEGIN	
	DECLARE @result int;  
	begin
	BEGIN TRANSACTION;  
	EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';
	INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id],[Answer_Text],[Question_Type],[Assessment_Id])     
		select mq.Mat_Question_Id,Answer_Text = 'U', Question_Type='Maturity', Assessment_Id =@Assessment_Id
		from [dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id in
			(select model_id from [dbo].[AVAILABLE_MATURITY_MODELS]
			where Assessment_Id = @Assessment_Id) 
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [dbo].[ANSWER] 
			where Assessment_Id = @Assessment_Id)
		IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END
	end

END
/****** Object:  StoredProcedure [dbo].[FillEmptyQuestionsForAnalysis]    Script Date: 12/16/2020 11:01:33 AM ******/
SET ANSI_NULLS ON
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
PRINT N'Creating [dbo].[usp_getStandardsSummary]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsSummary]
	@assessment_id int
AS
BEGIN
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
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin	
		select a.Answer_Full_Name, a.Short_Name, a.Answer_Text, 
			isnull(m.qc,0) as [qc],
			isnull(m.Total,0) as [Total], 
			isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0) as [Percent] 
		from (select Short_Name,l.Answer_Full_Name,l.Answer_Text from AVAILABLE_STANDARDS a 
		join SETS s on a.Set_Name = s.Set_Name
		, ANSWER_LOOKUP l
		where a.Assessment_Id = @assessment_id) a left join (
		SELECT ms.Short_Name, a.Answer_Text, isnull(count(c.question_id),0) qc, SUM(count(c.question_id)) OVER(PARTITION BY Short_Name) AS Total
				FROM Answer_Questions a 
				join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id				
				join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
				join [sets] ms on s.Set_Name = ms.Set_Name
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where a.Assessment_Id = @assessment_id and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
				group by ms.Short_Name, a.Answer_Text
		) m on a.Answer_Text = m.Answer_Text AND a.Short_Name = m.Short_Name
		order by Short_Name
end
else 
begin 
		select a.Answer_Full_Name, a.Short_Name, a.Answer_Text,
			isnull(m.[qc], 0) as [qc], 
			isnull(m.[Total], 0) as [Total],
			isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0) as [Percent] 
		from (select Short_Name,l.Answer_Full_Name,l.Answer_Text from AVAILABLE_STANDARDS a 
		join SETS s on a.Set_Name = s.Set_Name
		, ANSWER_LOOKUP l
		where a.Assessment_Id = @assessment_id) a left join (
		SELECT ms.Short_Name, a.Answer_Text, isnull(count(c.Requirement_Id),0) qc, SUM(count(c.Requirement_Id)) OVER(PARTITION BY Short_Name) AS Total  
				FROM Answer_Requirements a 
				join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id = c.Requirement_Id				
				join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id		
				join [sets] ms on s.Set_Name = ms.Set_Name		
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 			
				join REQUIREMENT_LEVELS rl on c.Requirement_Id = rl.Requirement_Id									
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where a.Assessment_Id = @assessment_id and v.Selected = 1 and v.Assessment_Id = @assessment_id and rl.Standard_Level = ul.Universal_Sal_Level
				group by ms.Short_Name, a.Answer_Text
	   ) m on a.Answer_Text = m.Answer_Text AND a.Short_Name = m.Short_Name
	   order by Short_Name
end
END







GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vFinancialGroups]'
GO

CREATE VIEW [dbo].[vFinancialGroups]
AS
SELECT dbo.FINANCIAL_GROUPS.FinancialGroupId, dbo.FINANCIAL_DOMAINS.DomainId, dbo.FINANCIAL_DOMAINS.Domain, dbo.FINANCIAL_MATURITY.MaturityLevel, dbo.FINANCIAL_ASSESSMENT_FACTORS.AssessmentFactorId, 
                  dbo.FINANCIAL_ASSESSMENT_FACTORS.AssessmentFactor, dbo.FINANCIAL_COMPONENTS.FinComponentId, dbo.FINANCIAL_COMPONENTS.FinComponent
FROM     dbo.FINANCIAL_GROUPS INNER JOIN
                  dbo.FINANCIAL_DOMAINS ON dbo.FINANCIAL_GROUPS.DomainId = dbo.FINANCIAL_DOMAINS.DomainId INNER JOIN
                  dbo.FINANCIAL_MATURITY ON dbo.FINANCIAL_GROUPS.Financial_Level_Id = dbo.FINANCIAL_MATURITY.Financial_Level_Id INNER JOIN
                  dbo.FINANCIAL_ASSESSMENT_FACTORS ON dbo.FINANCIAL_GROUPS.AssessmentFactorId = dbo.FINANCIAL_ASSESSMENT_FACTORS.AssessmentFactorId INNER JOIN
                  dbo.FINANCIAL_COMPONENTS ON dbo.FINANCIAL_GROUPS.FinComponentId = dbo.FINANCIAL_COMPONENTS.FinComponentId
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_MaturityDetailsCalculations]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_MaturityDetailsCalculations]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int
AS
BEGIN
	declare @applicationMode nvarchar(50)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	SET NOCOUNT ON;
	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	if(@ApplicationMode = 'Questions Based')	
	BEGIN    
	select grouporder, a.Total,Domain,AssessmentFactor,FinComponent,MaturityLevel,b.Answer_Text, isnull(b.acount, 0) as acount,   isnull((cast(b.acount as float)/cast(total as float)),0) as AnswerPercent, CAST(c.complete AS BIT) AS complete from (
			select distinct min(StmtNumber) as grouporder, fd.financialGroupId, Domain,AssessmentFactor,FinComponent,MaturityLevel,count(stmtnumber) Total
			FROM [FINANCIAL_DETAILS] fd 
			JOIN vFinancialGroups g ON fd.financialGroupId = g.financialGroupId			
			GROUP BY fd.financialGroupId,Domain,AssessmentFactor,FinComponent,MaturityLevel				
			) a 
		left join (SELECT  fd.FinancialGroupId , answer_text, count(a.Answer_Text) acount
			FROM       [dbo].[FINANCIAL_QUESTIONS] f
			INNER JOIN [dbo].[NEW_QUESTION] q ON f.[Question_Id] = q.[Question_Id]
			INNER JOIN (select assessment_id,Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y'   end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F.[Question_Id] = a.[Question_Or_Requirement_Id]
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    			
			WHERE [Assessment_Id] = @Assessment_Id AND [Is_Requirement] = 0 
			group by fd.FinancialGroupId, Answer_Text
			)  b  on a.financialGroupId = b.FinancialGroupId
    	join (SELECT fd.financialGroupId,  min(case answer_text when 'U' then 0 else 1 end) as Complete
			from (select * from [ANSWER] WHERE assessment_Id=@assessment_id and Is_Requirement = 0) u 
			join [dbo].[FINANCIAL_QUESTIONS] f ON F.[Question_Id] = u.[Question_Or_Requirement_Id]						
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
			WHERE assessment_Id=@assessment_id 
			group by fd.financialGroupId) c on a.FinancialGroupId = c.FinancialGroupId
		order by grouporder			
	end 
	else
	begin 	
	select grouporder, a.Total,Domain,AssessmentFactor,FinComponent,MaturityLevel,b.Answer_Text, isnull(b.acount, 0) as acount,   isnull((cast(b.acount as float)/cast(total as float)),0) as AnswerPercent , CAST(c.Complete AS BIT) AS complete FROM (
			select distinct min(StmtNumber) as grouporder, fd.financialGroupId,Domain,AssessmentFactor,FinComponent,MaturityLevel,count(stmtnumber) Total 
			FROM [FINANCIAL_DETAILS] fd 
			JOIN vFinancialGroups g ON fd.financialGroupId = g.financialGroupId	
			group by fd.FinancialGroupId,Domain,AssessmentFactor,FinComponent,MaturityLevel				
			) a 
		left join (SELECT  fd.FinancialGroupId, answer_text, count(a.Answer_Text) acount
			FROM       [dbo].[FINANCIAL_REQUIREMENTS] f
			INNER JOIN [dbo].[NEW_REQUIREMENT] q ON f.[Requirement_Id] = q.[Requirement_Id]
			INNER JOIN (select assessment_id,Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y' else 'N' end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F.[Requirement_Id] = a.[Question_Or_Requirement_Id]
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    			
			WHERE [Assessment_Id] = @Assessment_Id AND [Is_Requirement] = 1 
			group by fd.FinancialGroupId, Answer_Text
			) b  on a.FinancialGroupId = b.FinancialGroupId
		join (SELECT fd.financialGroupId,  min(case answer_text when 'U' then 0 else 1 end) as Complete
			from (select * from [ANSWER] WHERE assessment_Id=@assessment_id and Is_Requirement = 1)  u 
			join [dbo].[FINANCIAL_REQUIREMENTS] f ON F.[Requirement_Id] = u.[Question_Or_Requirement_Id]						
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
			WHERE assessment_Id=@assessment_id 
			group by fd.financialGroupId) c on a.FinancialGroupId = c.FinancialGroupId
		order by grouporder
	end

				
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetStandardsSummaryPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetStandardsSummaryPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getStandardsSummary] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Maturity]'
GO



CREATE VIEW [dbo].[Answer_Maturity]
AS
SELECT 
	a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, 
	a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, 
	a.Component_Guid, a.Is_Component, a.Is_Framework, a.Is_Maturity,
    a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.FeedBack, q.Maturity_Level_Id, q.Question_Text
FROM       [ANSWER] a
LEFT JOIN  [MATURITY_QUESTIONS] q on q.Mat_Question_Id = a.Question_Or_Requirement_Id
LEFT JOIN  [ASSESSMENT_SELECTED_LEVELS] l on l.Assessment_Id = a.Assessment_Id and l.Standard_Specific_Sal_Level = q.Maturity_Level_Id and l.Level_Name = 'Maturity_Level'
WHERE      a.Is_Maturity = 1
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GenerateSPRSScore]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 11/17/2021
-- Description:	generate scores for SPRS
-- =============================================
CREATE PROCEDURE [dbo].[usp_GenerateSPRSScore]
	-- Add the parameters for the stored procedure here
	@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;	
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	select sum(Score) +110 as SPRS_SCORE from (
	SELECT Mat_Question_Id,answer_text,e.CMMC1_Title,  case answer_text when 'Y' then 0 when 'NA' then 0 else -1*e.SPRSValue end as Score from Answer_Maturity a join MATURITY_QUESTIONS m on a.Question_Or_Requirement_Id=m.Mat_Question_Id
	join MATURITY_EXTRA e on m.Mat_Question_Id=e.Maturity_Question_Id
	where m.Maturity_Model_Id = 6 and Assessment_Id = @assessment_id) A

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetRelevantAnswers]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Returns a table containing ANSWER rows that are relevant
--              to the assessment's current question mode, standard selection and SAL level.
-- =============================================
CREATE PROCEDURE [dbo].[GetRelevantAnswers]
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
PRINT N'Creating [dbo].[usp_StatementsReviewed]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_StatementsReviewed]
	@Assessment_Id int	
AS
BEGIN

------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	declare @applicationMode nvarchar(50)

	exec GetApplicationModeDefault @assessment_id, @ApplicationMode output

	SET NOCOUNT ON;

	EXECUTE [FillEmptyQuestionsForAnalysis]  @Assessment_Id

	if(@ApplicationMode = 'Questions Based')	
	BEGIN

		SELECT assessment_id, c.Component, ReviewType, Hours, isnull(ReviewedCount, 0) as ReviewedCount, f.OtherSpecifyValue, c.DomainId, PresentationOrder, grouporder acount
		from FINANCIAL_HOURS f 
			join FINANCIAL_HOURS_COMPONENT c on f.Component = c.Component
			left join (
				select grouporder, a.DomainId, isnull(ReviewedCount, 0) as ReviewedCount
				from (
						select distinct min(StmtNumber) as grouporder, d.Domain, g.DomainId,count(stmtnumber) Total from [FINANCIAL_DETAILS] fd 
						INNER JOIN FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
						INNER JOIN [FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]						
						group by g.DomainId, d.Domain
						)  a left join (
						SELECT  g.DomainId, isnull(count(ans_rev.answer_id), 0) as ReviewedCount
						FROM       [FINANCIAL_QUESTIONS] f			
						INNER JOIN [NEW_QUESTION] q ON f.[Question_Id] = q.[Question_Id]
						INNER JOIN #answers a ON q.[Question_Id] = a.[Question_Or_Requirement_Id]
						INNER JOIN #answers ans_rev ON q.[Question_Id] = ans_rev.[Question_Or_Requirement_Id]
						INNER JOIN [FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
						inner join FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
						WHERE ans_rev.Reviewed = 1
						group by g.DomainId
						) b  on a.DomainId = b.DomainId
		) b on c.DomainId = b.DomainId		
		where f.assessment_id = @assessment_id
		order by PresentationOrder

	END 
	ELSE
	BEGIN 

		SELECT Assessment_id, c.Component, ReviewType, Hours, isnull(ReviewedCount, 0) as ReviewedCount, f.OtherSpecifyValue, c.DomainId, PresentationOrder, grouporder acount
		from FINANCIAL_HOURS f 
		join FINANCIAL_HOURS_COMPONENT c on f.Component = c.Component
		left join (
			select grouporder, a.DomainId, isnull(ReviewedCount, 0) as ReviewedCount
			from (
					select distinct min(StmtNumber) as grouporder, d.Domain, g.DomainId, count(stmtnumber) Total from [FINANCIAL_DETAILS] fd 
					INNER JOIN FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
					INNER JOIN [FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]			
					group by g.DomainId, d.Domain
					)  a left join (
					SELECT  g.DomainId, isnull(count(ans_rev.Answer_Id), 0) as ReviewedCount
					FROM       [FINANCIAL_REQUIREMENTS] f
					INNER JOIN [NEW_REQUIREMENT] q ON f.[Requirement_Id] = q.[Requirement_Id]
					INNER JOIN #answers a ON q.[Requirement_Id] = a.[Question_Or_Requirement_Id]
					INNER JOIN #answers ans_rev ON q.[Requirement_Id] = ans_rev.[Question_Or_Requirement_Id]
					INNER JOIN [FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
					inner join FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
					WHERE ans_rev.Reviewed = 1
					group by g.DomainId
					) b  on a.DomainId = b.DomainId 		
		) b on c.DomainId = b.DomainId
		where f.assessment_id = @assessment_id
		order by PresentationOrder		
			
	END
	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_setTrendOrder]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_setTrendOrder]
	-- Add the parameters for the stored procedure here
	@Aggregation_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @assessment_id int, @i int
	

	declare me cursor for 
	select aa.Assessment_Id from AGGREGATION_ASSESSMENT aa
	join ASSESSMENTS a on aa.Assessment_Id = a.Assessment_Id
	where Aggregation_Id = @Aggregation_id
	order by a.Assessment_Date
	
	open me

	fetch next from me into @assessment_id
	set @i = 0;
	while(@@FETCH_STATUS = 0)
	begin
	update AGGREGATION_ASSESSMENT set Sequence = @i where Assessment_Id = @assessment_id and Aggregation_Id=@Aggregation_id
	set @i= @i+1
	fetch next from me into @assessment_id
	end 
	close me 
	deallocate me    
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetMaturityAnswerTotals]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 27 AUG 2024
-- Description:	Flexible answer count/percentages for maturity models that have their own 
--              answer options other than Y, N, NA, etc.
--
--              A model ID can be supplied (for querying SSG answers), or if not supplied,
--              the assigned model ID is used.
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetMaturityAnswerTotals]
	@assessment_id int,
	@model_id int = null
AS
BEGIN
	-- Get the assigned maturity model ID if a model was not specified in the arguments
	if @model_id is null begin
	  set @model_id = (select model_id from AVAILABLE_MATURITY_MODELS where assessment_id = @assessment_id)
	end

	-- Create all missing answer rows
	exec [FillEmptyMaturityQuestionsForAnalysis] @assessment_id


	select *
	into #answers
	from answer
	where question_type = 'maturity' and Question_Or_Requirement_Id in (select mat_question_id from maturity_questions where maturity_model_id = @model_id)

	select [Answer_Text], 
		isnull(qc, 0) as [QC], 
		isnull(m.Total, 0) as [Total], 
		isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int), 0) as [Percent]
	from  (
		SELECT a.Answer_Text, count(a.question_or_requirement_id) qc, SUM(count(a.question_or_requirement_id)) OVER() AS [Total]
		FROM #answers a 				
		where a.Assessment_Id = @assessment_id
		group by a.Answer_Text
	) m 
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getStandardsResultsByCategory]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsResultsByCategory]
	@assessment_id int
AS
BEGIN
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
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id, isnull(count(c.question_id),0) qc into #temp	
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id

	insert into #temp (Set_Name, Question_Group_Heading, QC) 
	select a.Set_name,a.Question_Group_Heading, qc=0 from 
	(select * from (select distinct question_group_heading from #temp) a, (select distinct set_name from #temp) b) a 
	left join #temp on a.question_group_heading=#temp.question_group_heading and a.set_name = #temp.set_name
	where #temp.set_name is null

	SELECT s.Set_Name, Question_Group_Heading, Question_Group_Heading_Id, isnull(count(c.question_id),0) qc into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading, question_group_Heading_Id
     
	select t.Set_Name,
	s.Short_Name,
	t.Question_Group_Heading, 
	t.Question_Group_Heading_Id as [QGH_Id],
	isnull(a.qc,0) yaCount, 
	isnull(t.qc,0) Actualcr, 
	round(isnull(cast(a.qc as decimal(18,3))/t.qc,0),5) * 100 [prc]
	from #temp t left join #tempAnswered a on t.Set_Name = a.Set_Name and  t.Question_Group_Heading = a.Question_Group_Heading
	join [SETS] s on t.Set_Name = s.Set_Name
	order by Question_Group_Heading desc	
end
else 
begin 

	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR
	IF OBJECT_ID('tempdb..#TempRAnswer') IS NOT NULL DROP TABLE #TempRAnswer

	SELECT s.set_name, c.standard_category, isnull(count(c.Requirement_Id),0) qc into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text <> 'NA'
		group by s.set_name, standard_category


	insert into #tempR (Set_Name,standard_category, QC) 
	select a.Set_name,a.standard_category, qc=0 from 
	(select * from (select distinct standard_category from #tempR) a, (select distinct set_name from #tempR) b) a 
	left join #tempR on a.standard_category=#tempR.standard_category and a.set_name = #tempR.set_name
	where #tempR.set_name is null

	SELECT s.set_name, c.standard_category,  count(c.Requirement_Id) qc into #tempRAnswer
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text in ('Y','A')
		group by s.set_name, standard_category

	select t.Set_Name, 
	s.Short_Name, 
	t.standard_category as [question_group_heading],
	qgh.Question_Group_Heading_Id as [QGH_Id],
	isnull(a.qc,0) yaCount, 
	isnull(t.qc,0) Actualcr, 
	round(isnull(cast(a.qc as decimal(18,3))/t.qc,0),5) * 100 [prc]
	from #tempR t 
	left join #tempRAnswer a on t.Set_Name = a.Set_Name and t.Standard_Category = a.Standard_Category
	left join QUESTION_GROUP_HEADING qgh on t.Standard_Category = qgh.Question_Group_Heading
	join [SETS] s on t.Set_Name = s.Set_Name
	order by t.standard_category desc

end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillEmptyMaturityQuestionsForModel]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 09/10/2024
-- Description:	Create empty data for questions that have not been filled out.
--              This version of the proc is designed for deliberately fleshing out SSG questions
--              because their relevance is not determined by AVAILABLE_MATURITY_MODELS.
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyMaturityQuestionsForModel]
	@Assessment_Id int,
	@Model_Id int
AS
BEGIN	
	DECLARE @result int;  
	begin
	BEGIN TRANSACTION;  
	EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';
	INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id],[Answer_Text],[Question_Type],[Assessment_Id])     
		select mq.Mat_Question_Id,Answer_Text = 'U', Question_Type='Maturity', Assessment_Id = @Assessment_Id
		from [dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id = @Model_Id
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [dbo].[ANSWER] 
			where Assessment_Id = @Assessment_Id and Maturity_Model_Id = @Model_Id)
		IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END
	end

END
/****** Object:  StoredProcedure [dbo].[FillEmptyQuestionsForAnalysis]    Script Date: 12/16/2020 11:01:33 AM ******/
SET ANSI_NULLS ON
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_StatementsReviewedTabTotals]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: Mar 2, 2019
-- Description:	fill it and if missing get the data 
-- =============================================
CREATE PROCEDURE [dbo].[usp_StatementsReviewedTabTotals]
	@Assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [FINANCIAL_HOURS]
				([Assessment_Id]
				,[Component]
				,[ReviewType]
				,[Hours])     
	select a.* from (
	SELECT @assessment_id Assessment_id, Component, ReviewType, [Hours] = 0
		FROM [FINANCIAL_HOURS_COMPONENT], FINANCIAL_REVIEWTYPE) a left join [FINANCIAL_HOURS] f on 
		a.Assessment_id = f.Assessment_Id and a.Component = f.Component and a.ReviewType = f.ReviewType
		where f.Assessment_Id is null
  
	select * from (select Assessment_Id,ReviewType,sum([Hours]) as Totals from FINANCIAL_HOURS
	where assessment_id = @Assessment_id
	group by Assessment_Id,ReviewType) a,(
	select SUM([Hours]) AS GrandTotal from FINANCIAL_HOURS
	where assessment_id = @Assessment_id) b
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAnswerCountsForGroupings]'
GO

-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	Generically return answer counts for all groupings in 
--              an assessment's maturity model
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerCountsForGroupings]
	@assessmentId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec [FillEmptyMaturityQuestionsForAnalysis] @assessmentId

    select Title, Sequence, Grouping_Id, Parent_Id, Answer_Text, count(*) as AnsCount
	from (
		select mg.Title, mg.Sequence, mg.grouping_id, mg.Parent_Id, a.Answer_Text
		from answer a
		left join maturity_questions mq on a.Question_Or_Requirement_Id = mq.Mat_Question_Id and a.Question_Type = 'maturity'
		left join maturity_groupings mg on mq.Grouping_Id = mg.Grouping_Id
		where assessment_id = @assessmentId
	) b
	group by title, sequence, grouping_id, parent_id, answer_text
	order by sequence, answer_text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetTop5Areas]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 1/27/2020
-- Description:	get the percentages for each area
-- line up the assessments 
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTop5Areas]
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
	[Question_Group_Heading] [nvarchar](100) NOT NULL,
	[pdifference] [float] NULL,
	[TopBottomType] [nvarchar](10) NOT NULL
	)

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)

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
PRINT N'Creating [dbo].[usp_GetStandardsResultsByCategoryPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetStandardsResultsByCategoryPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getStandardsResultsByCategory] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getStandardsRankedCategories]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardsRankedCategories]
	@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;
	-- ranked category calculation is 
	-- sum up the total category risk
	-- for the questions on this assessment
	-- then take the number of questions - the question rank 

/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id,Assessment_Id from NEW_QUESTION_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Question_Id = s.Question_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT v.Set_Name, h.Question_Group_Heading,isnull(count(c.question_id),0) qc,  isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and a.Assessment_Id = v.Assessment_Id 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and v.Selected = 1 and v.Assessment_Id = @assessment_id 
		group by v.set_name, Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, isnull(count(c.question_id),0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and a.Assessment_Id = v.Assessment_Id 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U') and v.Selected = 1 and v.Assessment_Id = @assessment_id 
		group by v.Set_Name, h.Question_Group_Heading

	select t.*, isnull(a.nuCount,0) nuCount, isnull(a.cr,0) Actualcr, round(isnull(cast(a.cr as decimal(18,3))/Total,0),4)*100 [prc],  round(isnull(a.nuCount,0)/(cast(qc as decimal(18,3))),4)*100 as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
else 
begin 
	select @maxRank = max(c.Ranking) 
		FROM NEW_REQUIREMENT c 
		join (select distinct requirement_id,Assessment_Id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id=s.Requirement_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR

	SELECT h.Question_Group_Heading,count(c.Requirement_Id) qc,  SUM(@maxRank-c.Ranking) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id 
		group by Question_Group_Heading

	select *, cast(cr as decimal(18,3))/Total prc from #tempR
	order by prc desc
end
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetStandardsRankedCategoriesPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetStandardsRankedCategoriesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getStandardsRankedCategories] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getComponentsResultsByCategory]'
GO
-- =============================================
-- Author:		woodrk
-- Create date: 8/20/2019
-- Description:	Get answered component questions by category
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentsResultsByCategory]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- get all answers
	select Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #temp	
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id
	where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' 
	group by Question_Group_Heading


	-- get passing answers (Y, A)
	SELECT Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #tempAnswered
	from Answer_Components_InScope a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id		
	where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') 	
	group by Question_Group_Heading


	-- calc totals/percentage of passing		 
	select t.Question_Group_Heading, 
	ISNULL(a.qc,0) as [passed], 
	ISNULL(t.qc,0) as [total], 
	ROUND(ISNULL(CAST(a.qc as decimal(18,3))/t.qc,0),5) * 100 as [percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by Question_Group_Heading	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetComponentsResultsByCategoryPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetComponentsResultsByCategoryPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getComponentsResultsByCategory] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetQuestions]'
GO
-- =============================================
-- Author:		Barry Hansen
-- Create date: 10/8/2024
-- Description:	Ranked Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetQuestions]
@assessment_id INT
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
	
	if(@ApplicationMode = 'Questions Based')	
	begin
		SELECT Short_Name as ShortName,
			Question_Group_Heading as [Category], 							
			Simple_Question as [QuestionText], 						
			c.Question_Id as [QuestionId],
			null as [RequirementId],
			a.Answer_ID as [AnswerID],
			Answer_Text as [AnswerText],
			c.Universal_Sal_Level as [Level],
			CONVERT(varchar(10), a.Question_Number) as [QuestionRef],
			Question_Group_Heading + ' # ' + CONVERT(varchar(10), a.Question_Number) as CategoryAndNumber,
			a.Question_Or_Requirement_Id as [QuestionOrRequirementID]
			FROM Answer_Questions a
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
			join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
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
			order by ShortName,Question_Group_Heading,Question_Number
	end
	else
	begin
		SELECT Short_Name ShortName,
			Standard_Category as [Category], 			
			Requirement_Text as [QuestionText], 				
			null as [QuestionId],
			req.Requirement_Id as [RequirementId],
			Answer_Id as [AnswerID],
			Answer_Text as [AnswerText],
			u.Universal_Sal_Level as [Level],
			requirement_title as [QuestionRef],
			Standard_Category + ' - ' + requirement_title as CategoryAndNumber,
			rs.Requirement_Id as [QuestionOrRequirementID]
			from REQUIREMENT_SETS rs
				left join ANSWER ans on ans.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and ans.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level
			order by rs.Requirement_Sequence
	end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components]'
GO
CREATE VIEW [dbo].[Answer_Components]
AS
SELECT a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, a.Component_Guid, a.Is_Component, a.Is_Framework, 
                  a.Reviewed, a.FeedBack, q.Simple_Question AS QuestionText
FROM     dbo.ANSWER AS a INNER JOIN
                  dbo.NEW_QUESTION AS q ON q.Question_Id = a.Question_Or_Requirement_Id
WHERE  (a.Is_Requirement = 0) AND (a.Is_Component = 1)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getComponentsRankedCategories]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentsRankedCategories]
	@assessment_id int
AS
BEGIN
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
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
begin

	--declare @assessment_id int
	--set @assessment_id = 1041
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id from NEW_QUESTION_SETS where Set_Name = 'Components')
		s on c.Question_Id = s.Question_Id

	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT h.Question_Group_Heading, isnull(count(c.question_id), 0) qc, isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
		FROM Answer_Components a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id				
				join UNIVERSAL_SAL_LEVEL ul on l.Universal_Sal_Level = ul.Universal_Sal_Level
				where s.Set_Name = 'Components'
		)
		s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, isnull(count(c.question_id), 0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
		FROM Answer_Components a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id				
				join UNIVERSAL_SAL_LEVEL ul on l.Universal_Sal_Level = ul.Universal_Sal_Level
				where s.Set_Name = 'Components'
		)	s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading

	select t.*, isnull(a.nuCount,0) nuCount, isnull(a.cr,0) Actualcr, isnull(cast(a.cr as decimal(18,3))/Total,0)*100 [prc],  isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetComponentsRankedCategoriesPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetComponentsRankedCategoriesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getComponentsRankedCategories] @assessment_id

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
PRINT N'Creating [dbo].[usp_getComponentTypes]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	remember the answer values are percents
-- =============================================
CREATE PROCEDURE [dbo].[usp_getComponentTypes]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT Assessment_Id,
			Component_Symbol_Id,
			Symbol_Name,
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],
			ISNULL(Total,0) as [Total], 
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(	
			select Assessment_Id, b.Component_Symbol_Id, s.Symbol_Name,
			isnull(Acount,0) as Acount, aw.answer_text, SUM(acount) OVER(PARTITION BY Assessment_Id, b.Component_Symbol_Id) AS Total  
			from (select Component_Symbol_Id, answer_text from ANSWER_LOOKUP a, assessment_diagram_components c
			where c.assessment_id = @assessment_id) aw 
			left join (
				select assessment_id, a.Component_Symbol_Id, a.answer_text, count(a.answer_text) acount 
				from Answer_Components_Inscope a 
				where a.assessment_id = @assessment_id
				group by assessment_id, Component_Symbol_Id, a.answer_text) b 
			on aw.Answer_Text = b.answer_text and aw.Component_Symbol_Id = b.Component_Symbol_Id
			left join COMPONENT_SYMBOLS s on s.Component_Symbol_Id = b.Component_Symbol_Id
			where b.Component_Symbol_Id is not null
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.Component_Symbol_Id;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetComponentTypesPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetComponentTypesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getComponentTypes] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getOverallRankedCategories]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getOverallRankedCategories]
	@assessment_id int
AS
BEGIN
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
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id,Assessment_Id from NEW_QUESTION_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Question_Id = s.Question_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT h.Question_Group_Heading,
		h.Question_Group_Heading_Id as [QGH_Id],
		isnull(count(c.question_id),0) qc,  
		isnull(SUM(@maxRank-c.Ranking),0) cr, 
		sum(sum(@maxrank - c.Ranking)) OVER() AS Total 
		into #temp
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)
		s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading, Question_Group_Heading_id
     
	 SELECT h.Question_Group_Heading, 
		h.Question_Group_Heading_Id as [QGH_Id],
		isnull(count(c.question_id),0) nuCount, 
		isnull(SUM(@maxRank-c.Ranking),0) cr 
		into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)	s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading, Question_Group_Heading_Id

	select t.*, 
	isnull(a.nuCount,0) nuCount, 
	isnull(a.cr,0) Actualcr, 
	Round(isnull(cast(a.cr as decimal(18,3))/Total,0)*100,2) [prc],  
	isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
else 
begin 
	select @maxRank = max(c.Ranking) 
		FROM NEW_REQUIREMENT c 
		join (select distinct requirement_id,Assessment_Id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id=s.Requirement_Id
		where s.Assessment_Id = @assessment_id 
	
	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR
	IF OBJECT_ID('tempdb..#TempRAnswered') IS NOT NULL DROP TABLE #TempRAnswered

	SELECT h.Question_Group_Heading,
	h.Question_Group_Heading_Id as [QGH_Id],
	count(c.Requirement_Id) qc,  
	SUM(@maxRank-c.Ranking) cr, 
	sum(sum(@maxrank - c.Ranking)) OVER() AS Total
	into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1 and v.assessment_id = @assessment_id)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading, h.Question_Group_Heading_Id

	SELECT h.Question_Group_Heading,
	h.Question_Group_Heading_Id as [QGH_Id],
	isnull(count(c.requirement_id),0) nuCount,
	SUM(@maxRank-c.Ranking) cr
	into #tempRAnswered
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1 and v.assessment_id = @assessment_id)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading, h.Question_Group_Heading_Id

	select t.*, 
	isnull(a.nuCount,0) nuCount, 
	isnull(a.cr,0) Actualcr, 	
	ROUND(isnull(cast(a.cr as decimal(18,3))/Total,0)*100,2) [prc],  
	isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #tempR t left join #tempRAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetOverallRankedCategoriesPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetOverallRankedCategoriesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@assessment_id = null)
	select Question_Group_Heading='Information and Document Management',qc=5,
		cr=4827,Total=487078,nuCount=5,Actualcr=4827,prc=0.99101170654300,[Percent]=1.12


    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getOverallRankedCategories] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetRankedQuestions]'
GO

-- =============================================
-- Author:		Mitch Carroll
-- Create date: 9 Aug 2018
-- Description:	Ranked Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetRankedQuestions]
@assessment_id INT
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
	

	if(@ApplicationMode = 'Questions Based')	
	begin
		SELECT Short_Name as [Standard], 
			Question_Group_Heading as [Category], 
			ROW_NUMBER() over (order by c.ranking asc) as [Rank], 
			Simple_Question as [QuestionText], 
			c.Question_Id as [QuestionId],
			null as [RequirementId],
			a.Answer_ID as [AnswerID],
			Answer_Text as [AnswerText], 
			c.Universal_Sal_Level as [Level], 
			CONVERT(varchar(10), a.Question_Number) as [QuestionRef],
			a.Question_Or_Requirement_Id as [QuestionOrRequirementID]
			FROM Answer_Questions a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
			join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
			join (
				select distinct s.question_id, ns.Short_Name from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join SETS ns on s.Set_Name = ns.Set_Name
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
					join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
					join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
			)	s on c.Question_Id = s.Question_Id		
			where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
			order by c.Ranking		
	end
	else
	begin
		SELECT Short_Name [standard], 
			Standard_Category as [Category], 
			ROW_NUMBER() over (order by req.ranking asc) as [Rank], 
			Requirement_Text as [QuestionText], 
			null as [QuestionId],
			req.Requirement_Id as [RequirementId],
			Answer_Id as [AnswerID],
			Answer_Text as [AnswerText], 
			u.Universal_Sal_Level as [Level], 
			requirement_title as [QuestionRef],
			rs.Requirement_Id as [QuestionOrRequirementID]
			from REQUIREMENT_SETS rs
				left join ANSWER ans on ans.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and ans.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level and ans.Answer_Text in ('N','U')
			order by req.Ranking		
	end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vAllQuestionsOnly]'
GO
CREATE VIEW [dbo].[vAllQuestionsOnly]
AS
SELECT AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId,Simple_Question AS question, q.Original_Set_Name
FROM     NEW_QUESTION q
UNION
SELECT AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question, r.Original_Set_name
FROM     NEW_REQUIREMENT r
UNION
SELECT AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS question, m.Model_Name as Original_Set_Name 
FROM MATURITY_QUESTIONS mq
JOIN MATURITY_MODELS m on m.Maturity_Model_Id = mq.Maturity_Model_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillAll]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FillAll]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	exec FillEmptyMaturityQuestionsForAnalysis @assessment_id
	exec FillEmptyQuestionsForAnalysis @assessment_id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_countsForLevelsByGroupMaturityModel]'
GO
-- =============================================
-- Author:        hansbk
-- Create date: 11/3/2022
-- Description:    getting all the counts for a mat,grouping,level and answer
-- =============================================
CREATE PROCEDURE [dbo].[usp_countsForLevelsByGroupMaturityModel]
    -- Add the parameters for the stored procedure here
    @assessment_id int,
    @mat_model_id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    select a.*,b.Answer_Text as Answer_Text2,b.answer_count from (
    select distinct GROUPING_ID,Maturity_Level_Id, Answer_Text
    from MATURITY_QUESTIONS, (select ANSWER_text from ANSWER_LOOKUP where Answer_Text in ('Y','U','N')) ans
    where Maturity_Model_Id = @mat_model_id) a left join (
    select q.Grouping_Id,q.Maturity_Level_Id, a.Answer_Text, count(a.Answer_Text) answer_count from ANSWER a
    join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
    join MATURITY_LEVELS l on q.Maturity_Level_Id = l.Maturity_Level_Id
    where a.Question_Type = 'Maturity' and Assessment_Id = @assessment_id
    group  by q.Grouping_Id, q.Maturity_Level_Id, a.Answer_Text) b on a.Grouping_Id=b.Grouping_Id and a.Maturity_Level_Id=b.Maturity_Level_Id and a.Answer_Text=b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Acet_GetActionItemsForReport]'
GO
-- =============================================
-- Author:		mrwinston
-- Create date: 11/4/2022
-- Description:	loads in the Action_Items for ACET ISE's MERIT and Examination reports
-- =============================================
CREATE PROCEDURE [dbo].[Acet_GetActionItemsForReport]
	@Assessment_Id int,
	@Exam_Level int, 
	@Additional_Exam_Level int
AS
BEGIN
	SELECT a.Parent_Question_Id, a.Mat_Question_Id,a.Observation_Id,a.Question_Title,a.answer_text,Regulatory_Citation, isnull(b.action_items_override,a.Action_Items) as Action_Items, a.Maturity_Level_Id
	FROM (select m.mat_question_id,m.Question_Title, m.Parent_Question_Id,i.Action_Items, Regulatory_Citation, a.Answer_Text,m.Maturity_Level_Id, mf.Finding_Id as [Observation_Id]
		from [MATURITY_QUESTIONS] AS [m]
		join [ANSWER] [a] on m.Mat_Question_Id = a.Question_Or_Requirement_Id and a.Question_Type = 'Maturity' and Assessment_Id = @Assessment_Id
		join (select a1.Question_Or_Requirement_Id,f1.Finding_Id,f1.Auto_Generated from ANSWER a1 join FINDING f1 on a1.Answer_Id=f1.Answer_Id where Assessment_Id = @Assessment_Id and a1.Question_Type = 'Maturity') mf on m.Parent_Question_Id = mf.Question_Or_Requirement_Id
		INNER JOIN [ISE_ACTIONS] AS [i] ON [m].[Mat_Question_Id] = [i].[Mat_Question_Id]
		where a.Answer_Text = 'N' or Auto_Generated = 0
	) a

	left join (select a.Assessment_Id,a.Question_Or_Requirement_Id,f.Finding_Id,i0.Action_Items_Override,i0.Mat_Question_Id
		from [ANSWER] [a]
		JOIN [FINDING] AS [f] ON [a].[Answer_Id] = [f].[Answer_Id]
		LEFT JOIN [ISE_ACTIONS_FINDINGS] AS [i0] ON f.Finding_Id = i0.Finding_Id
		WHERE [a].[Assessment_Id] = @Assessment_Id and a.Question_Type = 'Maturity'
	) b on a.Parent_Question_Id = b.Question_Or_Requirement_Id and a.Mat_Question_Id = b.Mat_Question_Id and a.Observation_Id = b.Finding_Id
	
	where a.Maturity_Level_Id = @Exam_Level or a.Maturity_Level_Id = @Additional_Exam_Level
	order by a.Mat_Question_Id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InScopeQuestions]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Question IDs that are
--              'in scope' for an Assessment.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeQuestions]
	@assessment_id int
AS
BEGIN
select distinct s.Question_Id 
	from NEW_QUESTION_SETS s 
	join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
	where v.Selected = 1 and v.Assessment_Id = @assessment_id 
	and l.Universal_Sal_Level = (
		select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where Assessment_Id = @assessment_id 
	)
END


GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[InScopeRequirements]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Requirement IDs that are
--              'in scope' for an Assessment based on assessment mode,
--              standard selection and SAL.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeRequirements]
	@assessment_id int
AS
BEGIN
select s.Requirement_Id from requirement_sets s 
	join AVAILABLE_STANDARDS av on s.Set_Name=av.Set_Name
	join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
where av.Selected = 1 and av.Assessment_Id = @Assessment_Id
	and rl.Level_Type = 'NST'
	and rl.Standard_Level = (
	select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where Assessment_Id = @assessment_id 
	)	
END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[VIEW_QUESTIONS_STATUS]'
GO
CREATE VIEW [dbo].[VIEW_QUESTIONS_STATUS]
AS
SELECT        dbo.ANSWER.Question_Or_Requirement_Id,
						 CAST(CASE WHEN dbo.ANSWER.Comment IS NULL THEN 0 ELSE 1 END AS bit) AS HasComment, 
                         CAST(CASE WHEN dbo.ANSWER.Mark_For_Review IS NULL THEN 0 ELSE dbo.ANSWER.Mark_For_Review END AS bit) AS MarkForReview, 
						 CAST(CASE WHEN d .docnum IS NULL THEN 0 ELSE 1 END AS bit) AS HasDocument, 
						 ISNULL(d.docnum, 0) AS docnum, 
						 CAST(CASE WHEN f.findingnum IS NULL THEN 0 ELSE 1 END AS bit) AS HasDiscovery, 
						 ISNULL(f.findingnum, 0) AS findingnum, 
						 dbo.ANSWER.Assessment_Id, 
						 dbo.ANSWER.Answer_Id
FROM            dbo.ANSWER LEFT OUTER JOIN
                             (SELECT        Answer_Id, COUNT(Document_Id) AS docnum
                               FROM            dbo.DOCUMENT_ANSWERS
                               GROUP BY Answer_Id) AS d ON dbo.ANSWER.Answer_Id = d.Answer_Id LEFT OUTER JOIN
                             (SELECT        Answer_Id, COUNT(Finding_Id) AS findingnum
                               FROM            dbo.FINDING
                               GROUP BY Answer_Id) AS f ON dbo.ANSWER.Answer_Id = f.Answer_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_financial_attributes]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_financial_attributes]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	INSERT INTO [FINANCIAL_ASSESSMENT_VALUES]
			   ([Assessment_Id]
			   ,[AttributeName]
			   ,[AttributeValue])
	SELECT Assessment_Id = @Assessment_Id,a.AttributeName, isnull(AttributeValue, '') AttributeValue
	  FROM [FINANCIAL_ATTRIBUTES] a
		left join [FINANCIAL_ASSESSMENT_VALUES] v on a.AttributeName = v.AttributeName and v.Assessment_Id = @Assessment_Id
		where v.AttributeName is null

	select * from FINANCIAL_ASSESSMENT_VALUES where Assessment_Id = @Assessment_Id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ANSWER_ORDER]'
GO
CREATE TABLE [dbo].[ANSWER_ORDER]
(
[Answer_Text] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[answer_order] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ANSWER_ORDER] on [dbo].[ANSWER_ORDER]'
GO
ALTER TABLE [dbo].[ANSWER_ORDER] ADD CONSTRAINT [PK_ANSWER_ORDER] PRIMARY KEY CLUSTERED ([Answer_Text])
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
PRINT N'Creating [dbo].[ExcelExport]'
GO
CREATE VIEW [dbo].[ExcelExport]
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
				from MATURITY_QUESTIONS q 
				join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
				where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
					and g.Maturity_Model_Id=7 and Group_Level = 2
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
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary data for VADR report. 
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
                                                                join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
                                                                join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
                                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                                and a.Assessment_Id = @assessment_id and Is_Maturity = 1 --@assessment_id 
                                                                group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text
                                )m on a.Level_Name=m.Level_Name and a.Answer_Text=m.Answer_Text                         
                JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
                order by a.Level,o.answer_order

END
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
				from MATURITY_QUESTIONS q 
				join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
					and g.Maturity_Model_Id = 7 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 		
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	join ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getStandardSummaryOverall]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardSummaryOverall]
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
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)

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
PRINT N'Creating [dbo].[func_MQ]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all MATURITY_QUESTIONS rows applicable for an assessment.
--              If the assessment is using a "sub model", only the questions in the
--              sub model are returned.  Otherwise, all questions for the assessment's
--              model are returned.
-- =============================================
CREATE FUNCTION [dbo].[func_MQ]
(
	@assessmentId int
)
RETURNS 
@MQ TABLE 
(
	[Mat_Question_Id] [int] NOT NULL,
	[Question_Title] [nvarchar](250) NULL,
	[Question_Text] [nvarchar](max) NOT NULL,
	[Supplemental_Info] [nvarchar](max) NULL,
	[Category] [nvarchar](250) NULL,
	[Sub_Category] [nvarchar](250) NULL,
	[Maturity_Level_Id] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[Text_Hash]  [varbinary](20),
	[Maturity_Model_Id] [int] NOT NULL,
	[Parent_Question_Id] [int] NULL,
	[Ranking] [int] NULL,
	[Grouping_Id] [int] NULL,
	[Examination_Approach] [nvarchar](max) NULL,
	[Short_Name] [nvarchar](80) NULL,
	[Mat_Question_Type] [nvarchar](50) NULL,
	[Parent_Option_Id] [int] NULL,
	[Supplemental_Fact] [nvarchar](max) NULL,
	[Scope] [nvarchar](250) NULL,
	[Recommend_Action] [nvarchar](max) NULL,
	[Risk_Addressed] [nvarchar](max) NULL,
	[Services] [nvarchar](max) NULL,
	[Outcome] nvarchar(max) null,
	[Security_Practice] nvarchar(max) null,
	[Implementation_Guides] nvarchar(max) null
)
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
	end
	else
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
		and mat_question_id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end
	
	RETURN 
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vAllSimpleQuestions]'
GO
CREATE VIEW [dbo].[vAllSimpleQuestions]
AS
SELECT        AssessmentMode = 'question', q.Std_Ref_Id AS title, q.question_id AS CSETId, Simple_Question AS question
				,h.Question_Group_Heading AS Heading, h.Universal_Sub_Category AS SubHeading
FROM          NEW_QUESTION q JOIN
              vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
UNION
SELECT        AssessmentMode = 'requirement', r.Requirement_Title AS title, r.Requirement_Id AS CSETId, r.Requirement_Text AS question,
			  r.Standard_Category AS Heading, 
             r.Standard_Sub_Category AS SubHeading
FROM            REQUIREMENT_QUESTIONS_SETS s JOIN
                         NEW_REQUIREMENT r ON s.Requirement_Id = r.Requirement_Id
UNION
SELECT        AssessmentMode = 'maturity', Question_Title AS title, mat_question_id AS CSETId, Question_Text AS queestion, 
			  g.Title AS Heading, Question_Title AS SubHeading
FROM            MATURITY_QUESTIONS q JOIN
                         MATURITY_GROUPINGS g ON q.Grouping_Id = g.Grouping_Id JOIN
                         MATURITY_MODELS m ON q.Maturity_Model_Id = m.Maturity_Model_Id AND g.Maturity_Model_Id = m.Maturity_Model_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[func_AM]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all applicable rows from the ANSWER_MATURITY view.
--              If the assessment has a "sub model" defined, only the answers
--              for the sub model are returned.  Otherwise all maturity answers
--              are returned for the assessment.
-- =============================================
CREATE FUNCTION [dbo].[func_AM]
(	
	@assessmentId int
)
RETURNS  @AM TABLE (
	   [Answer_Id] int
      ,[Assessment_Id] int
      ,[Mark_For_Review] bit
      ,[Comment] nvarchar(max)
      ,[Alternate_Justification] varchar(2048)
      ,[Is_Requirement] bit
      ,[Question_Or_Requirement_Id] int
      ,[Question_Number] int
      ,[Answer_Text] nvarchar(50)
      ,[Component_Guid] uniqueidentifier
      ,[Is_Component] bit
      ,[Is_Framework] bit
      ,[Is_Maturity] bit
      ,[Custom_Question_Guid] nvarchar(50)
      ,[Old_Answer_Id] int
      ,[Reviewed] bit
      ,[FeedBack] nvarchar(2048)
      ,[Maturity_Level_Id] int
      ,[Question_Text] nvarchar(max))
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and Is_Maturity = 1
	end
	else
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and is_Maturity = 1 
		and Question_Or_Requirement_Id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end

	RETURN
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRRASummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummary]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)

	select a.Answer_Full_Name, a.Level_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from MATURITY_LEVELS, ANSWER_LOOKUP 
	where Maturity_Model_Id = 5 and answer_text in ('Y','N','U') ) a left join (
	SELECT l.Level_Name, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY Level_Name) AS Total
			FROM #AM a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			group by a.Assessment_Id, l.Maturity_Level_Id, l.Level_Name, a.Answer_Text)
			m on a.Level_Name = m.Level_Name and a.Answer_Text = m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Level,o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CF_Score_Averages]'
GO
-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	Averages of NCSF_V2 ordered by Category and Sub-category for CF reporting.
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_Score_Averages]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 --declare @Assessment_Id int
   select a.Standard_Category, a.Standard_Sub_Category, cast(Average as decimal(10, 2)) as Average, cast(AVG(Average) OVER(PARTITION BY a.standard_category) as decimal(10,2)) AS groupAvg, b.rseq from (
	select ta.Standard_Category, Standard_Sub_Category, avg(Adjusted_Answer_Value) as Average
	from ( 
		select *, case when temp.Answer_Value > 5 then (case when temp.Answer_Value = 6 then temp.Answer_Value - 0.5 else temp.Answer_Value - 1 end) else temp.Answer_Value end as Adjusted_Answer_Value from (
			select a.Assessment_Id, r.Standard_Category, r.Standard_Sub_Category, 
			cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as float) as Answer_Value
			from NEW_REQUIREMENT r 
			join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
			join ANSWER a on s.Requirement_Id = a.Question_Or_Requirement_Id and a.Is_Requirement = 1
			where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id
		) as temp
	) as ta
	group by Standard_Category, Standard_Sub_Category
) as a
join (
	select distinct Standard_Category,Standard_Sub_Category,min(requirement_sequence) rseq
	from NEW_REQUIREMENT r 
	join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
	where s.Set_Name = 'NCSF_V2'
	group by standard_category, standard_sub_category
) as b on a.Standard_Category = b.Standard_Category and a.Standard_Sub_Category = b.Standard_Sub_Category
order by rseq
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Assessments_For_User]'
GO

CREATE PROCEDURE [dbo].[usp_Assessments_For_User]
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
	LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	UseDiagram,
	UseStandard,
	UseMaturity,	
	workflow,
	SelectedMaturityModel = m.Model_Name,
	iseSubmitted = i.Ise_Submitted,
	submittedDate = i.Submitted_Date,
	SelectedStandards = string_agg(s.Short_Name, ', '),
	case when a.assessment_id in (select assessment_id from @ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		left join AVAILABLE_MATURITY_MODELS amm on amm.Assessment_Id = a.Assessment_Id
		left join MATURITY_MODELS m on m.Maturity_Model_Id = amm.model_id
		left join AVAILABLE_STANDARDS astd on astd.Assessment_Id = a.Assessment_Id
		left join SETS s on s.Set_Name = astd.Set_Name		
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
		where c.UserId = @User_Id
		group by a.Assessment_Id, Assessment_Name, Assessment_Date, AssessmentCreatedDate, 
					LastModifiedDate, mark_for_review, UseDiagram,
					UseStandard, UseMaturity, Workflow, Model_Name, 
					Ise_Submitted, Submitted_Date, c.UserId



					

					
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CF_Score_Overall]'
GO
-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	Averages of NCSF_V2 ordered by Category and Sub-category for CF reporting.
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_Score_Overall]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 --declare @Assessment_Id int
	 --set @Assessment_Id = 1020
   select avg(Answer_Value) as Average
	from ( 
		select a.Assessment_Id, r.Standard_Category, r.Standard_Sub_Category, 
		cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as float) as Answer_Value
		from NEW_REQUIREMENT r 
		join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
		join ANSWER a on s.Requirement_Id = a.Question_Or_Requirement_Id and a.Is_Requirement = 1
		where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id
	) as ta
	
END






GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRRASummaryOverall]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;
	
	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)

	
	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP 
	where answer_text in ('Y','N','U') ) a left join (
	SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM #AM a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text = m.Answer_Text		
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by o.answer_order

END



GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_INDEX_ANSWERS]'
GO
CREATE TABLE [dbo].[NCSF_INDEX_ANSWERS]
(
[Raw_Answer_Value] [int] NOT NULL,
[Display_Tag] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_INDEX_ANSWERS] on [dbo].[NCSF_INDEX_ANSWERS]'
GO
ALTER TABLE [dbo].[NCSF_INDEX_ANSWERS] ADD CONSTRAINT [PK_NCSF_INDEX_ANSWERS] PRIMARY KEY CLUSTERED ([Raw_Answer_Value])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CF_Questions]'
GO
-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	All questions and their scores
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_Questions]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select Standard_Category, Standard_Sub_Category, requirement_text, Requirement_Title, Answer_Value, Display_Tag from (
	select r.Standard_Category, r.Standard_Sub_Category, r.requirement_text, r.Requirement_Title, 	
	cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as int) as Answer_Value,
	s.requirement_sequence
	from NEW_REQUIREMENT r
	join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
	join ANSWER a on s.Requirement_Id = a.Question_Or_Requirement_Id and a.Is_Requirement = 1
	where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id) a
	join NCSF_INDEX_ANSWERS n on Answer_Value = n.Raw_Answer_Value
	order by Requirement_Sequence
	
End







GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRRASummaryByGoalOverall]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryByGoalOverall]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)

	
	select a.Title, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from #MG
		where Maturity_Model_Id = 5 and Group_Level = 2) a left join (
		SELECT g.Title, isnull(count(question_or_requirement_id),0) qc , SUM(count(Title)) OVER(PARTITION BY assessment_id) AS Total
			FROM #AM a 
			join (
				select q.Mat_Question_Id, g.* 
				from #MQ q join #MG g on q.Grouping_Id=g.Grouping_Id and q.Maturity_Model_Id=g.Maturity_Model_Id
				where g.Maturity_Model_Id=5 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id
			group by a.Assessment_Id, g.Title)
			m on a.Title=m.Title	
	order by a.Sequence

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRRASummaryByGoal]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryByGoal]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;

	--select Answer_Full_Name = N'Yes',Title=N'Robust Data Backup (DB)', Sequence=1, Answer_Text=N'Y',qc=0,Total=0,[Percent]=0	

	select * into #MQ from [dbo].[func_MQ](@assessment_id)
	select * into #AM from [dbo].[func_AM](@assessment_id)
	select * into #MG from MATURITY_GROUPINGS where grouping_id in (select grouping_id from #MQ)


	select a.Answer_Full_Name, a.Title, a.Grouping_Id, a.Sequence, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 	
	(select * from #MG, ANSWER_LOOKUP 
		where Maturity_Model_Id = 5 and answer_text in ('Y','N','U')  and Group_Level = 2) a left join (
		SELECT g.Title, g.Sequence, a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Answer_Text)) OVER(PARTITION BY Title) AS Total
			FROM #AM a 
			join (
				select q.Mat_Question_Id, g.* 
				from #MQ q join #MG g on q.Grouping_Id = g.Grouping_Id and q.Maturity_Model_Id = g.Maturity_Model_Id
				where g.Maturity_Model_Id = 5 and Group_Level = 2
			) g on a.Question_Or_Requirement_Id = g.Mat_Question_Id	
			group by a.Assessment_Id, g.Title, g.Sequence, a.Answer_Text)
			m on a.Title = m.Title and a.Answer_Text = m.Answer_Text
	JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by a.Sequence, o.answer_order

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[analytics_Compute_MaturitySampleSize]'
GO

-- =============================================
-- Author:		Mostafa, Randy
-- Create date: 11-12-2024
-- Description: Return Assessment count based on maturity model id and optional sector_id
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturitySampleSize]
@maturity_model_id int,
@sector_id int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--test base case where there is no data in db at all
SELECT SectorId, COUNT(Assessment_Id) AS AssessmentCount
FROM (
    SELECT dd.Assessment_Id, dd.IntValue as SectorId FROM DETAILS_DEMOGRAPHICS dd
    JOIN AVAILABLE_MATURITY_MODELS amm
    ON dd.Assessment_Id = amm.Assessment_Id
    WHERE amm.model_id = @maturity_model_id
    AND (@sector_id IS NULL OR (DataItemName = 'SECTOR' AND dd.IntValue = @sector_id))

    UNION

    SELECT d.Assessment_Id, d.SectorId FROM DEMOGRAPHICS d
    JOIN AVAILABLE_MATURITY_MODELS amm
    ON d.Assessment_Id = amm.Assessment_Id
    WHERE amm.model_id = @maturity_model_id
    AND (@sector_id IS NULL OR d.SectorId = @sector_id)
) AS CombinedResult
GROUP BY SectorId;
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getRRASummaryPage]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRRASummaryPage]	
@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getRRASummaryOverall] @assessment_id
	execute [dbo].[usp_getRRASummary] @assessment_id
	execute [dbo].[usp_getRRASummaryByGoal] @assessment_id
	execute [dbo].[usp_getRRASummaryByGoalOverall] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getVADRSummaryOverall]'
GO
-- =============================================
-- Author:                   Luke Galloway, Lilianne Cantillo
-- Create date: 5-17-2022
-- Description:             Gets the summary overall data for VADR report. 
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
                                                join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id --VADR uses all Levels, hence Level 1
                                                join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
                                                where q.Parent_Question_Id is null -- don't count child freeform text questions; they aren't answered y,n, etc.
                                                                and a.Assessment_Id = @assessment_id and Is_Maturity = 1 
                                                group by a.Assessment_Id, a.Answer_Text)
                                                m on a.Answer_Text=m.Answer_Text                            
                JOIN ANSWER_ORDER o on a.Answer_Text=o.answer_text
                order by o.answer_order

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
PRINT N'Creating [dbo].[usp_CF_ConvertLegacyFull]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 11/21/2023
-- Description:	does an upgrade of an assessment from a legacy to
-- a new full maturity index
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_ConvertLegacyFull]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- * update the answers for U to 0
	--* update the answers for N to 1
	--* update the answers for Y,A, NA to 2
	SET NOCOUNT ON;

    update ANSWER set Answer_Text = '0' where Assessment_Id = @assessment_id and Answer_Text = 'U' and question_type = 'Requirement'
	update ANSWER set Answer_Text = '1' where Assessment_Id = @assessment_id and Answer_Text = 'N' and question_type = 'Requirement'
	update ANSWER set Answer_Text = '2' where Assessment_Id = @assessment_id and Answer_Text in ('S','Y','NA','A') and question_type = 'Requirement'

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetComparisonFileOveralls]'
GO

CREATE PROCEDURE [dbo].[GetComparisonFileOveralls]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,StatType,isNull(Total,0) as Total, 
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],			
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 
		FROM 
		(
			select Assessment_Id, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer
					 where assessment_id=@assessment_Id
					 group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Requirements', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  		
				from (select t=1,ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text
					from answer 
					where Is_Requirement = 1 and assessment_id=@assessment_Id
					group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Questions', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 0 and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 	
			union
				select Assessment_Id,[StatType]='Components', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 1 and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
			union
				select Assessment_Id,[StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id) AS Total    
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Framework = 1  and assessment_id=@assessment_Id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[METRIC_ENTRY_QUESTIONS]'
GO
CREATE VIEW [dbo].[METRIC_ENTRY_QUESTIONS]
AS
select requirement_id as question_or_requirement_id ,'Requirement' as Question_type from NEW_REQUIREMENT 
where requirement_id in (36409, 36417, 36419, 36429, 36439, 36442, 36444, 36445, 36479, 36484, 36487, 36491, 36494, 36497, 36503)
union
select Mat_Question_Id as question_or_requirement_id,'Maturity' from MATURITY_QUESTIONS
where Mat_Question_Id in (1920, 1925, 1937, 1938, 1939)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[METRIC_COMPLETED_ENTRY]'
GO
CREATE VIEW [dbo].[METRIC_COMPLETED_ENTRY]
AS
select distinct assessment_id from (
select  *, sum(ac) over (partition by assessment_id) totalAC from (
select an.assessment_id, Answer_Text,count(answer_Text) ac, SUM(count(answer_Text)) OVER(partition by an.assessment_id) AS total_count
from assessments a 
join  ANSWER an on a.Assessment_Id=an.Assessment_Id
join METRIC_ENTRY_QUESTIONS q on an.Question_Or_Requirement_Id=q.question_or_requirement_id and an.Question_Type=q.question_type
where GalleryItemGuid = '9219F73D-A9EC-4E13-B884-CA1677BAC576'
group by an.assessment_id, Answer_Text) test
where total_count = 20 and Answer_Text <> 'U' ) partD
where totalAC = 20

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]'
GO
CREATE TABLE [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]
(
[Detail_Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CityOrSite] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Charter] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Model] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RegionCode] [int] NULL,
[CharterType] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_DETAIL_FILTER_DATA] on [dbo].[ASSESSMENT_DETAIL_FILTER_DATA]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DETAIL_FILTER_DATA] ADD CONSTRAINT [PK_ASSESSMENT_DETAIL_FILTER_DATA] PRIMARY KEY CLUSTERED ([Charter])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Get_Assess_Detail_Filter_Data]'
GO
CREATE PROCEDURE [dbo].[Get_Assess_Detail_Filter_Data]
   @model nvarchar(100) = ''

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT * FROM ASSESSMENT_DETAIL_FILTER_DATA WHERE Model = @model

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetComparisonFilePercentage]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[GetComparisonFilePercentage]
@Assessment_id int 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,Alias as [Name], StatType,isNull(Total,0) as Total, 
			isnull([Y],0) as [YesCount],			
			isnull([N],0) as [NoCount],
			isnull([NA],0) as [NaCount],
			isnull([A],0) as [AlternateCount],
			isnull([U],0) as [UnansweredCount],			
			Total as [TotalCount]
		FROM 
		(
			select b.Assessment_Id,af.Alias, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer
					where assessment_id = @assessment_id
					 group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
					join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id			
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;
end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetComparisonFileSummary]'
GO


CREATE PROCEDURE [dbo].[GetComparisonFileSummary]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,Alias as [Name], StatType,isNull(Total,0) as Total, 
			isnull([Y],0) as [YesCount],			
			isnull([N],0) as [NoCount],
			isnull([NA],0) as [NaCount],
			isnull([A],0) as [AlternateCount],
			isnull([U],0) as [UnansweredCount],			
			Total as [TotalCount]
		FROM 
		(
			select b.Assessment_Id,af.Alias, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer 
					where assessment_id = @assessment_id
					group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
					join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id
			union
				select b.Assessment_Id, af.Alias, [StatType]='Requirements', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  		
				from (select t=1,ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text
					from answer 
					where Is_Requirement = 1 and assessment_id = @assessment_id
					group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
					join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id
			union
				select b.Assessment_Id, af.Alias, [StatType]='Questions', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 0 and assessment_id = @assessment_id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 	
				join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id
			union
				select b.Assessment_Id, af.Alias,[StatType]='Components', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Requirement = 0 and Is_Component = 1 and assessment_id = @assessment_id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
				join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id
			union
				select b.Assessment_Id,af.Alias,[StatType]='Framework', isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total    
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw left join (select Assessment_Id, count(answer_text) as Acount, answer_text
				from answer 
				where Is_Framework = 1 and assessment_id = @assessment_id
				group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
				join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;

END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Assessments_Completion_For_Access_Key]'
GO




CREATE PROCEDURE [dbo].[usp_Assessments_Completion_For_Access_Key]
@accessKey varchar(20)
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

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseMaturity = 1 and mm.Maturity_Level_Usage_Type = 'Static'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and mm.Maturity_Level_Usage_Type = 'User_Selected'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

    
	-- special case for ISE
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id and asl.Level_Name = 'Maturity_Level'
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)


	-- special case for VADR
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestionsForVadr
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseMaturity = 1 and amm.model_id = 7
			and mq.Parent_Question_Id is null


	select a.Assessment_Id, q.question_Id into #AvailableQuestionBasedStandard
		from NEW_QUESTION q
			join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
			join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
			join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
			join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
			join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
			join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseStandard = 1 and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level


	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseStandard = 1 and rl.Standard_Level = usl.Universal_Sal_Level


	select a.Assessment_Id, q.Question_Id into #AvailableDiagramQuestions
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
			join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(DISTINCT(ans.Answer_Id))
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where ans.Answer_Text != 'U' 
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions amq
												where amq.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableQuestionBasedStandard aqbs
												where aqbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard arbs
												where arbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions ads
												where ads.Assessment_Id = a.Assessment_Id)
			OR
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse amqi
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amqi.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level = ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForVadr amqv 
												where amqv.Assessment_Id = a.Assessment_Id))
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = 0
		from ASSESSMENTS a
		join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
		WHERE a.Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
		

	--Maturity questions count (For maturity models with level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsWithLevels
		group by Assessment_Id


	--Total Maturity questions count (for maturity models without level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestions
		group by Assessment_Id


	--Total Maturity questions count for ISE available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForIse
		group by Assessment_Id
	

	--Total Maturity questions count for VADR available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForVadr
		group by Assessment_Id


	--Requirements based questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Requirement_Id))
		from #AvailableRequirementBasedStandard
		group by Assessment_Id


	--Questions based standards questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Question_Id))
		from #AvailableQuestionBasedStandard
		group by Assessment_Id
	

		--Total diagram questions count
	insert into @AssessmentTotalDiagramQuestionsCount
	select                  
		AssessmentId = a.Assessment_Id,
		TotalDiagramQuestionsCount = COUNT(ans.Answer_Id)
		from ANSWER ans
			join ASSESSMENTS a on a.Assessment_Id = ans.Assessment_Id
			join ACCESS_KEY_ASSESSMENT aka on a.Assessment_Id = aka.Assessment_Id and aka.AccessKey = @accessKey
			where a.UseDiagram = 1 and ans.Question_Type = 'Component'
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
PRINT N'Creating [dbo].[GetAnswerDistribMaturity]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 11 November 2022
-- Description:	Get a generic answer distribution for an assessment
--              without having to worry about which answers it supports.
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribMaturity]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- build list of answer options supported by the assessment's model
	declare @ao varchar(20)
	select @ao = answer_options
	from maturity_models mm
	left join AVAILABLE_MATURITY_MODELS amm on mm.Maturity_Model_Id = amm.model_id
	where amm.Assessment_Id = @assessment_id

	select * into #ao from STRING_SPLIT(@ao, ',')
	insert into #ao (value) values ('U')
	update #ao set value = TRIM(value)


	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP where Answer_Text in (select value from #ao)) a left join (
SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM Answer_Maturity a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text = m.Answer_Text		
	LEFT JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by o.answer_order

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetCompatibilityCounts]'
GO
CREATE PROCEDURE [dbo].[GetCompatibilityCounts]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;
	
		select a.IntersectionType, CommonValues, Total, (cast(CommonValues as float)/Total)*100 as Compatibility from (
			select IntersectionType,count(Question_or_Requirement_Id) as CommonValues from (
				SELECT IntersectionType='Question', Question_Or_Requirement_Id,count(Assessment_Id) as inFiles
				FROM dbo.Answer_Questions where assessment_id = @assessment_id
				group by Question_Or_Requirement_Id
				having count(Assessment_Id) = (select count(af.Assessment_Id) from ASSESSMENT_FILES af)
				union
				SELECT IntersectionType='Requirement', Question_Or_Requirement_Id,count(Assessment_Id) as inFiles
				FROM dbo.Answer_Requirements where assessment_id = @assessment_id
				group by Question_Or_Requirement_Id
				having count(Assessment_Id) = (select count(af.Assessment_Id) from ASSESSMENT_FILES af)				
				) c
				group by IntersectionType
		  ) a join (		
		select case Is_Requirement
					WHEN 1 THEN 'Requirement'
					ELSE 'Question' 
			END   as IntersectionType,
			COUNT(Is_Requirement) as Total
			FROM (select distinct Is_Requirement,Question_or_Requirement_id from [dbo].[ANSWER] where assessment_id = @assessment_id) a
		  group by Is_Requirement) b on a.IntersectionType = b.IntersectionType



END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAreasData]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetAreasData]		
@Assessment_Id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @Assessment_Id, @ApplicationMode output

	if(@Assessment_Id is null)  
	begin
		declare @ghq nvarchar(150)
		set @ghq = 'Access Control'
		 select [Assessment_id]=0,Question_Group_Heading=@ghq,    AreasPercent= 0.200000000, Assessment_Date=GETDATE()
		 union
		 select [Assessment_id]=0,Question_Group_Heading='Account Management',AreasPercent= 0.200000000, Assessment_Date=GETDATE()
	end

	if(@ApplicationMode = 'Questions Based')
	begin					
		select [Assessment_Id],[question_group_heading], answer_text,count(answer_text) ac into #TempStats2 from Answer_Questions join 
		(SELECT q.[Question_Id],h.[Question_Group_Heading],[Universal_Sal_Level],s.[Set_Name]
		  FROM NEW_QUESTION q 
		  join NEW_QUESTION_SETS s on q.Question_Id=s.Question_Id
		  join vQuestion_Headings h on q.Heading_Pair_Id=h.heading_pair_Id
		  join (select distinct [Set_Name] from available_standards where selected = 1 and Assessment_Id=@Assessment_Id) a on s.Set_Name=a.Set_Name) main 
		  on answer_questions.question_or_requirement_id = main.Question_Id
		  group by [assessment_id],[question_group_heading],[Answer_Text]

		  
		--YesCount + AlternateCount, TotalCount - NaCount
		select b.[assessment_id], b.question_group_heading, i.Assessment_Date, 
		 (isnull(cast(ynalt as decimal),0)/cast(total as decimal))*100 as AreasPercent from(
		select question_group_heading, sum(ac) as ynalt from #TempStats2
		where answer_text in ('Y','A') and Assessment_Id = @Assessment_Id
		group by question_group_heading) a right join 
		(select question_group_heading, sum(ac) as total    from #TempStats2
		where answer_text not in ('NA') and Assessment_Id = @Assessment_Id
		group by question_group_heading) b on a.Question_Group_Heading = b.question_group_heading
		join INFORMATION i on b.assessment_id = i.id
	end 
	else --- this is either framework or requirement
	begin		
		select [question_group_heading], answer_text,count(answer_text) ac into #TempStats from Answer_Requirements join 
		(SELECT q.[Requirement_Id],[Question_Group_Heading],s.[Set_Name]
		  FROM NEW_REQUIREMENT q join REQUIREMENT_SETS s on q.Requirement_Id=s.Requirement_Id
		  join QUESTION_GROUP_HEADING qgh on q.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
		  join (select distinct [Set_Name] from available_standards where selected = 1) a on s.Set_Name=a.Set_Name) main on answer_Requirements.question_or_requirement_id = main.requirement_id
		  where answer_requirements.assessment_id = @Assessment_Id
		  group by [question_group_heading],[Answer_Text]

		--YesCount + AlternateCount, TotalCount - NaCount
		select b.question_group_heading,i.Assessment_Date, 
		 (isnull(cast(ynalt as decimal),0)/cast(total as decimal))*100 as AreasPercent from(
		select question_group_heading, sum(ac) as ynalt from #Tempstats
		where answer_text in ('Y','A') and assessment_id = @Assessment_Id
		group by question_group_heading) a right join 
		(select question_group_heading, sum(ac) as total from #TempStats
		where answer_text not in ('NA')
		group by question_group_heading) b on a.Question_Group_Heading = b.question_group_heading
		join INFORMATION i on b.assessment_Id = i.Id
	end

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAnswerDistribGroupings]'
GO

-- =============================================
-- Author:		Randy Woods
-- Create date: 15 November 2022
-- Description:	Tallies answer counts for all maturity groupings
--              at the top level.  
--              TODO:  What if we want to target the children of a 
--              specific grouping?  g.Parent_Id = X
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribGroupings] 
	@assessmentId int,
	@modelId int = null
AS
BEGIN
	SET NOCOUNT ON;
	exec FillEmptyMaturityQuestionsForAnalysis @assessmentId

	-- get the main model ID for the assessment
	declare @maturityModelId int = (select model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId)

	-- if the caller specified a model ID, use that instead
	if @modelId is not null 
	BEGIN
		select @maturityModelId = @modelId
	END

	select [grouping_id], [title], [answer_text], count(answer_text) as [answer_count]
	from (
		select g.grouping_id, g.title, g.sequence, a.Answer_Text
		from maturity_groupings g 
		left join maturity_questions q on q.grouping_id = g.Grouping_Id
		left join ANSWER a on a.Question_Or_Requirement_Id = q.Mat_Question_Id
		where a.Assessment_Id = @assessmentId and g.Parent_Id is null and 
		g.maturitY_model_id = @maturityModelId
	) N
	group by n.answer_text, n.grouping_id, n.title, n.Sequence
	order by n.Sequence
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetAreasOverall]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetAreasOverall]		
@Assessment_Id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output
	if(@Assessment_Id is null)  
	begin
		declare @ghq nvarchar(150)
		set @ghq = 'Access Control'
		declare @value float 
		set @value = 1.0001;
		SELECT Question_group_heading=@ghq,Total=0, 
					[Y] = 0,
					[YValue] = @value,
					[N] = 0,
					[NValue] = @value,
					[NA] = 0,
					[NAValue] = @value,
					[A] = 0,
					[AValue] = @value,
					[U] = 0,
					[UValue] = @value,
					Value = @value,
					TotalNoNA = 0 
	end

	
	if(@ApplicationMode = 'Questions Based')	
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						isnull([Y],0) as [Y],
						isnull(cast([Y] as float)/isnull(nullif(Total-[NA],0),1),0) as [YValue],
						isnull([N],0) as [N],
						isnull(cast([N] as float)/isnull(nullif(Total-[NA],0),1),0) as [NValue],
						isnull([NA],0) as [NA],
						isnull(cast([NA] as float)/nullif(Total,1),0) as [NAValue],
						isnull([A],0) as [A],
						isnull(cast([A] as float)/isnull(nullif(Total-[NA],0),1),0) as [AValue],
						isnull([U],0) as [U],
						isnull(cast([U] as float)/isnull(nullif(Total-[NA],0),1),0) as [UValue],
						(cast((isnull([Y],0)+isnull([A],0)) as float)/isnull(nullif(Total-isnull([NA],0),0),1))*100 as Value,
						isnull(cast(isnull(Total-isnull([NA],0),0) as int),0) as TotalNoNA 
			from
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, isnull(count(a.question_or_requirement_id),0) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Questions] where assessment_id = @Assessment_Id)  a   
				  join (select Question_Or_Requirement_Id from answer_Questions where assessment_Id = @Assessment_Id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
				   join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
				   group by Question_Group_Heading, Answer_Text			   
	   ) p
			PIVOT
			(
			sum(acount)
			FOR Answer_Text IN
			( [Y],[N],[NA],[A],[U] )
			) AS pvt
			ORDER BY question_group_heading;
	else
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						isnull([Y],0) as [Y],
						isnull(cast([Y] as float)/isnull(nullif(Total-[NA],0),1),0) as [YValue],
						isnull([N],0) as [N],
						isnull(cast([N] as float)/isnull(nullif(Total-[NA],0),1),0) as [NValue],
						isnull([NA],0) as [NA],
						isnull(cast([NA] as float)/nullif(Total,1),0) as [NAValue],
						isnull([A],0) as [A],
						isnull(cast([A] as float)/isnull(nullif(Total-[NA],0),1),0) as [AValue],
						isnull([U],0) as [U],
						isnull(cast([U] as float)/isnull(nullif(Total-[NA],0),1),0) as [UValue],
						(cast((isnull([Y],0)+isnull([A],0)) as float)/isnull(nullif(Total-isnull([NA],0),0),1))*100 as Value,
						isnull(cast(isnull(Total-isnull([NA],0),0) as int),0) as TotalNoNA 
			FROM 
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Requirements] where assessment_id = @Assessment_Id)  a   
				  join (select Question_Or_Requirement_Id from answer_Requirements where assessment_id = @Assessment_Id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
				   join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id=h.Question_Group_Heading_Id
				   group by Question_Group_Heading, Answer_Text			   
	   ) p
			PIVOT
			(
			sum(acount)
			FOR Answer_Text IN
			( [Y],[N],[NA],[A],[U] )
			) AS pvt
			ORDER BY question_group_heading;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[convert_sal_short]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 10/10/2019
-- Description:	function to convert the SAL from 
-- word to letter or vice versa
-- =============================================
CREATE FUNCTION [dbo].[convert_sal_short]
(
	@SAL nvarchar(10)
)
RETURNS nvarchar(10)
AS
BEGIN
	declare @rval nvarchar(10)
	
	select @rval = UNIVERSAL_SAL_LEVEL from UNIVERSAL_SAL_LEVEL where Full_Name_Sal = @SAL;	
	if (@rval is null)
			return @SAL	

	RETURN @rval;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getExplodedComponent]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getExplodedComponent]
	-- Add the parameters for the stored procedure here
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) as UniqueKey,
	a.Assessment_Id, b.Answer_Id, a.Question_Id, isnull(b.Answer_Text, c.Answer_Text) as Answer_Text, 
	CONVERT(nvarchar(1000), b.Comment) AS Comment, CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification, 
	b.FeedBack,
	b.Question_Number, a.Simple_Question AS QuestionText, 	
	a.label AS ComponentName, a.Symbol_Name, 
	a.Question_Group_Heading, a.GroupHeadingId, 
	a.Universal_Sub_Category, a.SubCategoryId, 
	isnull(b.Is_Component,1) as Is_Component, a.Component_Guid, 
	a.Layer_Id, a.LayerName, a.Container_Id, 
	a.ZoneName, dbo.convert_sal(a.SAL) as SAL, 
	b.Mark_For_Review, Is_Requirement=cast(0 as bit), Is_Framework=cast(0 as bit),
	b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description, a.heading_pair_id, a.label, a.Component_Symbol_Id
from (
SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	adc.Assessment_Id, q.Question_Id, q.Simple_Question,
	adc.label, adc.Component_Symbol_Id, 
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
	z.Name AS ZoneName,  dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
	h.Sub_Heading_Question_Description,h.Heading_Pair_Id, cs.Symbol_Name
from	 ASSESSMENT_DIAGRAM_COMPONENTS AS adc
			join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
			join COMPONENT_QUESTIONS AS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id			
			join COMPONENT_SYMBOLS as cs on adc.Component_Symbol_Id = cs.Component_Symbol_Id
            join NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 			
            join DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id  
            left join DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id and adc.Assessment_Id=adc.Assessment_Id
			join (select s.*,nql.Universal_Sal_Level from NEW_QUESTION_SETS s
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id
			where set_name = 'Components' ) s on q.Question_Id = s.Question_Id and s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))		
			left join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id
			left join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		 
WHERE l.Visible = 1 and adc.Assessment_Id = @assessment_id) a left join Answer_Components AS b on a.Question_Id = b.Question_Or_Requirement_Id and a.Assessment_Id = b.Assessment_Id and a.component_guid = b.component_guid
left join (SELECT a.Assessment_Id, q.Question_Id, a.Answer_Text		
from   (SELECT distinct q.question_id,adc.assessment_id
				FROM [ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'						
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)) as f  
            join NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 			
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000') c on a.Assessment_Id=c.Assessment_Id and a.Question_Id = c.Question_Id
end 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetCombinedOveralls]'
GO
CREATE PROCEDURE [dbo].[GetCombinedOveralls]	
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
	create table #componentAnswers (UniqueKey int, Assessment_Id int, Answer_Id int, Question_Id int, Answer_Text nvarchar(50), Comment nvarchar(2048),
		Alternate_JustificaTion ntext, FeedBack nvarchar(2048), Question_Number int, QuestionText nvarchar(4000), ComponentName nvarchar(200), Symbol_Name nvarchar(100),
		Question_Group_Heading nvarchar(250), GroupHeadingId int, Universal_Sub_Category nvarchar(100), SubCategoryId int, Is_Component bit, Component_Guid uniqueidentifier,
		Layer_Id int, LayerName nvarchar(250),Container_Id int, ZoneName nvarchar(250), SAL nvarchar(20), Mark_For_Review bit, Is_Requirement bit,
		Is_Framework bit, Reviewed bit, Simple_Question nvarchar(4000), Sub_Heading_Question_Description nvarchar(200), heading_pair_id int,
		label nvarchar(200), Component_Symbol_Id int)
	insert into #componentAnswers exec [usp_getExplodedComponent] @assessment_id



	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '#assessmentAnswers')
		drop table #asessmentAnswers;
	create table #assessmentAnswers (answer_text nvarchar(50), assessment_id int, is_requirement bit, is_component bit, is_framework bit)


	-- Populate #assessmentAnswers from the correct source table
	declare @applicationMode nvarchar(50)
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
PRINT N'Creating [dbo].[FillNetworkDiagramQuestions]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 9/27/2019
-- Description:	calll to get defaults
-- =============================================
CREATE PROCEDURE [dbo].[FillNetworkDiagramQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

	  delete a from ANSWER a 
		left join (SELECT distinct q.question_id 
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
				join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id
				join new_question_sets qs on nq.question_id=qs.question_id		
				left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
				where a.assessment_id = @assessment_id and qs.Set_Name = 'Components') b on a.Question_Or_Requirement_Id = b.Question_Id and a.Assessment_Id = @assessment_id
		where b.Question_Id is null and Question_Type='Component' and Assessment_Id = @assessment_id 

    /*Rules for Component questions
	For the default questions 
	select the set of component types and questions associated with the component types
	then insert an answer for each unique question in that list. 
	this needs filterd for level

	the major dimensions are 
	*/
	--generate defaults 
	INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id],[Answer_Text],[Question_Type],[Assessment_Id])   	  		
		select Question_id, Answer_Text = 'U', Question_Type='Component', Assessment_Id = @Assessment_Id 
		from (select * from [ANSWER] where [Assessment_Id] = @assessment_id and Question_Type='Component') a 		
		right join 
		(SELECT distinct q.question_id 
		FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
		join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
		join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
		join new_question nq on q.question_id=nq.question_id
		join new_question_sets qs on nq.question_id=qs.question_id		
		left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
		join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
		where a.assessment_id = @assessment_id and qs.Set_Name = 'Components'
		) t 		
		on a.Question_Or_Requirement_Id = t.question_id
		where assessment_id is null
		--and Question_Or_Requirement_Id not in 
		--(select [Question_Or_Requirement_Id] from [ANSWER] where [Assessment_Id] = @assessment_id and [Component_Guid] = CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER))
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetComparisonAreasFile]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	Areas for next
-- =============================================
CREATE PROCEDURE [dbo].[GetComparisonAreasFile]		
@assessment_id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	if(@assessment_id is null)  
	begin
		declare @ghq nvarchar(150), @alias nvarchar(255)
		set @ghq = 'Access Control'
		set @alias = 'Test'
		SELECT Alias=@alias,Question_group_heading=@ghq,Total=0, 
					[Y]=cast(1.0000001 as float),
					[N]=cast(1.0000001 as float),
					[NA]=cast(1.0000001 as float),
					[A]=cast(1.0000001 as float),
					[U]=cast(1.0000001 as float),
					Value=cast(1.0000001 as float),
					TotalNoNA=0 
	end

	if(@ApplicationMode = 'Questions Based')
		SELECT Question_group_heading,isNull(Total,0) as Total, 
						cast(IsNull(cast(([Y]) as float)/isnull(nullif(Total,0),1),0) as float) as [Y],
						cast(IsNull(cast(([N]) as float)/isnull(nullif(Total,0),1),0) as float) as [N],
						cast(IsNull(cast(([NA]) as float)/isnull(nullif(Total,0),1),0) as float) as [NA],
						cast(IsNull(cast(([A]) as float)/isnull(nullif(Total,0),1),0) as float) as [A],
						cast(IsNull(cast(([U]) as float)/isnull(nullif(Total,0),1),0) as float) as [U],					
						cast(isnull([Y],0)+isnull([A],0) as float)/cast(isnull(nullif(Total-isnull([NA],0),0),1) as float) as Value, 										
						(Total-isnull([NA],0)) as TotalNoNA 
			FROM 
			(
				SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
				  FROM (select * from [ANSWER_Questions] where assessment_id = @assessment_id) a   
				  join (select Question_Or_Requirement_Id from answer_questions where assessment_id = @assessment_id) b
				   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
				   join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
				   join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_id
				   join ASSESSMENTS f on a.assessment_id=f.Assessment_Id
				   group by Question_Group_Heading, Answer_Text
	   ) p
			PIVOT
			(
			sum(acount)
			FOR Answer_Text IN
			( [Y],[N],[NA],[A],[U] )
			) AS pvt
			ORDER BY question_group_heading;
	else--this is requirement and framework
			SELECT Question_group_heading,isNull(Total,0) as Total, 
						cast(IsNull(cast(([Y]) as float)/isnull(nullif(Total,0),1),0) as float) as [Y],
						cast(IsNull(cast(([N]) as float)/isnull(nullif(Total,0),1),0) as float) as [N],
						cast(IsNull(cast(([NA]) as float)/isnull(nullif(Total,0),1),0) as float) as [NA],
						cast(IsNull(cast(([A]) as float)/isnull(nullif(Total,0),1),0) as float) as [A],
						cast(IsNull(cast(([U]) as float)/isnull(nullif(Total,0),1),0) as float) as [U],					
						cast(isnull([Y],0)+isnull([A],0) as float)/cast(isnull(nullif(Total-isnull([NA],0),0),1) as float) as Value, 										
						(Total-isnull([NA],0)) as TotalNoNA 
		FROM 
		(
			SELECT h.Question_Group_Heading,a.Answer_Text, count(a.question_or_requirement_id) as acount, SUM(count(a.question_or_requirement_id)) OVER(PARTITION BY h.question_group_heading) AS Total  
			  FROM (select * from [answer_requirements] where assessment_Id=@assessment_id)  a   
			  join (select Question_Or_Requirement_Id from answer_requirements where assessment_id =@assessment_id) b
			   on a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id
			   join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_id
			   join QUESTION_GROUP_HEADING h on h.Question_Group_Heading_Id = c.Question_Group_Heading_Id
			   join ASSESSMENTS f on a.assessment_id=f.Assessment_Id
			   group by Question_Group_Heading, Answer_Text
   ) p
		PIVOT
		(
		sum(acount)
		FOR Answer_Text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		ORDER BY question_group_heading;

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetComparisonBestToWorst]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	NOTE that this needs to be changed
-- to allow for mulitple asssessments just by 
-- passing mulitple id's 
-- =============================================
CREATE PROCEDURE [dbo].[GetComparisonBestToWorst]	
@assessment_id int,
@applicationMode nvarchar(100) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if((@applicationMode is null) or (@applicationMode = ''))
		exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@ApplicationMode = 'Questions Based')
		SELECT assessment_id,
		AssessmentName = Alias,                
		Name = Question_Group_Heading,
		AlternateCount = [A],
		AlternateValue = Round(((cast(([A]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NaCount = [NA],
		NaValue = Round(((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100),2),
		NoCount = [N],
		NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		TotalCount = Total,
		TotalValue = Total,
		UnansweredCount = [U],
		UnansweredValue = Round(cast([U] as float)/Total*100,2),
		YesCount = [Y],
		YesValue =  Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value = Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.assessment_id, f.Alias, b.Question_Group_Heading, b.Answer_Text, isnull(c.Value,0) as Value, Total = sum(c.Value) over(partition by b.assessment_id,b.question_group_heading)
			from 
			 (select distinct Assessment_Id, Question_Group_Heading, l.answer_Text
			from answer_lookup l, (select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a 
			join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join vQuestion_Headings h on q.Heading_Pair_Id = h.heading_pair_id
			) b left join 
			(select Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from ANSWER_QUESTIONS where assessment_id = @assessment_id) a 
				join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
				join vQuestion_Headings h on q.Heading_Pair_Id = h.heading_pair_id
			 group by Assessment_Id, Question_Group_Heading, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Question_Group_Heading = c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p
		PIVOT
		(
			sum(value)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
	else-----------------------------------------requirements and framework side
		SELECT Assessment_Id,
		AssessmentName = Alias,                
		Name = Question_Group_Heading,
		AlternateCount = [A],
		AlternateValue = Round(((cast(([A]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NaCount = [NA],
		NaValue = Round(((cast(([NA]) as float)/isnull(nullif(Total,0),1)))*100,2),
		NoCount = [N],
		NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		TotalCount = Total,
		TotalValue = Total,
		UnansweredCount = [U],
		UnansweredValue = Round(cast([U] as float)/Total*100,2),
		YesCount = [Y],
		YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		Value = Round(((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif((Total-[NA]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id, f.Alias, b.Question_Group_Heading, b.Answer_Text, isnull(c.Value,0) as Value, Total = sum(c.Value) over(partition by b.Assessment_Id, b.question_group_heading)			
			from 
			 (select distinct a.[Assessment_Id], h.Question_Group_Heading, l.answer_Text
			from answer_lookup l, (select * from Answer_Requirements where assessment_id = @assessment_id) a 
			join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id
			join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id = h.Question_Group_Heading_Id
			) b left join 
			(select a.Assessment_Id, Question_Group_Heading, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Requirements where assessment_id = @assessment_id) a 
				join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id
				join QUESTION_GROUP_HEADING h on q.Question_Group_Heading_Id = h.Question_Group_Heading_Id
			 group by Assessment_Id, Question_Group_Heading, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Question_Group_Heading = c.Question_Group_Heading and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p
		PIVOT
		(
			sum(value)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Assessments_For_User]'
GO





CREATE VIEW [dbo].[Assessments_For_User]
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
PRINT N'Creating [dbo].[requirement_final_moves]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[requirement_final_moves]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = s.weight from(
	SELECT r.Requirement_Id,nq.Weight
	  FROM 
	  QUESTION_REQUIREMENT_SUPPLEMENTAL r 
	  join REQUIREMENT_QUESTIONS_SETS rq on r.Requirement_Id=rq.Question_Id
	  join NEW_QUESTION nq on rq.Question_Id = nq.Question_Id
	  ) s
	  where QUESTION_REQUIREMENT_SUPPLEMENTAL.Requirement_Id = s.requirement_id

	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight = 0;
	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight is null;
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[View_Alts]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
		DROP TABLE [dbo].[View_Alts]
		
select distinct a.Requirement_Id,r.Question_Id,a.Top_U,b.User_Number,b.Top_Answer_User_Number,Alt_Text into dbo.VIEW_ALTS from 
	(SELECT Top_U,ru.User_Number,ru.REQUIREMENT_id,ru.Is_Alt
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  where Is_Alt = 0
	  ) a
	join (
	SELECT Requirement_Title,Top_U,ru.User_Number,ru.Top_Answer_User_Number, ru.REQUIREMENT_id,ru.Is_Alt,ru.Alt_Text
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  join QUESTION_REQUIREMENT_SUPPLEMENTAL r on ru.Requirement_Id = r.Requirement_Id  
	where Is_Alt=1) b on a.Requirement_Id = b.Requirement_Id
	join REQUIREMENT_QUESTIONS_SETS r on a.Requirement_Id = r.Requirement_Id
	
	
ALTER TABLE [dbo].[VIEW_ALTS] ADD CONSTRAINT [PK_VIEW_ALTS] PRIMARY KEY CLUSTERED  ([Requirement_Id], [Question_Id], [Top_U], [User_Number])

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getCSETQuestionsForCRRM]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/15/2023
-- Description:	gets the general questions regardless of maturity,new_question,or new_requirement
-- =============================================

--exec usp_getCSETQuestionsForCRRM 'SD02 Series'
CREATE PROCEDURE [dbo].[usp_getCSETQuestionsForCRRM]
	-- Add the parameters for the stored procedure here
	@setname varchar(100)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select AssessmentMode='question', q.Std_Ref_Id as title ,   q.question_id as Id,Simple_Question as question
	,r.Supplemental_Info as Info
	,h.Question_Group_Heading as Heading,h.Universal_Sub_Category as SubHeading,Set_Name as SetName, IsComplete=cast(0 as bit), CRRMId = 0
	from NEW_QUESTION q 
	join REQUIREMENT_QUESTIONS_SETS s on q.Question_Id=s.Question_Id
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id=h.Heading_Pair_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='requirement', r.Requirement_Title as title,  r.Requirement_Id as Id, r.Requirement_Text as question,r.Supplemental_Info as Info,r.Standard_Category as Heading,r.Standard_Sub_Category as SubHeading,s.Set_Name as setname , IsComplete=cast(0 as bit), CRRMId = 0
	from REQUIREMENT_QUESTIONS_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='maturity', Question_Title as title, mat_question_id as Id ,Question_Text as queestion,Supplemental_Info as Info,g.Title as Heading, Question_Title as SubHeading, m.Model_Name as setname, IsComplete=cast(0 as bit), CRRMId = 0
	from MATURITY_QUESTIONS q 
	join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id
	join MATURITY_MODELS m on q.Maturity_Model_Id=m.Maturity_Model_Id and g.Maturity_Model_Id=m.Maturity_Model_Id
	where m.Model_Name = @setname
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_Answer_Components_Default]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Answer_Components_Default]
	-- Add the parameters for the stored procedure here
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT                   
		-- This guarantees a unique column to key on in the model
		cast(ROW_NUMBER() OVER (ORDER BY q.Question_id)as int) as UniqueKey,
		a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
		CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
		a.Question_Number, q.Simple_Question AS QuestionText, 		
		h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
		h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
		a.FeedBack,
		a.Is_Component, a.Component_Guid, 
		dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
		a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,	
		q.heading_pair_id, h.Sub_Heading_Question_Description,
		q.Simple_Question, 
		a.Reviewed, label = null, ComponentName = null, Symbol_Name = null, Component_Symbol_id = 0
	from   STANDARD_SELECTION ss
			 join 
			 (SELECT distinct q.question_id,adc.assessment_id
					FROM [ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
					join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
					join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
					join new_question nq on q.question_id=nq.question_id		
					join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
					join DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
					left join DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
					join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
						and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
					where l.visible = 1) as f  on ss.assessment_id=f.assessment_id							
				join NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 
				join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
				join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
				join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
	where component_guid = '00000000-0000-0000-0000-000000000000' and a.Assessment_Id = @assessment_id
	order by Question_Group_Heading,Universal_Sub_Category
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getAnswerComponentOverrides]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getAnswerComponentOverrides]
	@assessment_id int
AS
BEGIN
	IF OBJECT_ID('tempdb..##componentExploded') IS NOT NULL DROP TABLE #componentExploded
	create table #componentExploded (UniqueKey int, Assessment_Id int, Answer_Id int, Question_Id int, Answer_Text nvarchar(50), Comment nvarchar(2048),
		Alternate_JustificaTion ntext, FeedBack nvarchar(2048), Question_Number int, QuestionText nvarchar(4000), ComponentName nvarchar(200), Symbol_Name nvarchar(100),
		Question_Group_Heading nvarchar(250), GroupHeadingId int, Universal_Sub_Category nvarchar(100), SubCategoryId int, Is_Component bit, Component_Guid uniqueidentifier,
		Layer_Id int, LayerName nvarchar(250),Container_Id int, ZoneName nvarchar(250), SAL nvarchar(20), Mark_For_Review bit, Is_Requirement bit,
		Is_Framework bit, Reviewed bit, Simple_Question nvarchar(4000), Sub_Heading_Question_Description nvarchar(200), heading_pair_id int,
		label nvarchar(200), Component_Symbol_Id int)
	insert into #componentExploded exec [usp_getExplodedComponent] @assessment_id

	SELECT [UniqueKey]
      ,[Assessment_Id]
      ,[Answer_Id]
      ,[Question_Id]
      ,[Answer_Text]
      ,[Comment]
      ,[Alternate_Justification]
      ,[Question_Number]
      ,[QuestionText]
      ,[ComponentName]
      ,[Symbol_Name]
      ,[Question_Group_Heading]
      ,[GroupHeadingId]
      ,[Universal_Sub_Category]
      ,[SubCategoryId]
      ,[Is_Component]
      ,[Component_Guid]
      ,[Layer_Id]
      ,[LayerName]
      ,[Container_Id]
      ,[ZoneName]
      ,[SAL]
      ,[Mark_For_Review]
      ,[Is_Requirement]
      ,[Is_Framework]
      ,[Reviewed]
      ,[Simple_Question]
      ,[Sub_Heading_Question_Description]
      ,[heading_pair_id]
      ,[label]
      ,[Component_Symbol_Id]
	  ,[FeedBack]
  FROM #componentExploded where Answer_Id is not null

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[changeEmail]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[changeEmail]
	@originalEmail nvarchar(200),
	@newEmail nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists (select * from users where PrimaryEmail = @newEmail)
		update USERS set PrimaryEmail = @newEmail where PrimaryEmail = @originalEmail
	--if we can't update then we can't update
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[clean_out_requirements_mode]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[clean_out_requirements_mode]
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
PRINT N'Creating [dbo].[final_data_moves]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[final_data_moves]	
AS
BEGIN
	
	SET NOCOUNT ON;

    insert NEW_QUESTION_SETS (Set_Name,Question_Id)
	SELECT distinct 'Standards',QUESTION_id FROM NEW_QUESTION_sets where Set_Name !='Components';
	
	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Default_Standard_Level = 0 where default_standard_level is null;
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetMaturityGroupings]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityGroupings]
	@ModelID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
select 
g1.grouping_id as [Group1_ID], g1.title as [Group1_Title], (select grouping_type_name from maturity_grouping_types where type_id = g1.Type_Id) as [Group1_Type], 
g2.grouping_id as [Group2_ID], g2.title as [Group2_Title], (select grouping_type_name from maturity_grouping_types where type_id = g2.Type_Id) as [Group2_Type], 
g3.grouping_id as [Group3_ID], g3.title as [Group3_Title], (select grouping_type_name from maturity_grouping_types where type_id = g3.Type_Id) as [Group3_Type], 
g4.grouping_id as [Group4_ID], g4.title as [Group4_Title], (select grouping_type_name from maturity_grouping_types where type_id = g4.Type_Id) as [Group4_Type], 
g5.grouping_id as [Group5_ID], g5.title as [Group5_Title], (select grouping_type_name from maturity_grouping_types where type_id = g5.Type_Id) as [Group5_Type] 
from maturity_groupings g1
left join maturity_groupings g2 on g2.parent_id = g1.grouping_id
left join maturity_groupings g3 on g3.parent_id = g2.grouping_id
left join maturity_groupings g4 on g4.parent_id = g3.grouping_id
left join maturity_groupings g5 on g5.parent_id = g4.grouping_id
where g1.maturity_model_id = @modelid 
and g1.Parent_Id is null
and (g2.Maturity_Model_Id = @modelid or g2.Maturity_Model_Id is null)
and (g3.Maturity_Model_Id = @modelid or g3.Maturity_Model_Id is null)
and (g4.Maturity_Model_Id = @modelid or g4.Maturity_Model_Id is null)
and (g5.Maturity_Model_Id = @modelid or g5.Maturity_Model_Id is null)
order by g1.sequence, g2.sequence, g3.sequence, g4.sequence, g5.sequence

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Get_Recommendations]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Recommendations]
	-- Add the parameters for the stored procedure here
	@value int, @industry int, @organization nvarchar(50) ,@assetvalue nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	


select distinct set_name from SECTOR_STANDARD_RECOMMENDATIONS
where Sector_Id = isnull(@value,sector_id) and Industry_Id = isnull(@industry,industry_id) and Organization_Size = isnull(@organization, Organization_Size) and Asset_Value= isnull(@assetvalue,Asset_Value)
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[vParameters]'
GO
CREATE VIEW [dbo].[vParameters]
AS
SELECT        p.Parameter_ID, p.Parameter_Name, ISNULL(a.Parameter_Value_Assessment, p.Parameter_Name) AS Default_Value, a.Assessment_ID
FROM            dbo.PARAMETERS AS p LEFT OUTER JOIN
                         dbo.PARAMETER_ASSESSMENT AS a ON p.Parameter_ID = a.Parameter_ID
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_Exploded]'
GO





CREATE VIEW [dbo].[Answer_Components_Exploded]
AS

SELECT CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) as UniqueKey,
	a.Assessment_Id, b.Answer_Id, a.Question_Id, isnull(b.Answer_Text, c.Answer_Text) as Answer_Text, 
	CONVERT(nvarchar(1000), b.Comment) AS Comment, CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification, 
	b.FeedBack,
	b.Question_Number, a.Simple_Question AS QuestionText, 	
	a.label AS ComponentName, a.Symbol_Name, 
	a.Question_Group_Heading, a.GroupHeadingId, 
	a.Universal_Sub_Category, a.SubCategoryId, 
	isnull(b.Is_Component,1) as Is_Component, a.Component_Guid, 
	a.Layer_Id, a.LayerName, a.Container_Id, 
	a.ZoneName, dbo.convert_sal(a.SAL) as SAL, 
	b.Mark_For_Review, Is_Requirement=cast(0 as bit), Is_Framework=cast(0 as bit),
	b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description, a.heading_pair_id, a.label, a.Component_Symbol_Id
from (
SELECT CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	adc.Assessment_Id, q.Question_Id, q.Simple_Question,
	adc.label, adc.Component_Symbol_Id, 
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
	z.Name AS ZoneName,  dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
	h.Sub_Heading_Question_Description,h.Heading_Pair_Id, cs.Symbol_Name
from	 dbo.ASSESSMENT_DIAGRAM_COMPONENTS AS adc
			join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
			join dbo.COMPONENT_QUESTIONS AS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id			
			join dbo.COMPONENT_SYMBOLS as cs on adc.Component_Symbol_Id = cs.Component_Symbol_Id
            join dbo.NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 			
            join dbo.DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id  
            left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id and adc.Assessment_Id=adc.Assessment_Id
			join (select s.*,nql.Universal_Sal_Level from NEW_QUESTION_SETS s
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id
			where set_name = 'Components' ) s on q.Question_Id = s.Question_Id and s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))		
			left join dbo.vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id
			left join dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id
			 
WHERE l.Visible = 1) a left join Answer_Components AS b on a.Question_Id = b.Question_Or_Requirement_Id and a.Assessment_Id = b.Assessment_Id and a.component_guid = b.component_guid
left join (SELECT a.Assessment_Id, q.Question_Id, a.Answer_Text		
from   (SELECT distinct q.question_id,adc.assessment_id
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'						
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)) as f  
            join dbo.NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 			
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000') c on a.Assessment_Id=c.Assessment_Id and a.Question_Id = c.Question_Id




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
PRINT N'Creating [dbo].[Answer_Components_Default]'
GO







/**
The default consists of one one question 
joined on the types in the diagram
filtered by level 
left joined by the answers
*/
CREATE VIEW [dbo].[Answer_Components_Default]
AS

SELECT                   
	-- This guarantees a unique column to key on in the model
	Isnull(CONVERT(int,  ROW_NUMBER() OVER (ORDER BY q.Question_id)),0) as UniqueKey,
	a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, q.Simple_Question AS QuestionText, 		
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	a.FeedBack,
	a.Is_Component, a.Component_Guid, 
	dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,	
	q.heading_pair_id, h.Sub_Heading_Question_Description,
	q.Simple_Question, 
	a.Reviewed, Cast(null as nvarchar) as label, cast(null as nvarchar) as ComponentName, cast(null as nvarchar) as Symbol_Name, Component_Symbol_id = 0
from   STANDARD_SELECTION ss
		 join 
		 (SELECT distinct q.question_id,adc.assessment_id
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
				join dbo.DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
				left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
				where l.visible = 1) as f  on ss.assessment_id=f.assessment_id							
            join dbo.NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 
			join dbo.vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			join dbo.UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000'
--order by question_group_heading,universal_sub_category
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
PRINT N'Creating [dbo].[usp_getFinancialQuestions]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getFinancialQuestions]
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
PRINT N'Creating [dbo].[usp_getRankedCategories]'
GO

-- =============================================
-- Author:		barry
-- Create date: 7/20/2018
-- Description:	returns the ranked categories
-- =============================================
CREATE PROCEDURE [dbo].[usp_getRankedCategories]
	@assessment_id int	
AS
BEGIN
	SET NOCOUNT ON;
	-- ranked category calculation is 
	-- sum up the total category risk
	-- for the questions on this assessment
	-- then take the number of questions - the question rank 

/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode nvarchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id,Assessment_Id from NEW_QUESTION_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Question_Id = s.Question_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT h.Question_Group_Heading, Question_Group_Heading_Id, isnull(count(c.question_id),0) qc,  isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)
		s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading, Question_Group_Heading_Id
     
	 SELECT h.Question_Group_Heading, h.Question_Group_Heading_Id, isnull(count(c.question_id),0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
				join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
				join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		)	s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading, Question_Group_Heading_Id

	select t.*, isnull(a.nuCount,0) nuCount, isnull(a.cr,0) Actualcr, isnull(cast(a.cr as decimal(18,3))/Total,0)*100 [prc],  isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
else 
begin 
	select @maxRank = max(c.Ranking) 
		FROM NEW_REQUIREMENT c 
		join (select distinct requirement_id,Assessment_Id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id=s.Requirement_Id
		where s.Assessment_Id = @assessment_id 
	

	IF OBJECT_ID('tempdb..#TempR') IS NOT NULL DROP TABLE #TempR

	SELECT h.Question_Group_Heading, h.Question_Group_Heading_Id as [QGH_Id], count(c.Requirement_Id) qc,  SUM(@maxRank-c.Ranking) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id 
		group by Question_Group_Heading, h.Question_Group_Heading_Id

	
	select *, isnull(cast(cr as decimal(18,3))/Total, 0) * 100 [prc] from #tempR
	order by prc desc
end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetMaturityDetailsCalculations]'
GO

-- =============================================
-- Author:		CSET/ACET Team
-- Create date: 20-Jan-2021
-- Description:	Updated Calulates on maturity details
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityDetailsCalculations]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- 'inflate' all applicable answers prior to analysis
	EXEC FillEmptyMaturityQuestionsForAnalysis @Assessment_Id


	select grouporder, 
	a.Total,
	DomainId,
	Domain,
	AssessmentFactorId,
	AssessmentFactor,
	FinComponentId,
	FinComponent,
	MaturityLevel,
	b.Answer_Text, 
	isnull(b.acount, 0) as acount,  
	isnull((cast(b.acount as float)/cast(total as float)),0) as AnswerPercent , 
	CAST(c.Complete AS BIT) AS complete 
	FROM (
			select distinct min(StmtNumber) as grouporder, fd.financialGroupId, DomainId, Domain, AssessmentFactorId, AssessmentFactor,FinComponentId, FinComponent,MaturityLevel,count(stmtnumber) Total 
			FROM [FINANCIAL_DETAILS] fd 
			JOIN vFinancialGroups g ON fd.financialGroupId = g.financialGroupId	
			group by fd.FinancialGroupId,DomainId, Domain, AssessmentFactorId, AssessmentFactor, FinComponentId, FinComponent,MaturityLevel				
			) a 
		left join (SELECT fd.FinancialGroupId, answer_text, count(a.Answer_Text) acount
			FROM    [dbo].[FINANCIAL_REQUIREMENTS] f
			INNER JOIN [dbo].[MATURITY_QUESTIONS] q ON f.[maturity_question_Id] = q.[Mat_Question_Id]
			INNER JOIN (select assessment_id, Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y' else 'N' end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F.[maturity_question_id] = a.[Question_Or_Requirement_Id]
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]   			
			WHERE [Assessment_Id] = @Assessment_Id 
			group by fd.FinancialGroupId, Answer_Text
			) b on a.FinancialGroupId = b.FinancialGroupId
		join (SELECT fd.financialGroupId, min(case answer_text when 'U' then 0 else 1 end) as Complete
			from (select * from [ANSWER] WHERE assessment_Id=@assessment_id and question_type = 'Maturity') u 
			join [dbo].[FINANCIAL_REQUIREMENTS] f ON F.[Maturity_Question_Id] = u.[Question_Or_Requirement_Id]						
			INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]   
			WHERE assessment_Id=@assessment_id 
			group by fd.financialGroupId) c on a.FinancialGroupId = c.FinancialGroupId
		order by grouporder
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

	declare @ParentMatIds table(Id INT)
	insert into @ParentMatIds select Parent_Question_Id from MATURITY_QUESTIONS where Parent_Question_Id is not null

	IF OBJECT_ID('tempdb..#AvailableMatQuestions') IS NOT NULL drop table #availableMatQuestions
	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseMaturity = 1 and mm.Maturity_Level_Usage_Type = 'Static'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	IF OBJECT_ID('tempdb..#AvailableMatQuestionsWithLevels') IS NOT NULL drop table #AvailableMatQuestionsWithLevels
	select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join MATURITY_MODELS mm on amm.model_id = mm.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level and mm.Maturity_Level_Usage_Type = 'User_Selected'
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)
    
	-- special case for ISE
	IF OBJECT_ID('tempdb..#AvailableMatQuestionsForIse') IS NOT NULL drop table #AvailableMatQuestionsForIse
		select a.Assessment_Id, mq.Mat_Question_Id, mq.Maturity_Level_Id into #AvailableMatQuestionsForIse	
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id and asl.Level_Name = 'Maturity_Level'
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level_Id
			where a.UseMaturity = 1
			and amm.model_id = 10 AND ml.Maturity_Level_Id = mq.Maturity_Level_Id AND ml.level = asl.Standard_Specific_Sal_Level
			and mq.Mat_Question_Id not in (select Id from @ParentMatIds)

	-- special case for VADR
	IF OBJECT_ID('tempdb..#AvailableMatQuestionsForVadr') IS NOT NULL drop table #availableMatQuestionsForVadr
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestionsForVadr
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseMaturity = 1 and amm.model_id = 7
			and mq.Parent_Question_Id is null

	IF OBJECT_ID('tempdb..#AvailableQuestionBasedStandard') IS NOT NULL drop table #AvailableQuestionBasedStandard		
	select a.Assessment_Id, q.question_Id, ss.Selected_Sal_Level into #AvailableQuestionBasedStandard
		from NEW_QUESTION q
			join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
			join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
			join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
			join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
			join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
			join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseStandard = 1 and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level 

	IF OBJECT_ID('tempdb..#AvailableRequirementBasedStandard') IS NOT NULL drop table #AvailableRequirementBasedStandard		
	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseStandard = 1 and rl.Standard_Level = usl.Universal_Sal_Level

	IF OBJECT_ID('tempdb..#AvailableDiagramQuestions') IS NOT NULL drop table #AvailableDiagramQuestions		
	select a.Assessment_Id, q.Question_Id into #AvailableDiagramQuestions
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
			join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(DISTINCT(ans.Answer_Id))
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where ans.Answer_Text != 'U'
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions avq 
												where avq.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels amql
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amql.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level)
			or
			ans.Question_Or_Requirement_Id in (select aqbs.Question_Id from #AvailableQuestionBasedStandard aqbs
												where aqbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard arbs 
												where arbs.Assessment_Id = a.Assessment_Id)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions adq
												where adq.Assessment_Id = a.Assessment_Id)
			or
            ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForIse amqi
												join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id 
												join MATURITY_LEVELS ml on ml.Maturity_Level_Id = amqi.Maturity_Level_Id 
												where asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level = ml.Level)
			or 
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsForVadr amqv 
												where amqv.Assessment_Id = a.Assessment_Id)
			)
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id, CompletedCount = 0
		from ASSESSMENTS a
		join ASSESSMENT_CONTACTS ac on a.Assessment_Id = ac.Assessment_Id and ac.UserId = @User_Id
		where a.Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
	

	--Maturity questions count (For maturity models with level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsWithLevels
		group by Assessment_Id


	--Total Maturity questions count (for maturity models without level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestions
		group by Assessment_Id


	--Total Maturity questions count for ISE available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForIse
		group by Assessment_Id
	

	--Total Maturity questions count for VADR available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsForVadr
		group by Assessment_Id


	--Requirements based questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = ISNULL(COUNT(DISTINCT(Requirement_Id)),0)
		from #AvailableRequirementBasedStandard
		group by Assessment_Id


	--Questions based standards questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = isnull(COUNT(DISTINCT(Question_Id)),0)
		from #AvailableQuestionBasedStandard
		group by Assessment_Id
	

		--Total diagram questions count
	insert into @AssessmentTotalDiagramQuestionsCount
	select                  
		AssessmentId = a.Assessment_Id,
		TotalDiagramQuestionsCount = COUNT(ans.Answer_Id)
		from ANSWER ans
			join ASSESSMENTS a on a.Assessment_Id = ans.Assessment_Id
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where a.UseDiagram = 1 and ans.Question_Type = 'Component'
			group by a.Assessment_Id
	

	select
		AssessmentId = acq.AssessmentId,
		CompletedCount = acq.CompletedCount,
		TotalMaturityQuestionsCount = isnull(atmq.TotalMaturityQuestionsCount,0),
		TotalStandardQuestionsCount = isnull(atsq.TotalStandardQuestionsCount,0),
		TotalDiagramQuestionsCount = isnull(atdq.TotalDiagramQuestionsCount,0)
		from @AssessmentCompletedQuestions acq
			full join @AssessmentTotalMaturityQuestionsCount atmq on atmq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalStandardQuestionsCount atsq on atsq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalDiagramQuestionsCount atdq on atdq.AssessmentId = acq.AssessmentId

END	
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Get_Merge_Conflicts]'
GO
CREATE PROCEDURE [dbo].[Get_Merge_Conflicts]
    -- At least 2 assessments are required to merge
	@id1 int, @id2 int, 

    -- Up to 10 total assessments are allowed
    @id3 int = NULL, @id4 int = NULL, @id5 int = NULL, @id6 int = NULL, 
    @id7 int = NULL, @id8 int = NULL, @id9 int = NULL, @id10 int = NULL

AS
BEGIN
	SET NOCOUNT ON;
	
EXEC FillEmptyMaturityQuestionsForAnalysis @id1
EXEC FillEmptyMaturityQuestionsForAnalysis @id2
EXEC FillEmptyMaturityQuestionsForAnalysis @id3
EXEC FillEmptyMaturityQuestionsForAnalysis @id4
EXEC FillEmptyMaturityQuestionsForAnalysis @id5
EXEC FillEmptyMaturityQuestionsForAnalysis @id6
EXEC FillEmptyMaturityQuestionsForAnalysis @id7
EXEC FillEmptyMaturityQuestionsForAnalysis @id8
EXEC FillEmptyMaturityQuestionsForAnalysis @id9
EXEC FillEmptyMaturityQuestionsForAnalysis @id10

SELECT 
    (SELECT Question_Text FROM MATURITY_QUESTIONS WHERE Mat_Question_Id = a.Question_Or_Requirement_Id) as Question_Text,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id1) as Assessment_Name1,
    (SELECT Charter FROM ASSESSMENTS WHERE Assessment_Id = @id1) as Charter_Number,
    (SELECT Assets FROM ASSESSMENTS WHERE Assessment_Id = @id1) as Asset_Amount,
    a.Assessment_Id as Assessment_id1,
    a.Question_Or_Requirement_Id as Question_Or_Requirement_Id1,
    a.Answer_Text as Answer_Text1,
    a.Comment as Comment1,
    a.Alternate_Justification as Alt_Text1, 
    
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id2) as Assessment_Name2,
    b.Assessment_Id as Assessment_id2,
    b.Question_Or_Requirement_Id as Question_Or_Requirement_Id2, 
    b.Answer_Text as Answer_Text2,
    b.Comment as Comment2,
    b.Alternate_Justification as Alt_Text2,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id3) as Assessment_Name3,
    c.Assessment_Id as Assessment_id3,
    c.Question_Or_Requirement_Id as Question_Or_Requirement_Id3, 
    c.Answer_Text as Answer_Text3,
    c.Comment as Comment3,
    c.Alternate_Justification as Alt_Text3,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id4) as Assessment_Name4,
    d.Assessment_Id as Assessment_id4, 
    d.Question_Or_Requirement_Id as Question_Or_Requirement_Id4, 
    d.Answer_Text as Answer_Text4,
    d.Comment as Comment4,
    d.Alternate_Justification as Alt_Text4,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id5) as Assessment_Name5,
    e.Assessment_Id as Assessment_id5, 
    e.Question_Or_Requirement_Id as Question_Or_Requirement_Id5, 
    e.Answer_Text as Answer_Text5,
    e.Comment as Comment5,
    e.Alternate_Justification as Alt_Text5,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id6) as Assessment_Name6,
    f.Assessment_Id as Assessment_id6, 
    f.Question_Or_Requirement_Id as Question_Or_Requirement_Id6, 
    f.Answer_Text as Answer_Text6,
    f.Comment as Comment6,
    f.Alternate_Justification as Alt_Text6,

    g.Assessment_Id as Assessment_id7,
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id7) as Assessment_Name7,
    g.Question_Or_Requirement_Id as Question_Or_Requirement_Id7, 
    g.Answer_Text as Answer_Text7,
    g.Comment as Comment7,
    g.Alternate_Justification as Alt_Text7,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id8) as Assessment_Name8,
    h.Assessment_Id as Assessment_id8,
    h.Question_Or_Requirement_Id as Question_Or_Requirement_Id8, 
    h.Answer_Text as Answer_Text8,
    h.Comment as Comment8,
    h.Alternate_Justification as Alt_Text8,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id9) as Assessment_Name9,
    i.Assessment_Id as Assessment_id9,
    i.Question_Or_Requirement_Id as Question_Or_Requirement_Id9, 
    i.Answer_Text as Answer_Text9,
    i.Comment as Comment9,
    i.Alternate_Justification as Alt_Text9,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id10) as Assessment_Name10,
    j.Assessment_Id as Assessment_id10,
    j.Question_Or_Requirement_Id as Question_Or_Requirement_Id10, 
    j.Answer_Text as Answer_Text10,
    j.Comment as Comment10,
    j.Alternate_Justification as Alt_Text10


FROM (SELECT * FROM ANSWER WHERE Assessment_Id = @id1) a

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id2) b 
ON (a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id) AND (a.Question_Type = b.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id3) c
ON (a.Question_Or_Requirement_Id = c.Question_Or_Requirement_Id) AND (a.Question_Type = c.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id4) d
ON (a.Question_Or_Requirement_Id = d.Question_Or_Requirement_Id) AND (a.Question_Type = d.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id5) e
ON (a.Question_Or_Requirement_Id = e.Question_Or_Requirement_Id) AND (a.Question_Type = e.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id6) f
ON (a.Question_Or_Requirement_Id = f.Question_Or_Requirement_Id) AND (a.Question_Type = f.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id7) g
ON (a.Question_Or_Requirement_Id = g.Question_Or_Requirement_Id) AND (a.Question_Type = g.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id8) h
ON (a.Question_Or_Requirement_Id = h.Question_Or_Requirement_Id) AND (a.Question_Type = h.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id9) i
ON (a.Question_Or_Requirement_Id = i.Question_Or_Requirement_Id) AND (a.Question_Type = i.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id10) j
ON (a.Question_Or_Requirement_Id = j.Question_Or_Requirement_Id) AND (a.Question_Type = j.Question_Type)

WHERE 
    -- Compare Exam 1 (a) to all other exams being merged
    ((a.Answer_Text != 'U' AND b.Answer_Text != 'U') AND (a.Answer_Text != b.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND c.Answer_Text != 'U') AND (a.Answer_Text != c.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (a.Answer_Text != d.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (a.Answer_Text != e.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (a.Answer_Text != f.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (a.Answer_Text != g.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (a.Answer_Text != h.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (a.Answer_Text != i.Answer_Text)) OR
    ((a.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (a.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 2 (b) to all other exams being merged
    ((b.Answer_Text != 'U' AND c.Answer_Text != 'U') AND (b.Answer_Text != c.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (b.Answer_Text != d.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (b.Answer_Text != e.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (b.Answer_Text != f.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (b.Answer_Text != g.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (b.Answer_Text != h.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (b.Answer_Text != i.Answer_Text)) OR
    ((b.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (b.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 3 (c)
    ((c.Answer_Text != 'U' AND d.Answer_Text != 'U') AND (c.Answer_Text != d.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (c.Answer_Text != e.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (c.Answer_Text != f.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (c.Answer_Text != g.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (c.Answer_Text != h.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (c.Answer_Text != i.Answer_Text)) OR
    ((c.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (c.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 4 (d)
    ((d.Answer_Text != 'U' AND e.Answer_Text != 'U') AND (d.Answer_Text != e.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (d.Answer_Text != f.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (d.Answer_Text != g.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (d.Answer_Text != h.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (d.Answer_Text != i.Answer_Text)) OR
    ((d.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (d.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 5 (e)
    ((e.Answer_Text != 'U' AND f.Answer_Text != 'U') AND (e.Answer_Text != f.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (e.Answer_Text != g.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (e.Answer_Text != h.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (e.Answer_Text != i.Answer_Text)) OR
    ((e.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (e.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 6 (f)
    ((f.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (f.Answer_Text != g.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (f.Answer_Text != h.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (f.Answer_Text != i.Answer_Text)) OR
    ((f.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (f.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 7 (g)
    ((g.Answer_Text != 'U' AND g.Answer_Text != 'U') AND (g.Answer_Text != g.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND h.Answer_Text != 'U') AND (g.Answer_Text != h.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (g.Answer_Text != i.Answer_Text)) OR
    ((g.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (g.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 8 (h)
    ((h.Answer_Text != 'U' AND i.Answer_Text != 'U') AND (h.Answer_Text != i.Answer_Text)) OR
    ((h.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (h.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 9 (i)
    ((i.Answer_Text != 'U' AND j.Answer_Text != 'U') AND (i.Answer_Text != j.Answer_Text))


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Analytics_Answers]'
GO


CREATE VIEW [dbo].[Analytics_Answers]
AS
SELECT Assessment_Id, Question_Or_Requirement_Id, Question_Type, 
			CASE WHEN ANSWER.Answer_Text = 'A' OR
                      ANSWER.Answer_Text = 'Y' OR
					  Answer.Answer_Text = 'FI' OR
					  Answer.Answer_Text = 'LI'
				  THEN N'Y' ELSE 'N' END AS Answer_Text
FROM     dbo.ANSWER
WHERE  (Answer_Text <> 'NA')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AcetAnswerDistribution]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AcetAnswerDistribution]
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
	and l.Level <= @targetLevel
	and a.Assessment_Id = @assessment_id
	group by Answer_Text


END
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
--
-- Modification date: 12-NOV-2024
-- Author:      Randy
-- Description: Made sector and industry parameters optional, to cast a wider net.  
-- Also added consideration for a sector and industry stored in DETAILS_DEMOGRAPHICS.
-- Also the groupings are sorted in their sequence order, rather than alphabetically.
-- =============================================
CREATE PROCEDURE [dbo].[analytics_Compute_MaturityAll]
@maturity_model_id int,
@sector_id int = NULL,
@industry_id int = NULL
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
		left join details_demographics ddsector on a.Assessment_Id = ddsector.Assessment_Id and ddsector.DataItemName = 'SECTOR'
		left join details_demographics ddsubsector on a.Assessment_Id = ddsubsector.Assessment_Id and ddsubsector.DataItemName = 'SUBSECTOR'
		where a.question_type = 'Maturity' and q.Maturity_Model_Id=@maturity_model_id and g.Maturity_Model_Id=@maturity_model_id
			and (nullif(@sector_id, sectorid) is null or nullif(@sector_id, ddsector.IntValue) is null)
			and (nullif(@industry_id,industryid) is null or nullif(@industry_id, ddsubsector.IntValue) is null)
		group by a.assessment_id, Question_Group, Answer_Text


if (@maturity_model_id = 12)
begin
	update #temp set Answer_Text = 'Y' where Answer_Text in ('FI','LI')
	update #temp set Answer_Text = 'N' where Answer_Text not in ('FI','LI')
end


--step 2 handle the cases where we have all yes, all no, and mixed
	--get the yes and mixed case
	select * into #temp2 from #temp where answer_text='Y'
	--get the all no case
	insert #temp2
	select assessment_id,QUESTION_GROUP,Answer_Text='Y',Answer_Count,total, [percentage]=0 from #temp where Answer_Text = 'N' and Answer_Count=total


--step 3 calculate the min,max,avg
	select G1.Question_Group as Question_Group_Heading, g1.Global_Sequence, min(isnull([percentage],0)) [minimum],max(isnull([percentage],0)) [maximum],avg(isnull([percentage],0)) [average] 
	into #temp3
	from
	(	
		select distinct Question_Group, global_sequence from ANALYTICS_MATURITY_GROUPINGS where Maturity_Model_Id = @maturity_model_id
	) G1 LEFT OUTER JOIN #temp2 G2 ON G1.Question_Group = G2.Question_Group 
	group by G1.Question_Group, global_sequence


--step 4 add median
	select a.Question_Group_Heading, cast(a.minimum as float) as minimum,cast(a.maximum as float) as maximum,cast(a.average as float) as average,isnull(b.median,0) as median from
	#temp3 a left join 
	(
	select distinct Question_Group as Question_Group_Heading		
	,isnull(PERCENTILE_disc(0.5) WITHIN GROUP (ORDER BY [Percentage]) OVER (PARTITION BY question_group),0) AS median	
	from #temp2) b on a.Question_Group_Heading=b.Question_Group_Heading
	order by a.Global_Sequence
end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Get_Cie_Merge_Conflicts]'
GO
-- =============================================
-- Author:		Matt Winston
-- Create date: 4/12/24
-- Description:	Gets the merge conflicts for CIE assessments
-- =============================================
CREATE PROCEDURE [dbo].[Get_Cie_Merge_Conflicts]
    -- At least 2 assessments are required to merge
	@id1 int, @id2 int, 

    -- Up to 10 total assessments are allowed
    @id3 int = NULL, @id4 int = NULL, @id5 int = NULL, @id6 int = NULL, 
    @id7 int = NULL, @id8 int = NULL, @id9 int = NULL, @id10 int = NULL

AS
BEGIN
	SET NOCOUNT ON;
	
EXEC FillEmptyMaturityQuestionsForAnalysis @id1
EXEC FillEmptyMaturityQuestionsForAnalysis @id2
EXEC FillEmptyMaturityQuestionsForAnalysis @id3
EXEC FillEmptyMaturityQuestionsForAnalysis @id4
EXEC FillEmptyMaturityQuestionsForAnalysis @id5
EXEC FillEmptyMaturityQuestionsForAnalysis @id6
EXEC FillEmptyMaturityQuestionsForAnalysis @id7
EXEC FillEmptyMaturityQuestionsForAnalysis @id8
EXEC FillEmptyMaturityQuestionsForAnalysis @id9
EXEC FillEmptyMaturityQuestionsForAnalysis @id10

SELECT 
    (SELECT Question_Text FROM MATURITY_QUESTIONS WHERE Mat_Question_Id = a.Question_Or_Requirement_Id) as Question_Text,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id1) as Assessment_Name1,
	(SELECT Facility_Name FROM INFORMATION WHERE Id = @id1) as Facility,
    a.Assessment_Id as Assessment_id1,
    a.Question_Or_Requirement_Id as Question_Or_Requirement_Id1,
    a.Answer_Text as Answer_Text1,
	a.FeedBack as Feedback1,
    a.Comment as Comment1,
    a.Free_Response_Answer as Free_Response_Answer1, 
    
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id2) as Assessment_Name2,
    b.Assessment_Id as Assessment_id2,
    b.Question_Or_Requirement_Id as Question_Or_Requirement_Id2, 
    b.Answer_Text as Answer_Text2,
	b.FeedBack as Feedback2,
    b.Comment as Comment2,
    b.Free_Response_Answer as Free_Response_Answer2,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id3) as Assessment_Name3,
    c.Assessment_Id as Assessment_id3,
    c.Question_Or_Requirement_Id as Question_Or_Requirement_Id3, 
    c.Answer_Text as Answer_Text3,
	c.FeedBack as Feedback3,
    c.Comment as Comment3,
    c.Free_Response_Answer as Free_Response_Answer3,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id4) as Assessment_Name4,
    d.Assessment_Id as Assessment_id4, 
    d.Question_Or_Requirement_Id as Question_Or_Requirement_Id4, 
    d.Answer_Text as Answer_Text4,
	d.FeedBack as Feedback4,
    d.Comment as Comment4,
    d.Free_Response_Answer as Free_Response_Answer4,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id5) as Assessment_Name5,
    e.Assessment_Id as Assessment_id5, 
    e.Question_Or_Requirement_Id as Question_Or_Requirement_Id5, 
    e.Answer_Text as Answer_Text5,
	e.FeedBack as Feedback5,
    e.Comment as Comment5,
    e.Free_Response_Answer as Free_Response_Answer5,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id6) as Assessment_Name6,
    f.Assessment_Id as Assessment_id6, 
    f.Question_Or_Requirement_Id as Question_Or_Requirement_Id6, 
    f.Answer_Text as Answer_Text6,
	f.FeedBack as Feedback6,
    f.Comment as Comment6,
    f.Free_Response_Answer as Free_Response_Answer6,

    g.Assessment_Id as Assessment_id7,
    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id7) as Assessment_Name7,
    g.Question_Or_Requirement_Id as Question_Or_Requirement_Id7, 
    g.Answer_Text as Answer_Text7,
	g.FeedBack as Feedback7,
    g.Comment as Comment7,
    g.Free_Response_Answer as Free_Response_Answer7,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id8) as Assessment_Name8,
    h.Assessment_Id as Assessment_id8,
    h.Question_Or_Requirement_Id as Question_Or_Requirement_Id8, 
    h.Answer_Text as Answer_Text8,
	h.FeedBack as Feedback8,
    h.Comment as Comment8,
    h.Free_Response_Answer as Free_Response_Answer8,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id9) as Assessment_Name9,
    i.Assessment_Id as Assessment_id9,
    i.Question_Or_Requirement_Id as Question_Or_Requirement_Id9, 
    i.Answer_Text as Answer_Text9,
	i.FeedBack as Feedback9,
    i.Comment as Comment9,
    i.Free_Response_Answer as Free_Response_Answer9,

    (SELECT Assessment_Name FROM INFORMATION WHERE Id = @id10) as Assessment_Name10,
    j.Assessment_Id as Assessment_id10,
    j.Question_Or_Requirement_Id as Question_Or_Requirement_Id10, 
    j.Answer_Text as Answer_Text10,
	j.FeedBack as Feedback10,
    j.Comment as Comment10,
    j.Free_Response_Answer as Free_Response_Answer10


FROM (SELECT * FROM ANSWER WHERE Assessment_Id = @id1) a

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id2) b 
ON (a.Question_Or_Requirement_Id = b.Question_Or_Requirement_Id) AND (a.Question_Type = b.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id3) c
ON (a.Question_Or_Requirement_Id = c.Question_Or_Requirement_Id) AND (a.Question_Type = c.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id4) d
ON (a.Question_Or_Requirement_Id = d.Question_Or_Requirement_Id) AND (a.Question_Type = d.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id5) e
ON (a.Question_Or_Requirement_Id = e.Question_Or_Requirement_Id) AND (a.Question_Type = e.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id6) f
ON (a.Question_Or_Requirement_Id = f.Question_Or_Requirement_Id) AND (a.Question_Type = f.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id7) g
ON (a.Question_Or_Requirement_Id = g.Question_Or_Requirement_Id) AND (a.Question_Type = g.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id8) h
ON (a.Question_Or_Requirement_Id = h.Question_Or_Requirement_Id) AND (a.Question_Type = h.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id9) i
ON (a.Question_Or_Requirement_Id = i.Question_Or_Requirement_Id) AND (a.Question_Type = i.Question_Type)

FULL OUTER JOIN (SELECT * FROM ANSWER WHERE Assessment_Id = @id10) j
ON (a.Question_Or_Requirement_Id = j.Question_Or_Requirement_Id) AND (a.Question_Type = j.Question_Type)

WHERE 
    -- Compare Exam 1 (a) to all other exams being merged
    (
		(a.Answer_Text != b.Answer_Text) 
			AND ((a.Answer_Text = 'NA') OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is not null)) 
			AND ((b.Answer_Text = 'NA') OR (b.Answer_Text = 'U' AND b.Free_Response_Answer is not null))
	) OR
	((a.Answer_Text != c.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (c.Answer_Text = 'NA' OR (c.Answer_Text = 'U' AND c.Free_Response_Answer is null))) OR
    ((a.Answer_Text != d.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (d.Answer_Text = 'NA' OR (d.Answer_Text = 'U' AND d.Free_Response_Answer is null))) OR
    ((a.Answer_Text != e.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (e.Answer_Text = 'NA' OR (e.Answer_Text = 'U' AND e.Free_Response_Answer is null))) OR
    ((a.Answer_Text != f.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (f.Answer_Text = 'NA' OR (f.Answer_Text = 'U' AND f.Free_Response_Answer is null))) OR
    ((a.Answer_Text != g.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (g.Answer_Text = 'NA' OR (g.Answer_Text = 'U' AND g.Free_Response_Answer is null))) OR
    ((a.Answer_Text != h.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (h.Answer_Text = 'NA' OR (h.Answer_Text = 'U' AND h.Free_Response_Answer is null))) OR
    ((a.Answer_Text != i.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (i.Answer_Text = 'NA' OR (i.Answer_Text = 'U' AND i.Free_Response_Answer is null))) OR
    ((a.Answer_Text != j.Answer_Text) AND (a.Answer_Text = 'NA' OR (a.Answer_Text = 'U' AND a.Free_Response_Answer is null)) AND (j.Answer_Text = 'NA' OR (j.Answer_Text = 'U' AND j.Free_Response_Answer is null))) OR

    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (c.Answer_Text = 'U' AND c.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (d.Answer_Text = 'U' AND d.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (e.Answer_Text = 'U' AND e.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (f.Answer_Text = 'U' AND f.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (g.Answer_Text = 'U' AND g.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (h.Answer_Text = 'U' AND h.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (i.Answer_Text = 'U' AND i.Free_Response_Answer is NULL))) OR
    --((a.Answer_Text != b.Answer_Text) AND ((a.Answer_Text = 'U' AND a.Free_Response_Answer is NULL) OR (j.Answer_Text = 'U' AND j.Free_Response_Answer is NULL))) OR

	--((a.Answer_Text != b.Answer_Text) OR (a.Answer_Text != b.Answer_Text)) OR
	--((a.Answer_Text != c.Answer_Text) OR (a.Answer_Text != c.Answer_Text)) OR
    --((a.Answer_Text != d.Answer_Text) OR (a.Answer_Text != d.Answer_Text)) OR
    --((a.Answer_Text != e.Answer_Text) OR (a.Answer_Text != e.Answer_Text)) OR
    --((a.Answer_Text != f.Answer_Text) OR (a.Answer_Text != f.Answer_Text)) OR
    --((a.Answer_Text != g.Answer_Text) OR (a.Answer_Text != g.Answer_Text)) OR
    --((a.Answer_Text != h.Answer_Text) OR (a.Answer_Text != h.Answer_Text)) OR
    --((a.Answer_Text != i.Answer_Text) OR (a.Answer_Text != i.Answer_Text)) OR
    --((a.Answer_Text != j.Answer_Text) OR (a.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 2 (b) to all other exams being merged
    ((b.Answer_Text != c.Answer_Text) OR (b.Answer_Text != c.Answer_Text)) OR
    ((b.Answer_Text != d.Answer_Text) OR (b.Answer_Text != d.Answer_Text)) OR
    ((b.Answer_Text != e.Answer_Text) OR (b.Answer_Text != e.Answer_Text)) OR
    ((b.Answer_Text != f.Answer_Text) OR (b.Answer_Text != f.Answer_Text)) OR
    ((b.Answer_Text != g.Answer_Text) OR (b.Answer_Text != g.Answer_Text)) OR
    ((b.Answer_Text != h.Answer_Text) OR (b.Answer_Text != h.Answer_Text)) OR
    ((b.Answer_Text != i.Answer_Text) OR (b.Answer_Text != i.Answer_Text)) OR
    ((b.Answer_Text != j.Answer_Text) OR (b.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 3 (c)
    ((c.Answer_Text != d.Answer_Text) OR (c.Answer_Text != d.Answer_Text)) OR
    ((c.Answer_Text != e.Answer_Text) OR (c.Answer_Text != e.Answer_Text)) OR
    ((c.Answer_Text != f.Answer_Text) OR (c.Answer_Text != f.Answer_Text)) OR
    ((c.Answer_Text != g.Answer_Text) OR (c.Answer_Text != g.Answer_Text)) OR
    ((c.Answer_Text != h.Answer_Text) OR (c.Answer_Text != h.Answer_Text)) OR
    ((c.Answer_Text != i.Answer_Text) OR (c.Answer_Text != i.Answer_Text)) OR
    ((c.Answer_Text != j.Answer_Text) OR (c.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 4 (d)
    ((d.Answer_Text != e.Answer_Text) OR (d.Answer_Text != e.Answer_Text)) OR
    ((d.Answer_Text != f.Answer_Text) OR (d.Answer_Text != f.Answer_Text)) OR
    ((d.Answer_Text != g.Answer_Text) OR (d.Answer_Text != g.Answer_Text)) OR
    ((d.Answer_Text != h.Answer_Text) OR (d.Answer_Text != h.Answer_Text)) OR
    ((d.Answer_Text != i.Answer_Text) OR (d.Answer_Text != i.Answer_Text)) OR
    ((d.Answer_Text != j.Answer_Text) OR (d.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 5 (e)
    ((e.Answer_Text != f.Answer_Text) OR (e.Answer_Text != f.Answer_Text)) OR
    ((e.Answer_Text != g.Answer_Text) OR (e.Answer_Text != g.Answer_Text)) OR
    ((e.Answer_Text != h.Answer_Text) OR (e.Answer_Text != h.Answer_Text)) OR
    ((e.Answer_Text != i.Answer_Text) OR (e.Answer_Text != i.Answer_Text)) OR
    ((e.Answer_Text != j.Answer_Text) OR (e.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 6 (f)
    ((f.Answer_Text != g.Answer_Text) OR (f.Answer_Text != g.Answer_Text)) OR
    ((f.Answer_Text != h.Answer_Text) OR (f.Answer_Text != h.Answer_Text)) OR
    ((f.Answer_Text != i.Answer_Text) OR (f.Answer_Text != i.Answer_Text)) OR
    ((f.Answer_Text != j.Answer_Text) OR (f.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 7 (g)
    ((g.Answer_Text != h.Answer_Text) OR (g.Answer_Text != h.Answer_Text)) OR
    ((g.Answer_Text != i.Answer_Text) OR (g.Answer_Text != i.Answer_Text)) OR
    ((g.Answer_Text != j.Answer_Text) OR (g.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 8 (h)
    ((h.Answer_Text != i.Answer_Text) OR (h.Answer_Text != i.Answer_Text)) OR
    ((h.Answer_Text != j.Answer_Text) OR (h.Answer_Text != j.Answer_Text)) OR

    -- Compare Exam 9 (i)
    ((i.Answer_Text != j.Answer_Text) OR (i.Answer_Text != j.Answer_Text))


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CopyIntoSet]'
GO

-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	copy a base set into an existing custom set
-- =============================================
CREATE PROCEDURE [dbo].[usp_CopyIntoSet]
	-- Add the parameters for the stored procedure here
	@SourceSetName nvarchar(50),
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end

    -- Insert statements for procedure here
	insert CUSTOM_STANDARD_BASE_STANDARD (Custom_Questionaire_Name,Base_Standard) values(@DestinationSetName,@SourceSetName)
	--do the headers first
	INSERT INTO [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]
			   ([Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,[Set_Name])
	select a.* from
	(select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @SourceSetName ) a 
	left join (select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @DestinationSetName ) b on a.Question_Group_Heading_Id=b.Question_Group_Heading_Id
	and a.Universal_Sub_Category_Id = b.Universal_Sub_Category_Id
	where b.Question_Group_Heading_Id is not null

	INSERT INTO [dbo].[NEW_REQUIREMENT]
           ([Requirement_Title]
           ,[Requirement_Text]
           ,[Supplemental_Info]
           ,[Standard_Category]
           ,[Standard_Sub_Category]
           ,[Weight]
           ,[Implementation_Recommendations]
           ,[Original_Set_Name]
           ,[NCSF_Cat_Id]
           ,[NCSF_Number]
           ,[Ranking]
           ,[Question_Group_Heading_Id]
           ,[ExaminationApproach]
           ,[Old_Id_For_Copy])
	select 		
		Requirement_Title,
		Requirement_Text,
		Supplemental_Info,
		Standard_Category,
		Standard_Sub_Category,
		Weight,
		Implementation_Recommendations,
		Original_Set_Name = @DestinationSetName,
		NCSF_Cat_Id,
		NCSF_Number,
		Ranking,
		Question_Group_Heading_Id,
		ExaminationApproach,
		r.Requirement_Id as Old_Id_For_Copy
		from REQUIREMENT_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id	
	where set_name = @SourceSetName
	order by Requirement_Sequence

	INSERT INTO [dbo].[REQUIREMENT_SETS]
           ([Requirement_Id]
           ,[Set_Name]
           ,[Requirement_Sequence])
	select nr.Requirement_Id,Set_name = @DestinationSetName,ns.Requirement_Sequence from NEW_REQUIREMENT nr 
	join (select s.Requirement_Id,s.Requirement_Sequence,s.Set_Name 
		from NEW_REQUIREMENT r join REQUIREMENT_SETS s on r.Requirement_Id=s.Requirement_Id 
		where s.Set_Name = @SourceSetName) ns on nr.Old_Id_For_Copy=ns.Requirement_Id
	where Original_Set_Name = @DestinationSetName

	insert into REQUIREMENT_LEVELS (Requirement_Id,Level_Type,Standard_Level)
	select a.Requirement_Id,b.Level_Type,b.Standard_Level from (
	select r.* from REQUIREMENT_SETS s join NEW_REQUIREMENT r
	on s.Requirement_Id = r.Requirement_Id
	where s.Set_Name = @DestinationSetName) a join (	
	select l.* from requirement_levels l 
	join REQUIREMENT_SETS s on l.Requirement_Id=s.Requirement_Id	
	where s.Set_Name = @SourceSetName) b on a.Old_Id_For_Copy=b.Requirement_Id


	insert into REQUIREMENT_QUESTIONS_SETS (Question_Id,Requirement_Id,Set_Name)
	select b.Question_Id,b.Requirement_Id,set_name = @DestinationSetName from REQUIREMENT_QUESTIONS_SETS a right join (
	select question_id,r.Requirement_Id
		from REQUIREMENT_QUESTIONS_SETS s
		join (select * from NEW_REQUIREMENT where Original_Set_Name= @DestinationSetName) r on s.Requirement_Id=r.Old_Id_For_Copy
		where set_name = @SourceSetName) b on a.Question_Id=b.Question_Id and a.Set_Name=@DestinationSetName
	where a.Question_Id is null

	
	INSERT INTO [dbo].[NEW_QUESTION_SETS]
           ([Set_Name]
           ,[Question_Id])    
	select a.set_name,a.Question_Id from (
	select set_name = @DestinationSetName,question_id
	from NEW_QUESTION_SETS where Set_Name = @SourceSetName) a 
	left join NEW_QUESTION_SETS b on a.Question_Id=b.Question_Id and a.set_name=b.Set_Name
	where b.Question_Id is null

	--insert the question sets records then join that with the old 
	--question sets records 		
	INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([New_Question_Set_Id],[Universal_Sal_Level])                
	select distinct b.New_Question_Set_Id,l.Universal_Sal_Level
	from NEW_QUESTION_SETS s
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
	join (select ss.Question_Id,ss.New_Question_Set_Id 
	from NEW_QUESTION_SETS ss
		left join NEW_QUESTION_LEVELS ls on ss.New_Question_Set_Id=ls.New_Question_Set_Id
		where set_name = @DestinationSetName and ls.New_Question_Set_Id is null) b on s.Question_Id=b.Question_Id 
	where s.Set_Name = @SourceSetName


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_CopyIntoSet_Delete]'
GO
-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	Delete a copied set
-- =============================================
CREATE PROCEDURE [dbo].[usp_CopyIntoSet_Delete]
	-- Add the parameters for the stored procedure here	
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end
		
	delete [dbo].[REQUIREMENT_SETS] 	where Set_Name = @DestinationSetName

	
	delete REQUIREMENT_QUESTIONS_SETS where set_name = @DestinationSetName
	--do the headers first
	delete UNIVERSAL_SUB_CATEGORY_HEADINGS where Set_Name=@DestinationSetName

	delete NEW_QUESTION_SETS where Set_Name = @DestinationSetName

	
	delete NEW_REQUIREMENT where Original_Set_Name = @destinationSetName

	-- Insert statements for procedure here
	delete CUSTOM_STANDARD_BASE_STANDARD where Custom_Questionaire_Name = @DestinationSetName	

	
	
END
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
		Question_Group as Title, Global_Sequence, Answer_Text = 'Y'
		from ANALYTICS_MATURITY_GROUPINGS		
		where Maturity_Model_Id= @maturity_model_id			
	) G1 LEFT OUTER JOIN
	(
		select
		Question_Group as Title, answer_text, count(answer_text) answer_count,
		sum(count(answer_text)) OVER(PARTITION BY Question_Group) AS Total,
		cast(IsNull(Round((cast((COUNT(a.answer_text)) as float)/(isnull(nullif(sum(count(answer_text)) OVER(PARTITION BY Question_Group),0),1)))*100,0),0) as int)  as [Percentage] 
		from Analytics_Answers a
		join ANALYTICS_MATURITY_GROUPINGS g on a.Question_Or_Requirement_Id=g.Maturity_Question_Id
		where assessment_id = @assessment_id
		group by Question_Group, Answer_Text
	) G2 ON G1.Title = G2.Title AND G1.Answer_Text = G2.Answer_Text		
	where g1.answer_text = 'Y'
	order by Global_Sequence
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Components_Overrides]'
GO


CREATE VIEW [dbo].[Answer_Components_Overrides]
AS
/**
retreives only overriden component answers
so it is the same normal query but only returns 
those records where component guid is not null
*/
SELECT [UniqueKey]
      ,[Assessment_Id]
      ,[Answer_Id]
      ,[Question_Id]
      ,[Answer_Text]
      ,[Comment]
      ,[Alternate_Justification]
      ,[Question_Number]
      ,[QuestionText]
      ,[ComponentName]
      ,[Symbol_Name]
      ,[Question_Group_Heading]
      ,[GroupHeadingId]
      ,[Universal_Sub_Category]
      ,[SubCategoryId]
      ,[Is_Component]
      ,[Component_Guid]
      ,[Layer_Id]
      ,[LayerName]
      ,[Container_Id]
      ,[ZoneName]
      ,[SAL]
      ,[Mark_For_Review]
      ,[Is_Requirement]
      ,[Is_Framework]
      ,[Reviewed]
      ,[Simple_Question]
      ,[Sub_Heading_Question_Description]
      ,[heading_pair_id]
      ,[label]
      ,[Component_Symbol_Id]
	  ,[FeedBack]
  FROM [dbo].[Answer_Components_Exploded] where Answer_Id is not null
/*SELECT   distinct                
	-- This guarantees a unique column to key on in the model
	CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
	CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
	a.Question_Number, nq.Simple_Question AS QuestionText, 		
	h.Question_Group_Heading, h.Universal_Sub_Category,
	a.Is_Component, adc.Component_Guid, 
	dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
	a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,
	nq.heading_pair_id, h.Sub_Heading_Question_Description,
	nq.Simple_Question,
	a.Reviewed, adc.Diagram_Component_Type, adc.label,

from   [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
		join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id				
		join component_questions q on adc.Diagram_Component_Type = q.Component_Type				
		join new_question nq on q.question_id=nq.question_id		
		join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
		join dbo.DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
		left join dbo.DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
		join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
		and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))				        
		join dbo.vQUESTION_HEADINGS h on nq.Heading_Pair_Id = h.Heading_Pair_Id			    
		join Answer_Components AS a on q.Question_Id = a.Question_Or_Requirement_Id and ss.assessment_id = a.assessment_id	  
		where l.visible=1 and a.Component_Guid <> '00000000-0000-0000-0000-000000000000'*/
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RelevantAnswers]'
GO
-- =============================================
-- Author:		Randy Woods
-- Create date: 29-May-2019
-- Description:	This proc is a wrapper for GetRelevantAnswers and returns 
--              everything it comes up with.
-- =============================================
CREATE PROCEDURE [dbo].[RelevantAnswers]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    ------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text nvarchar(50), 
	component_guid nvarchar(36), is_component bit, custom_question_guid nvarchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	
	SELECT a.*
			FROM #answers a 				
			where a.Assessment_Id = @assessment_id 
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GetMaturityComparisonBestToWorst]'
GO

-- =============================================
-- Author:		WOODRK
-- Create date: 8/29/2024
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityComparisonBestToWorst]	
@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		SELECT Assessment_Id,
		AssessmentName = Alias,                
		Name = Title,
		*
		--AlternateCount = [I],
		--AlternateValue = Round(((cast(([I]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NaCount = [S],
		--NaValue = Round(((cast(([S]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--NoCount = [N],
		--NoValue = Round(((cast(([N]) as float)/isnull(nullif(Total,0),1)))*100,2),
		--TotalCount = Total,
		--TotalValue = Total,
		--UnansweredCount = [U],
		--UnansweredValue = Round(cast([U] as float)/Total*100,2),
		--YesCount = [Y],
		--YesValue = Round((cast(([Y]) as float)/isnull(nullif(Total,0),1))*100,2),
		--Value = Round(((cast(([Y]+ isnull([I],0)) as float)/isnull(nullif((Total-[S]),0),1)))*100,2)
		FROM 
		(
			select b.Assessment_Id, f.Alias, b.Title, b.Answer_Text, isnull(c.Value,0) as Value, 
			Total = sum(c.Value) over(partition by b.Assessment_Id, b.Title)			
			from 
			 (select distinct a.[Assessment_Id], g.Title, l.answer_Text
			from answer_lookup l, (select * from Answer_Maturity where assessment_id = @assessment_id) a 
			join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
			join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			) b left join 
			(select a.Assessment_Id, g.Title, a.Answer_Text, count(a.answer_text) as Value
				from (select * from Answer_Maturity where assessment_id = @assessment_id) a 
				join [MATURITY_QUESTIONS] q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
				join MATURITY_GROUPINGS g on q.Grouping_Id = g.Grouping_Id
			 group by Assessment_Id, g.Title, a.Answer_Text) c
			 on b.Assessment_Id = c.Assessment_Id and b.Title = c.Title and b.Answer_Text = c.Answer_Text
			 join ASSESSMENTS f on b.Assessment_Id = f.Assessment_Id
		) p


			PIVOT
			(
				sum(value)
				FOR answer_text IN ( [Y],[I],[S],[N],[U] )
			) AS pvt
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetAssessmentPie]'
GO
-- =============================================
-- Author:		barry
-- Create date: 7/20/2018
-- Description:	returns the top level pie chart data
-- for an assessment
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetAssessmentPie]	
    @Assessment_Id int	
AS
BEGIN	
	SET NOCOUNT ON;
select l.Answer_Text,l.Answer_Full_Name,isnull(b.vcount,0) vcount, isnull(b.value,0) [value] from ANSWER_LOOKUP l left join (
select Answer_Text,count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] from  ANSWER 
where assessment_id = @Assessment_Id
group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getMaturitySummaryOverall]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getMaturitySummaryOverall]
	@assessment_id int
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select *
into #answers
from answer
where question_type = 'maturity' and Question_Or_Requirement_Id in (select mat_question_id from maturity_questions where maturity_model_id = 5)
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
PRINT N'Creating [dbo].[GetPercentageOverall]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[GetPercentageOverall]
@Assessment_id int 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Assessment_Id,Alias as [Name], StatType,isNull(Total,0) as Total, 
			cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int) as [Y],			
			cast(IsNull(Round((cast(([N]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [N],
			cast(IsNull(Round((cast(([NA]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [NA],
			cast(IsNull(Round((cast(([A]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [A],
			cast(IsNull(Round((cast(([U]) as float)/isnull(nullif(Total,0),1))*100,0),0) as int) as [U],			
			((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100) as Value, 			
			(Total-[NA]) as TotalNoNA 				
		FROM 
		(
			select b.Assessment_Id,af.Alias, [StatType]='Overall', isnull(Acount,0) as Acount, aw.answer_text , SUM(acount) OVER(PARTITION BY b.Assessment_Id) AS Total  
				from (select ANSWER_LOOKUP.Answer_Text from ANSWER_LOOKUP) aw 
					left join (select Assessment_Id, count(answer_text) as Acount, answer_text from answer
					where assessment_id = @assessment_id
					 group by Assessment_Id, answer_Text) B on aw.Answer_Text=b.Answer_Text 
					join ASSESSMENTS af on b.Assessment_Id=af.Assessment_Id			
		) p
		PIVOT
		(
			sum(acount) 
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.StatType;
end
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getFirstPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/30/2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getFirstPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id
	EXECUTE [dbo].[GetCombinedOveralls] @Assessment_Id	
	EXECUTE [dbo].[usp_GetOverallRankedCategoriesPage] @assessment_id
	-- EXECUTE [dbo].[usp_getRankedCategories] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_GetQuestionsWithFeedBack]'
GO

--exec usp_getQuestionswithFeedback 8
CREATE PROCEDURE [dbo].[usp_GetQuestionsWithFeedBack]
@assessment_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	-- get the application mode
	declare @applicationMode nvarchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- get currently selected sets
	IF OBJECT_ID('tempdb..#mySets') IS NOT NULL DROP TABLE #mySets
	select set_name into #mySets from AVAILABLE_STANDARDS where Assessment_Id = @assessment_Id and Selected = 1
	
	if(@ApplicationMode = 'Questions Based')	
	begin
		Select
			Simple_Question as [QuestionText],
			a.Feedback as [Feedback],
			a.Question_Or_Requirement_Id as [QuestionOrRequirementID],
			a.Answer_Id as [AnswerId],
			s.Short_Name as [ShortName]
		FROM Answer_Questions a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
			join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
			join (
				select distinct s.question_id, ns.Short_Name, ns.Set_Name from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join [SETS] ns on s.Set_Name = ns.Set_Name
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
					--join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
					--join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
					where v.Selected = 1 and v.Assessment_Id = @assessment_id --and l.Universal_Sal_Level = ul.Universal_Sal_Level
			)	s on c.Question_Id = s.Question_Id		
		where a.Assessment_Id = @assessment_id 
		and a.Feedback is not null
	end
	else
		begin
				SELECT 
			Requirement_Text as [QuestionText], 
			Answer_Id as [AnswerID],			
			ans.Feedback as [Feedback],			
			s.short_name as [ShortName],
			rs.Requirement_Id as [QuestionOrRequirementID]
			from REQUIREMENT_SETS rs
				left join ANSWER ans on ans.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and ans.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level
			and ans.feedback is not null
		end	
END
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
	@set_name nvarchar(20), --this is the standard set name key
	@sector_id int,
	@industry_id int	
AS
BEGIN
	SET NOCOUNT ON;
	declare @ApplicationMode nvarchar(20)

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
	@set_name nvarchar(20)
AS
BEGIN
SET NOCOUNT ON;
	declare @ApplicationMode nvarchar(20)

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
PRINT N'Creating [dbo].[usp_GetRankedCategoriesPage]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/30/2018
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[usp_GetRankedCategoriesPage]
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id	
	execute [dbo].[usp_getRankedCategories] @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Split]'
GO
CREATE FUNCTION [dbo].[Split](@string nvarchar(500))
RETURNS @TableValues TABLE (Value nvarchar(4000),Id bigint identity(1,1))
AS
BEGIN
declare @pos int
declare @piece nvarchar(500)
DECLARE @id INT
SET @id = 1

-- Need to tack a delimiter onto the end of the input string if one doesn’t exist
if right(rtrim(@string),1) <> ','
 set @string = @string  + ','

set @pos =  patindex('%,%' , @string)
while @pos <> 0
begin
 set @piece = left(@string, @pos - 1)
 
 -- You have a piece of data, so insert it, print it, do whatever you want to with it.
 INSERT @TableValues
         ( Value)
 VALUES  ( @piece)
SET @id=@id +1            

 set @string = stuff(@string, 1, @pos, '')
 set @pos =  patindex('%,%' , @string)
END
RETURN 
END 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[COMPONENT_SYMBOLS_GM_TO_CSET]'
GO
CREATE TABLE [dbo].[COMPONENT_SYMBOLS_GM_TO_CSET]
(
[GM_FingerType] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_COMPONENT_SYMBOLS_GM_TO_CSET] on [dbo].[COMPONENT_SYMBOLS_GM_TO_CSET]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS_GM_TO_CSET] ADD CONSTRAINT [PK_COMPONENT_SYMBOLS_GM_TO_CSET] PRIMARY KEY CLUSTERED ([GM_FingerType])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CONFIDENTIAL_TYPE]'
GO
CREATE TABLE [dbo].[CONFIDENTIAL_TYPE]
(
[ConfidentialTypeId] [int] NOT NULL IDENTITY(1, 1),
[ConfidentialTypeKey] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfidentialTypeOrder] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CONFIDENTIAL_TYPE] on [dbo].[CONFIDENTIAL_TYPE]'
GO
ALTER TABLE [dbo].[CONFIDENTIAL_TYPE] ADD CONSTRAINT [PK_CONFIDENTIAL_TYPE] PRIMARY KEY CLUSTERED ([ConfidentialTypeId])
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
PRINT N'Creating [dbo].[CSET_VERSION]'
GO
CREATE TABLE [dbo].[CSET_VERSION]
(
[Id] [int] NOT NULL,
[Version_Id] [decimal] (18, 4) NOT NULL,
[Cset_Version] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Build_Number] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CSET_VERSION] on [dbo].[CSET_VERSION]'
GO
ALTER TABLE [dbo].[CSET_VERSION] ADD CONSTRAINT [PK_CSET_VERSION] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CSF_MAPPING]'
GO
CREATE TABLE [dbo].[CSF_MAPPING]
(
[CSF_Code] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Type] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CSF_MAPPING] on [dbo].[CSF_MAPPING]'
GO
ALTER TABLE [dbo].[CSF_MAPPING] ADD CONSTRAINT [PK_CSF_MAPPING] PRIMARY KEY CLUSTERED ([CSF_Code], [Question_Type], [Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]'
GO
CREATE TABLE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]
(
[Option_Id] [int] NOT NULL IDENTITY(1, 1),
[DataItemName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NOT NULL,
[OptionValue] [int] NOT NULL,
[OptionText] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DETAIL_DEMOG_OPTIONS] on [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]'
GO
ALTER TABLE [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ADD CONSTRAINT [PK_DETAIL_DEMOG_OPTIONS] PRIMARY KEY CLUSTERED ([Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[DIAGRAM_TEMPLATES]'
GO
CREATE TABLE [dbo].[DIAGRAM_TEMPLATES]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Template_Name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[File_Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Is_Read_Only] [bit] NOT NULL CONSTRAINT [DF_DIAGRAM_TEMPLATES_Is_Read_Only] DEFAULT ((1)),
[Is_Visible] [bit] NOT NULL CONSTRAINT [DF_DIAGRAM_TEMPLATES_Is_Visible] DEFAULT ((1)),
[Diagram_Markup] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Image_Source] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_DIAGRAM_TEMPATES] on [dbo].[DIAGRAM_TEMPLATES]'
GO
ALTER TABLE [dbo].[DIAGRAM_TEMPLATES] ADD CONSTRAINT [PK_DIAGRAM_TEMPATES] PRIMARY KEY CLUSTERED ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[EXTRA_ACET_MAPPING]'
GO
CREATE TABLE [dbo].[EXTRA_ACET_MAPPING]
(
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Id] [int] NOT NULL,
[New_Question_Set_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_EXTRA_ACET_MAPPING] on [dbo].[EXTRA_ACET_MAPPING]'
GO
ALTER TABLE [dbo].[EXTRA_ACET_MAPPING] ADD CONSTRAINT [PK_EXTRA_ACET_MAPPING] PRIMARY KEY CLUSTERED ([Set_Name], [Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GLOBAL_PROPERTIES]'
GO
CREATE TABLE [dbo].[GLOBAL_PROPERTIES]
(
[Property] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Property_Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GlobalProperties] on [dbo].[GLOBAL_PROPERTIES]'
GO
ALTER TABLE [dbo].[GLOBAL_PROPERTIES] ADD CONSTRAINT [PK_GlobalProperties] PRIMARY KEY CLUSTERED ([Property])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[GLOSSARY]'
GO
CREATE TABLE [dbo].[GLOSSARY]
(
[Maturity_Model_Id] [int] NOT NULL,
[Term] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Definition] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_GLOSSARY] on [dbo].[GLOSSARY]'
GO
ALTER TABLE [dbo].[GLOSSARY] ADD CONSTRAINT [PK_GLOSSARY] PRIMARY KEY CLUSTERED ([Maturity_Model_Id], [Term])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[INSTALLATION]'
GO
CREATE TABLE [dbo].[INSTALLATION]
(
[JWT_Secret] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Generated_UTC] [datetime] NOT NULL,
[Installation_ID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_INSTALLATION] on [dbo].[INSTALLATION]'
GO
ALTER TABLE [dbo].[INSTALLATION] ADD CONSTRAINT [PK_INSTALLATION] PRIMARY KEY CLUSTERED ([Installation_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[JWT]'
GO
CREATE TABLE [dbo].[JWT]
(
[Secret] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Generated] [datetime] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_JWT] on [dbo].[JWT]'
GO
ALTER TABLE [dbo].[JWT] ADD CONSTRAINT [PK_JWT] PRIMARY KEY CLUSTERED ([Secret])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[LEVEL_BACKUP_ACET]'
GO
CREATE TABLE [dbo].[LEVEL_BACKUP_ACET]
(
[requirement_id] [int] NOT NULL,
[Standard_Level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_LEVEL_BACKUP_ACET] on [dbo].[LEVEL_BACKUP_ACET]'
GO
ALTER TABLE [dbo].[LEVEL_BACKUP_ACET] ADD CONSTRAINT [PK_LEVEL_BACKUP_ACET] PRIMARY KEY CLUSTERED ([requirement_id], [Standard_Level])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[LEVEL_BACKUP_ACET_QUESTIONS]'
GO
CREATE TABLE [dbo].[LEVEL_BACKUP_ACET_QUESTIONS]
(
[question_id] [int] NOT NULL,
[New_Question_Set_Id] [int] NOT NULL,
[universal_sal_level] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_LEVEL_BACKUP_ACET_QUESTIONS] on [dbo].[LEVEL_BACKUP_ACET_QUESTIONS]'
GO
ALTER TABLE [dbo].[LEVEL_BACKUP_ACET_QUESTIONS] ADD CONSTRAINT [PK_LEVEL_BACKUP_ACET_QUESTIONS] PRIMARY KEY CLUSTERED ([New_Question_Set_Id], [universal_sal_level])
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
PRINT N'Creating [dbo].[MALCOLM_MAPPING]'
GO
CREATE TABLE [dbo].[MALCOLM_MAPPING]
(
[Malcolm_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Or_Requirement_Id] [int] NOT NULL,
[Rule_Violated] [int] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Rule_Violated] DEFAULT ((0)),
[Is_Standard] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Requirement] DEFAULT ((0)),
[Is_Component] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Component] DEFAULT ((0)),
[Is_Maturity] [bit] NOT NULL CONSTRAINT [DF_MALCOLM_MAPPING_Is_Maturity] DEFAULT ((0)),
[Mat_Option_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MALCOLM_MAPPING] on [dbo].[MALCOLM_MAPPING]'
GO
ALTER TABLE [dbo].[MALCOLM_MAPPING] ADD CONSTRAINT [PK_MALCOLM_MAPPING] PRIMARY KEY CLUSTERED ([Malcolm_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_POSSIBLE_ANSWERS]'
GO
CREATE TABLE [dbo].[MATURITY_POSSIBLE_ANSWERS]
(
[Maturity_Model_Id] [int] NOT NULL,
[Maturity_Answer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
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
PRINT N'Creating [dbo].[NAVIGATION_STATE]'
GO
CREATE TABLE [dbo].[NAVIGATION_STATE]
(
[Name] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[IsError] [bit] NOT NULL,
[IsVisited] [bit] NOT NULL,
[IsAvailable] [bit] NOT NULL CONSTRAINT [DF_NAVIGATION_STATE_IsAvailable] DEFAULT ((1)),
[PercentCompletion] [float] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NAVIGATION_STATE] on [dbo].[NAVIGATION_STATE]'
GO
ALTER TABLE [dbo].[NAVIGATION_STATE] ADD CONSTRAINT [PK_NAVIGATION_STATE] PRIMARY KEY CLUSTERED ([Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_CONVERSION_MAPPINGS]'
GO
CREATE TABLE [dbo].[NCSF_CONVERSION_MAPPINGS]
(
[Conversion_Id] [int] NOT NULL IDENTITY(1, 1),
[Entry_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mid_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Full_Level_Titles] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Maturity_Model_Id] [int] NOT NULL,
[Set_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NCSF_ASSESSMENT_UPGRADE] on [dbo].[NCSF_CONVERSION_MAPPINGS]'
GO
ALTER TABLE [dbo].[NCSF_CONVERSION_MAPPINGS] ADD CONSTRAINT [PK_NCSF_ASSESSMENT_UPGRADE] PRIMARY KEY CLUSTERED ([Conversion_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NCSF_MIGRATION2]'
GO
CREATE TABLE [dbo].[NCSF_MIGRATION2]
(
[V2id] [int] NULL,
[V2Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[V1Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[V1Id] [int] NULL
)
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
PRINT N'Creating [dbo].[NIST_SAL_INFO_TYPES_DEFAULTS]'
GO
CREATE TABLE [dbo].[NIST_SAL_INFO_TYPES_DEFAULTS]
(
[Type_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Confidentiality_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Confidentiality_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Integrity_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Integrity_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Availability_Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Availability_Special_Factor] [nvarchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Area] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NIST_Number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NIST_SAL_INFO_TYPES_DEFAULTS] on [dbo].[NIST_SAL_INFO_TYPES_DEFAULTS]'
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES_DEFAULTS] ADD CONSTRAINT [PK_NIST_SAL_INFO_TYPES_DEFAULTS] PRIMARY KEY CLUSTERED ([Type_Value])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Nlogs]'
GO
CREATE TABLE [dbo].[Nlogs]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Date] [datetime] NOT NULL,
[Level] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logger] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[QUESTION_GROUP_TYPE]'
GO
CREATE TABLE [dbo].[QUESTION_GROUP_TYPE]
(
[Question_Group_Id] [int] NOT NULL IDENTITY(1, 1),
[Group_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Scoring_Group] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Scoring_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Group_Header] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Question_Group_Type] on [dbo].[QUESTION_GROUP_TYPE]'
GO
ALTER TABLE [dbo].[QUESTION_GROUP_TYPE] ADD CONSTRAINT [PK_Question_Group_Type] PRIMARY KEY CLUSTERED ([Question_Group_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_QUESTION_GROUP_TYPE] on [dbo].[QUESTION_GROUP_TYPE]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_QUESTION_GROUP_TYPE] ON [dbo].[QUESTION_GROUP_TYPE] ([Group_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RECENT_FILES]'
GO
CREATE TABLE [dbo].[RECENT_FILES]
(
[AssessmentName] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filename] [nvarchar] (900) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilePath] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastOpenedTime] [datetime] NOT NULL,
[RecentFileId] [int] NOT NULL IDENTITY(1, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_RECENT_FILES_1] on [dbo].[RECENT_FILES]'
GO
ALTER TABLE [dbo].[RECENT_FILES] ADD CONSTRAINT [PK_RECENT_FILES_1] PRIMARY KEY CLUSTERED ([RecentFileId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[RapidAssessmentControls]'
GO
CREATE TABLE [dbo].[RapidAssessmentControls]
(
[order] [tinyint] NOT NULL,
[value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_RapidAssessmentControls] on [dbo].[RapidAssessmentControls]'
GO
ALTER TABLE [dbo].[RapidAssessmentControls] ADD CONSTRAINT [PK_RapidAssessmentControls] PRIMARY KEY CLUSTERED ([order])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SECURITY_QUESTION]'
GO
CREATE TABLE [dbo].[SECURITY_QUESTION]
(
[SecurityQuestionId] [int] NOT NULL IDENTITY(1, 1),
[SecurityQuestion] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsCustomQuestion] [bit] NOT NULL CONSTRAINT [DF_SECURITY_QUESTION_IsCustomQuestion] DEFAULT ((1))
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_SECURITY_QUESTION] on [dbo].[SECURITY_QUESTION]'
GO
ALTER TABLE [dbo].[SECURITY_QUESTION] ADD CONSTRAINT [PK_SECURITY_QUESTION] PRIMARY KEY CLUSTERED ([SecurityQuestionId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SHAPE_TYPES]'
GO
CREATE TABLE [dbo].[SHAPE_TYPES]
(
[Diagram_Type_XML] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Telerik_Shape_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Visio_Shape_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDefault] [bit] NOT NULL,
[DisplayName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_Shape_Types] on [dbo].[SHAPE_TYPES]'
GO
ALTER TABLE [dbo].[SHAPE_TYPES] ADD CONSTRAINT [PK_Shape_Types] PRIMARY KEY CLUSTERED ([Diagram_Type_XML])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SP80053_FAMILY_ABBREVIATIONS]'
GO
CREATE TABLE [dbo].[SP80053_FAMILY_ABBREVIATIONS]
(
[ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard_Category] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Standard_Order] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_NEW_53_FAMILY_ABBREVIATIONS] on [dbo].[SP80053_FAMILY_ABBREVIATIONS]'
GO
ALTER TABLE [dbo].[SP80053_FAMILY_ABBREVIATIONS] ADD CONSTRAINT [PK_NEW_53_FAMILY_ABBREVIATIONS] PRIMARY KEY CLUSTERED ([ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[UNIVERSAL_AREA]'
GO
CREATE TABLE [dbo].[UNIVERSAL_AREA]
(
[Universal_Area_Name] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Area_Weight] [float] NULL,
[Comments] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Universal_Area_Number] [int] NOT NULL IDENTITY(43, 1)
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [UNIVERSAL_AREA_PK] on [dbo].[UNIVERSAL_AREA]'
GO
ALTER TABLE [dbo].[UNIVERSAL_AREA] ADD CONSTRAINT [UNIVERSAL_AREA_PK] PRIMARY KEY CLUSTERED ([Universal_Area_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[WEIGHT]'
GO
CREATE TABLE [dbo].[WEIGHT]
(
[Weight] [int] NOT NULL,
[Question_Normalized_Weight] [decimal] (18, 2) NOT NULL,
[Requirement_Normalized_Weight] [decimal] (18, 2) NOT NULL,
[Category_Normalized_Weight] [decimal] (18, 2) NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_QUESTION_WEIGHT] on [dbo].[WEIGHT]'
GO
ALTER TABLE [dbo].[WEIGHT] ADD CONSTRAINT [PK_QUESTION_WEIGHT] PRIMARY KEY CLUSTERED ([Weight])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[CheckHeading]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckHeading]
	-- Add the parameters for the stored procedure here
	@Heading nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if not exists (SELECT * from Question_Headings where Question_Group_Heading = @heading)
		insert QUESTION_HEADINGS values(@Heading);
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Parse_XML]'
GO
-- =============================================
-- Author:		Scott Cook
-- Create date: 11/10/14
-- Description:	Parses XML string and writes the data to the temporary table.
-- =============================================
CREATE PROCEDURE [dbo].[Parse_XML](
                                   @XMLString nvarchar(MAX),
                                   @strtX BIGINT,
					 			   @endX BIGINT OUTPUT,
								   @DataStr nvarchar(MAX) OUTPUT
								  )
AS
BEGIN
	DECLARE @StartChar CHAR(1)
	DECLARE @endTmp BIGINT

	SET @strtX = CHARINDEX('<', @XMLString, @strtX)
	SET @StartChar = SUBSTRING(@XMLString, @strtX + 1, 1)

	IF @StartChar = '/'
	  SET @endX = CHARINDEX('>', @XMLString, @strtX)
	ELSE
	  BEGIN  
        SET @endTmp = CHARINDEX('>', @XMLString, @strtX)
        IF SUBSTRING(@XMLString, @endTmp - 1, 1) = '/'
          SET @endX = @endTmp
	    ELSE
	      BEGIN
		    SET @endTmp = CHARINDEX('<', @XMLString, @endTmp)
		    IF SUBSTRING(@XMLString, @endTmp + 1, 1) = '/'
              SET @endX = CHARINDEX('>', @XMLString, @endTmp + 1)
		    ELSE
		      SET @endX = @endTmp - 1
	      END
	  END

	SET @DataStr = SUBSTRING(@XMLString, @strtX, (@endX - @strtX) + 1)
	SET @endX = @endX + 1

--select @DataStr
--select @endX

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SP_SearchTables]'
GO
CREATE PROCEDURE [dbo].[SP_SearchTables] 
 @Tablenames nvarchar(500) 
,@SearchStr NVARCHAR(60) 
,@GenerateSQLOnly Bit = 0 
AS 
 
/* 
    Parameters and usage 
 
    @Tablenames        -- Provide a single table name or multiple table name with comma seperated.  
                        If left blank , it will check for all the tables in the database 
    @SearchStr        -- Provide the search string. Use the '%' to coin the search.  
                        EX : X%--- will give data staring with X 
                             %X--- will give data ending with X 
                             %X%--- will give data containig  X 
    @GenerateSQLOnly -- Provide 1 if you only want to generate the SQL statements without seraching the database.  
                        By default it is 0 and it will search. 
 
    Samples : 
 
    1. To search data in a table 
 
        EXEC SP_SearchTables @Tablenames = 'T1' 
                         ,@SearchStr  = '%TEST%' 
 
        The above sample searches in table T1 with string containing TEST. 
 
    2. To search in a multiple table 
 
        EXEC SP_SearchTables @Tablenames = 'T2' 
                         ,@SearchStr  = '%TEST%' 
 
        The above sample searches in tables T1 & T2 with string containing TEST. 
     
    3. To search in a all table 
 
        EXEC SP_SearchTables @Tablenames = '%' 
                         ,@SearchStr  = '%TEST%' 
 
        The above sample searches in all table with string containing TEST. 
 
    4. Generate the SQL for the Select statements 
 
        EXEC SP_SearchTables @Tablenames        = 'T1' 
                         ,@SearchStr        = '%TEST%' 
                         ,@GenerateSQLOnly    = 1 
 
*/ 
 
    SET NOCOUNT ON 
 
    DECLARE @MatchFound BIT 
 
    SELECT @MatchFound = 0 
 
    DECLARE @CheckTableNames Table 
    ( 
    Tablename sysname 
    ) 
 
    DECLARE @SQLTbl TABLE 
    ( 
     Tablename        SYSNAME 
    ,WHEREClause    nvarchar(MAX) 
    ,SQLStatement   nvarchar(MAX) 
    ,Execstatus        BIT  
    ) 
 
    DECLARE @SQL nvarchar(MAX) 
    DECLARE @tmpTblname sysname 
    DECLARE @ErrMsg nvarchar(100) 
 
    IF LTRIM(RTRIM(@Tablenames)) IN ('' ,'%') 
    BEGIN 
 
        INSERT INTO @CheckTableNames 
        SELECT Name 
          FROM sys.tables 
    END 
    ELSE 
    BEGIN 
 
        SELECT @SQL = 'SELECT ''' + REPLACE(@Tablenames,',',''' UNION SELECT ''') + '''' 
 
        INSERT INTO @CheckTableNames 
        EXEC(@SQL) 
 
    END 
 
    IF NOT EXISTS(SELECT 1 FROM @CheckTableNames) 
    BEGIN 
         
        SELECT @ErrMsg = 'No tables are found in this database ' + DB_NAME() + ' for the specified filter' 
        PRINT @ErrMsg 
        RETURN 
 
    END 
     
    INSERT INTO @SQLTbl 
    ( Tablename,WHEREClause) 
    SELECT QUOTENAME(SCh.name) + '.' + QUOTENAME(ST.NAME), 
            ( 
                SELECT '[' + SC.Name + ']' + ' LIKE ''' + @SearchStr + ''' OR ' + CHAR(10) 
                  FROM SYS.columns SC 
                  JOIN SYS.types STy 
                    ON STy.system_type_id = SC.system_type_id 
                   AND STy.user_type_id =SC.user_type_id 
                 WHERE STY.name in ('varchar','char','nvarchar','nchar','text') 
                   AND SC.object_id = ST.object_id 
                 ORDER BY SC.name 
                FOR XML PATH('') 
            ) 
      FROM  SYS.tables ST 
      JOIN @CheckTableNames chktbls 
                ON chktbls.Tablename = ST.name  
      JOIN SYS.schemas SCh 
        ON ST.schema_id = SCh.schema_id 
     WHERE ST.name <> 'SearchTMP' 
      GROUP BY ST.object_id, QUOTENAME(SCh.name) + '.' +  QUOTENAME(ST.NAME) ; 
     
 
      UPDATE @SQLTbl 
         SET SQLStatement = 'SELECT * INTO SearchTMP FROM ' + Tablename + ' WHERE ' + substring(WHEREClause,1,len(WHEREClause)-5) 
 
      DELETE FROM @SQLTbl 
       WHERE WHEREClause IS NULL 
     
    WHILE EXISTS (SELECT 1 FROM @SQLTbl WHERE ISNULL(Execstatus ,0) = 0) 
    BEGIN 
 
        SELECT TOP 1 @tmpTblname = Tablename , @SQL = SQLStatement 
          FROM @SQLTbl  
         WHERE ISNULL(Execstatus ,0) = 0 
 
         IF @GenerateSQLOnly = 0 
         BEGIN 
 
            IF OBJECT_ID('SearchTMP','U') IS NOT NULL 
                DROP TABLE SearchTMP 
                 
            EXEC (@SQL) 
 
            IF EXISTS(SELECT 1 FROM SearchTMP) 
            BEGIN 
                SELECT Tablename=@tmpTblname,* FROM SearchTMP 
                SELECT @MatchFound = 1 
            END 
 
         END 
         ELSE 
         BEGIN 
             PRINT REPLICATE('-',100) 
             PRINT @tmpTblname 
             PRINT REPLICATE('-',100) 
             PRINT replace(@SQL,'INTO SearchTMP','') 
         END 
 
         UPDATE @SQLTbl 
            SET Execstatus = 1 
          WHERE Tablename = @tmpTblname 
 
    END 
 
    IF @MatchFound = 0  
    BEGIN 
        SELECT @ErrMsg = 'No Matches are found in this database ' + DB_NAME() + ' for the specified filter' 
        PRINT @ErrMsg 
        RETURN 
    END 
     
    SET NOCOUNT OFF 
 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[SearchAllTables]'
GO
CREATE PROC [dbo].[SearchAllTables]
(
@SearchStr nvarchar(100)
)
AS
BEGIN

-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
-- Purpose: To search all columns of all tables for a given search string
-- Written by: Narayana Vyas Kondreddi
-- Site: http://vyaskn.tripod.com
-- Tested on: SQL Server 7.0 and SQL Server 2000
-- Date modified: 28th July 2002 22:50 GMT


CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

SET NOCOUNT ON

DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
SET  @TableName = ''
--SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
SET @SearchStr2 = QUOTENAME(@SearchStr, '''')

WHILE @TableName IS NOT NULL
BEGIN
    SET @ColumnName = ''
    SET @TableName = 
    (
        SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
        FROM    INFORMATION_SCHEMA.TABLES
        WHERE       TABLE_TYPE = 'BASE TABLE'
            AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND OBJECTPROPERTY(
                    OBJECT_ID(
                        QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                         ), 'IsMSShipped'
                           ) = 0
    )

    WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
    BEGIN
        SET @ColumnName =
        (
            SELECT MIN(QUOTENAME(COLUMN_NAME))
            FROM    INFORMATION_SCHEMA.COLUMNS
            WHERE       TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                AND TABLE_NAME  = PARSENAME(@TableName, 1)
                AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
                AND QUOTENAME(COLUMN_NAME) > @ColumnName
        )

        IF @ColumnName IS NOT NULL
        BEGIN
            INSERT INTO #Results
            EXEC
            (
                'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                FROM ' + @TableName + ' (NOLOCK) ' +
                ' WHERE ' + @ColumnName + ' = ' + @SearchStr2
            )
        END
    END 
END

SELECT ColumnName, ColumnValue FROM #Results
 END

 exec SearchAllTables 'Low'
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
PRINT N'Creating [dbo].[usp_AggregationCustomQuestionnaireLoad]'
GO

--drop procedure usp_AggregationCustomQuestionnaireLoad
-- =============================================
-- Author:		hansbk
-- Create date: 6-16-2016
-- Description:	Note that this returns your expected custom control set name it may 
-- not be the same name that went in. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_AggregationCustomQuestionnaireLoad]
	@AssessmentDBName nvarchar(4000),	
	@entity_name nvarchar(50)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @tempEntityName nvarchar(50)
declare @i int
declare @addNew bit
declare @sql nvarchar(max)

Set @addNew = 1

IF (1=0) 
BEGIN 
    SET FMTONLY OFF 
    if @entity_name is null 
        begin
            select cast(null as nvarchar(50)) as [entity_name]            
        END
END   

set @tempEntityName = @entity_name

set @sql = 
'if @entity_name is not null
begin '+
'--copy the entity name to the sets table '+  CHAR(13)+CHAR(10) + 
'--copy all the questions over to new_question_sets '+  CHAR(13)+CHAR(10) + 
'set @tempEntityName = @entity_name '+  CHAR(13)+CHAR(10) +
'set @i =0 '+ CHAR(13)+CHAR(10) + 
'--first get a unique name for the set'+ CHAR(13)+CHAR(10) + 
'	if @addNew = 1'+ CHAR(13)+CHAR(10) + 
'	begin'+ CHAR(13)+CHAR(10) + 
'		while exists (select * from sets where set_name = @tempEntityName)'+ CHAR(13)+CHAR(10) + 
'		begin'+ CHAR(13)+CHAR(10) + 
'			set @i = @i+1'+ CHAR(13)+CHAR(10) + 
'			set @tempEntityName = @entity_name +convert(varchar,@i)'+CHAR(13)+CHAR(10) + 
'		end'+CHAR(13)+CHAR(10) + 
'	end'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [SETS]'+CHAR(13)+CHAR(10) + 
'			   ([Set_Name],[Full_Name],[Short_Name],[Is_Displayed],[Is_Pass_Fail],[Old_Std_Name],[Set_Category_Id],[Order_In_Category],[Report_Order_Section_Number],[Aggregation_Standard_Number],[Is_Question],[Is_Requirement],[Order_Framework_Standards],[Standard_ToolTip],[Is_Deprecated],[Upgrade_Set_Name],[Is_Custom],[Date],[IsEncryptedModule],[IsEncryptedModuleOpen])'+CHAR(13)+CHAR(10) + 
'		 VALUES(@tempEntityName,@entity_name,@entity_name,1,1,null,1,1,35,35,1,0,35,null,0,null,1,getdate(),0,0)'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [NEW_QUESTION_SETS] ([Set_Name],[Question_Id])     '+CHAR(13)+CHAR(10) + 
'		SELECT [Custom_Questionaire_Name]=@tempEntityName'+CHAR(13)+CHAR(10) + 
'			  ,[Question_Id]'+CHAR(13)+CHAR(10) + 
'		FROM ['+@AssessmentDBName+'].[CUSTOM_QUESTIONAIRE_QUESTIONS]'+CHAR(13)+CHAR(10) + 
'end';

print @sql

EXECUTE sp_executesql   
          @sql, 
		  N'@entity_name nvarchar(50), @tempEntityName nvarchar(50) output, @i int, @addNew bit',
          @entity_name,
		  @tempEntityName out,
		  @i,
		  @addNew;

		  set @entity_name = @tempEntityName;

select [entity_name] = @entity_name 

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [CK_ASSESSMENTS_REQUIRED_DOCUMENTATION] CHECK (([Answer]='NA' OR [Answer]='N' OR [Answer]='Y' OR [Answer]='U'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[NIST_SAL_QUESTION_ANSWERS]'
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] ADD CONSTRAINT [CK_NIST_SAL_QUESTION_ANSWERS] CHECK (([Question_Answer]='No' OR [Question_Answer]='Yes'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ANSWER]'
GO
ALTER TABLE [dbo].[ANSWER] WITH NOCHECK  ADD CONSTRAINT [FK_ANSWER_Answer_Lookup] FOREIGN KEY ([Answer_Text]) REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] WITH NOCHECK  ADD CONSTRAINT [FK_ANSWER_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_Component_Questions_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CUSTOM_STANDARD_BASE_STANDARD]'
GO
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] WITH NOCHECK  ADD CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS] FOREIGN KEY ([Base_Standard]) REFERENCES [dbo].[SETS] ([Set_Name])
GO
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] WITH NOCHECK  ADD CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1] FOREIGN KEY ([Custom_Questionaire_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] WITH NOCHECK  ADD CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER] FOREIGN KEY ([Parent_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id]) NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DOCUMENT_ANSWERS]'
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS] WITH NOCHECK  ADD CONSTRAINT [FK_Document_Answers_DOCUMENT_FILE] FOREIGN KEY ([Document_Id]) REFERENCES [dbo].[DOCUMENT_FILE] ([Document_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DOCUMENT_FILE]'
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] WITH NOCHECK  ADD CONSTRAINT [FK_DOCUMENT_FILE_DEMOGRAPHICS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[DEMOGRAPHICS] ([Assessment_Id]) NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FILE_KEYWORDS]'
GO
ALTER TABLE [dbo].[FILE_KEYWORDS] WITH NOCHECK  ADD CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINDING]'
GO
ALTER TABLE [dbo].[FINDING] WITH NOCHECK  ADD CONSTRAINT [FK_FINDING_IMPORTANCE1] FOREIGN KEY ([Importance_Id]) REFERENCES [dbo].[IMPORTANCE] ([Importance_Id]) ON DELETE SET NULL ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GEN_FILE_LIB_PATH_CORL]'
GO
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] WITH NOCHECK  ADD CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] WITH NOCHECK  ADD CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH] FOREIGN KEY ([Lib_Path_Id]) REFERENCES [dbo].[REF_LIBRARY_PATH] ([Lib_Path_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[INFORMATION]'
GO
ALTER TABLE [dbo].[INFORMATION] WITH NOCHECK  ADD CONSTRAINT [FK_INFORMATION_DOCUMENT_FILE1] FOREIGN KEY ([eMass_Document_Id]) REFERENCES [dbo].[DOCUMENT_FILE] ([Document_Id]) ON DELETE SET NULL
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
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK__MATURITY___Matur__5B638405] FOREIGN KEY ([Maturity_Level_Id]) REFERENCES [dbo].[MATURITY_LEVELS] ([Maturity_Level_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS] FOREIGN KEY ([Parent_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) NOT FOR REPLICATION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NERC_RISK_RANKING]'
GO
ALTER TABLE [dbo].[NERC_RISK_RANKING] WITH NOCHECK  ADD CONSTRAINT [FK_NERC_RISK_RANKING_NEW_QUESTION] FOREIGN KEY ([Question_id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NERC_RISK_RANKING] WITH NOCHECK  ADD CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION]'
GO
ALTER TABLE [dbo].[NEW_QUESTION] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_QUESTION_SETS] FOREIGN KEY ([Original_Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION_LEVELS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL] FOREIGN KEY ([Universal_Sal_Level]) REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION_SETS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NEW_QUESTION_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_QUESTION_SETS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category] FOREIGN KEY ([NCSF_Cat_Id]) REFERENCES [dbo].[NCSF_CATEGORY] ([NCSF_Cat_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_SETS] FOREIGN KEY ([Original_Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name])
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY] FOREIGN KEY ([Standard_Category]) REFERENCES [dbo].[STANDARD_CATEGORY] ([Standard_Category]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NIST_SAL_INFO_TYPES]'
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES] WITH NOCHECK  ADD CONSTRAINT [FK_NIST_SAL_STANDARD_SELECTION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] WITH NOCHECK  ADD CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PROCUREMENT_DEPENDENCY]'
GO
ALTER TABLE [dbo].[PROCUREMENT_DEPENDENCY] WITH NOCHECK  ADD CONSTRAINT [FK_PROCUREMENT_DEPENDENCY_PROCUREMENT_LANGUAGE_DATA] FOREIGN KEY ([Procurement_Id]) REFERENCES [dbo].[PROCUREMENT_LANGUAGE_DATA] ([Procurement_Id])
GO
ALTER TABLE [dbo].[PROCUREMENT_DEPENDENCY] WITH NOCHECK  ADD CONSTRAINT [FK_PROCUREMENT_DEPENDENCY_PROCUREMENT_LANGUAGE_DATA1] FOREIGN KEY ([Dependencies_Id]) REFERENCES [dbo].[PROCUREMENT_LANGUAGE_DATA] ([Procurement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PROCUREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[PROCUREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_Procurement_References_Procurement_Language_Data] FOREIGN KEY ([Procurement_Id]) REFERENCES [dbo].[PROCUREMENT_LANGUAGE_DATA] ([Procurement_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[RECOMMENDATIONS_REFERENCES]'
GO
ALTER TABLE [dbo].[RECOMMENDATIONS_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_Recommendations_References_Catalog_Recommendations_Data] FOREIGN KEY ([Data_Id]) REFERENCES [dbo].[CATALOG_RECOMMENDATIONS_DATA] ([Data_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_LEVELS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL] FOREIGN KEY ([Standard_Level]) REFERENCES [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_QUESTION_SETS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]'
GO
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] WITH NOCHECK  ADD CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STANDARD_CATEGORY_SEQUENCE]'
GO
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] WITH NOCHECK  ADD CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STANDARD_SOURCE_FILE]'
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] WITH NOCHECK  ADD CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS] FOREIGN KEY ([Doc_Num]) REFERENCES [dbo].[FILE_REF_KEYS] ([Doc_Num]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] WITH NOCHECK  ADD CONSTRAINT [FK_Standard_Source_File_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SUB_CATEGORY_ANSWERS]'
GO
ALTER TABLE [dbo].[SUB_CATEGORY_ANSWERS] WITH NOCHECK  ADD CONSTRAINT [FK_SUB_CATEGORY_ANSWERS_Answer_Lookup] FOREIGN KEY ([Answer_Text]) REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[VISIO_MAPPING]'
GO
ALTER TABLE [dbo].[VISIO_MAPPING] WITH NOCHECK  ADD CONSTRAINT [FK_VISIO_MAPPING_DIAGRAM_TYPES] FOREIGN KEY ([Specific_Type]) REFERENCES [dbo].[DIAGRAM_TYPES] ([Specific_Type]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ACCESS_KEY_ASSESSMENT]'
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ACCESS_KEY] FOREIGN KEY ([AccessKey]) REFERENCES [dbo].[ACCESS_KEY] ([AccessKey]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ACCESS_KEY_ASSESSMENT] ADD CONSTRAINT [FK_ACCESS_KEY_ASSESSMENT_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ADDRESS]'
GO
ALTER TABLE [dbo].[ADDRESS] ADD CONSTRAINT [FK_ADDRESS_USER_DETAIL_INFORMATION1] FOREIGN KEY ([Id]) REFERENCES [dbo].[USER_DETAIL_INFORMATION] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AGGREGATION_ASSESSMENT]'
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [FK__AGGREGATI__Aggre__6EAB62A3] FOREIGN KEY ([Aggregation_Id]) REFERENCES [dbo].[AGGREGATION_INFORMATION] ([AggregationID])
GO
ALTER TABLE [dbo].[AGGREGATION_ASSESSMENT] ADD CONSTRAINT [FK__AGGREGATI__Asses__6CC31A31] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AGGREGATION_INFORMATION]'
GO
ALTER TABLE [dbo].[AGGREGATION_INFORMATION] ADD CONSTRAINT [FK_AGGREGATION_INFORMATION_AGGREGATION_TYPES] FOREIGN KEY ([Aggregation_Mode]) REFERENCES [dbo].[AGGREGATION_TYPES] ([Aggregation_Mode])
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
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [FK_ANSWER_ANSWER_QUESTION_TYPES] FOREIGN KEY ([Question_Type]) REFERENCES [dbo].[ANSWER_QUESTION_TYPES] ([Question_Type]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] ADD CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1] FOREIGN KEY ([Mat_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id]) ON DELETE CASCADE
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
ALTER TABLE [dbo].[ANSWER_PROFILE] ADD CONSTRAINT [FK_ANSWER_PROFILE_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM] FOREIGN KEY ([GalleryItemGuid]) REFERENCES [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid]) ON DELETE SET NULL ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD CONSTRAINT [FK_ASSESSMENTS_USERS] FOREIGN KEY ([AssessmentCreatorId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE SET NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [FK_ASSESSMENTS_REQUIRED_DOCUMENTATION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [FK_ASSESSMENTS_REQUIRED_DOCUMENTATION_REQUIRED_DOCUMENTATION] FOREIGN KEY ([Documentation_Id]) REFERENCES [dbo].[REQUIRED_DOCUMENTATION] ([Documentation_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_CONTACTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD CONSTRAINT [FK_ASSESSMENT_CONTACTS_ASSESSMENT_ROLES] FOREIGN KEY ([AssessmentRoleId]) REFERENCES [dbo].[ASSESSMENT_ROLES] ([AssessmentRoleId])
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD CONSTRAINT [FK_ASSESSMENT_CONTACTS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD CONSTRAINT [FK_ASSESSMENT_CONTACTS_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_COMPONENT_SYMBOLS1] FOREIGN KEY ([Component_Symbol_Id]) REFERENCES [dbo].[COMPONENT_SYMBOLS] ([Component_Symbol_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER] FOREIGN KEY ([Layer_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id])
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_DIAGRAM_CONTAINER1] FOREIGN KEY ([Zone_Id]) REFERENCES [dbo].[DIAGRAM_CONTAINER] ([Container_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_IRP]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP] ADD CONSTRAINT [FK__Assessmen__Asses__5DEAEAF5] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP] ADD CONSTRAINT [FK__Assessmen__IRP_I__5EDF0F2E] FOREIGN KEY ([IRP_Id]) REFERENCES [dbo].[IRP] ([IRP_ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_IRP_HEADER]'
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP_HEADER] ADD CONSTRAINT [FK__ASSESSMEN__ASSES__658C0CBD] FOREIGN KEY ([ASSESSMENT_ID]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_IRP_HEADER] ADD CONSTRAINT [FK__ASSESSMEN__IRP_H__668030F6] FOREIGN KEY ([IRP_HEADER_ID]) REFERENCES [dbo].[IRP_HEADER] ([IRP_Header_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_SELECTED_LEVELS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS] ADD CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_LEVEL_NAMES] FOREIGN KEY ([Level_Name]) REFERENCES [dbo].[LEVEL_NAMES] ([Level_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_SELECTED_LEVELS] ADD CONSTRAINT [FK_ASSESSMENT_SELECTED_LEVELS_STANDARD_SELECTION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2] FOREIGN KEY ([model_id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [FK_AVAILABLE_MATURITY_MODELS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AVAILABLE_STANDARDS]'
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] ADD CONSTRAINT [FK_AVAILABLE_STANDARDS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] ADD CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CATALOG_RECOMMENDATIONS_DATA]'
GO
ALTER TABLE [dbo].[CATALOG_RECOMMENDATIONS_DATA] ADD CONSTRAINT [FK_CATALOG_RECOMMENDATIONS_DATA_CATALOG_RECOMMENDATIONS_HEADINGS] FOREIGN KEY ([Parent_Heading_Id]) REFERENCES [dbo].[CATALOG_RECOMMENDATIONS_HEADINGS] ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CS_SITE_INFORMATION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_ORGANIZATION_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_ORGANIZATION_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS_2] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_CIS_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Primary_Defining_System]) REFERENCES [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIS_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Defining_System_Id]) REFERENCES [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIS_CSI_SERVICE_COMPOSITION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[CIS_CSI_SERVICE_COMPOSITION] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CS_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_BUDGET_BASES] FOREIGN KEY ([Budget_Basis]) REFERENCES [dbo].[CIS_CSI_BUDGET_BASES] ([Budget_Basis]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_CUSTOMER_COUNTS] FOREIGN KEY ([Customers_Count]) REFERENCES [dbo].[CIS_CSI_CUSTOMER_COUNTS] ([Customer_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS_2] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count])
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_USER_COUNTS] FOREIGN KEY ([Authorized_Non_Organizational_User_Count]) REFERENCES [dbo].[CIS_CSI_USER_COUNTS] ([User_Count]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CNSS_CIA_JUSTIFICATIONS]'
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS] ADD CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS] ADD CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_CNSS_CIA_TYPES] FOREIGN KEY ([CIA_Type]) REFERENCES [dbo].[CNSS_CIA_TYPES] ([CIA_Type]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_NAMES_LEGACY]'
GO
ALTER TABLE [dbo].[COMPONENT_NAMES_LEGACY] ADD CONSTRAINT [FK_COMPONENT_NAMES_LEGACY_COMPONENT_SYMBOLS] FOREIGN KEY ([Component_Symbol_id]) REFERENCES [dbo].[COMPONENT_SYMBOLS] ([Component_Symbol_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] ADD CONSTRAINT [FK_COMPONENT_QUESTIONS_COMPONENT_SYMBOLS] FOREIGN KEY ([Component_Symbol_Id]) REFERENCES [dbo].[COMPONENT_SYMBOLS] ([Component_Symbol_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_SYMBOLS]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS] ADD CONSTRAINT [FK_COMPONENT_SYMBOLS_COMPONENT_FAMILY] FOREIGN KEY ([Component_Family_Name]) REFERENCES [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS] ADD CONSTRAINT [FK_COMPONENT_SYMBOLS_SYMBOL_GROUPS] FOREIGN KEY ([Symbol_Group_Id]) REFERENCES [dbo].[SYMBOL_GROUPS] ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_SYMBOLS_MAPPINGS]'
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS_MAPPINGS] ADD CONSTRAINT [FK_COMPONENT_SYMBOLS_MAPPINGS_COMPONENT_SYMBOLS] FOREIGN KEY ([Component_Symbol_Id]) REFERENCES [dbo].[COMPONENT_SYMBOLS] ([Component_Symbol_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COUNTIES]'
GO
ALTER TABLE [dbo].[COUNTIES] ADD CONSTRAINT [FK_COUNTIES_STATE_REGION] FOREIGN KEY ([State], [RegionCode]) REFERENCES [dbo].[STATE_REGION] ([State], [RegionCode])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COUNTY_ANSWERS]'
GO
ALTER TABLE [dbo].[COUNTY_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicCountyAnswers_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COUNTY_ANSWERS] ADD CONSTRAINT [FK_ExtendedDemographicCountyAnswers_COUNTIES] FOREIGN KEY ([County_FIPS]) REFERENCES [dbo].[COUNTIES] ([County_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COUNTY_METRO_AREA]'
GO
ALTER TABLE [dbo].[COUNTY_METRO_AREA] ADD CONSTRAINT [FK_COUNTY_METRO_AREA_METRO_AREA] FOREIGN KEY ([Metro_FIPS]) REFERENCES [dbo].[METRO_AREA] ([Metro_FIPS])
GO
ALTER TABLE [dbo].[COUNTY_METRO_AREA] ADD CONSTRAINT [FK_County_MetropolitanArea_COUNTIES] FOREIGN KEY ([County_FIPS]) REFERENCES [dbo].[COUNTIES] ([County_FIPS])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CUSTOM_BASE_STANDARDS]'
GO
ALTER TABLE [dbo].[CUSTOM_BASE_STANDARDS] ADD CONSTRAINT [FK_CUSTOM_BASE_STANDARD_CUSTOM_QUESTIONAIRES] FOREIGN KEY ([Custom_Questionaire_Name]) REFERENCES [dbo].[CUSTOM_QUESTIONAIRES] ([Custom_Questionaire_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS]'
GO
ALTER TABLE [dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS] ADD CONSTRAINT [FK_CUSTON_QUESTIONAIRE_QUESTIONS_CUSTOM_QUESTIONAIRES] FOREIGN KEY ([Custom_Questionaire_Name]) REFERENCES [dbo].[CUSTOM_QUESTIONAIRES] ([Custom_Questionaire_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_ASSESSMENT_CONTACTS_FACILITATOR] FOREIGN KEY ([Facilitator]) REFERENCES [dbo].[ASSESSMENT_CONTACTS] ([Assessment_Contact_Id])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_ASSESSMENT_CONTACTS_POINTOFCONTACT] FOREIGN KEY ([PointOfContact]) REFERENCES [dbo].[ASSESSMENT_CONTACTS] ([Assessment_Contact_Id])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[DEMOGRAPHICS] ([Assessment_Id])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_ASSET_VALUES] FOREIGN KEY ([AssetValue]) REFERENCES [dbo].[DEMOGRAPHICS_ASSET_VALUES] ([AssetValue]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_ORGANIZATION_TYPE] FOREIGN KEY ([OrganizationType]) REFERENCES [dbo].[DEMOGRAPHICS_ORGANIZATION_TYPE] ([OrganizationTypeId])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_DEMOGRAPHICS_SIZE] FOREIGN KEY ([Size]) REFERENCES [dbo].[DEMOGRAPHICS_SIZE] ([Size]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_SECTOR] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[SECTOR] ([SectorId])
GO
ALTER TABLE [dbo].[DEMOGRAPHICS] ADD CONSTRAINT [FK_DEMOGRAPHICS_SECTOR_INDUSTRY] FOREIGN KEY ([IndustryId]) REFERENCES [dbo].[SECTOR_INDUSTRY] ([IndustryId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DEMOGRAPHICS_ASSET_VALUES]'
GO
ALTER TABLE [dbo].[DEMOGRAPHICS_ASSET_VALUES] ADD CONSTRAINT [FK_DEMOGRAPHICS_ASSET_VALUES_APP_CODE] FOREIGN KEY ([AppCode]) REFERENCES [dbo].[APP_CODE] ([AppCode]) ON DELETE CASCADE ON UPDATE CASCADE
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
PRINT N'Adding foreign keys to [dbo].[DETAILS_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[DETAILS_DEMOGRAPHICS] ADD CONSTRAINT [FK_DETAILS_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] ADD CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER_TYPES] FOREIGN KEY ([ContainerType]) REFERENCES [dbo].[DIAGRAM_CONTAINER_TYPES] ([ContainerType]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DIAGRAM_TYPES]'
GO
ALTER TABLE [dbo].[DIAGRAM_TYPES] ADD CONSTRAINT [FK_DIAGRAM_TYPES_DIAGRAM_OBJECT_TYPES] FOREIGN KEY ([Object_Type]) REFERENCES [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DOCUMENT_ANSWERS]'
GO
ALTER TABLE [dbo].[DOCUMENT_ANSWERS] ADD CONSTRAINT [FK_DOCUMENT_ANSWERS_ANSWER] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[ANSWER] ([Answer_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[DOCUMENT_FILE]'
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ADD CONSTRAINT [FK_DOCUMENT_FILE_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[EXT_SUB_SECTOR]'
GO
ALTER TABLE [dbo].[EXT_SUB_SECTOR] ADD CONSTRAINT [FK_ExtendedSubSector_ExtendedSector] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[EXT_SECTOR] ([SectorId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_ASSESSMENT_VALUES]'
GO
ALTER TABLE [dbo].[FINANCIAL_ASSESSMENT_VALUES] ADD CONSTRAINT [FK_FINANCIAL_ASSESSMENT_VALUES_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_ASSESSMENT_VALUES] ADD CONSTRAINT [FK_FINANCIAL_ASSESSMENT_VALUES_FINANCIAL_ATTRIBUTES] FOREIGN KEY ([AttributeName]) REFERENCES [dbo].[FINANCIAL_ATTRIBUTES] ([AttributeName]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_DETAILS]'
GO
ALTER TABLE [dbo].[FINANCIAL_DETAILS] ADD CONSTRAINT [FK_FINANCIAL_DETAILS_FINANCIAL_GROUPS] FOREIGN KEY ([FinancialGroupId]) REFERENCES [dbo].[FINANCIAL_GROUPS] ([FinancialGroupId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_DOMAIN_FILTERS]'
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS] ADD CONSTRAINT [FK_FINANCIAL_DOMAIN_FILTERS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_DOMAIN_FILTERS] ADD CONSTRAINT [FK_FINANCIAL_DOMAIN_FILTERS_FINANCIAL_DOMAINS] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[FINANCIAL_DOMAINS] ([DomainId])
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
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_FFIEC_MAPPINGS]'
GO
ALTER TABLE [dbo].[FINANCIAL_FFIEC_MAPPINGS] ADD CONSTRAINT [FK_FINANCIAL_FFIEC_MAPPINGS_FINANCIAL_DETAILS] FOREIGN KEY ([StmtNumber]) REFERENCES [dbo].[FINANCIAL_DETAILS] ([StmtNumber]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_GROUPS]'
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_ASSESSMENT_FACTORS] FOREIGN KEY ([AssessmentFactorId]) REFERENCES [dbo].[FINANCIAL_ASSESSMENT_FACTORS] ([AssessmentFactorId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_COMPONENTS] FOREIGN KEY ([FinComponentId]) REFERENCES [dbo].[FINANCIAL_COMPONENTS] ([FinComponentId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_DOMAINS] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[FINANCIAL_DOMAINS] ([DomainId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_GROUPS] ADD CONSTRAINT [FK_FINANCIAL_GROUPS_FINANCIAL_MATURITY] FOREIGN KEY ([Financial_Level_Id]) REFERENCES [dbo].[FINANCIAL_MATURITY] ([Financial_Level_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_HOURS]'
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS] ADD CONSTRAINT [FK_FINANCIAL_HOURS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS] ADD CONSTRAINT [FK_FINANCIAL_HOURS_FINANCIAL_HOURS_COMPONENT] FOREIGN KEY ([Component]) REFERENCES [dbo].[FINANCIAL_HOURS_COMPONENT] ([Component]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS] ADD CONSTRAINT [FK_FINANCIAL_HOURS_FINANCIAL_REVIEWTYPE] FOREIGN KEY ([ReviewType]) REFERENCES [dbo].[FINANCIAL_REVIEWTYPE] ([ReviewType]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_HOURS_COMPONENT]'
GO
ALTER TABLE [dbo].[FINANCIAL_HOURS_COMPONENT] ADD CONSTRAINT [FK_FINANCIAL_HOURS_COMPONENT_FINANCIAL_DOMAINS] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[FINANCIAL_DOMAINS] ([DomainId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_QUESTIONS]'
GO
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] ADD CONSTRAINT [FK_FINANCIAL_QUESTIONS_FINANCIAL_DETAILS] FOREIGN KEY ([StmtNumber]) REFERENCES [dbo].[FINANCIAL_DETAILS] ([StmtNumber]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] ADD CONSTRAINT [FK_FINANCIAL_QUESTIONS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] ADD CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_FINANCIAL_DETAILS] FOREIGN KEY ([StmtNumber]) REFERENCES [dbo].[FINANCIAL_DETAILS] ([StmtNumber]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] ADD CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_TIERS]'
GO
ALTER TABLE [dbo].[FINANCIAL_TIERS] ADD CONSTRAINT [FK_FINANCIAL_TIERS_FINANCIAL_DETAILS] FOREIGN KEY ([StmtNumber]) REFERENCES [dbo].[FINANCIAL_DETAILS] ([StmtNumber]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINDING]'
GO
ALTER TABLE [dbo].[FINDING] ADD CONSTRAINT [FK_FINDING_ANSWER] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[ANSWER] ([Answer_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINDING_CONTACT]'
GO
ALTER TABLE [dbo].[FINDING_CONTACT] ADD CONSTRAINT [FK_FINDING_CONTACT_ASSESSMENT_CONTACTS] FOREIGN KEY ([Assessment_Contact_Id]) REFERENCES [dbo].[ASSESSMENT_CONTACTS] ([Assessment_Contact_Id])
GO
ALTER TABLE [dbo].[FINDING_CONTACT] ADD CONSTRAINT [FK_FINDING_INDIVIDUAL_FINDING1] FOREIGN KEY ([Finding_Id]) REFERENCES [dbo].[FINDING] ([Finding_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FRAMEWORK_TIER_DEFINITIONS]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_DEFINITIONS] ADD CONSTRAINT [FK_FRAMEWORK_TIER_DEFINITIONS_FRAMEWORK_TIERS] FOREIGN KEY ([Tier]) REFERENCES [dbo].[FRAMEWORK_TIERS] ([Tier]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FRAMEWORK_TIER_TYPE_ANSWER]'
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ADD CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ADD CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIER_TYPE] FOREIGN KEY ([TierType]) REFERENCES [dbo].[FRAMEWORK_TIER_TYPE] ([TierType]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FRAMEWORK_TIER_TYPE_ANSWER] ADD CONSTRAINT [FK_FRAMEWORK_TIER_TYPE_ANSWER_FRAMEWORK_TIERS] FOREIGN KEY ([Tier]) REFERENCES [dbo].[FRAMEWORK_TIERS] ([Tier])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GALLERY_GROUP_DETAILS]'
GO
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] ADD CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP] FOREIGN KEY ([Group_Id]) REFERENCES [dbo].[GALLERY_GROUP] ([Group_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] ADD CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM] FOREIGN KEY ([Gallery_Item_Guid]) REFERENCES [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GALLERY_ROWS]'
GO
ALTER TABLE [dbo].[GALLERY_ROWS] ADD CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP] FOREIGN KEY ([Group_Id]) REFERENCES [dbo].[GALLERY_GROUP] ([Group_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GALLERY_ROWS] ADD CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT] FOREIGN KEY ([Layout_Name]) REFERENCES [dbo].[GALLERY_LAYOUT] ([Layout_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GENERAL_SAL]'
GO
ALTER TABLE [dbo].[GENERAL_SAL] ADD CONSTRAINT [FK_GENERAL_SAL_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GENERAL_SAL] ADD CONSTRAINT [FK_GENERAL_SAL_GEN_SAL_NAMES] FOREIGN KEY ([Sal_Name]) REFERENCES [dbo].[GEN_SAL_NAMES] ([Sal_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GEN_FILE]'
GO
ALTER TABLE [dbo].[GEN_FILE] ADD CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS] FOREIGN KEY ([Doc_Num]) REFERENCES [dbo].[FILE_REF_KEYS] ([Doc_Num]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GEN_FILE] ADD CONSTRAINT [FK_GEN_FILE_FILE_TYPE] FOREIGN KEY ([File_Type_Id]) REFERENCES [dbo].[FILE_TYPE] ([File_Type_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[GEN_SAL_WEIGHTS]'
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS] ADD CONSTRAINT [FK_GEN_SAL_WEIGHTS_GEN_SAL_NAMES] FOREIGN KEY ([Sal_Name]) REFERENCES [dbo].[GEN_SAL_NAMES] ([Sal_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GEN_SAL_WEIGHTS] ADD CONSTRAINT [FK_GEN_SAL_WEIGHTS_GENERAL_SAL_DESCRIPTIONS] FOREIGN KEY ([Sal_Name]) REFERENCES [dbo].[GENERAL_SAL_DESCRIPTIONS] ([Sal_Name]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[HYDRO_DATA]'
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [FK__HYDRO_DAT__Mat_O__377107A9] FOREIGN KEY ([Mat_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
ALTER TABLE [dbo].[HYDRO_DATA] ADD CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[HYDRO_DATA_ACTIONS]'
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [FK__HYDRO_DAT__Progr__76D69450] FOREIGN KEY ([Progress_Id]) REFERENCES [dbo].[HYDRO_PROGRESS] ([Progress_Id])
GO
ALTER TABLE [dbo].[HYDRO_DATA_ACTIONS] ADD CONSTRAINT [FK_HYDRO_DATA_ACTIONS_ANSWER] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[ANSWER] ([Answer_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[INFORMATION]'
GO
ALTER TABLE [dbo].[INFORMATION] ADD CONSTRAINT [FK_INFORMATION_ASSESSMENTS] FOREIGN KEY ([Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[IRP]'
GO
ALTER TABLE [dbo].[IRP] ADD CONSTRAINT [FK_IRP_IRP_HEADER] FOREIGN KEY ([Header_Id]) REFERENCES [dbo].[IRP_HEADER] ([IRP_Header_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ISE_ACTIONS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ISE_ACTIONS_FINDINGS]'
GO
ALTER TABLE [dbo].[ISE_ACTIONS_FINDINGS] ADD CONSTRAINT [FK_ISE_ACTIONS_FINDINGS_FINDING] FOREIGN KEY ([Finding_Id]) REFERENCES [dbo].[FINDING] ([Finding_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MALCOLM_ANSWERS]'
GO
ALTER TABLE [dbo].[MALCOLM_ANSWERS] ADD CONSTRAINT [FK_MALCOLM_ANSWERS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_ANSWER_OPTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] ADD CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK]'
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] ADD CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS] FOREIGN KEY ([Mat_Option_Id_1]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK] ADD CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK_MATURITY_ANSWER_OPTIONS2] FOREIGN KEY ([Mat_Option_Id_2]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_DOMAIN_REMARKS]'
GO
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] ADD CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
GO
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] ADD CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS] FOREIGN KEY ([Grouping_ID]) REFERENCES [dbo].[MATURITY_GROUPINGS] ([Grouping_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_EXTRA]'
GO
ALTER TABLE [dbo].[MATURITY_EXTRA] ADD CONSTRAINT [fk_mat_questions] FOREIGN KEY ([Maturity_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_GROUPINGS]'
GO
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ADD CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES] FOREIGN KEY ([Type_Id]) REFERENCES [dbo].[MATURITY_GROUPING_TYPES] ([Type_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_LEVELS]'
GO
ALTER TABLE [dbo].[MATURITY_LEVELS] ADD CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[MATURITY_MODELS] ADD CONSTRAINT [FK_MATURITY_MODELS_MATURITY_LEVEL_USAGE_TYPES] FOREIGN KEY ([Maturity_Level_Usage_Type]) REFERENCES [dbo].[MATURITY_LEVEL_USAGE_TYPES] ([Maturity_Level_Usage_Type])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS] FOREIGN KEY ([Grouping_Id]) REFERENCES [dbo].[MATURITY_GROUPINGS] ([Grouping_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS] FOREIGN KEY ([Maturity_Level_Id]) REFERENCES [dbo].[MATURITY_LEVELS] ([Maturity_Level_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS] FOREIGN KEY ([Parent_Option_Id]) REFERENCES [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES] FOREIGN KEY ([Mat_Question_Type]) REFERENCES [dbo].[MATURITY_QUESTION_TYPES] ([Mat_Question_Type]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTION_PROPS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] ADD CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] ADD CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_SUB_MODEL_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_SUB_MODELS] FOREIGN KEY ([Sub_Model_Name]) REFERENCES [dbo].[MATURITY_SUB_MODELS] ([Sub_Model_Name]) ON DELETE CASCADE ON UPDATE CASCADE
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
PRINT N'Adding foreign keys to [dbo].[NCSF_CATEGORY]'
GO
ALTER TABLE [dbo].[NCSF_CATEGORY] ADD CONSTRAINT [FK_NCSF_Category_NCSF_FUNCTIONS] FOREIGN KEY ([NCSF_Function_Id]) REFERENCES [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NCSF_ENTRY_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [FK_NCSF_ENTRY_TO_MID_NCSF_CONVERSION_MAPPINGS_ENTRY] FOREIGN KEY ([Entry_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_ENTRY] ([Entry_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NCSF_ENTRY_TO_MID] ADD CONSTRAINT [FK_NCSF_ENTRY_TO_MID_NCSF_CONVERSION_MAPPINGS_MID] FOREIGN KEY ([Mid_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ([Mid_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NCSF_FULL_TO_MID]'
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [FK_NCSF_FULL_TO_MID_NCSF_CONVERSION_MAPPINGS_FULL] FOREIGN KEY ([Full_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_FULL] ([Full_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NCSF_FULL_TO_MID] ADD CONSTRAINT [FK_NCSF_FULL_TO_MID_NCSF_CONVERSION_MAPPINGS_MID] FOREIGN KEY ([Mid_Level_Titles]) REFERENCES [dbo].[NCSF_CONVERSION_MAPPINGS_MID] ([Mid_Level_Titles]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NETWORK_WARNINGS]'
GO
ALTER TABLE [dbo].[NETWORK_WARNINGS] ADD CONSTRAINT [FK_NETWORK_WARNING_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION]'
GO
ALTER TABLE [dbo].[NEW_QUESTION] ADD CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SAL_LEVEL] FOREIGN KEY ([Universal_Sal_Level]) REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[NEW_QUESTION] ADD CONSTRAINT [FK_NEW_QUESTION_UNIVERSAL_SUB_CATEGORY_HEADINGS] FOREIGN KEY ([Heading_Pair_Id]) REFERENCES [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ([Heading_Pair_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION_LEVELS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] ADD CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS] FOREIGN KEY ([New_Question_Set_Id]) REFERENCES [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] ADD CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING] FOREIGN KEY ([Question_Group_Heading_Id]) REFERENCES [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NIST_SAL_QUESTION_ANSWERS]'
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] ADD CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_NIST_SAL_QUESTIONS] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NIST_SAL_QUESTIONS] ([Question_Id])
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] ADD CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_STANDARD_SELECTION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_ASSESSMENT]'
GO
ALTER TABLE [dbo].[PARAMETER_ASSESSMENT] ADD CONSTRAINT [FK_ASSESSMENT_PARAMETERS_ASSESSMENTS] FOREIGN KEY ([Assessment_ID]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARAMETER_ASSESSMENT] ADD CONSTRAINT [FK_ASSESSMENT_PARAMETERS_PARAMETERS] FOREIGN KEY ([Parameter_ID]) REFERENCES [dbo].[PARAMETERS] ([Parameter_ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] ADD CONSTRAINT [FK_Parameter_Requirements_Parameters] FOREIGN KEY ([Parameter_Id]) REFERENCES [dbo].[PARAMETERS] ([Parameter_ID]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_VALUES]'
GO
ALTER TABLE [dbo].[PARAMETER_VALUES] ADD CONSTRAINT [FK_PARAMETER_VALUES_ANSWER] FOREIGN KEY ([Answer_Id]) REFERENCES [dbo].[ANSWER] ([Answer_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PARAMETER_VALUES] ADD CONSTRAINT [FK_PARAMETER_VALUES_PARAMETERS] FOREIGN KEY ([Parameter_Id]) REFERENCES [dbo].[PARAMETERS] ([Parameter_ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PASSWORD_HISTORY]'
GO
ALTER TABLE [dbo].[PASSWORD_HISTORY] ADD CONSTRAINT [FK_PASSWORD_HISTORY_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PROCUREMENT_LANGUAGE_DATA]'
GO
ALTER TABLE [dbo].[PROCUREMENT_LANGUAGE_DATA] ADD CONSTRAINT [FK_PROCUREMENT_LANGUAGE_DATA_PROCUREMENT_LANGUAGE_HEADINGS] FOREIGN KEY ([Parent_Heading_Id]) REFERENCES [dbo].[PROCUREMENT_LANGUAGE_HEADINGS] ([Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PROCUREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[PROCUREMENT_REFERENCES] ADD CONSTRAINT [FK_Procurement_References_References_Data] FOREIGN KEY ([Reference_Id]) REFERENCES [dbo].[REFERENCES_DATA] ([Reference_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[RECOMMENDATIONS_REFERENCES]'
GO
ALTER TABLE [dbo].[RECOMMENDATIONS_REFERENCES] ADD CONSTRAINT [FK_Recommendations_References_References_Data] FOREIGN KEY ([Reference_Id]) REFERENCES [dbo].[REFERENCES_DATA] ([Reference_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REFERENCES_DATA]'
GO
ALTER TABLE [dbo].[REFERENCES_DATA] ADD CONSTRAINT [FK_References_Data_Reference_Docs] FOREIGN KEY ([Reference_Doc_Id]) REFERENCES [dbo].[REFERENCE_DOCS] ([Reference_Doc_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REF_LIBRARY_PATH]'
GO
ALTER TABLE [dbo].[REF_LIBRARY_PATH] ADD CONSTRAINT [FK_REF_LIBRARY_PATH_REF_LIBRARY_PATH] FOREIGN KEY ([Parent_Path_Id]) REFERENCES [dbo].[REF_LIBRARY_PATH] ([Lib_Path_Id])
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
PRINT N'Adding foreign keys to [dbo].[REPORT_DETAIL_SECTION_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_DETAIL_SECTION_SELECTION] ADD CONSTRAINT [FK_REPORT_DETAIL_SECTION_SELECTION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REPORT_DETAIL_SECTION_SELECTION] ADD CONSTRAINT [FK_REPORT_DETAIL_SECTION_SELECTION_REPORT_DETAIL_SECTIONS] FOREIGN KEY ([Report_Section_Id]) REFERENCES [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REPORT_OPTIONS_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_OPTIONS_SELECTION] ADD CONSTRAINT [FK_REPORT_OPTIONS_SELECTION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REPORT_OPTIONS_SELECTION] ADD CONSTRAINT [FK_REPORT_OPTIONS_SELECTION_REPORT_OPTIONS] FOREIGN KEY ([Report_Option_Id]) REFERENCES [dbo].[REPORT_OPTIONS] ([Report_Option_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REPORT_STANDARDS_SELECTION]'
GO
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] ADD CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_ASSESSMENTS] FOREIGN KEY ([Assesment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] ADD CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS] FOREIGN KEY ([Report_Set_Entity_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[REQUIRED_DOCUMENTATION] ADD CONSTRAINT [FK_REQUIRED_DOCUMENTATION_REQUIRED_DOCUMENTATION_HEADERS] FOREIGN KEY ([RDH_Id]) REFERENCES [dbo].[REQUIRED_DOCUMENTATION_HEADERS] ([RDH_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_LEVELS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] ADD CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE] FOREIGN KEY ([Level_Type]) REFERENCES [dbo].[REQUIREMENT_LEVEL_TYPE] ([Level_Type]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCE_TEXT]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] ADD CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SECTOR_INDUSTRY]'
GO
ALTER TABLE [dbo].[SECTOR_INDUSTRY] ADD CONSTRAINT [FK_SECTOR_INDUSTRY_SECTOR] FOREIGN KEY ([SectorId]) REFERENCES [dbo].[SECTOR] ([SectorId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]'
GO
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] ADD CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SECTOR] FOREIGN KEY ([Sector_Id]) REFERENCES [dbo].[SECTOR] ([SectorId]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SETS]'
GO
ALTER TABLE [dbo].[SETS] ADD CONSTRAINT [FK_SETS_Sets_Category] FOREIGN KEY ([Set_Category_Id]) REFERENCES [dbo].[SETS_CATEGORY] ([Set_Category_Id]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[SET_FILES]'
GO
ALTER TABLE [dbo].[SET_FILES] ADD CONSTRAINT [FK_SET_FILES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SET_FILES] ADD CONSTRAINT [FK_SET_FILES_SETS] FOREIGN KEY ([SetName]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STANDARD_CATEGORY_SEQUENCE]'
GO
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] ADD CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_STANDARD_CATEGORY] FOREIGN KEY ([Standard_Category]) REFERENCES [dbo].[STANDARD_CATEGORY] ([Standard_Category]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STANDARD_SELECTION]'
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD CONSTRAINT [FK_STANDARD_SELECTION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD CONSTRAINT [FK_STANDARD_SELECTION_SAL_DETERMINATION_TYPES] FOREIGN KEY ([Last_Sal_Determination_Type]) REFERENCES [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_SELECTION] ADD CONSTRAINT [FK_STANDARD_SELECTION_UNIVERSAL_SAL_LEVEL] FOREIGN KEY ([Selected_Sal_Level]) REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Full_Name_Sal]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STANDARD_TO_UNIVERSAL_MAP]'
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP] ADD CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_STANDARD_SPECIFIC_LEVEL] FOREIGN KEY ([Standard_Level]) REFERENCES [dbo].[STANDARD_SPECIFIC_LEVEL] ([Standard_Level]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[STANDARD_TO_UNIVERSAL_MAP] ADD CONSTRAINT [FK_STANDARD_TO_UNIVERSAL_MAP_UNIVERSAL_SAL_LEVEL] FOREIGN KEY ([Universal_Sal_Level]) REFERENCES [dbo].[UNIVERSAL_SAL_LEVEL] ([Universal_Sal_Level]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[STATES_AND_PROVINCES]'
GO
ALTER TABLE [dbo].[STATES_AND_PROVINCES] ADD CONSTRAINT [FK_STATES_AND_PROVINCES_COUNTRIES] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[COUNTRIES] ([ISO_code]) ON DELETE CASCADE ON UPDATE CASCADE
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
PRINT N'Adding foreign keys to [dbo].[TTP_MAT_QUESTION]'
GO
ALTER TABLE [dbo].[TTP_MAT_QUESTION] ADD CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
ALTER TABLE [dbo].[TTP_MAT_QUESTION] ADD CONSTRAINT [FK_TTP_MAT_QUESTION_TTP] FOREIGN KEY ([TTP_Code]) REFERENCES [dbo].[TTP] ([TTP_Code])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ADD CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_QUESTION_GROUP_HEADING] FOREIGN KEY ([Question_Group_Heading_Id]) REFERENCES [dbo].[QUESTION_GROUP_HEADING] ([Question_Group_Heading_Id]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ADD CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS] FOREIGN KEY ([Set_Name]) REFERENCES [dbo].[SETS] ([Set_Name]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] ADD CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_UNIVERSAL_SUB_CATEGORIES] FOREIGN KEY ([Universal_Sub_Category_Id]) REFERENCES [dbo].[UNIVERSAL_SUB_CATEGORIES] ([Universal_Sub_Category_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[USER_EMAIL_HISTORY]'
GO
ALTER TABLE [dbo].[USER_EMAIL_HISTORY] ADD CONSTRAINT [FK_USER_EMAIL_HISTORY_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[USER_SECURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[USER_SECURITY_QUESTIONS] ADD CONSTRAINT [FK_USER_SECURITY_QUESTIONS_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[DIAGRAM_CONTAINER]'
GO
ALTER TABLE [dbo].[DIAGRAM_CONTAINER] NOCHECK CONSTRAINT [FK_DIAGRAM_CONTAINER_DIAGRAM_CONTAINER]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[DOCUMENT_FILE]'
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] NOCHECK CONSTRAINT [FK_DOCUMENT_FILE_DEMOGRAPHICS]
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
PRINT N'Disabling constraints on [dbo].[NEW_QUESTION]'
GO
ALTER TABLE [dbo].[NEW_QUESTION] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[NEW_QUESTION_LEVELS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[NEW_REQUIREMENT]'
GO
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
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
