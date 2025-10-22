#!/usr/bin/env bash

# Convert an MSSQL .bak (CSETWebTest) into a PostgreSQL 17 backup file.
#
# This script orchestrates the following steps:
#  1) Ensure SQL Server is running via docker compose and restore backup/CSETWebTest.bak
#  2) Start a temporary Postgres 17 container
#  3) Use local pgloader to migrate data from MSSQL -> Postgres
#  4) Produce a Postgres 17-compatible backup (custom format .dump) in ./backup
#  5) Optional: emit a plain SQL dump as well
#
# Prereqs:
#  - Docker Desktop (alloc ≥ 10 GB RAM as per repo docs)
#  - `make create-bak` (if using split parts in backup/bak-files/) to generate backup/CSETWebTest.bak
#  - `make up` or at least `make launch-db` so cset-mssql is running
#
# Usage:
#  bash DatabaseScripts/convert-mssql-bak-to-postgres.sh
#  
# Optional env vars to override defaults:
#  MSSQL_CONTAINER=cset-mssql
#  MSSQL_HOST=localhost
#  MSSQL_PORT=1433
#  MSSQL_DB=CSETWebTest
#  MSSQL_SA_PASSWORD=Password123
#  BAK_PATH=backup/CSETWebTest.bak   # falls back to backup/CSET.bak if found
#  PG_CONTAINER=cset-pg17
#  PG_DB=csetweb
#  PG_USER=cset
#  PG_PASSWORD=password
#  PG_HOST=localhost
#  PG_HOST_PORT=55432            # host port mapped to container 5432
#  PG_DUMP_OUT=backup/csetweb.pg17.dump  # custom format (.dump)
#  PG_PLAIN_OUT=backup/CSETWeb.pg17.sql  # plain SQL (optional)
#
set -euo pipefail

echo "[+] Starting MSSQL -> Postgres17 conversion"

# Defaults aligned to compose.yml and compose.dev.yml
MSSQL_CONTAINER="${MSSQL_CONTAINER:-cset-mssql}"
MSSQL_HOST="${MSSQL_HOST:-localhost}"
MSSQL_PORT="${MSSQL_PORT:-1433}"
MSSQL_DB="${MSSQL_DB:-CSETWebTest}"
MSSQL_SA_PASSWORD="${MSSQL_SA_PASSWORD:-Password123}"
BAK_PATH="${BAK_PATH:-backup/CSETWebTest.bak}"

PG_CONTAINER="${PG_CONTAINER:-cset-pg17}"
PG_DB="${PG_DB:-csetweb}"
PG_USER="${PG_USER:-cset}"
PG_PASSWORD="${PG_PASSWORD:-password}"
PG_HOST="${PG_HOST:-localhost}"
PG_HOST_PORT="${PG_HOST_PORT:-55432}"
PG_DUMP_OUT="${PG_DUMP_OUT:-backup/csetweb-from-mssql.sql}"
PG_PLAIN_OUT="${PG_PLAIN_OUT:-}"  # empty disables plain SQL dump by default

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "[-] '$1' is required"; exit 1; }
}

require docker

# Choose pgloader execution mode: 'docker' (default) or 'local'
PGLOADER_MODE="${PGLOADER_MODE:-docker}"

# pgloader may be installed locally; if not, we will fallback to a Docker image
if command -v pgloader >/dev/null 2>&1; then
  HAVE_PGLOADER=1
else
  HAVE_PGLOADER=0
fi

# Validate inputs
if [[ ! -f "$BAK_PATH" ]]; then
  echo "[-] Backup file not found at '$BAK_PATH'"
  echo "    If using split parts, run: make create-bak"
  exit 1
fi

echo "[+] Ensuring SQL Server container '$MSSQL_CONTAINER' is running"
if ! docker ps --format '{{.Names}}' | grep -q "^${MSSQL_CONTAINER}$"; then
  echo "[-] Container '$MSSQL_CONTAINER' not running. Start with: make launch-db"
  exit 1
fi

# We will connect to MSSQL via host-published port ($MSSQL_HOST:$MSSQL_PORT)
echo "[+] Connecting to MSSQL at $MSSQL_HOST:$MSSQL_PORT"

# Restore the .bak into MSSQL if needed
echo "[+] Restoring '$BAK_PATH' into MSSQL database '$MSSQL_DB' (idempotent)"
# We mount ./backup into the SQL Server container via compose.yml already.
# The existing restore script uses that path; reuse it for consistency.
if ! docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools/bin/sqlcmd \
    -U 'sa' \
    -P "$MSSQL_SA_PASSWORD" \
    -Q "RESTORE HEADERONLY FROM DISK = '/var/opt/mssql/backup/$(basename "$BAK_PATH")'" >/dev/null 2>&1; then
  echo "[-] SQL Server cannot read the backup at /var/opt/mssql/backup/$(basename "$BAK_PATH")."
  echo "    Ensure compose mounts './backup' and the file exists there."
  exit 1
fi

# Use the committed restore script if present; otherwise inline a MOVE-based restore
if docker exec -i "$MSSQL_CONTAINER" test -f /var/opt/mssql/backup/restoredb.sql; then
  docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools/bin/sqlcmd \
    -U 'sa' \
    -P "$MSSQL_SA_PASSWORD" \
    -i /var/opt/mssql/backup/restoredb.sql
else
  echo "[!] /var/opt/mssql/backup/restoredb.sql not found; performing direct RESTORE"
  # Discover logical names
  FILELIST=$(docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools/bin/sqlcmd \
    -U 'sa' -P "$MSSQL_SA_PASSWORD" -h -1 -W \
    -Q "RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/$(basename "$BAK_PATH")'" | tr -d '\r')
  DB_LOGICAL=$(echo "$FILELIST" | awk -F'|' 'NR==3{gsub(/^ +| +$/, "", $1); print $1}')
  LOG_LOGICAL=$(echo "$FILELIST" | awk -F'|' 'NR==4{gsub(/^ +| +$/, "", $1); print $1}')
  docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools/bin/sqlcmd -U 'sa' -P "$MSSQL_SA_PASSWORD" -Q "
    ALTER DATABASE [$MSSQL_DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    RESTORE DATABASE [$MSSQL_DB]
      FROM DISK = '/var/opt/mssql/backup/$(basename "$BAK_PATH")'
      WITH REPLACE,
           MOVE '$DB_LOGICAL' TO '/var/opt/mssql/data/$MSSQL_DB.mdf',
           MOVE '$LOG_LOGICAL' TO '/var/opt/mssql/data/${MSSQL_DB}_Log.ldf';
    ALTER DATABASE [$MSSQL_DB] SET MULTI_USER;
  "
fi

# Start a temporary Postgres 17 container with host port mapping
if docker ps -a --format '{{.Names}}' | grep -q "^${PG_CONTAINER}$"; then
  echo "[+] Reusing existing Postgres container '$PG_CONTAINER'"
  docker start "$PG_CONTAINER" >/dev/null
else
  echo "[+] Starting Postgres 17 container '$PG_CONTAINER'"
  docker run -d \
    --name "$PG_CONTAINER" \
    -p "$PG_HOST_PORT:5432" \
    -e POSTGRES_DB="$PG_DB" \
    -e POSTGRES_USER="$PG_USER" \
    -e POSTGRES_PASSWORD="$PG_PASSWORD" \
    postgres:17-alpine >/dev/null
fi

# Wait for Postgres to accept connections (use pg_isready inside the container)
echo -n "[+] Waiting for Postgres to become ready"
until docker exec "$PG_CONTAINER" pg_isready -U "$PG_USER" >/dev/null 2>&1; do
  echo -n "."
  sleep 1
done
echo " ok"

# Ensure required PostgreSQL extensions are available (uuid-ossp for uuid_generate_v4)
echo "[+] Ensuring Postgres extensions (uuid-ossp) are installed"
docker exec -e PGPASSWORD="$PG_PASSWORD" "$PG_CONTAINER" \
  psql -h localhost -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 \
  -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' >/dev/null

# After restore, give SQL Server a brief moment and verify it's accepting queries
echo -n "[+] Verifying MSSQL accept connections"
for i in $(seq 1 10); do
  if docker exec -i "$MSSQL_CONTAINER" /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U 'sa' -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" >/dev/null 2>&1; then
    echo " ok"
    break
  fi
  echo -n "."; sleep 1
  if [[ $i -eq 10 ]]; then
    echo "\n[!] Warning: MSSQL query check didn't succeed, proceeding anyway"
  fi
done

# Prepare staging database
PG_DB_STAGE="${PG_DB_STAGE:-csetweb_stage}"
LOG_DIR="DatabaseScripts/Migration/logs"
mkdir -p "$LOG_DIR"

echo "[+] Preparing staging database '$PG_DB_STAGE'"
docker exec "$PG_CONTAINER" dropdb -U "$PG_USER" --if-exists "$PG_DB_STAGE" 2>/dev/null || true
docker exec "$PG_CONTAINER" createdb -U "$PG_USER" "$PG_DB_STAGE"

echo "[+] Installing extensions in staging database"
docker exec -e PGPASSWORD="$PG_PASSWORD" "$PG_CONTAINER" \
  psql -h localhost -U "$PG_USER" -d "$PG_DB_STAGE" -v ON_ERROR_STOP=1 \
  -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' >/dev/null

# Use pgloader configuration file
PGLOADER_LOAD_FILE="DatabaseScripts/Migration/pgloader-mssql-to-pg.load"
if [[ ! -f "$PGLOADER_LOAD_FILE" ]]; then
  echo "[-] pgloader config file not found: $PGLOADER_LOAD_FILE"
  exit 1
fi

echo "[+] Running pgloader with configuration file: $PGLOADER_LOAD_FILE"
docker run --rm \
  --platform linux/amd64 \
  --name cset-pgloader \
  -e TDS_MAX_CONN=2048 \
  -e TDSVER=7.4 \
  -v "$PWD:/work" \
  -w /work \
  dimitri/pgloader:latest pgloader "$PGLOADER_LOAD_FILE" \
  2>&1 | tee "$LOG_DIR/pgloader-run.log"

# Check pgloader exit status
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
  echo "[-] pgloader failed. Check logs at $LOG_DIR/pgloader-run.log"
  exit 1
fi

# Sanity check: verify assessments table was populated
echo "[+] Verifying data in staging database"
ASSESSMENTS_COUNT=$(docker exec -e PGPASSWORD="$PG_PASSWORD" "$PG_CONTAINER" \
  psql -h localhost -U "$PG_USER" -d "$PG_DB_STAGE" -t -c 'SELECT COUNT(*) FROM dbo."ASSESSMENTS";' | tr -d '[:space:]')

echo "[+] Assessments count in staging DB: $ASSESSMENTS_COUNT"
if [[ "$ASSESSMENTS_COUNT" -eq 0 ]]; then
  echo "[-] ERROR: No assessments were migrated! Check $LOG_DIR/pgloader-run.log"
  exit 1
fi

# Produce a PostgreSQL plain SQL dump from staging database
echo "[+] Creating Postgres plain SQL dump: $PG_DUMP_OUT"
mkdir -p "$(dirname "$PG_DUMP_OUT")"
docker exec -e PGPASSWORD="$PG_PASSWORD" "$PG_CONTAINER" \
  pg_dump -h localhost -U "$PG_USER" -d "$PG_DB_STAGE" \
  --schema=dbo --no-owner --no-privileges \
  > "$PG_DUMP_OUT"

if [[ -n "$PG_PLAIN_OUT" && "$PG_PLAIN_OUT" != "$PG_DUMP_OUT" ]]; then
  echo "[+] Creating additional Postgres dump: $PG_PLAIN_OUT"
  docker exec -e PGPASSWORD="$PG_PASSWORD" "$PG_CONTAINER" \
    pg_dump -h localhost -U "$PG_USER" -d "$PG_DB_STAGE" \
    > "$PG_PLAIN_OUT"
fi

echo "[+] Completed. Outputs:"
echo "    - $PG_DUMP_OUT (plain SQL dump from staging DB)"
if [[ -n "$PG_PLAIN_OUT" && "$PG_PLAIN_OUT" != "$PG_DUMP_OUT" ]]; then
  echo "    - $PG_PLAIN_OUT"
fi

cat <<EOF

How to restore:
  # Use the load-postgres-dump.sh script:
  make load-postgres-dump

  # Or manually:
  psql -U $PG_USER -d csetweb -f $PG_DUMP_OUT

Next steps:
  1. Run 'make load-postgres-dump' to load into target database
  2. Verify migration with DatabaseScripts/Migration/verify-migration.sh

Cleanup temporary Postgres container:
  docker rm -f $PG_CONTAINER

EOF

echo "[+] Done."
