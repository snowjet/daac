# Setup Supervisor and activate dbus

yum install -y supervisor
cp /etc/supervisord.conf /etc/supervisord.conf.bak
cp /tmp/config/supervisord/supervisord.conf /etc/supervisord.conf

mkdir -p /var/run/dbus
chown dbus:root /var/run/dbus
chgrp -R 0 /var/run/dbus
chmod -R g=u /var/run/dbus
dbus-uuidgen --ensure

cp /tmp/config/supervisord/conf.d/dbus.conf /etc/supervisord.d/dbus.conf

# END