/*
    Granting execute permissions to user_cset_online, if it exists.
*/

IF EXISTS (SELECT name FROM sysusers where name = 'user_cset_online')
BEGIN
GRANT EXECUTE ON SCHEMA::dbo
    TO user_cset_online
END
GO  