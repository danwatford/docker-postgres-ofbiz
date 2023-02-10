#!/bin/bash
set -e

# Maximum amount of time to wait for the ofbiz service to stop.
TIMEOUT_SEC=20

# Check if the ofbiz service is running.
RUNNING_OFBIZ_SERVICE_ID=$(docker compose ps --quiet --filter status=running ofbiz 2>/dev/null || true)
if [ -z "$RUNNING_OFBIZ_SERVICE_ID" ]; then
    echo "OFBiz service is not running."
    exit 0
fi

echo "OFBiz service is running. Stopping..."
docker compose exec ofbiz /send_ofbiz_stop_signal.sh

# Wait for the ofbiz service to stop.
loopCount=0
while (true); do
    EXITED_OFBIZ_SERVICE_ID=$(docker compose ps --quiet --filter status=exited ofbiz)
    if [ -n "$EXITED_OFBIZ_SERVICE_ID" ]; then
        echo "OFBiz service has shutdown. Container ID: $EXITED_OFBIZ_SERVICE_ID"
        exit 0
    fi

    loopCount=$((loopCount + 1))
    if ((loopCount >= TIMEOUT_SEC)); then
        echo "$LOG_CONTENT"
        echo "WARNING: OFBiz service shutdown timed out after $TIMEOUT_SEC seconds."
        echo "The OFBiz service may still be running."
        exit 1
    fi

    # Otherwise, wait a second and try again.
    sleep 1
done
