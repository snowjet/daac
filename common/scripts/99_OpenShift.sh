# The following commands are needed to work in 
# OpenShift without privilged mode

chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp

chmod 755 /opt/bin/*
chgrp -R 0 /opt/bin
chmod -R g=u /opt/bin

chmod -R g=u /etc/passwd
chmod -R g=u /etc/group
chmod -R g=u /etc/shadow
chmod u+s /usr/bin/chmod

chmod -R g+w /etc/supervisord.d/
chmod -R g+w /var
chmod -R g+w /home

/opt/bin/fix_permissions.sh /var/run
/opt/bin/fix_permissions.sh /var/log
/opt/bin/fix_permissions.sh /home/user
/opt/bin/fix_permissions.sh /var/lib/tomcat
/opt/bin/fix_permissions.sh /usr/share/tomcat/

# OpenShift Tweaks may not be needed
# touch /run/dbus/messagebus.pid
# touch /run/dbus/system_bus_socket.pid
# touch /run/dbus/system_bus_socket

# chgrp -R 0 /run/dbus/messagebus.pid && chmod -R g=u /run/dbus/messagebus.pid
# chgrp -R 0 /run/dbus/system_bus_socket.pid && chmod -R g=u /run/dbus/system_bus_socket.pid
# chmod 777 /run/dbus/system_bus_socket

# chgrp -R 0 /var/run && chmod -R g=u /var/run 
# chgrp -R 0 /var/log && chmod -R g=u /var/log

# Uncomment for local testing
# echo "password" | passwd --stdin root

# END