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
