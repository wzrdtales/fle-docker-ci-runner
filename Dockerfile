FROM sameersbn/gitlab-ci-runner:latest
#MAINTAINER sameer@damagehead.com

RUN sudo echo 'Defaults env_keep += "http_proxy https_proxy ftp_proxy"' >> /etc/sudoers

RUN export http_proxy=http://10.1.0.16:8080 && \
    export https_proxy=http://10.1.0.16:8080 && \
    export ftp_proxy=http://10.1.0.16:8080 && \
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    sudo sh -c "echo 'deb http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted' >> /etc/apt/sources.list" && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    sudo apt-get update && sudo apt-get install software-properties-common -y && \
    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 && \
    sudo add-apt-repository 'deb http://hhvm.bauerj.eu//ubuntu trusty main' && \
    sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
    sudo add-apt-repository 'deb http://ftp.hosteurope.de/mirror/mariadb.org/repo/10.0/ubuntu trusty main' && \
    sudo apt-get update && \
    apt-get install -y build-essential cmake openssh-server \
      ruby2.1-dev zlib1g-dev libyaml-dev libssl-dev \
      libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
      libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
      mariadb-server redis-server memcached php5 php5-memcached php5-mysqlnd php5-curl php5-xcache \
      php5-xdebug php5-sybase php5-mcrypt nodejs fontconfig chromium-browser \
      xvfb firefox google-chrome-stable php5-cli ant libmemcached-dev hhvm curl && \
    gem install --no-document bundler && \
    rm -rf /var/lib/apt/lists/* # 20140918 && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini && \
    curl -L https://npmjs.com/install.sh | sh

ADD assets/ /app/
RUN chmod 755 /app/setup/install

ADD tmpfs.cnf /etc/mysql/conf.d/tmpfs.cnf
RUN chmod 664 /etc/mysql/conf.d/tmpfs.cnf
ADD setup_and_run_tmpfs.sh /usr/local/bin/setup_and_run_tmpfs.sh
RUN chmod +x /usr/local/bin/setup_and_run_tmpfs.sh


RUN export http_proxy=http://10.1.0.16:8080 && \
    export https_proxy=http://10.1.0.16:8080 && \
    export ftp_proxy=http://10.1.0.16:8080 && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    curl -L https://npmjs.com/install.sh | sh && \
    npm install -g bower && \
    npm install -g grunt && \
    npm install -g grunt-cli

CMD ["/usr/local/bin/setup_and_run_tmpfs.sh"]
RUN /app/setup/install
