# Install Guacamole

GUAC_VER='1.0.0'

# Default == password
GUAC_PWHASH='5F4DCC3B5AA765D61D8327DEB882CF99'

## Install Prereqs

# yum install -y wget cairo-devel libjpeg-devel libpng-devel uuid-devel \
#                freerdp-devel pango-devel libssh2-devel libssh-dev \
#                tomcat tomcat-admin-webapps tomcat-webapps

yum install -y dejavu-sans-mono-fonts tomcat

## Install Server

# mkdir /root/guacamole
# cd /root/guacamole
# wget -O /root/guacamole/guacamole-server-${GUAC_VER}.tar.gz https://www.apache.org/dist/guacamole/1.0.0/source/guacamole-server-${GUAC_VER}.tar.gz
# tar zxf guacamole-server-${GUAC_VER}.tar.gz
# cd guacamole-server-${GUAC_VER}
# ./configure --with-systemd-dir=/lib/systemd/system
# make 
# make install
# ldconfig
# systemctl daemon-reload

yum --enablerepo=epel-testing install -y guacd libguac{,-client*}

## Install Client ##

mkdir -p /etc/guacamole

rm -rf /var/lib/tomcat/webapps/*
wget -q -O /var/lib/tomcat/webapps/ROOT.war https://www.apache.org/dist/guacamole/1.0.0/binary/guacamole-${GUAC_VER}.war

cp /tmp/config/guacamole/guacamole.properties /etc/sysconfig/guacd
ln -s /etc/sysconfig/guacd /etc/guacamole/guacamole.properties

cp /tmp/config/guacamole/user-mapping.xml /etc/guacamole/user-mapping.xml
chmod 660 /etc/guacamole/user-mapping.xml

cp /tmp/config/supervisord/conf.d/guacd.conf /etc/supervisord.d/guacd.conf

# END