-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Recommendations]
	-- Add the parameters for the stored procedure here
	@value int, @industry int, @organization varchar(50) ,@assetvalue varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	


select distinct set_name from SECTOR_STANDARD_RECOMMENDATIONS
where Sector_Id = isnull(@value,sector_id) and Industry_Id = isnull(@industry,industry_id) and Organization_Size = isnull(@organization, Organization_Size) and Asset_Value= isnull(@assetvalue,Asset_Value)
END
