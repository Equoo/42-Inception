FROM alpine:3.23

RUN addgroup -S mysql && \
	adduser -S mysql -G mysql -h /var/lib/mysql

RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

RUN mkdir -p /etc/my.cnf.d/ && echo -e "[mysqld]\nbind-address = 0.0.0.0" > /etc/my.cnf.d/mariadb-server.cnf

COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["mariadbd", "--user=mysql"]
