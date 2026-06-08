FROM alpine:3.22

RUN addgroup -S redis && \
	adduser  -s /bin/false -S redis -G redis -h /home/redis

RUN apk add --no-cache redis

RUN mkdir -p /etc/redis/ /var/log/redis
COPY conf/redis.conf /etc/redis/redis.conf
RUN chown -R redis:redis /etc/redis/ /var/log/redis

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

USER redis

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["redis-server", "--bind", "0.0.0.0"]
