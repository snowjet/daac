#!/bin/bash

# retrieve uid
USERNAME=${USERNAME}
USER_ID=$(id -u)

# Use password from env
PASSWORD_HASH=${PASSWORD_HASH}

# Update user uid and password
sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
chmod 660 /etc/shadow /etc/shadow.template
sed "s@user:\!\!:@user:${PASSWORD_HASH}:@g" /etc/shadow.template > /etc/shadow
# need to allow read access for group root so pam which is running
# as the uid of the temp user can read the shadow file
chmod 440 /etc/shadow /etc/shadow.template

rm -rf /home/user
mkdir /home/user
chown -R $(id -u):0 /home/user
chmod 770 -R /home/user
chmod 775 /dev/shm
chmod 770 -R /tmp

exit 0