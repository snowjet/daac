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
cp /tmp/config/bin/uid_entrypoint /opt/uid_entrypoint
chmod 755 /optuid_entrypoint
chgrp -R 0 /opt/uid_entrypoint
chmod -R g=u /opt/uid_entrypoint /etc/passwd

chgrp -R 0 /var/run && chmod -R g=u /var/run 
chgrp -R 0 /var/log && chmod -R g=u /var/log

# END