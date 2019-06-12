FROM centos:centos6
MAINTAINER Maksym Kryva @mkryva

RUN yum -y install epel-release centos-release-scl
RUN yum groupinstall -y 'Development Tools'

RUN yum install -y \
    which \
    openssl-devel \
    expat-devel \
    perl-ExtUtils-MakeMaker \
    perl-devel \
    curl-devel \
    gettext-devel \
    zlib-devel \
    wget \
    fakeroot \
    gcc \
    python27 \
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
    vim-common \
    devtoolset-7-gcc*

RUN source /opt/rh/python27/enable; pip install awscli

RUN yum remove -y git

RUN \
    cd /usr/src ; \
    wget --quiet https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz ; \
    tar xzf git-2.9.5.tar.gz ; \
    cd git-2.9.5 ; \
    make prefix=/usr/local all ; \
    make prefix=/usr/local install

RUN cat /opt/rh/python27/enable >> /root/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/git/bin' >> /root/.bashrc

COPY gpg/409B6B1796C275462A1703113804BB82D39DC0E3.txt /tmp/409B6B1796C275462A1703113804BB82D39DC0E3.txt
COPY gpg/7D2BAF1CF37B13E2069D6956105BD0E739499BDB.txt /tmp/7D2BAF1CF37B13E2069D6956105BD0E739499BDB.txt
RUN gpg2 --import /tmp/7D2BAF1CF37B13E2069D6956105BD0E739499BDB.txt
RUN gpg2 --import /tmp/409B6B1796C275462A1703113804BB82D39DC0E3.txt

RUN curl -sSL https://get.rvm.io | bash -s stable

RUN bash -lc "rvm requirements; \
        rvm install 2.6.1 ; \
        gem install bundler;\
        "

RUN rm -rf /usr/local/rvm/src/ruby-*

COPY Gemfile.lock Gemfile /tmp/
RUN bash -lc "cd /tmp/; bundle install --binstubs"

ENTRYPOINT ["/usr/bin/scl", "enable", "devtoolset-7", "--"]
CMD ["/usr/bin/scl", "enable", "devtoolset-7", "--", "/usr/bin/bash"]
