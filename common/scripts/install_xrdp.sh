# Install XRDP and tigervnc

yum install -y xrdp xorgxrdp tigervnc-server

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/xrdp-template.ini /etc/xrdp/xrdp-template.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp
chmod -R g+w /etc/xrdp

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord.d/xrdp.conf

# END