#!/bin/sh

echo "Check wordpress installation"

if [ -f ./wp-config.php ]
then
	echo "Wordpress already downloaded"
else
	rm -Rf ./*

	wget https://wordpress.org/wordpress-latest.tar.gz && \
		tar -xzvf wordpress-latest.tar.gz && \
		rm wordpress-latest.tar.gz &> /dev/null

	mv wordpress/* .
	rm -Rf wordpress/

	cp wp-config-sample.php wp-config.php
	sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
	sed -i "s/password_here/$(cat /run/secrets/mysql_password)/g" wp-config.php
	sed -i "s/localhost/$MYSQL_HOST/g" wp-config.php
	sed -i "s/database_name_here/$MYSQL_DB/g" wp-config.php

	echo "Wordpress installed"
fi

php-fpm84 -F
