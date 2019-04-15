#!/bin/bash

# Generate a password automatically
PASSWD=$(/opt/bin/genpw.sh)
PWHASH=$(openssl passwd -1 ${PASSWD})

# Update XRDP
sed "s@password=\${PASSWORD}@password=${PASSWD}@g" /etc/xrdp/xrdp-template.ini > /etc/xrdp/xrdp.ini

# Update user uid and password
sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
chmod 660 /etc/shadow /etc/shadow.template
sed "s@user:\!\!:@user:${PWHASH}:@g" /etc/shadow.template > /etc/shadow
chmod 000 /etc/shadow /etc/shadow.template

chown -R $(id -u):0 /home/user
chmod 775 /dev/shm

# Update Guacamole Server
/opt/bin/guac_setup.py --vnc_pass "${PWHASH}"

# END