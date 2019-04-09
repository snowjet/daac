#!/bin/sh
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

chmod 775 /dev/shm

/opt/bin/guac_setup.py

/usr/bin/supervisord -c /etc/supervisord/supervisord.conf

# END