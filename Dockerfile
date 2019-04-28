FROM centos:7
# FROM registry.access.redhat.com/rhel7/rhel 

ENV container docker

ARG IPA_SERVER="" 
ARG LDAP_BASEDN=""
ARG NFS_HOMEDIR_SEVER=""
ARG DESKTOP=""
ARG OC_DEV_TOOLS=""

ENV guac_username="user" \
    guac_password_hash=""

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin

ADD common/scripts/ /tmp/
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/00_install_repos.sh
RUN /tmp/install_supervisord.sh

RUN /tmp/install_tools.sh
RUN /tmp/install_xrdp.sh
RUN /tmp/install_desktop.sh
RUN /tmp/install_guacamole.sh
RUN /tmp/install_oc_dev_tools.sh
RUN /tmp/add_local_user.sh
RUN /tmp/ipa.sh

RUN /tmp/99_OpenShift.sh

RUN mkdir -p /mnt/workspace
RUN chmod 755 /mnt/workspace
RUN chgrp -R 0 /mnt/workspace && chmod -R g=u /mnt/workspace 

# Final Clean
RUN \
yum autoremove -y; \
yum clean all; \
rm -rf /var/cache/yum; \
rm -rf /tmp/*.sh; \
rm -rf /tmp/config; \
rm -f /var/log/*.log

USER 10001

# You need this else X wont work
WORKDIR /home/user

EXPOSE 8080 9001
VOLUME [ "/dev/shm", "/mnt/workspace" ]
ENTRYPOINT /opt/bin/uid_entrypoint.sh; /usr/bin/supervisord -c /etc/supervisord.conf
