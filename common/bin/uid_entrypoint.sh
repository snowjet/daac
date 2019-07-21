#!/bin/bash

# retrieve uid
USER_ID=$(id -u)

# Generate a password automatically
# PASSWD=$(/opt/bin/genpw.sh)

# Use password from env
PASSWD=${XRDP_PASSWORD}

set_xrdp() {
    # Update XRDP
    PWHASH=$(openssl passwd -1 ${PASSWD})
    sed "s@password=\${PASSWORD}@password=${PASSWD}@g" /etc/xrdp/xrdp-template.ini > /etc/xrdp/xrdp.ini

    # Update user uid and password
    sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
    chmod 660 /etc/shadow /etc/shadow.template
    sed "s@user:\!\!:@user:${PWHASH}:@g" /etc/shadow.template > /etc/shadow
    chmod 000 /etc/shadow /etc/shadow.template

    chown -R $(id -u):0 /home/user
    chmod 775 /dev/shm
} 

set_guac() {
    # Update Guacamole Server
    # user if local user-mapping is required
    # /opt/bin/guac_setup.py --vnc_pass "${PASSWD}"
    /opt/bin/guac_setup.sh
} 

case "$1" in
'guac')
    echo "Patching Guacamole usermapping"
    set_guac
    ;;
'xrdp')
    echo "Patching xrdp and shadow files"
    set_xrdp
    ;;
'both')
    echo "Patching Guacamole usermapping"
    set_guac
    echo "Patching xrdp and shadow files"
    set_xrdp
    ;;    
'*')
    echo "Usage: $0 [guac|xrdp|both]"
    ;;
esac

exit 0