# docker compose configuration for running OFBiz with a PostgreSQL database.

This docker compose configuration consists of two containers:

- a standard postgres container
- an OFBiz container built using the Eclipse Temurin JDK 17 container image.

Several scripts have been created to assist with creating an OFBiz deployment.

These scripts can be run in a Unix environment where Docker (docker compose) is available.

# Quick start: OFBiz with demo data

[Note: do not do this if restoring from a database dump]

The recommended way to evaulate OFBiz is to use Demo data. This is the same data loaded on the OFBiz project's demo sites, accessible here https://ofbiz.apache.org/ofbiz-demos.html

## First run

To initialise your OFBIz deployment, run the script:
>`./init_ofbiz_with_demo_data.sh`

This script will:
* Download OFBiz sources (currently the release 22.01 branch)
* Pull necessary docker base images
* Build the OFBiz docker image
* Launch the database service
* Load demo data to the database
* Launch the OFBiz service

Once complete you should be able to access OFBiz URLs such as:
- https://localhost:8443/partymgr
- https://localhost:8443/accounting

Your browser may warn that the website is unsecure. This is due to the self-signed certificates used to protect the TLS (https) connection. In this case you can confirm the site as safe to your browser and continue.


# Deploying OFBiz with seed data

[Note: do not do this if restoring from a database dump]

Deploying with seed data rather than demo data can involve a lot of work, but it will help you ensure you have a 'clean' system tailored to your specific requirements.

At the very minimum you will need to create a Party Group representing your organisation, and configure this group with the role, Internal Organisation.

## First run

To initialise your OFBIz deployment using seed data, run the script:
>`./init_ofbiz_with_seed_data.sh`

This script will:
* Download OFBiz sources (currently the release 22.01 branch)
* Pull necessary docker base images
* Build the OFBiz docker image
* Launch the database service
* Load the seed data to the database
* Launch the OFBiz service

Once complete you should be able to access OFBiz URLs such as:
- https://localhost:8443/partymgr
- https://localhost:8443/accounting

Your browser may warn that the website is unsecure. This is due to the self-signed certificates used to protect the TLS (https) connection. In this case you can confirm the site as safe to your browser and continue.

# Shut down

To stop OFBiz and the database from running, use the script:
>`./stop.sh`

This script will:
* Send a signal to OFBiz and wait for it to perform a graceful shutdown.
* Shutdown the database service.

# Normal running

To start OFBiz again, use the script:
>`./start.sh`

This script will:
* Start the database service and wait for the database to be ready.
* Start the OFBiz service and wait for OFBiz to be ready.

# About the containers

## Postgres

The postgres DBMS keeps all its data in volumes internal to the container.

Databases and users to support the OFBiz application are configured in script `docker-entrypoint-initdb.d/init-user-db.sh.`

Database usernames and passwords have been chosen to correspond to defaults
of postgres in OFBiz to reduce the number of configuration changes needed in
OFBiz. This shouldn't pose a security issue as the database will not be
accessible outside of the docker compose configuration.

Backups of the databases are performed using pg_dump, with files written to
a dumps directory which is on a volume mounted from the docker host.

Run script, `backup_db.sh`, to dump the ofbiz database to the dbdumps directory.

If spinning up a new postgres container, the `docker-entrypoint-initdb.d/20-restore-ofbiz-from-dump-file.sh`
will sort the dump files in the dbdumps directory and restore to the ofbiz database.

## OFBiz

The OFBiz container is built as part of the docker compose configuration, based on the OpenJDK 8 image.

OFBiz sources are built using gradle inside the new image.

The entity engine configuration is then modified to refer to the
local postgres datasource rather than the default derby datasource.

### Get OFBiz

If using the `init_ofbiz_with_seed_data.sh` or `init_ofbiz_with_demo_data.sh` scripts, then the sources will be retrieved automatically using
`scripts/get_ofbiz_sources_if_needed.sh`.

However if you wish to obtain sources from elsewhere - such as the git repository or a different release - place them in the `ofbiz/apache-ofbiz`
directory and they will be picked up by the container build process.

If the `ofbiz/apache-ofbiz` directory already exists, the `get_ofbiz_sources_if_needed.sh` won't overwrite them. 

OFBiz can be downloaded from https://ofbiz.apache.org/download.html

### Example if using the stable release

Assuming this repository has been checked out to $HOME/apps/docker-postgres-ofbiz.

- Download the stable release zip file from https://ofbiz.apache.org/download.html
- Save the downloaded zip file to directory $HOME/apps/docker-postgres-ofbiz/ofbiz.
- Extract the zip file in place: `unzip apache-ofbiz-*.zip`
- Rename the extracted directory to apache-ofbiz.

### Example if using the trunk branch

Assuming this repository has been checked out to $HOME/apps/docker-postgres-ofbiz-trunk.

At the terminal:

- Change to the ofbiz directory: 
> `cd $HOME/apps/docker-postgres-ofbiz-trunk/ofbiz`
- Clone the ofbiz-framework repo to the apache-ofbiz directory:
> `git clone https://github.com/apache/ofbiz-framework.git apache-ofbiz`
