#!/bin/bash
set -e

# Maximum amount of time to wait for the database to startup.
TIMEOUT_SEC=20

# Check if the database service is already running.
RUNNING_DB_SERVICE_ID=$(docker-compose ps --quiet --filter status=running db 2>/dev/null || true)
if [ -n "$RUNNING_DB_SERVICE_ID" ]; then
    echo "Database service is already running. Container ID: $RUNNING_DB_SERVICE_ID"
    exit 0
fi

echo "Database service is not running. Starting up..."

# Get the length of any existing logs for the database service so we can skip over them when waiting for the database to start.
PREV_LOG_LENGTH_LINES=$(docker-compose logs db | wc -l)

docker-compose up -d db
echo "Database startup in progress..."

# Log strings to match on.
INIT_COMPLETE_STRING="PostgreSQL init process complete"
SKIPPING_INIT_STRING="Skipping initialization"
DB_READY_STRING="database system is ready to accept connections"

# Monitor the log to see that database initialisation is complete or is being skipped, and that the database is ready to accept connections.
loopCount=0
while (true); do
    # Read the log content generated since starting up the db service.
    LOG_CONTENT=$(docker-compose logs db | tail --lines=+$((PREV_LOG_LENGTH_LINES + 1)))

    # Find a match in the log starting with either the INIT_COMPLETE_STRING or SKIPPING_INIT_STRING, and then look for the DB_READY_STRING.
    READY=$(echo "$LOG_CONTENT" | awk '{if ($0 ~ /'"$INIT_COMPLETE_STRING"'|'"$SKIPPING_INIT_STRING"'/) {initProcessMatched=1;} if (initProcessMatched) {if ($0 ~ /'"$DB_READY_STRING"'/) { print "READY"; exit;}}}')
    if [ "$READY" = "READY" ]; then
        echo "$LOG_CONTENT"
        break
    fi

    loopCount=$((loopCount + 1))
    if ((loopCount >= TIMEOUT_SEC)); then
        echo "$LOG_CONTENT"
        echo "WARNING: Database startup timed out after $TIMEOUT_SEC seconds."
        echo "The database service may still be running."
        exit 1
    fi

    # Otherwise, wait a second and try again.
    sleep 1
done
