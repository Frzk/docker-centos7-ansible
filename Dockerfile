# Build CentOS 7 image.

FROM centos:7
LABEL maintainer="François KUBLER"

# Enable systemd -- See https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) \
 && rm -f /lib/systemd/system/multi-user.target.wants/* \
 && rm -f /etc/systemd/system/*.wants/* \
 && rm -f /lib/systemd/system/local-fs.target.wants/* \
 && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
 && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
 && rm -f /lib/systemd/system/basic.target.wants/* \
 && rm -f /lib/systemd/system/anaconda.target.wants/*

# Install EPEL repo and PIP
RUN yum -y install \
    epel-release \
    python-pip \
 && yum -y clean all

RUN pip install --upgrade setuptools \
 && pip install wheel \
 && pip install ansible

RUN mkdir -p /etc/ansible \
 && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ENV ANSIBLE_FORCE_COLOR 1

ENTRYPOINT ["/sbin/init"]
