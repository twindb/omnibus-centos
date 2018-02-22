FROM centos:centos7
MAINTAINER Ovais Tariq @ovaistariq

RUN yum -y install epel-release
RUN yum groupinstall -y 'Development Tools'

RUN yum install -y \
    git \
    which \
    openssl-devel \
    expat-devel \
    perl-ExtUtils-MakeMaker \
    perl-devel \
    zlib-devel \
    fakeroot \
    gcc \
    gcc-c++ \
    cmake \
    libaio \
    libaio-devel \
    automake \
    autoconf \
    libtool \
    bison \
    ncurses-devel \
    libgcrypt-devel \
    libev-devel \
    libcurl-devel \
    vim-common
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable

RUN bash -lc "rvm requirements; \
        rvm install 2.2.2 ; \
        gem install bundler --no-ri --no-rdoc;\
        "

RUN rm -rf /usr/local/rvm/src/ruby-2.2.2

RUN git clone https://github.com/twindb/backup.git /tmp/backup
RUN cd /tmp/backup/omnibus; \
    /usr/local/rvm/gems/ruby-2.2.2/bin/bundle update; \
    /usr/local/rvm/gems/ruby-2.2.2/bin/bundle bundle install --binstubs

CMD /bin/bash -l
