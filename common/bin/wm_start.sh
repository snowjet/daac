#!/bin/bash -l

cd /home/user
export DISPLAY=":10"
export HOME="/home/user"

# Source /etc/sysconfig/desktop for future
. /etc/sysconfig/desktop

mate-session

vncserver -kill $DISPLAY