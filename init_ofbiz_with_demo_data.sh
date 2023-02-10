#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "This script will initialise a deployment of OFBiz with a PostgreSQL database using Demo data."
echo "You should only run this script once."

echo "Retrieving OFBiz sources"
"$SCRIPT_DIR/scripts/get_ofbiz_sources_if_needed.sh"

echo "Retrieving base docker images"
docker compose pull

echo "Building OFBiz docker image"
docker compose build

echo "Starting database service"
"$SCRIPT_DIR/scripts/start_db.sh"

echo "Loading OFBiz Seed data"
"$SCRIPT_DIR/scripts/load_demo_data.sh"

echo "Starting OFBiz service"
"$SCRIPT_DIR/scripts/start_ofbiz.sh"

echo "OFBiz is now running with Demo data."
echo "Administrative user name: admin"
echo "Administrative user password: ofbiz"
echo
echo "You can now access OFBiz at https://localhost:8443/partymgr."
