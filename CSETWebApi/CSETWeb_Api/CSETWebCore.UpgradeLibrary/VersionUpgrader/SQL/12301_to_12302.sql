/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12301    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12302

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 12/16/2024 3:50:13 PM

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
PRINT N'Altering [dbo].[ANALYTICS_MATURITY_GROUPINGS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] ADD
[Group_Sequence] [int] NULL,
[Global_Sequence] [int] NULL,
[Group_id] [int] NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[analytics_setup_maturity_groupings]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 3/31/2022
-- Description:	setup for analytics.  This stored proces creates a global temporary
-- table that contains the categories to group by for each maturity model. 
-- the stored proc should look to see if the temporary table exists if it does then 
-- we don't need to do anything if it does not then we should build the temp table
-- =============================================
ALTER PROCEDURE [dbo].[analytics_setup_maturity_groupings]
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
PRINT N'Altering [dbo].[MATURITY_EXTRA]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_EXTRA] ADD
[Answer_Options] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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
PRINT N'Altering [dbo].[Analytics_Answers]'
GO

ALTER VIEW [dbo].[Analytics_Answers]
AS
SELECT Assessment_Id, Question_Or_Requirement_Id, Question_Type, CASE WHEN ANSWER.Answer_Text = 'A' OR
                  ANSWER.Answer_Text = 'Y' THEN N'Y' ELSE 'N' END AS Answer_Text
FROM     dbo.ANSWER
WHERE  (Answer_Text <> 'NA')
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[analytics_Compute_MaturityAll]'
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
ALTER PROCEDURE [dbo].[analytics_Compute_MaturityAll]
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
PRINT N'Altering [dbo].[analytics_compute_single_averages_maturity]'
GO

-- =============================================
-- Author:		Barry
-- Create date: 4/6/2022
-- Description:	average for maturity model
-- =============================================
ALTER PROCEDURE [dbo].[analytics_compute_single_averages_maturity]
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
PRINT N'Altering [dbo].[usp_Assessments_Completion_For_User]'
GO




ALTER PROCEDURE [dbo].[usp_Assessments_Completion_For_User]
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
PRINT N'Adding foreign keys to [dbo].[MATURITY_EXTRA]'
GO
ALTER TABLE [dbo].[MATURITY_EXTRA] ADD CONSTRAINT [fk_mat_questions] FOREIGN KEY ([Maturity_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
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
