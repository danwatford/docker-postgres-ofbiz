#!/bin/bash
set -e

# Maximum amount of time to wait for ofbiz to startup.
TIMEOUT_SEC=120

# Ensure the ofbiz service is NOT running.
RUNNING_OFBIZ_SERVICE_ID=$(docker-compose ps --quiet --filter status=running ofbiz 2>/dev/null || true)
if [ -n "$RUNNING_OFBIZ_SERVICE_ID" ]; then
    echo "OFBiz service is already running. Please stop the OFBiz service before running this script. (See stop_ofbiz.sh)"
    exit 0
fi

echo "OFBiz service is NOT running. Starting..."

# Get the length of any existing logs for the ofbiz service so we can skip over them when waiting for ofbiz to start.
PREV_LOG_LENGTH_LINES=$(docker-compose logs ofbiz | wc -l)

docker-compose up -d ofbiz
echo "OFBiz startup in progress..."

# Log string to match on.
OFBIZ_READY_STRING="is started and ready"

# Monitor the log to see that OFBiz startup is complete.
loopCount=0
while (true); do
    # Read the log content generated since starting up the ofbiz service.
    LOG_CONTENT=$(docker-compose logs ofbiz | tail --lines=+$((PREV_LOG_LENGTH_LINES + 1)))

    # Find a match in the log containing the OFBIZ_READY_STRING.
    READY=$(echo "$LOG_CONTENT" | awk '{if ($0 ~ /'"$OFBIZ_READY_STRING"'/) { print "READY"; }}')
    if [ "$READY" = "READY" ]; then
        echo "$LOG_CONTENT"
        break
    fi

    loopCount=$((loopCount + 1))
    if ((loopCount >= TIMEOUT_SEC)); then
        echo "$LOG_CONTENT"
        echo "WARNING: OFBiz startup timed out after $TIMEOUT_SEC seconds."
        echo "The OFBiz service may still be running."
        exit 1
    fi

    # Otherwise, wait a second and try again.
    sleep 1
done
