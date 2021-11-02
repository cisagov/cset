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
PRINT N'Dropping foreign keys from [dbo].[COMPONENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] DROP CONSTRAINT [FK_Component_Questions_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[COMPONENT_STANDARD_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] DROP CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] DROP CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[FINANCIAL_QUESTIONS]'
GO
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] DROP CONSTRAINT [FK_FINANCIAL_QUESTIONS_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] DROP CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[NEW_QUESTION_SETS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_SETS] DROP CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] DROP CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] DROP CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] DROP CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] DROP CONSTRAINT [CK_ASSESSMENTS_REQUIRED_DOCUMENTATION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] DROP CONSTRAINT [PK_ASSESSMENT_DIAGRAM_COMPONENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] DROP CONSTRAINT [DF_ASSESSMENTS_REQUIRED_DOCUMENTATION_Answer]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[Diagram_Markup] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUsedComponentNumber] [int] NOT NULL CONSTRAINT [DF_ASSESSMENTS_LastUsedComponentNumber] DEFAULT ((0)),
[Diagram_Image] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Rebuilding [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
CREATE TABLE [dbo].[RG_Recovery_1_ASSESSMENT_DIAGRAM_COMPONENTS]
(
[Assessment_Id] [int] NOT NULL,
[Component_Id] [uniqueidentifier] NOT NULL,
[Diagram_Component_Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[label] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DrawIO_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
INSERT INTO [dbo].[RG_Recovery_1_ASSESSMENT_DIAGRAM_COMPONENTS]([Assessment_Id], [Diagram_Component_Type]) SELECT [Assessment_Id], [Diagram_Component_Type] FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DROP TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[RG_Recovery_1_ASSESSMENT_DIAGRAM_COMPONENTS]', N'ASSESSMENT_DIAGRAM_COMPONENTS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ASSESSMENT_DIAGRAM_COMPONENTS_1] on [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [PK_ASSESSMENT_DIAGRAM_COMPONENTS_1] PRIMARY KEY CLUSTERED  ([Assessment_Id], [Component_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[COMPONENT_SYMBOLS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[COMPONENT_SYMBOLS] ADD
[WIdth] [int] NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_WIdth] DEFAULT ((60)),
[Height] [int] NOT NULL CONSTRAINT [DF_COMPONENT_SYMBOLS_Height] DEFAULT ((60)),
[Tags] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[NETWORK_WARNINGS]'
GO
CREATE TABLE [dbo].[NETWORK_WARNINGS]
(
[Assessment_Id] [int] NOT NULL,
[Id] [int] NOT NULL,
[WarningText] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__network_warnings_001] on [dbo].[NETWORK_WARNINGS]'
GO
ALTER TABLE [dbo].[NETWORK_WARNINGS] ADD CONSTRAINT [PK__network_warnings_001] PRIMARY KEY CLUSTERED  ([Assessment_Id], [Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillNetworkDiagramQuestions]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FillNetworkDiagramQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

    /*Rules for Component questions
	For the default questions 
	select the set of component types and questions associated with the component types
	then insert an answer for each unique question in that list. 
	*/
	--generate defaults 
	INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Component_Id],[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])     		
		select Is_Requirement=0,Question_id,Component_Id=0, Answer_Text = 'U', Is_Component='1',Is_Framework=0, Assessment_Id =@Assessment_Id 
		from (select * from ANSWER where assessment_id = @assessment_id) a right join (SELECT distinct question_id 
		FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a join component_questions q on a.Diagram_Component_Type = q.Component_Type
		where assessment_id = @assessment_id) t on a.Question_Or_Requirement_Id = t.question_id
		where assessment_id is null			
	--delete defaults
		delete answer from ANSWER a left join 
		(SELECT distinct question_id 
		FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a join component_questions q on a.Diagram_Component_Type = q.Component_Type
		where assessment_id = @assessment_id) t on a.Question_Or_Requirement_Id = t.question_id
		where question_id is null and is_component = 1	and assessment_id = @assessment_id

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getStandardSummaryOverall2]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	Stub needs completed
-- =============================================
CREATE PROCEDURE [dbo].[usp_getStandardSummaryOverall2]
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
declare @applicationMode varchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, component_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin	
		select a.Answer_Full_Name,a.Answer_Text, isnull(m.qc,0) qc,isnull(m.Total,0) Total, isnull(cast(IsNull(Round((cast((qc) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int),0)  as [Percent] 
		from ANSWER_LOOKUP a left join (
		SELECT a.Answer_Text, isnull(count(a.question_or_requirement_id),0) qc, SUM(count(a.question_or_requirement_id)) OVER() AS Total
				FROM #answers a 				
				where a.Assessment_Id = @assessment_id 
				group by a.Answer_Text
		) m on a.Answer_Text = m.Answer_Text
end
else 
begin 
		select a.Answer_Full_Name, m.*, cast((qc/cast(total as float)*100) as int) as [Percent] from answer_lookup a left join (
		SELECT a.Answer_Text, isnull(count(a.question_or_requirement_id),0) qc, SUM(count(a.question_or_requirement_id)) OVER() AS Total  
				FROM #answers a 
				where a.Assessment_Id = @assessment_id 
				group by a.Answer_Text
	   ) m on a.Answer_Text = m.Answer_Text
end
END







GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getRankedCategories]'
GO
-- =============================================
-- Author:		barry
-- Create date: 7/20/2018
-- Description:	returns the ranked categories
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRankedCategories]
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
declare @applicationMode varchar(50)

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

	SELECT h.Question_Group_Heading,isnull(count(c.question_id),0) qc,  isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
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
		group by Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, isnull(count(c.question_id),0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
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
		group by Question_Group_Heading

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

	SELECT h.Question_Group_Heading,count(c.Requirement_Id) qc,  SUM(@maxRank-c.Ranking) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id 
		group by Question_Group_Heading

	
	select *, isnull(cast(cr as decimal(18,3))/Total, 0) * 100 [prc] from #tempR
	order by prc desc
end
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsSummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select l.Answer_Text, l.Answer_Full_Name, isnull(b.vcount, 0) vcount, round(isnull(b.value, 0),0) [value] 
	from ANSWER_LOOKUP l 
	left join (select Answer_Text, count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] 
	from  ANSWER 
	where assessment_id = @assessment_id and Is_Component = 1
	group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getStandardsSummary]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
ALTER PROCEDURE [dbo].[usp_getStandardsSummary]
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
declare @applicationMode varchar(50)

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
declare @applicationMode varchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
if(@ApplicationMode = 'Questions Based')	
begin
	

	
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT s.Set_Name,Question_Group_Heading,isnull(count(c.question_id),0) qc into #temp	
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading

	insert into #temp (Set_Name,Question_Group_Heading, QC) 
	select a.Set_name,a.Question_Group_Heading, qc=0 from 
	(select * from (select distinct question_group_heading from #temp) a, (select distinct set_name from #temp) b) a 
	left join #temp on a.question_group_heading=#temp.question_group_heading and a.set_name = #temp.set_name
	where #temp.set_name is null

	SELECT s.Set_Name,Question_Group_Heading,isnull(count(c.question_id),0) qc into #tempAnswered
		FROM Answer_Questions a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id=c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id=h.heading_pair_Id		
		join NEW_QUESTION_SETS s on c.Question_Id = s.Question_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
		join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id 
		join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
		join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') and v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
		group by s.Set_Name, Question_Group_Heading
     
	select t.Set_Name,
	s.Short_Name,
	t.Question_Group_Heading, 
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

	SELECT s.set_name, h.Question_Group_Heading, isnull(count(c.Requirement_Id),0) qc into #tempR
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text <> 'NA'
		group by s.set_name, Question_Group_Heading

			/**for multiple sets get the unique list of sets and question_group headers
	   take the cross product 
	   left join and fill with zero
	   Essentially fill in the gaps on the categories
	   */


	insert into #tempR (Set_Name,Question_Group_Heading, QC) 
	select a.Set_name,a.Question_Group_Heading, qc=0 from 
	(select * from (select distinct question_group_heading from #tempR) a, (select distinct set_name from #tempR) b) a 
	left join #tempR on a.question_group_heading=#tempR.question_group_heading and a.set_name = #tempR.set_name
	where #tempR.set_name is null

	SELECT s.set_name, h.Question_Group_Heading,count(c.Requirement_Id) qc into #tempRAnswer
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join REQUIREMENT_SETS s on c.Requirement_Id = s.Requirement_Id
		join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 		
		where a.Assessment_Id = @assessment_id and v.Assessment_Id = a.Assessment_Id and v.Selected = 1 and a.Answer_Text in ('Y','A')
		group by s.set_name, Question_Group_Heading

	select t.Set_Name, 
	s.Short_Name, 
	t.Question_Group_Heading, 
	isnull(a.qc,0) yaCount, 
	isnull(t.qc,0) Actualcr, 
	--isnull(a.qc,0)/cast(t.qc as decimal(18,3)) * 100 [prc]
	round(isnull(cast(a.qc as decimal(18,3))/t.qc,0),5) * 100 [prc]
	from #tempR t 
	left join #tempRAnswer a on t.Set_Name = a.Set_Name and t.Question_Group_Heading = a.Question_Group_Heading
	join [SETS] s on t.Set_Name = s.Set_Name
	order by Question_Group_Heading desc
end
END



	
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsResultsByCategory]'
GO
-- =============================================
-- Author:		woodrk
-- Create date: 8/20/2019
-- Description:	Get answered component questions by category
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsResultsByCategory]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- get all answers
	select Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #temp	
	from ANSWER a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id
	where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA' and a.is_component = 1
	group by Question_Group_Heading


	-- get passing answers (Y, A)
	SELECT Question_Group_Heading, ISNULL(COUNT(q.question_id),0) qc into #tempAnswered
	from ANSWER a
	left join NEW_QUESTION q on q.Question_Id = a.question_or_requirement_id
	left join vQUESTION_HEADINGS h on h.Heading_Pair_Id = q.Heading_Pair_Id		
	where a.Assessment_Id = @assessment_id and a.Answer_Text in ('Y','A') and a.is_component = 1	
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
PRINT N'Altering [dbo].[usp_getComponentTypes]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	remember the answer values are percents
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentTypes]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	


	SELECT Assessment_Id,
			component_type,
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
			select Assessment_Id,component_type, isnull(Acount,0) as Acount, aw.answer_text ,SUM(acount) OVER(PARTITION BY Assessment_Id,component_type) AS Total  
			from (select diagram_component_type, answer_text from ANSWER_LOOKUP a, assessment_diagram_components c
			where c.assessment_id = @assessment_id) aw left join (
			select assessment_id, c.Component_Type,a.answer_text, count(a.answer_text) acount from NEW_QUESTION s 
			join COMPONENT_QUESTIONS c on s.Question_id= c.Question_Id			
			join answer_components a on s.Question_Id = a.question_or_requirement_id
			where a.assessment_id=@assessment_id
			group by assessment_id,Component_Type, a.answer_text) B on aw.Answer_Text = b.answer_text and aw.diagram_component_type = b.Component_Type
			where component_type is not null
		) p
		PIVOT
		(
		sum(acount)
		FOR answer_text IN
		( [Y],[N],[NA],[A],[U] )
		) AS pvt
		where Assessment_Id is not null
		ORDER BY pvt.Component_Type;
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getOverallRankedCategories]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
ALTER PROCEDURE [dbo].[usp_getOverallRankedCategories]
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
declare @applicationMode varchar(50)

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
		group by Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, 
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
		group by Question_Group_Heading

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
		group by Question_Group_Heading

	SELECT h.Question_Group_Heading,
	isnull(count(c.requirement_id),0) nuCount,
	SUM(@maxRank-c.Ranking) cr
	into #tempRAnswered
		FROM Answer_Requirements a 
		join NEW_REQUIREMENT c on a.Question_Or_Requirement_Id=c.Requirement_Id
		join QUESTION_GROUP_HEADING h on c.Question_Group_Heading_Id = h.Question_Group_Heading_Id
		join (select distinct requirement_id from REQUIREMENT_SETS s join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name where v.Selected = 1 and v.assessment_id = @assessment_id)
		s on c.Requirement_Id = s.Requirement_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading

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
PRINT N'Altering [dbo].[DIAGRAM_TEMPLATES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[DIAGRAM_TEMPLATES] ADD
[Diagram_Markup] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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
ALTER TABLE [dbo].[COUNTRIES] ADD CONSTRAINT [PK_COUNTRIES] PRIMARY KEY CLUSTERED  ([COUNTRIES_ID])
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
ALTER TABLE [dbo].[STATES_AND_PROVINCES] ADD CONSTRAINT [PK_STATES_AND_PROVINCES] PRIMARY KEY CLUSTERED  ([STATES_AND_PROVINCES_ID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [CK_ASSESSMENTS_REQUIRED_DOCUMENTATION] CHECK (([Answer]='NA' OR [Answer]='N' OR [Answer]='Y' OR [Answer]='U'))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_Component_Questions_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[COMPONENT_STANDARD_QUESTIONS]'
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COMPONENT_STANDARD_QUESTIONS] WITH NOCHECK  ADD CONSTRAINT [FK_STANDARD_COMPONENT_QUESTIONS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NEW_QUESTION_SETS]'
GO
ALTER TABLE [dbo].[NEW_QUESTION_SETS] WITH NOCHECK  ADD CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[PARAMETER_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] WITH NOCHECK  ADD CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_REFERENCES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] WITH NOCHECK  ADD CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] ADD CONSTRAINT [FK_ASSESSMENT_DIAGRAM_COMPONENTS_COMPONENT_SYMBOLS] FOREIGN KEY ([Diagram_Component_Type]) REFERENCES [dbo].[COMPONENT_SYMBOLS] ([Diagram_Type_Xml]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_QUESTIONS]'
GO
ALTER TABLE [dbo].[FINANCIAL_QUESTIONS] ADD CONSTRAINT [FK_FINANCIAL_QUESTIONS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[FINANCIAL_REQUIREMENTS]'
GO
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] ADD CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[NETWORK_WARNINGS]'
GO
ALTER TABLE [dbo].[NETWORK_WARNINGS] ADD CONSTRAINT [FK_NETWORK_WARNING_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[REQUIREMENT_QUESTIONS_SETS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_QUESTION] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[NEW_QUESTION] ([Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] ADD CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT] FOREIGN KEY ([Requirement_Id]) REFERENCES [dbo].[NEW_REQUIREMENT] ([Requirement_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Disabling constraints on [dbo].[NEW_QUESTION]'
GO
ALTER TABLE [dbo].[NEW_QUESTION] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION]'
GO
ALTER TABLE [dbo].[ASSESSMENTS_REQUIRED_DOCUMENTATION] ADD CONSTRAINT [DF_ASSESSMENTS_REQUIRED_DOCUMENTATION_Answer] DEFAULT ('U') FOR [Answer]
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
