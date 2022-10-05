-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[clean_out_requirements_mode]
	   @standard_name nvarchar(50), @standard_name_with_mode nvarchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

/**
we will do a sheet by sheet clean
select all the q_s_r id's into a temp table
delete out all the corresponding records.

*/


SELECT * INTO #tempSetList FROM dbo.REQUIREMENT_sets WHERE Set_Name = @standard_name_with_mode;

BEGIN TRANSACTION
IF @standard_name = 'ICS'
BEGIN
	delete  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
ELSE
begin
	DELETE FROM dbo.REQUIREMENT_SOURCE_FILES
	FrOM dbo.REQUIREMENT_SOURCE_FILES a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_REFERENCES
	FROM dbo.REQUIREMENT_REFERENCES a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_levels
	FROM dbo.REQUIREMENT_levels a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_QUESTIONS
	FROM dbo.REQUIREMENT_QUESTIONS a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	delete  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
COMMIT TRANSACTION

DROP TABLE #tempsetlist;


END
