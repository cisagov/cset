.PHONY: help build-backend launch-backend build-frontend launch-frontend launch-db load-db sql-shell stop-db remove-db
include .env
export

# target: help - Display callable targets.
help:
	@egrep "^# target:" [Mm]akefile

# target: build - Build the project
build:
	docker compose build --no-cache

# target: build-dev - Build the project in development mode
build-dev:
	docker compose -f compose.dev.yml build --no-cache

# target: up - Start the project
up:
	docker compose up -d

# target: up-dev - Start the project in development mode
up-dev:
	docker compose -f compose.dev.yml up -d

# target: stop - Stop the project
stop:
	docker compose stop

# target: stop-dev - Stop the project in development mode
stop-dev:
	docker compose -f compose.dev.yml stop

# target: build-backend - Launch the backend server
build-backend:
	cd CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore && dotnet build

# target: launch-backend - Launch the backend server
launch-backend:
	cd CSETWebApi/CSETWeb_Api/CSETWeb_ApiCore && dotnet watch

# target: build-frontend - Launch the frontend server
build-frontend:
	cd CSETWebNg && npm install

# target: launch-frontend - Launch the frontend server
launch-frontend:
	cd CSETWebNg && ng serve

# target: launch-db - Launch the local database
launch-db:
	docker compose up -d sqlserver

# target: split-bak - Split the database backup file into smaller chunks
split-bak:
	split -b 50M backup/CSETWeb.bak backup/bak-files/CSETWeb.bak.part_

# target: create-bak - Create a database backup file
create-bak:
	cat backup/bak-files/CSETWeb.bak.part_* > backup/CSETWeb.bak

# target: load-bak = Load the database backup file
load-bak:
	docker exec -i cset-mssql /opt/mssql-tools/bin/sqlcmd \
		-U 'sa' \
		-P "Password123" \
		-i /var/opt/mssql/backup/restoredb.sql

# target: sql - Access SQL shell in the cset-mssql container
sql:
	docker exec -it cset-mssql /opt/mssql-tools/bin/sqlcmd \
		-U 'sa' \
		-P "Password123"

# target: stop-db - Stop the local database
stop-db:
	docker compose stop sqlserver

# target: remove-db - Remove the database, container and its data
remove-db:
	docker compose down -v sqlserver

# target: sql - Run SQL commands in the database
sql:
	docker exec -it cset-mssql /opt/mssql-tools/bin/sqlcmd -U 'sa' -P "Password123"
