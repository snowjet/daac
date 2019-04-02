FROM centos:7
# FROM registry.access.redhat.com/rhel7/rhel 

ENV container docker

ENV IPA_SERVER="" \
    LDAP_BASEDN="" \
    LOCAL_AUTH_USER="" \
    NFS_HOMEDIR_SEVER="" \ 
    OC_DEV_TOOLS="" 


##SHELL ["/bin/bash", "-c"]

ADD ../common/scripts/ /tmp/
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/systemd.sh

RUN \
yum install -y epel-release && \
yum install -y xrdp xorgxrdp autofs nfs-utils wget chromium && \
yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts \
yum autoremove -y; \
yum clean all; \
echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop; \
systemctl enable xrdp.service

COPY ../common/config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
COPY ../common/config/xrdp/sesman.ini /etc/xrdp/sesman.ini

RUN /tmp/install_tools.sh
RUN /tmp/install_oc_dev_tools.sh
RUN /tmp/autofs.sh
RUN /tmp/add_local_user.sh

# Final Clean
RUN \
yum autoremove -y; \
yum clean all; \
rm -rf /var/cache/yum; \
rm -rf /tmp/*.sh

EXPOSE 3389
VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
