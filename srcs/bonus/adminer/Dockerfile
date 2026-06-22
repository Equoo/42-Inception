FROM alpine:3.23

RUN addgroup -S adminer && \
	adduser -S adminer -G adminer -h /var/www/adminer/

RUN apk add --no-cache php84 fcgi php84-fpm php84-mysqli php84-session

RUN mkdir -p /var/www/adminer/

RUN wget -O /var/www/adminer/index.php \
        https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php

RUN chown -R adminer:adminer /var/www/ /var/log/php84/

COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

USER adminer
COPY conf/www.conf /etc/php84/php-fpm.d/www.conf

CMD ["php-fpm84", "-F"]
