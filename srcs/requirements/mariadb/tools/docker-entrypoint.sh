#!/bin/sh
set -e

if [ ! -d "/var/lib/mysql/$MYSQL_DB" ]; then
    echo "First run — initializing..."

    mariadbd --user=mysql --skip-networking &
    until mariadbd-admin ping --socket=/run/mysqld/mysqld.sock --silent 2>/dev/null; do
        sleep 1
    done

	echo "Step twp"

    mariadb --socket=/run/mysqld/mysqld.sock -uroot << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mariadbd-admin --socket=/run/mysqld/mysqld.sock -uroot shutdown
    wait
    echo "Init done."
else
    echo "Already initialized."
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0 --port=3306
