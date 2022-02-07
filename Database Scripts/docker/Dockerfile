FROM mcr.microsoft.com/mssql/server:2019-latest

USER root 

WORKDIR /data

COPY . .

RUN chmod +x /data/database.sh

EXPOSE 1433

USER mssql
ENTRYPOINT /bin/bash ./entrypoint.sh