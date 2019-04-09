# Install XRDP

yum install -y xrdp xorgxrdp 

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

ln -sf /dev/stdout /var/log/xrdp-sesman.log 
ln -sf /dev/stdout /var/log/xrdp.log

chgrp -R 0 /var/log/xrdp-sesman.log
chmod -R g=u /var/log/xrdp-sesman.log

chgrp -R 0 /var/log/xrdp-sesman.log
chmod -R g=u /var/log/xrdp-sesman.log

chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp

# If you need to change the config on the fly
chmod g+w /etc/xrdp

chmod u+s /usr/sbin/xrdp-sesman
chmod u+s /usr/sbin/xrdp

if [[ ! -z $SYSTEMD  ]]; then
        systemctl enable tomcat
        systemctl enable guacd
fi

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord/conf.d/xrdp.conf

# END