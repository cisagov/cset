-- =============================================
-- Author:		CSET Team
-- Create date: 2021-04-08
-- Description:	Deletes a user from the CSET database
--              Supply an assessment ID argument to delete a single assessment, or
--              use an argument of -1 to delete all assessments.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAssessment]
	@assessmentid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @assessmentid < 0
		BEGIN
			delete from [DOCUMENT_FILE]
			delete from ASSESSMENTS;
		END
	ELSE
		BEGIN
			delete from [DOCUMENT_FILE] where [Assessment_Id] = @assessmentid;
			delete from [ASSESSMENTS] where [Assessment_Id] = @assessmentid;
		END
END


