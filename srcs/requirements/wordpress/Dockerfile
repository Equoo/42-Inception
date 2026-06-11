FROM alpine:3.23

RUN addgroup -S wordpress && \
	adduser -S wordpress -G wordpress -h /var/www/wordpress/

RUN apk add --no-cache curl php84 fcgi php84-redis php84-cgi php84-fpm php84-mysqli php84-pdo php84-gd php84-cli php84-mbstring

RUN mkdir -p /var/www/
RUN chown -R wordpress:wordpress /var/www/ /var/log/php84/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

USER wordpress
COPY conf/www.conf /etc/php84/php-fpm.d/www.conf

WORKDIR /var/www/
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["php-fpm84", "-F"]
