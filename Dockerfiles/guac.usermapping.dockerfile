FROM registry.redhat.io/jboss-webserver-5/webserver50-tomcat9-openshift

LABEL io.openshift.expose-services="8080:http" \
      io.openshift.wants="postgres"

ARG GUACAMOLE_VERSION='1.0.0'
ARG POSTGRES_CONNECTOR_VERSION='42.2.6'

# Example Environment
# ENV XRDP_PASSWORD="user" \
#     GUAC_PWHASH="5f4dcc3b5aa765d61d8327deb882cf99" \
#     POSTGRES_DATABASE=guacamole_db  \
#     POSTGRES_USER=guacamole_user    \
#     POSTGRES_PASSWORD=some_password \        
#     POSTGRES_DATABASE_FILE=/run/secrets/db \
#     POSTGRES_USER_FILE=/run/secrets/user \
#     POSTGRES_PASSWORD_FILE=/run/secrets/pwd

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin
ADD common/scripts/ /tmp/

RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN rm -rf /deployments/* && \
    curl -L -o /deployments/ROOT.war https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-${GUACAMOLE_VERSION}.war && \
    mkdir -p /etc/guacamole/{extensions,lib} && \
    curl -L -o guacamole-auth-quickconnect.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-quickconnect-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-quickconnect.tar.gz && \
    mv guacamole-auth-quickconnect-${GUACAMOLE_VERSION}/*.jar /etc/guacamole/extensions && \
    rm -rf guacamole-auth-quickconnect* && \
    curl -L -o guacamole-auth-jdbc.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-jdbc-${GUACAMOLE_VERSION}.tar.gz && \
    tar -xzf guacamole-auth-jdbc.tar.gz && \
    mv guacamole-auth-jdbc-${GUACAMOLE_VERSION}/postgresql/*.jar /etc/guacamole/extensions && \
    rm -rf guacamole-auth-jdbc* && \
    curl -L -o /etc/guacamole/lib/postgres-connector.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar && \
    cp /tmp/config/guacamole/guacamole.properties /etc/guacamole/guacamole.properties && \
    cp /tmp/config/guacamole/user-mapping.xml /etc/guacamole/user-mapping.xml && \
    chmod 660 /etc/guacamole/user-mapping.xml && \
    chown jboss:root -R /deployments /etc/guacamole && \
    chgrp -R 0 /etc/guacamole /deployments && chmod -R g=u /etc/guacamole /deployments && \
    ls -alR /etc/guacamole

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
ENTRYPOINT /opt/bin/uid_entrypoint.sh guac; /opt/jws-5.0/tomcat/bin/launch.sh

