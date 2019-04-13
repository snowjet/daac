#!/bin/bash

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:/home/${LOCAL_AUTH_USER}:/usr/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:${LOCAL_AUTH_USER_PWHASH}:17997:0:99999:7:::" >> /etc/shadow
  fi
fi

chown -R $(id -u):0 /home/${LOCAL_AUTH_USER}
chmod 775 /dev/shm

# END