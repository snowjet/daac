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

chmod -R g+w /etc/supervisord
chmod -R g+w /var
chmod -R g+w /home

/opt/bin/fix_permissions.sh /var/run
/opt/bin/fix_permissions.sh /var/log
/opt/bin/fix_permissions.sh /home/user
/opt/bin/fix_permissions.sh /var/lib/tomcat
/opt/bin/fix_permissions.sh /usr/share/tomcat/

# Uncomment for local testing
# echo "password" | passwd --stdin root

# END