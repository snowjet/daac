# DaaC
Desktop as a Container

* Guacamole
* XRDP
* noVNC (broken)

## Prerequisites

This container requires systemd - so you will need enable the relevant SELinux policy

```bash
setsebool -P container_manage_cgroup 1
```

## Build Arguments

If you want ldap auth set these build args:
* ARG IPA_SERVER="<server name>"
* ARG LDAP_BASEDN="<ldap base dn>"

If you want a local user set these build args:
* ARG LOCAL_AUTH_USER="<username>"
* ARG LOCAL_AUTH_USER_PWHASH=""

If you want nfs home dirs set set this build args:
* ARG NFS_HOMEDIR_SEVER=""

Set a desktop environment:
* ARG DESKTOP="<gnome3, mate>"

## HowTo Build

```bash
buildah bud -f <xrdp, guacamole>/Dockerfile \
            -t <xrdp, guacamole> \
            --build-arg LOCAL_AUTH_USER_PWHASH=<password hash> --build-arg LOCAL_AUTH_USER=<user> \
            --build-arg DESKTOP=<mate, gnome3> \
            --squash --logfile ./buildlog .
```

## HowTo Run

If you are using the autofs mounts you will need to start the container with SYS_ADMIN capabilities, else just run normally.

* -p exposes the 3389 or 8080 port on the host and forwards it through to the container
* -dns sets DNS for the container if host is localhost
* -cap-add run this a privileged container

```bash
podman run -p 8080:8080 --dns 8.8.8.8 -d --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro  localhost/<xrdp, guacamole>
```

## How to access

### Guacamole

Browse to: http://127.0.0.1:8080/root