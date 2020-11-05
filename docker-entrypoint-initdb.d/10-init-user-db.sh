#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER ofbiz WITH PASSWORD 'ofbiz';
    CREATE DATABASE ofbiz;
    GRANT ALL PRIVILEGES ON DATABASE ofbiz TO ofbiz;

    CREATE USER ofbizolap WITH PASSWORD 'ofbizolap';
    CREATE DATABASE ofbizolap;
    GRANT ALL PRIVILEGES ON DATABASE ofbizolap TO ofbizolap;

    CREATE USER ofbiztenant WITH PASSWORD 'ofbiztenant';
    CREATE DATABASE ofbiztenant;
    GRANT ALL PRIVILEGES ON DATABASE ofbiztenant TO ofbiztenant;
EOSQL