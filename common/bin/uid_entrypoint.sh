#!/bin/bash

USER_ID=$(id -u)
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
    # chmod 660 /etc/shadow
    # echo "user:${LOCAL_AUTH_USER_PWHASH}:17997:0:99999:7:::" >> /etc/shadow
    # chmod 000 /etc/shadow
  fi
fi

chown -R $(id -u):0 /home/user
chmod 775 /dev/shm

# END