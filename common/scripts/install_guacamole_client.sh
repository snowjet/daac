# Install Guacamole Client

mkdir -p /guacamole/{extensions,lib,bin} 
mkdir -p /etc/guacamole 

rm -rf /deployments/* 

curl -L -o /deployments/ROOT.war https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-${GUACAMOLE_VERSION}.war 

curl -L -o guacamole-auth-quickconnect.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-quickconnect-${GUACAMOLE_VERSION}.tar.gz 
tar -xzf guacamole-auth-quickconnect.tar.gz 
mv guacamole-auth-quickconnect-${GUACAMOLE_VERSION}/*.jar /guacamole/extensions 
rm -rf guacamole-auth-quickconnect* 

curl -L -o guacamole-auth-jdbc.tar.gz https://www.apache.org/dist/guacamole/${GUACAMOLE_VERSION}/binary/guacamole-auth-jdbc-${GUACAMOLE_VERSION}.tar.gz 
tar -xzf guacamole-auth-jdbc.tar.gz 
mv guacamole-auth-jdbc-${GUACAMOLE_VERSION}/postgresql/*.jar /guacamole/extensions 
rm -rf guacamole-auth-jdbc* 

curl -L -o /guacamole/lib/postgres-connector.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar 

cp /tmp/config/guacamole/guacamole.properties /etc/guacamole/guacamole.properties 
cp /tmp/config/guacamole/user-mapping.xml /etc/guacamole/user-mapping.xml 
chmod 660 /etc/guacamole/user-mapping.xml 
chown jboss:root -R /deployments /guacamole /etc/guacamole 

chgrp -R 0 /guacamole /etc/guacamole /deployments && chmod -R g=u /guacamole /etc/guacamole /deployments 
ls -alR /guacamole

# Final Clean
chmod 755 /opt/bin/*
chgrp -R 0 /opt/bin
chmod -R g=u /opt/bin
rm -rf /tmp/*.sh
rm -rf /tmp/config
rm -f /var/log/*.log    

# END
