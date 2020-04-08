#FROM centos:7
FROM centos:8

LABEL io.openshift.expose-services="4822:http"

ENV GUACD_LOG_LEVEL=info

USER root

ADD common/config /tmp/config

RUN yum update -y && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum --enablerepo=epel-testing install -y guacd libguac{,-client*} liberation-fonts dejavu-sans-mono-font freerdp-plugins && \
    mkdir -p /etc/guacamole && \
    yum autoremove -y; \
    yum clean all; \
    rm -rf /var/cache/yum; \
    rm -rf /tmp/*.sh; \
    rm -rf /tmp/config; \
    rm -f /var/log/*.log

USER 10001
EXPOSE 4822
ENTRYPOINT guacd -b 0.0.0.0 -L $GUACD_LOG_LEVEL -f
