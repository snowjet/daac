#!/bin/bash

# Use password from env
PASSWORD_HASH=${PASSWORD_HASH}

# Update user uid and password
sed "s@user:x:10001:@user:x:10001:@g" /etc/passwd.template > /etc/passwd
chmod 600 /etc/shadow /etc/shadow.template
sed "s@user:\!\!:@user:${PASSWORD_HASH}:@g" /etc/shadow.template > /etc/shadow
chmod 400 /etc/shadow /etc/shadow.template

rm -rf /home/user
mkdir /home/user
chown -R 10001:0 /home/user
chmod 770 -R /home/user
chmod 775 /dev/shm
chmod 770 -R /tmp

/usr/bin/supervisord -c /etc/supervisord.conf