FROM postgres:latest

ADD common/scripts/db_schema /db_schema

COPY common/scripts/initdb.sh /docker-entrypoint-initdb.d/initdb.sh

RUN chmod 755 /docker-entrypoint-initdb.d/initdb.sh



