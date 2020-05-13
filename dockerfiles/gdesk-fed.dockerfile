FROM fedora:latest

LABEL io.openshift.expose-services="3389:tcp"

ENV container docker

ENV PASSWORD_HASH="user"
ENV USERNAME="user"

USER root

ADD common/config /tmp/config
ADD common/bin /opt/bin
ADD common/scripts/ /tmp/

RUN dnf install findutils -y
RUN find /tmp/ -name '*.sh' -exec chmod a+x {} +

RUN /tmp/00_fedora.sh

# Final Clean
RUN \
dnf autoremove -y; \
dnf clean all; \
rm -rf /var/cache/*; \
rm -rf /tmp/*.sh; \
rm -rf /tmp/config; \
rm -f /var/log/*.log

EXPOSE 3389
VOLUME [ "/dev/shm" ]

# You need this else X wont work
USER root
WORKDIR /home/user

ENTRYPOINT ["sh", "/opt/bin/entrypoint.sh"]
