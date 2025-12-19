-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[changeEmail]
	@originalEmail nvarchar(200),
	@newEmail nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists (select * from users where PrimaryEmail = @newEmail)
		update USERS set PrimaryEmail = @newEmail where PrimaryEmail = @originalEmail
	--if we can't update then we can't update
END
