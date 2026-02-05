RESTORE DATABASE CSET
FROM DISK = '/var/opt/mssql/backup/CSET.bak'
WITH REPLACE,
MOVE 'CSET' TO '/var/opt/mssql/data/CSET.mdf',
MOVE 'CSET_log' TO '/var/opt/mssql/data/CSET_log.ldf'
GO
