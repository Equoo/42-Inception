FROM alpine:3.23.3

RUN addgroup -S mysql && \
	adduser -S mysql -G mysql -h /var/lib/mysql

RUN apk update && \
	apk add --no-cache mariadb mariadb-client

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

VOLUME /var/lib/mysql

COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/

USER mysql
COPY conf/server.cnf /etc/my.cnf.d/mariadb-server.cnf
# ENTRYPOINT [ "docker-entrypoint.sh" ]

EXPOSE 3306
CMD ["mariadbd", "--user=mysql", "--console"]
