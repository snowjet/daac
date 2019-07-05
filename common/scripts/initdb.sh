#!/bin/bash
set -e

cat /db_schema/*.sql | psql  -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f -

exit 0