# Setup Supervisor and activate dbus

yum install -y supervisor
mkdir -p /etc/supervisord/conf.d
cp /tmp/config/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

mkdir -p /var/run/dbus
chown dbus:dbus /var/run/dbus
dbus-uuidgen --ensure
cp /tmp/config/supervisord/conf.d/dbus.conf /etc/supervisord/conf.d/dbus.conf

# END