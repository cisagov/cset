ALTER DATABASE CSETWebTest
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
GO

RESTORE DATABASE CSETWebTest
FROM DISK = '/var/opt/mssql/backup/CSETWebTest.bak'
WITH REPLACE,
MOVE 'CSETWebTest' TO '/var/opt/mssql/data/CSETWebTest.mdf',
MOVE 'CSETWebTest_Log' TO '/var/opt/mssql/data/CSETWebTest_Log.ldf'
GO
