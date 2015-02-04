#!/bin/bash
set -eu

MYSQLD_RAM_SIZE=${MYSQLD_RAM_SIZE:-"256"}
MYSQLD_ARGS=${MYSQLD_ARGS:-"--skip-name-resolve --skip-host-cache"}
MYSQL_SQL_TO_RUN=${MYSQL_SQL_TO_RUN:-"GRANT ALL ON \`%_test\`.* TO testrunner@'%' IDENTIFIED BY 'testrunner';"}

/etc/init.d/mysql stop

chown gitlab_ci_runner:gitlab_ci_runner /home/gitlab_ci_runner/.* -R

echo "Mounting MySQL with ${MYSQLD_RAM_SIZE}MB of RAM."
if [[ ! -d /var/lib/mysql_template ]]; then
	mv /var/lib/mysql /var/lib/mysql_template
	mkdir /var/lib/mysql
fi
mount -t tmpfs -o size="${MYSQLD_RAM_SIZE}m" tmpfs /var/lib/mysql
cp -a /var/lib/mysql_template/* /var/lib/mysql/

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
    return 1
fi

cat << EOF > $tfile
FLUSH PRIVILEGES;
$MYSQL_SQL_TO_RUN
EOF

/usr/sbin/mysqld --bootstrap --verbose=0 $MYSQLD_ARGS < $tfile
rm -f $tfile

ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini
/etc/init.d/memcached start

exec /usr/sbin/mysqld $MYSQLD_ARGS &


sleep 5
/app/init app:start
