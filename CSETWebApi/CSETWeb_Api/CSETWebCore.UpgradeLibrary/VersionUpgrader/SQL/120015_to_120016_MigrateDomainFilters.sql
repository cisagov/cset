SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DELETE FROM FINANCIAL_DOMAIN_FILTERS_V2
INSERT INTO [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
           ([Assessment_Id]
           ,[DomainId]
           ,[Financial_Level_Id]
           ,[IsOn])
	SELECT [Assessment_Id]
		  ,[DomainId]
		  ,1
		  ,[b]
		  FROM [dbo].[FINANCIAL_DOMAIN_FILTERS]

INSERT INTO [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
           ([Assessment_Id]
           ,[DomainId]
           ,[Financial_Level_Id]
           ,[IsOn])
	SELECT [Assessment_Id]
		  ,[DomainId]
		  ,2
		  ,[E]
		  FROM [dbo].[FINANCIAL_DOMAIN_FILTERS]

INSERT INTO [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
    ([Assessment_Id]
    ,[DomainId]
    ,[Financial_Level_Id]
    ,[IsOn])
	SELECT [Assessment_Id]
		  ,[DomainId]
		  ,3
		  ,[int]
		  FROM [dbo].[FINANCIAL_DOMAIN_FILTERS]

INSERT INTO [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
    ([Assessment_Id]
    ,[DomainId]
    ,[Financial_Level_Id]
    ,[IsOn])
	SELECT [Assessment_Id]
		  ,[DomainId]
		  ,4
		  ,[A]
		  FROM [dbo].[FINANCIAL_DOMAIN_FILTERS]

INSERT INTO [dbo].[FINANCIAL_DOMAIN_FILTERS_V2]
           ([Assessment_Id]
           ,[DomainId]
           ,[Financial_Level_Id]
           ,[IsOn])
	SELECT [Assessment_Id]
		  ,[DomainId]
		  ,5
		  ,[inn]
		  FROM [dbo].[FINANCIAL_DOMAIN_FILTERS]

GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
