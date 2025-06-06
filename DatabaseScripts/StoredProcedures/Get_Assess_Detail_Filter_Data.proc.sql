CREATE PROCEDURE [dbo].[Get_Assess_Detail_Filter_Data]
   @model nvarchar(100) = ''

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT * FROM ASSESSMENT_DETAIL_FILTER_DATA WHERE Model = @model

END
