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
