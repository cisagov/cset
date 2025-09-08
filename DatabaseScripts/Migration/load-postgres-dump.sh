#!/usr/bin/env bash

# Load a custom-format Postgres dump (created by pg_dump -Fc)
# into a running Postgres instance.
#
# Defaults map to compose.dev.yml (dev Postgres on host port 5433)
# but everything is overridable via env vars.
#
# Env vars (override as needed):
#  DUMP_PATH=backup/csetweb.pg17.dump
#  PG_HOST=localhost
#  PG_PORT=5432
#  PG_DB=csetweb
#  PG_USER=cset
#  PG_PASSWORD=password
#  DROP_DB=false            # true to drop and recreate the database
#  MODE=docker              # docker | local (default docker uses postgres:17-alpine client)
#
set -euo pipefail

echo "[+] Loading Postgres dump into database"

DUMP_PATH="${DUMP_PATH:-backup/csetweb.pg17.dump}"
PG_HOST="${PG_HOST:-localhost}"
PG_PORT="${PG_PORT:-5432}"
PG_DB="${PG_DB:-csetweb}"
PG_USER="${PG_USER:-cset}"
PG_PASSWORD="${PG_PASSWORD:-password}"
DROP_DB="${DROP_DB:-false}"
MODE="${MODE:-docker}"

if [[ ! -f "$DUMP_PATH" ]]; then
  echo "[-] Dump file not found: $DUMP_PATH"
  echo "    Expected a custom-format dump produced by pg_dump -Fc"
  exit 1
fi

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "[-] '$1' is required"; exit 1; }
}

run_local() {
  require pg_restore
  require psql

  export PGPASSWORD="$PG_PASSWORD"

  if [[ "$DROP_DB" == "true" ]]; then
    echo "[+] Dropping database '$PG_DB' (if exists)"
    psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d postgres -v ON_ERROR_STOP=1 \
      -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$PG_DB' AND pid <> pg_backend_pid();" || true
    dropdb -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" --if-exists "$PG_DB"
  fi

  echo "[+] Ensuring database '$PG_DB' exists"
  createdb -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" "$PG_DB" 2>/dev/null || true

  echo "[+] Ensuring extensions"
  psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -v ON_ERROR_STOP=1 \
    -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' >/dev/null

  echo "[+] Restoring from $DUMP_PATH"
  pg_restore -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" \
    --clean --if-exists --no-owner --no-privileges "$DUMP_PATH"
}

run_docker() {
  require docker

  # Use a client-only ephemeral container; mount backup dir and connect via host.docker.internal
  DUMP_DIR=$(cd "$(dirname "$DUMP_PATH")" && pwd)
  DUMP_FILE="$(basename "$DUMP_PATH")"

  echo "[+] Using Docker postgres:17-alpine client to restore"

  docker run --rm \
    -e PGPASSWORD="$PG_PASSWORD" \
    -v "$DUMP_DIR:/dump:ro" \
    postgres:17-alpine sh -c "\
      if [ '$DROP_DB' = 'true' ]; then \
        psql -h host.docker.internal -p '$PG_PORT' -U '$PG_USER' -d postgres -v ON_ERROR_STOP=1 \
          -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$PG_DB' AND pid <> pg_backend_pid();\" || true && \
        dropdb -h host.docker.internal -p '$PG_PORT' -U '$PG_USER' --if-exists '$PG_DB'; \
      fi; \
      createdb -h host.docker.internal -p '$PG_PORT' -U '$PG_USER' '$PG_DB' 2>/dev/null || true; \
      psql -h host.docker.internal -p '$PG_PORT' -U '$PG_USER' -d '$PG_DB' -v ON_ERROR_STOP=1 -c \"CREATE EXTENSION IF NOT EXISTS \\\"uuid-ossp\\\";\" >/dev/null; \
      pg_restore -h host.docker.internal -p '$PG_PORT' -U '$PG_USER' -d '$PG_DB' --clean --if-exists --no-owner --no-privileges /dump/$DUMP_FILE \
    "
}

case "$MODE" in
  local)
    run_local
    ;;
  docker|*)
    run_docker
    ;;
esac

echo "[+] Restore complete. Database: $PG_DB on $PG_HOST:$PG_PORT"

