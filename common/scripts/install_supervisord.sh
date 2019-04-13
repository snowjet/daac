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

# OpenShift Tweaks
touch /run/dbus/messagebus.pid
touch /run/dbus/system_bus_socket.pid
touch /run/dbus/system_bus_socket

chgrp -R 0 /run/dbus/messagebus.pid && chmod -R g=u /run/dbus/messagebus.pid
chgrp -R 0 /run/dbus/system_bus_socket.pid && chmod -R g=u /run/dbus/system_bus_socket.pid
chmod 777 /run/dbus/system_bus_socket

chgrp -R 0 /var/run && chmod -R g=u /var/run 
chgrp -R 0 /var/log && chmod -R g=u /var/log

# END