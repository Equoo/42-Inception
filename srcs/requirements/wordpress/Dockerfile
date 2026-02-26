FROM alpine:3.23.3

RUN addgroup -S wordpress && \
	adduser -S wordpress -G wordpress -h /var/www

RUN apk update && \
	apk add --no-cache php84 fcgi php84-cgi php84-fpm php84-mysqli

RUN chown -R wordpress:wordpress /var/www /var/log/php84/

COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/

USER wordpress
COPY conf/www.conf /etc/php84/php-fpm.d/www.conf

WORKDIR /var/www
EXPOSE 9000
ENTRYPOINT [ "docker-entrypoint.sh" ]
# CMD ["php-fpm84", "-F"]
