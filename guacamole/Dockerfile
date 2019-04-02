FROM centos:7
# FROM registry.access.redhat.com/rhel7/rhel 

ENV container docker

ARG IPA_SERVER="" 
ARG LDAP_BASEDN=""
ARG LOCAL_AUTH_USER=""
ARG LOCAL_AUTH_USER_PWHASH=""
ARG NFS_HOMEDIR_SEVER=""
ARG DESKTOP=""

##SHELL ["/bin/bash", "-c"]

ADD common/scripts/ /tmp/
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/systemd.sh

RUN \
yum install -y epel-release && \
yum install -y xrdp xorgxrdp autofs nfs-utils wget && \
yum autoremove -y; \
yum clean all; \
systemctl enable xrdp.service

COPY common/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
COPY common/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

RUN /tmp/install_tools.sh
RUN /tmp/install_desktop.sh
RUN /tmp/install_guacamole.sh
RUN /tmp/add_local_user.sh
RUN /tmp/autofs.sh
RUN /tmp/ipa.sh

# Final Clean
RUN \
yum autoremove -y; \
yum clean all; \
rm -rf /var/cache/yum; \
rm -rf /tmp/*.sh

EXPOSE 8080
VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
