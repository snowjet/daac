FROM centos:7
# FROM fedora:latest
# FROM registry.access.redhat.com/ubi7/ubi

LABEL io.openshift.expose-services="3389:tcp"

ENV container docker

ARG DESKTOP=""
ARG OC_DEV_TOOLS=""

ENV XRDP_PASSWORD="user"

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin
ADD common/scripts/ /tmp/

RUN yum install findutils -y
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/00_install_repos.sh
RUN /tmp/install_supervisord.sh

RUN /tmp/install_xrdp.sh
RUN /tmp/install_desktop.sh
RUN /tmp/add_local_user.sh

RUN /tmp/99_OpenShift.sh

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

EXPOSE 3389
VOLUME [ "/dev/shm" ]
ENTRYPOINT /opt/bin/uid_entrypoint.sh xrdp; /usr/bin/supervisord -c /etc/supervisord.conf
