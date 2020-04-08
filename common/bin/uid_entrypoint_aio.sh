#!/bin/bash

# retrieve uid
USERNAME=${USERNAME}
USER_ID=$(id -u)

# Use password from env
PASSWORD_HASH=${PASSWORD_HASH}

set_xrdp() {
    # Update XRDP
    #sed "s@password=\${PASSWORD}@password=${PASSWD}@g" /etc/xrdp/xrdp-template.ini > /etc/xrdp/xrdp.ini
    #sed "s@user=\${USERNAME}@user=${USERNAME}@g" /etc/xrdp/xrdp-template.ini > /etc/xrdp/xrdp.ini

    # Update user uid and password
    sed "s@user:x:\${USER_ID}:@user:x:${USER_ID}:@g" /etc/passwd.template > /etc/passwd
    chmod 660 /etc/shadow /etc/shadow.template
    sed "s@user:\!\!:@user:${PASSWORD_HASH}:@g" /etc/shadow.template > /etc/shadow
    chmod 000 /etc/shadow /etc/shadow.template

    rm -rf /home/user
    mkdir /home/user
    chown -R $(id -u):0 /home/user
    chmod 770 -R /home/user
    chmod 775 /dev/shm
} 

set_guac() {
    # Update Guacamole Server
    # user if local user-mapping is required
    /opt/bin/guac_setup.py --vnc_pass "${PASSWD}"
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