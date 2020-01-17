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