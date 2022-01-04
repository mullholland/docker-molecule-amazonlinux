FROM amazonlinux

LABEL maintainer="mullholland"
LABEL build_update="2022-01-04"

ENV container=docker

RUN yum -y update; yum clean all; \
  yum -y install systemd ; \
  cd /lib/systemd/system/sysinit.target.wants/ ; \
  for i in * ; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i ; done ; \
  rm -f /lib/systemd/system/multi-user.target.wants/* ; \
  rm -f /etc/systemd/system/*.wants/* ; \
  rm -f /lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /lib/systemd/system/basic.target.wants/* ; \
  rm -f /lib/systemd/system/anaconda.target.wants/*

# Install requirements.
RUN yum makecache fast \
 && yum -y update \
 && yum -y install deltarpm initscripts \
 && yum -y install \
      sudo \
      which \
      hostname \
      procps-ng \
      ca-certificates \
 && yum clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers


VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/lib/systemd/systemd"]
