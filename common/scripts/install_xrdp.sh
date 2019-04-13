# Install XRDP and tigervnc

yum install -y xrdp xorgxrdp tigervnc-server

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp

# If you need to change the config on the fly
chmod -R g+w /etc/xrdp

if [[ ! -z $SYSTEMD  ]]; then
        systemctl enable tomcat
        systemctl enable guacd
fi

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord/conf.d/xrdp.conf

# END