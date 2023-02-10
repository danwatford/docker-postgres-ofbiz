#!/bin/bash
set -x
DUMP_FILE_NAME=$(date +%Y-%m-%dT%H%M%S)
echo '*:*:ofbiz:ofbiz:ofbiz' | docker compose exec db tee /root/.pgpass
docker compose exec db chmod 600 /root/.pgpass
docker compose exec db pg_dump --username=ofbiz --file=/opt/dbdumps/${DUMP_FILE_NAME}.dump ofbiz
