docker-mysql-tmpfs
============

MySQL mounted on a ramdisk using tmpfs. Intended for test environments to speed up tests that access MySQL.

Here's how it works:

    $ docker run --privileged -d -p 3307:3306 -e MYSQL_SQL_TO_RUN='GRANT ALL ON *.* TO "testrunner"@"%";' theasci/docker-mysql-tmpfs
    2caf9f1822037b9fb22bfcd23fabc24545d616fc8af69e97be693986650fce33
    $ mysql --host=127.0.0.1 --port=3307 --user=testrunner 
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 1
    Server version: 5.6.19-log MySQL Community Server (GPL)

    Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>

(Example assumes MySQL client is installed on Docker host.)

Environment variables
---------------------

 - `MYSQL_SQL_TO_RUN`: Chunk of SQL to run when starting. Defaults to ``"GRANT ALL ON \`%_test\`.* TO testrunner@'%' IDENTIFIED BY 'testrunner'";``
 - `MYSQLD_ARGS`: Extra parameters to pass to the mysqld process. Defaults to `"--skip-name-resolve --skip-host-cache"`
 - `MYSQLD_RAM_SIZE`: Amount of memory to allocate to tmpfs datadir. Defaults to `256`
