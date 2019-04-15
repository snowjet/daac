FROM centos:7
# FROM registry.access.redhat.com/rhel7/rhel 

ENV container docker
ENV GUACAMOLE_HOME="/usr/share/tomcat/.guacamole"

ARG IPA_SERVER="" 
ARG LDAP_BASEDN=""
ARG LOCAL_AUTH_USER=""
ARG LOCAL_AUTH_USER_PWHASH=""
ARG NFS_HOMEDIR_SEVER=""
ARG DESKTOP=""
ARG OC_DEV_TOOLS=""

ENV LOCAL_AUTH_USER="user" \
    LOCAL_AUTH_USER_PWHASH="" \
    guac_username="user" \
    guac_password_hash="" \
    guac_password_encoding=""

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

EXPOSE 8080
VOLUME [ "/dev/shm", "/mnt/workspace" ]
ENTRYPOINT /opt/bin/uid_entrypoint.sh; /opt/bin/guac_setup.py; /usr/bin/supervisord -c /etc/supervisord/supervisord.conf
