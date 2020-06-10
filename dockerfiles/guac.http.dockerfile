FROM jboss/wildfly

LABEL io.openshift.expose-services="8080:http" \
      io.openshift.wants="postgres"

ARG GUACAMOLE_VERSION='1.1.0'
ARG POSTGRES_CONNECTOR_VERSION='42.2.12'

# Example Environment
# ENV POSTGRES_DATABASE=guacamole_db  \
#     POSTGRES_USER=guacamole_user    \
#     POSTGRES_PASSWORD=some_password \        
#     POSTGRES_DATABASE_FILE=/run/secrets/db \
#     POSTGRES_USER_FILE=/run/secrets/user \
#     POSTGRES_PASSWORD_FILE=/run/secrets/pwd
# The HTTP header containing the username of the authenticated user. 
# This property is optional. If not specified, 
# REMOTE_USER will be used by default.
# ENV http-auth-header='REMOTE_USER'

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin
ADD common/scripts/ /tmp/

RUN yum update -y && yum clean all

RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN rm -rf /opt/jboss/wildfly/standalone/deployments/* && \
    curl -L -o /opt/jboss/wildfly/standalone/deployments/ROOT.war https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-${GUACAMOLE_VERSION}.war && \
    mkdir -p /etc/guacamole/{extensions,lib,samples} && \
    curl -L -o guacamole-auth-header.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-header-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-header.tar.gz && \
    mv guacamole-auth-header-${GUACAMOLE_VERSION}/*.jar /etc/guacamole/extensions/00-guacamole-auth-header.jar && \
    rm -rf guacamole-auth-header* && \
    curl -L -o guacamole-auth-jdbc.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-jdbc-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-jdbc.tar.gz && \
    mv guacamole-auth-jdbc-${GUACAMOLE_VERSION}/postgresql/*.jar /etc/guacamole/extensions/01-guacamole-auth-jdbc-postgres.jar && \
    rm -rf guacamole-auth-jdbc* && \
    curl -L -o /etc/guacamole/lib/postgres-connector.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar && \
    cp -r /tmp/config/guacamole/* /etc/guacamole/ && \
    chown jboss:root -R /opt/jboss/wildfly/standalone/deployments /etc/guacamole && \
    chgrp -R 0 /etc/guacamole /opt/jboss/wildfly/standalone/deployments && chmod -R g=u /etc/guacamole /opt/jboss/wildfly/standalone/deployments && \
    ls -alR /etc/guacamole

# Final Clean
RUN \
    chmod 755 /opt/bin/*; \
    chgrp -R 0 /opt/bin; \
    chmod -R g=u /opt/bin; \
    rm -rf /tmp/*.sh; \
    rm -rf /tmp/config; \
    rm -f /var/log/*.log    

USER 1000
EXPOSE 8080
ENTRYPOINT /opt/bin/guac_setup.sh; /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0

