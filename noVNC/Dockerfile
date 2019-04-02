FROM centos:7
ENV container docker

ENV IPA_SERVER="" \
    LDAP_BASEDN="" \
    LOCAL_AUTH_USER="johan" \
    LOCAL_AUTH_USER_PWHASH="Passw0rd123" \
    NFS_HOMEDIR_SEVER="" \ 
    OC_DEV_TOOLS="" 

SHELL ["/bin/bash", "-c"]

ADD ../common/scripts/ /tmp/

RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/systemd.sh

RUN \
yum install -y epel-release && \
yum install -y novnc gdm xorg-x11-server-Xvfb x11vnc xorg-x11-drv-fbdev xorg-x11-font-utils xdg-user-dirs xcb-util-wm && \
yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts \
yum autoremove -y; \
yum clean all; \
echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop

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

EXPOSE 8080
VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
