/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12403    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12404

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/12/2025 4:43:29 PM

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
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[AssessorMode] [bit] NOT NULL CONSTRAINT [DF__ASSESSMEN__Asses__62307D25] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[DOCUMENT_FILE]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DOCUMENT_FILE] ADD
[IsGlobal] [bit] NOT NULL CONSTRAINT [DF__DOCUMENT___IsGlo__7F01C5FD] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[GEN_FILE]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[GEN_FILE] ADD
[Language] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[MATURITY_QUESTION_PROPS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] ALTER COLUMN [PropertyValue] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ROLES]'
GO
CREATE TABLE [dbo].[ROLES]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[RoleName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ROLES] on [dbo].[ROLES]'
GO
ALTER TABLE [dbo].[ROLES] ADD CONSTRAINT [PK_ROLES] PRIMARY KEY CLUSTERED ([RoleId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[USER_ROLES]'
GO
CREATE TABLE [dbo].[USER_ROLES]
(
[UserRoleId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[RoleId] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_USER_ROLES] on [dbo].[USER_ROLES]'
GO
ALTER TABLE [dbo].[USER_ROLES] ADD CONSTRAINT [PK_USER_ROLES] PRIMARY KEY CLUSTERED ([UserRoleId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Analytics_Answers]'
GO


ALTER VIEW [dbo].[Analytics_Answers]
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
PRINT N'Altering [dbo].[usp_getStandardsResultsByCategory]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
ALTER PROCEDURE [dbo].[usp_getStandardsResultsByCategory]
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
PRINT N'Adding foreign keys to [dbo].[USER_ROLES]'
GO
ALTER TABLE [dbo].[USER_ROLES] ADD CONSTRAINT [FK_USER_ROLES_ROLES] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[ROLES] ([RoleId])
GO
ALTER TABLE [dbo].[USER_ROLES] ADD CONSTRAINT [FK_USER_ROLES_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId])
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
