
# DaaC

Desktop as a Container

## Prereq

This container requires systemd - so you will need enable the relevant SELinux policy

```bash
setsebool -P container_manage_cgroup 1
```

## Howto Build

```bash
buildah bud -f Dockerfile -t gnome --squash --logfile ./buildlog .
```

## HowTo Run

If you are using the autofs mounts you will need to start the container with SYS_ADMIN capabilities, else just run normally.

* -p exposes the 3389 port on the host and forwards it through to the container
* -dns sets DNS for the container if host is localhost
* -cap-add run this a privileged container

```bash
podman run -p 3389:3389 --dns 8.8.8.8 -d --cap-add SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro  localhost/gnome
```