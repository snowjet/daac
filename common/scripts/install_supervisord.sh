# Setup Supervisor

yum install -y supervisor

mkdir -p /etc/supervisord/conf.d

cp /tmp/config/supervisord/supervisord.conf /etc/supervisord/supervisord.conf

# END