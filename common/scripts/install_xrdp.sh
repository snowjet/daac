# Install XRDP

yum install -y xrdp xorgxrdp 

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini
touch /var/log/xrdp-sesman.log
chgrp -R 0 /var/log/xrdp-sesman.log
chmod -R g=u /var/log/xrdp-sesman.log

touch /var/log/xrdp.log
chgrp -R 0 /var/log/xrdp-sesman.log
chmod -R g=u /var/log/xrdp-sesman.log


chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp

if [[ ! -z $SYSTEMD  ]]; then
        systemctl enable tomcat
        systemctl enable guacd
fi

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord/conf.d/xrdp.conf

# END