#!/bin/sh

echo "/var/lib/mysql/$MYSQL_DB"

if [ -d "/var/lib/mysql/$MYSQL_DB" ]; then
	echo "Setup already done."
else
	mariadbd --user=mysql --console &

	mysql_secure_installation << _EOF_

y
none
none
y
n
y
y
_EOF_

# echo "GRANT ALL ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat /run/secrets/mysql_password)'; FLUSH PRIVILEGES;" | mariadb -uroot

	mariadb stop
fi

mariadbd --user=mysql --console
