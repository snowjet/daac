#!/bin/bash -l

cd /home/user
export DISPLAY=":10"
export HOME="/home/user"

# check to see if the user has a preferred desktop
PREFERRED=
if [ -f /etc/sysconfig/desktop ]; then
    . /etc/sysconfig/desktop
    if [ "$DESKTOP" = "GNOME" ]; then
	PREFERRED="$GSESSION"
    elif [ "$DESKTOP" = "KDE" ]; then
	PREFERRED="$STARTKDE"
    fi
fi

if [ -n "$PREFERRED" ]; then
    exec "$PREFERRED"
fi

# now if we can reach here, either no desktop file was present,
# or the desktop requested is not installed.

logger "check that you have configured /etc/sysconfig/desktop"

vncserver -kill $DISPLAY