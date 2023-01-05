#!/bin/bash
set -e

# Check if the ofbiz service is running.
RUNNING_OFBIZ_SERVICE_ID=$(docker-compose ps --quiet --filter status=running ofbiz 2>/dev/null || true)
if [ -z "$RUNNING_OFBIZ_SERVICE_ID" ]; then
    echo "OFBiz service is not running."
    exit 0
fi

echo "OFBiz service is running. Stopping..."
docker-compose exec ofbiz /send_ofbiz_stop_signal.sh
