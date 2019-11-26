CREATE PROCEDURE [dbo].[GetApplicationModeDefault]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int,
	@Application_Mode varchar(100) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

	SELECT @Application_Mode = Application_Mode
	  FROM STANDARD_SELECTION where Assessment_Id = @Assessment_Id

	  if @Application_Mode is null
		Set @Application_Mode = 'Questions Based'

	

END
