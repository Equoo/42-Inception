FROM alpine:3.22

RUN addgroup -S proftpd && \
	adduser  -s /bin/sh -S proftpd -G proftpd -h /home/proftpd

RUN apk add --no-cache proftpd openssl

RUN mkdir -p /srv /etc/proftpd/ /var/log/proftpd /tmp/proftpd/ /run/proftpd
COPY conf/proftpd.conf /etc/proftpd/proftpd.conf
COPY conf/ftpd.passwd /etc/proftpd/ftpd.passwd
COPY conf/ftpd.group /etc/proftpd/ftpd.group
RUN chown -R proftpd:proftpd /srv /etc/proftpd/ /var/log/proftpd /tmp/proftpd/ /run/proftpd/ && \
	chmod 600 /etc/proftpd/ftpd.passwd /etc/proftpd/ftpd.group

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

WORKDIR /srv/
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["proftpd", "-n"]
