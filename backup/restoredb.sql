RESTORE DATABASE CSET
FROM DISK = '/var/opt/mssql/backup/CSET.bak'
WITH REPLACE,
MOVE 'CSETWeb' TO '/var/opt/mssql/data/CSET.mdf',
MOVE 'CSETWeb_Log' TO '/var/opt/mssql/data/CSET_Log.ldf'
GO
