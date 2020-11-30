# Docker-compose configuration for running Ofbiz with a PostgreSQL database.

This docker-compose configuration consists of two containers:

- a standard postgres container
- an Ofbiz container built using an OpenJDK 8 image.

## Postgres

The postgres DBMS keeps all its data in volumes internal to the container.

Databases and users to support the Ofbiz application are configured in script:
`docker-entrypoint-initdb.d/init-user-db.sh.`

Database usernames and passwords have been chosen to correspond to defaults
or postgres in Ofbiz to reduce the number of configuration changes needed in
Ofbiz. This shouldn't pose a security issue as the database will not be
accessible outside of the docker-compose configuration.

Backups of the databases are performed using pg_dump, with files written to
a dumps directory which is on a volume mounted from the docker host.

Run script, `backup_db.sh`, to dump the ofbiz database to the dbdumps directory.

If spinning up a new postgres container, the `docker-entrypoint-initdb.d/20-restore-ofbiz-from-dump-file.sh`
will sort the dump files in the dbdumps directory and restore to the ofbiz database.

## Ofbiz

The Ofbiz container is built as part of this docker-compose configuration, based on the OpenJDK 8 image.

Ofbiz sources are built using gradle inside the new image.

The entity engine configuration is then modified to refer to the
local postgres datasource rather than the default derby datasource.

### Get Ofbiz

You will need to download Apache Ofbiz and extract the contents such that file build.gradle is accessible
at `ofbiz/apache-ofbiz/build.gradle`.

Download from https://ofbiz.apache.org/download.html

### Example if using the stable release

Assuming this repository has been checked out to $HOME/apps/docker-postgres-ofbiz.

- Download the stable release zip file from https://ofbiz.apache.org/download.html
- Save the downloaded zip file to directory $HOME/apps/docker-postgres-ofbiz/ofbiz.
- Extract the zip file in place: `unzip apache-ofbiz-*.zip`
- Rename the extracted directory to apache-ofbiz.

### Example if using the trunk branch

Assuming this repository has been checked out to $HOME/apps/docker-postgres-ofbiz-trunk.

At the terminal:

- Change to the ofbiz directory: `cd $HOME/apps/docker-postgres-ofbiz-trunk/ofbiz`
- Clone the ofbiz-framework repo to the apache-ofbiz directory: `git clone https://github.com/apache/ofbiz-framework.git apache-ofbiz`

# First run

The first time Ofbiz is executed it is necessary to at least load the seed data.
It might also be appropriate to load demo data.

Build the ofbiz container:
`docker-compose build`

Ensure the database is running:
`docker-compose up -d db`

If loading all data run (do not do this if restoring from a database dump):
`docker-compose run ofbiz loadAll`

# Normal running

It is recommended to bring up the database first if restoring from a database dump:
`docker-compose up -d db`

Once data has been loaded to the database using data loading (see First Run section above), or possibly a database restore, run ofbiz using:
`docker-compose up -d`

Database and ofbiz logs can be seen using:
`docker-compose logs -f`

The ofbiz container exposes ports 8080 and 8443. Example URLS:

- http://localhost:8080/partymgr
- https://localhost:8443/partymgr
