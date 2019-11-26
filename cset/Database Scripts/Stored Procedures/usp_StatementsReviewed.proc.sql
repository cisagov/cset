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
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	declare @applicationMode varchar(50)

	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	SET NOCOUNT ON;

	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	if(@ApplicationMode = 'Questions Based')	
	BEGIN

		SELECT assessment_id, c.Component, ReviewType, Hours, isnull(ReviewedCount, 0) as ReviewedCount, f.OtherSpecifyValue, c.DomainId, PresentationOrder, grouporder acount
		from FINANCIAL_HOURS f 
			join FINANCIAL_HOURS_COMPONENT c on f.Component = c.Component
			left join (
				select grouporder, a.DomainId, isnull(ReviewedCount, 0) as ReviewedCount
				from (
						select distinct min(StmtNumber) as grouporder, d.Domain, g.DomainId,count(stmtnumber) Total from [FINANCIAL_DETAILS] fd 
						INNER JOIN dbo.FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
						INNER JOIN [dbo].[FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]						
						group by g.DomainId, d.Domain
						)  a left join (
						SELECT  g.DomainId, isnull(count(ans_rev.answer_id), 0) as ReviewedCount
						FROM       [dbo].[FINANCIAL_QUESTIONS] f			
						INNER JOIN [dbo].[NEW_QUESTION] q ON f.[Question_Id] = q.[Question_Id]
						INNER JOIN #answers a ON q.[Question_Id] = a.[Question_Or_Requirement_Id]
						INNER JOIN #answers ans_rev ON q.[Question_Id] = ans_rev.[Question_Or_Requirement_Id]
						INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
						inner join dbo.FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
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
					INNER JOIN dbo.FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
					INNER JOIN [dbo].[FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]			
					group by g.DomainId, d.Domain
					)  a left join (
					SELECT  g.DomainId, isnull(count(ans_rev.Answer_Id), 0) as ReviewedCount
					FROM       [dbo].[FINANCIAL_REQUIREMENTS] f
					INNER JOIN [dbo].[NEW_REQUIREMENT] q ON f.[Requirement_Id] = q.[Requirement_Id]
					INNER JOIN #answers a ON q.[Requirement_Id] = a.[Question_Or_Requirement_Id]
					INNER JOIN #answers ans_rev ON q.[Requirement_Id] = ans_rev.[Question_Or_Requirement_Id]
					INNER JOIN [dbo].[FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
					inner join dbo.FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
					WHERE ans_rev.Reviewed = 1
					group by g.DomainId
					) b  on a.DomainId = b.DomainId 		
		) b on c.DomainId = b.DomainId
		where f.assessment_id = @assessment_id
		order by PresentationOrder		
			
	END
	
END
