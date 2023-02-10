#!/bin/bash
set -e

# Check if the database service is running.
RUNNING_DB_SERVICE_ID=$(docker compose ps --quiet --filter status=running db 2>/dev/null || true)
if [ -z "$RUNNING_DB_SERVICE_ID" ]; then
    echo "Database service is not running."
    exit 0
fi

echo "Database service is running. Stopping..."
docker compose stop db
