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
			INNER JOIN (select assessment_id,Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y'   end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F.[Questi
on_Id] = a.[Question_Or_Requirement_Id]
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
			INNER JOIN (select assessment_id,Question_Or_Requirement_Id, is_requirement, case when Answer_Text in ('Y','A','NA') then 'Y' else 'N' end as Answer_Text from [dbo].[ANSWER] where Assessment_Id = @Assessment_Id and answer_text not in ('U','N')) a ON F.
[Requirement_Id] = a.[Question_Or_Requirement_Id]
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

