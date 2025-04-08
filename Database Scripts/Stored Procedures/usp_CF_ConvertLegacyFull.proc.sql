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
