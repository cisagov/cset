/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12150    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12160

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/28/2024 2:14:51 PM

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
PRINT N'Altering [dbo].[vFinancialGroups]'
GO

ALTER VIEW [dbo].[vFinancialGroups]
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
PRINT N'Altering [dbo].[GetMaturityDetailsCalculations]'
GO

-- =============================================
-- Author:		CSET/ACET Team
-- Create date: 20-Jan-2021
-- Description:	Updated Calulates on maturity details
-- =============================================
ALTER PROCEDURE [dbo].[GetMaturityDetailsCalculations]
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
PRINT N'Altering [dbo].[usp_GetRankedQuestions]'
GO

-- =============================================
-- Author:		Mitch Carroll
-- Create date: 9 Aug 2018
-- Description:	Ranked Questions
-- =============================================
ALTER PROCEDURE [dbo].[usp_GetRankedQuestions]
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
PRINT N'Altering [dbo].[usp_getRRASummaryByGoal]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getRRASummaryByGoal]
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
