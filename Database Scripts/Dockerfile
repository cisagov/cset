FROM mcr.microsoft.com/mssql/server:2019-latest

WORKDIR /data

RUN /opt/mssql-tools/bin/sqlcmd -U sa -P CSET-Developer22 -S localhost -i AttachDb.sql