# How to run locally

You need a minimum of 3 containers

docker run --name guc --link some-guacd:guacd \
    --link some-postgres:postgres      \
    -e POSTGRES_DATABASE=guacamole_db  \
    -e POSTGRES_USER=guacamole_user    \
    -e POSTGRES_PASSWORD=some_password \
    -d -p 8080:8080 guac

## Build Local Containers

docker build -f Dockerfiles/guac.dockerfile -t guac .
docker build -f Dockerfiles/guacd.dockerfile -t guacd .
docker build -f Dockerfiles/desktop.dockerfile -t gdesk .

docker build -f Dockerfiles/pgsql.dockerfile -t pgsql .

## Run and Link Docker Files

export XRDP_PASSWORD='KL3ECRd9dd68xFsZ'

export GUACD_HOSTNAME='guacd'
export GUACD_PORT='4822'

export POSTGRES_HOST='127.0.0.1'

export POSTGRES_USER='guac'
export POSTGRES_PASSWORD='guac_pass'
export POSTGRES_DATABASE='guacamole_db'

docker run --name desktop \
    -e XRDP_PASSWORD=${XRDP_PASSWORD} \
    -d -p 3389:3389 desktop

docker run --name guacd --link desktop:desktop \
    -d -p 4822:4822 guacd

docker run --name postgres \
    -e POSTGRESQL_USER=${POSTGRES_USER} \
    -e POSTGRESQL_PASSWORD=${POSTGRES_PASSWORD} \
    -e POSTGRESQL_DATABASE=${POSTGRES_DATABASE} \
    -d -p 5432:5432 registry.redhat.io/rhscl/postgresql-96-rhel7

docker run --name guac --link guacd:guacd \
    --link postgres:postgres \
    -e POSTGRES_DATABASE=${POSTGRES_DATABASE}  \
    -e POSTGRES_USER=${POSTGRES_USER}    \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e GUACD_HOSTNAME=${GUACD_HOSTNAME} \
    -e GUACD_PORT=${GUACD_PORT} \
    -d -p 8080:8080 guac

docker run --name guac-api --link postgres:postgres \
    -e POSTGRES_DATABASE=${POSTGRES_DATABASE}  \
    -e POSTGRES_USER=${POSTGRES_USER}    \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e GUACD_HOSTNAME=${GUACD_HOSTNAME} \
    -e GUACD_PORT=${GUACD_PORT} \
    -d -p 8080:8080 guac