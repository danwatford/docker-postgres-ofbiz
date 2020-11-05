#!/bin/bash
set -e

find /opt/dbdumps -iname '*.dump' -type f | sort | tail -1 | while read dumpfile; do
    echo "Dump file name: " $dumpfile
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname ofbiz -f $dumpfile
done
