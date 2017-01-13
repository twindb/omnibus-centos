FROM centos:centos7
MAINTAINER Ovais Tariq @ovaistariq

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN rpm -ivh http://download.fedoraproject.org/pub/epel/7/$(arch)/e/epel-release-7-5.noarch.rpm
RUN yum groupinstall -y 'Development Tools'

RUN yum install -y \
    curl \
    gpg \
    which \
    rpm-build \
    xz \
    openssl-devel \
    expat-devel \
    gettext-devel \
    perl-ExtUtils-MakeMaker \
    perl-devel \
    curl-devel \
    zlib-devel \
    tar \
    fakeroot \
    install \
    gcc \
    cmake

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable

RUN /bin/bash -l -c "rvm requirements && rvm install 2.2.2 && gem install bundler --no-ri --no-rdoc" && \
    rm -rf /usr/local/rvm/src/ruby-2.2.2

RUN git config --global user.email "packager@twindb.com" && \
    git config --global user.name "TwinDB Packager (TwinDB packager key)" && \
    git clone https://github.com/twindb/backup.git /twindb-backup

RUN cd /twindb-backup/omnibus && \
    /bin/bash -l -c "bundle install --binstubs"

ENTRYPOINT /bin/bash -l /twindb-backup/omnibus/omnibus_build.sh
