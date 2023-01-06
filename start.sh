#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Starting OFBiz with PostgreSQL..."

echo "Starting database service"
"$SCRIPT_DIR/scripts/start_db.sh"

echo "Starting OFBiz service"
"$SCRIPT_DIR/scripts/start_ofbiz.sh"

echo "You can now access OFBiz at https://localhost:8443/partymgr."
