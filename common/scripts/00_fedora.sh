# Install Repos

dnf update -y
dnf autoremove -y

# Setup Supervisor and activate dbus

dnf install -q -y supervisor dbus-tools
cp /etc/supervisord.conf /etc/supervisord.conf.bak
cp /tmp/config/supervisord/supervisord.conf /etc/supervisord.conf

mkdir -p /var/run/dbus
chown dbus:root /var/run/dbus
chgrp -R 0 /var/run/dbus
chmod -R g=u /var/run/dbus
dbus-uuidgen --ensure

cp /tmp/config/supervisord/conf.d/dbus.conf /etc/supervisord.d/dbus.conf

# Install XRDP and tigervnc

dnf install -q -y xrdp xorgxrdp tigervnc-server

cp /tmp/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
cp /tmp/config/xrdp/xrdp-template.ini /etc/xrdp/xrdp-template.ini
cp /tmp/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp
chmod -R g+w /etc/xrdp

cp /tmp/config/supervisord/conf.d/xrdp.conf /etc/supervisord.d/xrdp.conf

# Install Desktop 

dnf install -q -y caja marco mate-desktop mate-menus mate-session-manager \
    mate-system-monitor xdg-user-dirs-gtk yelp gtk2-engines mate-terminal mate-panel \
    mate-polkit mate-settings-daemon numix-gtk-theme numix-icon-theme 

echo "PREFERRED=/usr/bin/mate-session" > /etc/sysconfig/desktop

dnf install -q -y liberation-fonts dejavu-sans-mono-fonts unzip htop wget chromium firefox curl

# Create Placeholder for Local User

mkdir -p /home/user
chown -R root:root /home/user

useradd user -u 10001 -g 0 -d /home/user -G wheel,tty

chmod 400 /etc/shadow
cp /etc/shadow /etc/shadow.template
chmod 000 /etc/shadow /etc/shadow.template

chmod 770 /home/user
chown -R user:0 /home/user
chmod -R g+rw /etc/passwd

sed "s@user:x:10001:@user:x:\${USER_ID}:@g" /etc/passwd > /etc/passwd.template

# The following commands are needed to work in 
# OpenShift without privilged mode
chgrp -R 0 /etc/xrdp
chmod -R g=u /etc/xrdp

chmod 755 /opt/bin/*
chgrp -R 0 /opt/bin
chmod -R g=u /opt/bin

chmod -R g=u /etc/passwd
chmod -R g=u /etc/group
chmod -R g=u /etc/shadow
chmod u+s /usr/bin/chmod

chmod -R g+w /etc/supervisord.d/
chmod -R g+w /var
chmod -R g+w /home

/opt/bin/fix_permissions.sh /var/run
/opt/bin/fix_permissions.sh /var/log
/opt/bin/fix_permissions.sh /home/user

chgrp -R 0 /var/run && chmod -R g=u /var/run 
chgrp -R 0 /var/log && chmod -R g=u /var/log
