#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Stopping OFBiz with PostgreSQL..."

echo "Stopping OFBiz service"
"$SCRIPT_DIR/scripts/stop_ofbiz.sh"

echo "Stopping database service"
"$SCRIPT_DIR/scripts/stop_db.sh"

echo "OFBiz and PostgreSQL have been stopped."