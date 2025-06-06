
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
			INNER JOIN (select assessment_id, Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y' else 'N' end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F
.[maturity_question_id] = a.[Question_Or_Requirement_Id]
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
