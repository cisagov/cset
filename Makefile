.PHONY: help build-backend launch-backend build-frontend launch-frontend launch-db load-db remove-db
include .env
export

# target: help - Display callable targets.
help:
	@egrep "^# target:" [Mm]akefile

# target: build-backend - Launch the backend server
build-backend:
	cd CSETWebApi/CSETWeb_API/CSETWeb_ApiCore && dotnet build

# target: launch-backend - Launch the backend server
launch-backend:
	cd CSETWebApi/CSETWeb_API/CSETWeb_ApiCore && dotnet run

# target: build-frontend - Launch the frontend server
build-frontend:
	cd CSETWebNg && npm install

# target: launch-frontend - Launch the frontend server
launch-frontend:
	cd CSETWebNg && ng serve

# target: launch-db - Launch the local database
launch-db:
	docker compose up -d

# target: load-db - Load the database from the backup
load-db:
	docker exec -i cset-mssql /opt/mssql-tools/bin/sqlcmd -U 'sa' -P "Password123" -i /var/opt/mssql/backup/restoredb.sql

# target: remove-db - Remove the database, container and its data
remove-db:
	docker compose down -v
