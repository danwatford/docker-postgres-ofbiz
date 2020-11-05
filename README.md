# Docker-compose configuration for running Ofbiz with a PostgreSQL database.

This docker-compose configuration consists of two containers:

- a standard postgres container
- an Ofbiz container built using an OpenJDK 8 image.

## Postgres

The postgres DBMS keeps all its data in volumes internal to the container.

Databases and users to support the Ofbiz application are configured in:
`script docker-entrypoint-initdb.d/init-user-db.sh.`

Database usernames and passwords have been chosen to correspond to defaults
or postgres in Ofbiz to reduce the number of configuration changes needed in
Ofbiz. This shouldn't pose a security issue and the database will not be
accessible outside of the docker-compose configuration.

Backups of the databases are performed using pg_dump, with files written to
a dumps directory with is on a volume mounted from the docker host.

Run script, `backup_db.sh`, to dump the ofbiz database to the dbdumps directory.

If spinning up a new postgres container, the `docker-entrypoint-initdb.d/20-restore-ofbiz-from-dump-file.sh`
will sort the dump files in the dbdumps directory and restore to the ofbiz database.

## Ofbiz

The Ofbiz container is built as part of this docker-compose configuration, based on the OpenJDK 8 image.

Ofbiz sources are built using gradle inside the new image.

The entity engine configuration is then modified to refer to the
local postgres datasource rather than the default derby datasource.

# First run

The first time Ofbiz is executed it is necessary to atleast load seed data.
It might also be appropriate to load demo data.

Build the ofbiz container:
`docker-compose build`

Either way ensure the database is running:
`docker-compose up -d db`

If loading all data run:
`docker-compose run ofbiz loadAll`

# Normal running

Once data has been loaded to the database using data loading, or possibly database restore, then run ofbiz using:
`docker-compose up -d`

Database and ofbiz logs can be seen using:
`docker-compose logs -f`

The ofbiz container exposes ports 8080 and 8443. Example URLS:

- http://localhost:8080/partymgr
- https://localhost:8443/partymgr
-
-
