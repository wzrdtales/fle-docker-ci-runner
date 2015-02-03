FROM sameersbn/gitlab-ci-runner:latest
MAINTAINER sameer@damagehead.com

RUN sudo apt-get install software-properties-common
RUN sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN sudo add-apt-repository 'deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.0/ubuntu trusty main'

RUN apt-get update && \
    apt-get install -y build-essential cmake openssh-server \
      ruby2.1-dev libmysqlclient-dev zlib1g-dev libyaml-dev libssl-dev \
      libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
      libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
      mariadb-server redis-server memcached php5 php5-mysqlnd php5-xcache \
      php5-xdebug php5-sybase php5-mcrypt nodejs fontconfig && \
    gem install --no-document bundler && \
    rm -rf /var/lib/apt/lists/* # 20140918

RUN ln -s /usr/bin/nodejs /usr/bin/node && \
    curl -L https://npmjs.com/install.sh | sh

ADD assets/ /app/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD tmpfs.cnf /etc/mysql/conf.d/tmpfs.cnf
RUN chmod 664 /etc/mysql/conf.d/tmpfs.cnf
ADD setup_and_run_tmpfs.sh /usr/local/bin/setup_and_run_tmpfs.sh
RUN chmod +x /usr/local/bin/setup_and_run_tmpfs.sh

EXPOSE 3306
CMD ["/usr/local/bin/setup_and_run_tmpfs.sh"]

