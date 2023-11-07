
-- Clean out all Assessment-related information
delete from [DOCUMENT_FILE]
delete from [ACCESS_KEY_ASSESSMENT]
delete from [ACCESS_KEY]
delete from [ASSESSMENTS]
delete from FINANCIAL_DOMAIN_FILTERS_V2
DBCC CHECKIDENT ('[ASSESSMENTS]', RESEED, 0);
GO


-- Clean out all User-related information
delete from [PASSWORD_HISTORY]
delete from [USERS]
delete from [USER_DETAIL_INFORMATION]

DBCC CHECKIDENT ('[USERS]', RESEED, 0)
GO


-- Clean out the JWT secret
delete from [JWT]
delete from [INSTALLATION]
delete from [DIAGRAM_CONTAINER]

delete from [NIST_SAL_INFO_TYPES]

delete from [Nlogs]
GO