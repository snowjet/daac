# Install Repos

cp /tmp/config/yum.repos.d/tigervnc.repo /etc/yum.repos.d/tigervnc.repo

yum update -y

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
# yum install -y https://centos7.iuscommunity.org/ius-release.rpm

yum autoremove -y
