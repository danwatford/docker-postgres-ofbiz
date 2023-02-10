#!/bin/bash
set -e

# Ensure the database service is running.
RUNNING_DB_SERVICE_ID=$(docker compose ps --quiet --filter status=running db 2>/dev/null || true)
if [ -z "$RUNNING_DB_SERVICE_ID" ]; then
    echo "Database service is NOT running. Please start the database service before running this script. (See start_db.sh)"
    exit 0
fi

# Ensure the ofbiz service is NOT running.
RUNNING_OFBIZ_SERVICE_ID=$(docker compose ps --quiet --filter status=running ofbiz 2>/dev/null || true)
if [ -n "$RUNNING_OFBIZ_SERVICE_ID" ]; then
    echo "OFBiz service is running. Please stop the OFBiz service before running this script. (See stop_ofbiz.sh)"
    exit 0
fi

echo Loading seed data...
docker compose run --rm ofbiz "ofbiz --load-data readers=seed,seed-initial" loadAdminUserLogin -PuserLoginId=localadmin
echo Seed data loaded.

echo Administrative user name: localadmin
echo Administrative user password: ofbiz
echo This localadmin user will be prompted to change this password on first login.
