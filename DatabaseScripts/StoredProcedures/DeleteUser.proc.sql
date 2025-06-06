-- =============================================
-- Author:		CSET Team
-- Create date: 2021-04-08
-- Description:	Deletes a user from the CSET database.  
--              Supply a user ID argument to delete a single user, or
--              use an argument of -1 to delete all users.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUser]
	@userid nvarchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if @userid < 0
		BEGIN
			delete from [ASSESSMENT_CONTACTS];
			delete from [FINDING_CONTACT];
			delete from [USER_SECURITY_QUESTIONS];
			delete from [USERS];
		END
	ELSE
		BEGIN
			select [assessment_contact_id] into #xyz from [ASSESSMENT_CONTACTS] where [userid] = @userid;
			delete from [FINDING_CONTACT] where [Assessment_Contact_Id] in (select [assessment_contact_id] from #xyz);
			delete from [ASSESSMENT_CONTACTS] where [Assessment_Contact_Id] in (select [assessment_contact_id] from #xyz);

			delete from [USER_SECURITY_QUESTIONS] where [userid] = @userid;

			delete from [USERS] where [UserId] = @userid;
		END
END


