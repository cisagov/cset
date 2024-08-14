ALTER DATABASE CSETWeb
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
GO

RESTORE DATABASE CSETWeb
FROM DISK = '/var/opt/mssql/backup/CSETWeb.bak'
WITH REPLACE,
MOVE 'CSETWeb' TO '/var/opt/mssql/data/CSETWeb.mdf',
MOVE 'CSETWeb_Log' TO '/var/opt/mssql/data/CSETWeb_Log.ldf'
GO