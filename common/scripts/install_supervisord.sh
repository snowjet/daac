# Setup Supervisor and activate dbus

yum install -y supervisor
mkdir -p /etc/supervisord/conf.d
cp /tmp/config/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

mkdir -p /var/run/dbus
chown dbus:dbus /var/run/dbus
cp /tmp/config/supervisord/conf.d/dbus.conf /etc/supervisord/conf.d/dbus.conf
chgrp -R 0 /var/run/dbus
chmod -R g=u /var/run/dbus
dbus-uuidgen --ensure

# END