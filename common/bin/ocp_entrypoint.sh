#!/bin/bash

# retrieve uid
# USERNAME=${USERNAME}
USER_ID=$(id -u)

# Use password from env
PASSWORD_HASH=${PASSWORD_HASH}

# Update user uid and password
sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
chmod 660 /etc/shadow /etc/shadow.template
sed "s@user:\!\!:@user:${PASSWORD_HASH}:@g" /etc/shadow.template > /etc/shadow

chmod 775 /dev/shm
chmod 770 -R /tmp

/usr/bin/supervisord -c /etc/supervisord.conf