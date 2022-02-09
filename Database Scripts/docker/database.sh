# Executes the AttachDb.sql script against the MSSQL Server listening on localhost

/opt/mssql-tools/bin/sqlcmd -U sa -P CSET-Developer22 -S localhost -i AttachDb.sql

/opt/mssql-tools/bin/sqlcmd -U sa -P CSET-Developer22 -S localhost -Q "ALTER DATABASE CSETWeb SET READ_WRITE"