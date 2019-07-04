FROM registry.redhat.io/jboss-webserver-5/webserver50-tomcat9-openshift

LABEL io.openshift.expose-services="8080:http" \
      io.openshift.wants="postgres"

ARG GUACAMOLE_VERSION='1.0.0'
ARG POSTGRES_CONNECTOR_VERSION='42.2.6'

ENV POSTGRES_DATABASE=guacamole_db  \
    POSTGRES_USER=guacamole_user    \
    POSTGRES_PASSWORD=some_password \        
    POSTGRES_DATABASE_FILE=/run/secrets/db \
    POSTGRES_USER_FILE=/run/secrets/user \
    POSTGRES_PASSWORD_FILE=/run/secrets/pwd

USER root

RUN rm -rf /deployments/* && \
    curl -L -o /deployments/ROOT.war https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-${GUACAMOLE_VERSION}.war && \
    mkdir -p /guacamole/{extensions,lib,bin} && \
    curl -L -o guacamole-auth-quickconnect.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-quickconnect-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-quickconnect.tar.gz && \
    mv guacamole-auth-quickconnect-${GUACAMOLE_VERSION}/*.jar /guacamole/extensions && \
    rm -rf guacamole-auth-quickconnect* && \
    curl -L -o guacamole-auth-jdbc.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-jdbc-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-jdbc.tar.gz && \
    mv guacamole-auth-jdbc-${GUACAMOLE_VERSION}/postgresql/*.jar /guacamole/extensions && \
    rm -rf guacamole-auth-jdbc* && \
    curl -L -o /guacamole/lib/postgres-connector.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar && \
    chown jboss:root -R /deployments /guacamole && \
    chgrp -R 0 /guacamole && chmod -R g=u /guacamole 

USER 1001
EXPOSE 8080
ENTRYPOINT /opt/jws-5.0/tomcat/bin/launch.sh

