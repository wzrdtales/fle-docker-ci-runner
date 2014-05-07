FROM centos
MAINTAINER Mason Malone <masonm@the-jci.org>

RUN yum -y upgrade
RUN yum install -y http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum install -y mysql-community-server

ADD my.cnf /etc/my.cnf
RUN chmod 664 /etc/my.cnf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

EXPOSE 3306
CMD ["/usr/local/bin/run"]
