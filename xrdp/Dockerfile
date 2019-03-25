FROM centos:7
ENV container docker

ENV IPA_SERVER="" \
    LDAP_BASEDN="" \
    LOCAL_AUTH_USER="" \
    NFS_HOMEDIR_SEVER=""

SHELL ["/bin/bash", "-c"]

ADD ./scripts/ /tmp/
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/systemd.sh

RUN \
yum update -y && \
yum install -y epel-release && \
yum install -y xrdp xorgxrdp autofs nfs-utils wget chromium && \
yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts firefox \
yum autoremove -y; \
yum clean all; \
echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop; \
systemctl enable xrdp.service

COPY config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
COPY config/xrdp/sesman.ini /etc/xrdp/sesman.ini

RUN /tmp/autofs.sh
RUN /tmp/ipa.sh

# Final Clean
RUN \
yum autoremove -y; \
yum clean all; \
rm -rf /var/cache/yum; \
rm -rf /tmp/*.sh

EXPOSE 3389
VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
