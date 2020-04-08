#!/bin/bash


USER_ID=$(id -u)

# Update user uid and password
sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd

rm -rf /home/user
mkdir /home/user
chown -R $(id -u):0 /home/user
chmod 770 -R /home/user
chmod 770 -R /tmp

exit 0