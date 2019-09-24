FROM registry.redhat.io/jboss-webserver-5/webserver50-tomcat9-openshift

LABEL io.openshift.expose-services="8080:http" \
      io.openshift.wants="postgres"

ARG GUACAMOLE_VERSION='1.0.0'
ARG POSTGRES_CONNECTOR_VERSION='42.2.6'

# Example Environment
# ENV POSTGRES_DATABASE=guacamole_db  \
#     POSTGRES_USER=guacamole_user    \
#     POSTGRES_PASSWORD=some_password \        
#     POSTGRES_DATABASE_FILE=/run/secrets/db \
#     POSTGRES_USER_FILE=/run/secrets/user \
#     POSTGRES_PASSWORD_FILE=/run/secrets/pwd
# OpenID Connect
# openid-authorization-endpoint: keycloak auth endpoint
# openid-jwks-endpoint: keycloak jwks endpoint
# openid-issuer: keycloak issuer
# openid-client-id: guacamole
# openid-redirect-uri: https://guacamole.example.com/guacamole
# openid-username-claim-type: username
# openid-scope: openid email profile
# openid-allowed-clock-skew: 500

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin
ADD common/scripts/ /tmp/

RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN rm -rf /deployments/* && \
    curl -L -o /deployments/ROOT.war https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-${GUACAMOLE_VERSION}.war && \
    mkdir -p /etc/guacamole/{extensions,lib,samples} && \
    curl -L -o guacamole-auth-openid.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-openid-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-openid.tar.gz && \
    mv guacamole-auth-openid-${GUACAMOLE_VERSION}/*.jar /etc/guacamole/extensions/00-guacamole-auth-openid.jar && \
    rm -rf guacamole-auth-openid* && \
    curl -L -o guacamole-auth-jdbc.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-jdbc-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-jdbc.tar.gz && \
    mv guacamole-auth-jdbc-${GUACAMOLE_VERSION}/postgresql/*.jar /etc/guacamole/extensions/01-guacamole-auth-jdbc-postgres.jar && \
    rm -rf guacamole-auth-jdbc* && \
    curl -L -o /etc/guacamole/lib/postgres-connector.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar && \
    cp -r /tmp/config/guacamole/* /etc/guacamole/ && \
    chown jboss:root -R /deployments /etc/guacamole && \
    chgrp -R 0 /etc/guacamole /deployments && chmod -R g=u /etc/guacamole /deployments && \
    ls -alR /etc/guacamole

    # curl -L -o guacamole-auth-quickconnect.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-quickconnect-${GUACAMOLE_VERSION}.tar.gz && \
    # tar -xzf guacamole-auth-quickconnect.tar.gz && \
    # mv guacamole-auth-quickconnect-${GUACAMOLE_VERSION}/*.jar /etc/guacamole/extensions && \
    # rm -rf guacamole-auth-quickconnect* && \

# Final Clean
RUN \
    chmod 755 /opt/bin/*; \
    chgrp -R 0 /opt/bin; \
    chmod -R g=u /opt/bin; \
    rm -rf /tmp/*.sh; \
    rm -rf /tmp/config; \
    rm -f /var/log/*.log    

USER 10001
EXPOSE 8080
ENTRYPOINT /opt/bin/guac_setup.sh; /opt/jws-5.0/tomcat/bin/launch.sh

