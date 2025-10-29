.PHONY: help build-backend launch-backend build-frontend launch-frontend launch-db load-db stop-db remove-db launch-pg-dev psql-dev mssql-to-postgres load-postgres-dump lint lint-fix lint-check lint-analyzers lint-style lint-whitespace lint-all pre-migration-prep
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

# target: stop-db - Stop the local database
stop-db:
	docker compose stop sqlserver

# target: remove-db - Remove the database, container and its data
remove-db:
	docker compose down -v sqlserver

# target: sql - Run SQL commands in the database
sql:
	docker exec -it cset-mssql /opt/mssql-tools/bin/sqlcmd -U 'sa' -P "Password123"

# target: launch-pgdb - Launch the Postgres database from compose.dev.yml
launch-pgdb:
	docker compose -f compose.dev.yml up -d db

# target: make launch-dbs - Launch both MSSQL and Postgres databases from compose.dev.yml
launch-dbs:
	docker compose -f compose.dev.yml up -d

# target: mssql-to-postgres - Convert MSSQL .bak to Postgres 17 backup
mssql-to-postgres:
	bash DatabaseScripts/Migration/convert-mssql-bak-to-postgres.sh

# target: load-postgres-dump - Load backup/CSETWeb.pg17.dump into Postgres (dev defaults)
load-postgres-dump:
	bash DatabaseScripts/Migration/load-postgres-dump.sh

##
## Backend Linting Commands
##

# target: lint - Check code formatting without making changes (for CI/CD)
lint:
	@echo "🔍 Checking C# code formatting..."
	@dotnet format CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --verify-no-changes --severity warn || \
		(echo "❌ Code formatting issues found. Run 'make lint-fix' to auto-fix." && exit 1)
	@echo "✅ Code formatting check passed!"

# target: lint-fix - Automatically fix code formatting issues
lint-fix:
	@echo "🔧 Fixing C# code formatting..."
	@dotnet format CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --severity info
	@echo "✅ Code formatting applied!"

# target: lint-check - Detailed formatting check with diagnostic output
lint-check:
	@echo "🔍 Running detailed code formatting check..."
	@dotnet format CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --verify-no-changes --severity info --verbosity diagnostic

# target: lint-analyzers - Run only analyzer rules
lint-analyzers:
	@echo "🔍 Running Roslyn analyzers..."
	@dotnet format analyzers CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --verify-no-changes --severity warn

# target: lint-style - Run only style rules
lint-style:
	@echo "🔍 Running style checks..."
	@dotnet format style CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --verify-no-changes --severity warn

# target: lint-whitespace - Run only whitespace formatting
lint-whitespace:
	@echo "🔍 Checking whitespace formatting..."
	@dotnet format whitespace CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln --verify-no-changes

# target: lint-all - Complete linting workflow (check all)
lint-all: lint-whitespace lint-style lint-analyzers
	@echo "✅ All linting checks passed!"

# target: pre-migration-prep - Pre-migration preparation workflow
pre-migration-prep:
	@echo "🚀 Preparing codebase for database migration..."
	@echo ""
	@echo "Step 1: Auto-fixing formatting issues..."
	@$(MAKE) lint-fix
	@echo ""
	@echo "Step 2: Running all linting checks..."
	@$(MAKE) lint-all
	@echo ""
	@echo "Step 3: Building solution..."
	@dotnet build CSETWebApi/CSETWeb_Api/CSETWeb_Api.sln
	@echo ""
	@echo "✅ Pre-migration preparation complete!"
	@echo "   Review changes and commit with: git add -A && git commit -m 'chore: code formatting baseline before PostgreSQL migration'"
