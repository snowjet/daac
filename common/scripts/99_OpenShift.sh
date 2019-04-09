# The following commands are needed to work in 
# OpenShift without privilged mode

chmod u+s /usr/bin/chmod 

chmod 755 /opt/bin/*
chgrp -R 0 /opt/bin
chmod -R g=u /opt/bin
chmod -R g=u /etc/passwd

#yum install -y sudo
