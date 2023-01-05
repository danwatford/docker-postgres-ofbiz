#!/bin/bash
set -e

# Read a property value. Assumes all properties are single line and do not have spaces around the '=' sign or comments following the valuel.
function getPropertyValue
{
    echo "$1" | sed "/^$2=/!d; s///"
}

echo "Getting admin port and key..."
START_PROPERTIES_CONTENT=$(cat /ofbiz/build/resources/main/org/apache/ofbiz/base/start/start.properties)

OFBIZ_ADMIN_PORT=$(getPropertyValue "$START_PROPERTIES_CONTENT" "ofbiz.admin.port")
echo Admin port: $OFBIZ_ADMIN_PORT;

OFBIZ_ADMIN_KEY=$(getPropertyValue "$START_PROPERTIES_CONTENT" "ofbiz.admin.key")
echo Admin key: $OFBIZ_ADMIN_KEY;

echo "Sending shutdown signal..."
echo "$OFBIZ_ADMIN_KEY:SHUTDOWN" | curl telnet://localhost:$OFBIZ_ADMIN_PORT
echo "Done"
