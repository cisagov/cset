
-- Clean out all Assessment-related information
delete from [DOCUMENT_FILE]
delete from [ASSESSMENTS]

DBCC CHECKIDENT ('[ASSESSMENTS]', RESEED, 0);
GO


-- Clean out all User-related information
delete from [USERS]
delete from [USER_DETAIL_INFORMATION]

DBCC CHECKIDENT ('[USERS]', RESEED, 0)
GO


-- Clean out the JWT secret
delete from [JWT]
GO



