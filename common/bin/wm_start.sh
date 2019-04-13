#!/bin/bash -l

cd /home/user
export DISPLAY=":10"

# Source /etc/sysconfig/desktop for future
mate-session

vncserver -kill $DISPLAY