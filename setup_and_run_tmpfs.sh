#!/bin/bash
set -eu

MYSQL_RAM_SIZE=${MYSQL_RAM_SIZE:-"256"}
MYSQLD_ARGS=${MYSQLD_ARGS:-"--skip-name-resolve --skip-host-cache"}

echo "Mounting MySQL with ${MYSQL_RAM_SIZE}MB of RAM."
mv /var/lib/mysql /var/lib/mysql_old
mkdir /var/lib/mysql
mount -t tmpfs -o size="${MYSQL_RAM_SIZE}m" tmpfs /var/lib/mysql
cp -a /var/lib/mysql_old/* /var/lib/mysql/
rm -rf /var/lib/mysql_old

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
    return 1
fi

cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT USAGE ON *.* TO 'testrunner'@'%' IDENTIFIED BY 'testrunner';
GRANT ALL PRIVILEGES ON \`%_test\`.* TO 'testrunner'@'%';
EOF

/usr/sbin/mysqld --bootstrap --verbose=0 $MYSQLD_ARGS < $tfile
rm -f $tfile

exec /usr/sbin/mysqld $MYSQLD_ARGS
