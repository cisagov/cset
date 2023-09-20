RESTORE DATABASE CSETWeb.bak
FROM DISK = '/var/opt/mssql/backup/CSETWeb.bak'
WITH MOVE 'CSETWeb' TO '/var/opt/mssql/data/CSETWeb.mdf'
MOVE 'CSETWeb_Log' TO '/var/opt/mssql/data/CSETWeb_Log.ldf'
GO