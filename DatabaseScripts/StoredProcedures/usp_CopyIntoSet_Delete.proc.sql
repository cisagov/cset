-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	Delete a copied set
-- =============================================
CREATE PROCEDURE [dbo].[usp_CopyIntoSet_Delete]
	-- Add the parameters for the stored procedure here	
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end
		
	delete [dbo].[REQUIREMENT_SETS] 	where Set_Name = @DestinationSetName

	
	delete REQUIREMENT_QUESTIONS_SETS where set_name = @DestinationSetName
	--do the headers first
	delete UNIVERSAL_SUB_CATEGORY_HEADINGS where Set_Name=@DestinationSetName

	delete NEW_QUESTION_SETS where Set_Name = @DestinationSetName

	
	delete NEW_REQUIREMENT where Original_Set_Name = @destinationSetName

	-- Insert statements for procedure here
	delete CUSTOM_STANDARD_BASE_STANDARD where Custom_Questionaire_Name = @DestinationSetName	

	
	
END
