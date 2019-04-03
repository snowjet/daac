# Install XRDP

yum install -y xrdp xorgxrdp 

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

if [[ ! -z $SYSTEMD  ]]; then
        systemctl enable tomcat
        systemctl enable guacd
fi

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord/conf.d/xrdp.conf

# END