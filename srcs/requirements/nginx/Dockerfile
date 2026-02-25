FROM alpine:3.23.3

RUN addgroup -S nginx && \
	adduser -S nginx -G nginx -h /var/lib/nginx

RUN apk update && \
	apk add --no-cache nginx

RUN chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

VOLUME /var/lib/nginx/html
# VOLUME /var/log/nginx

COPY tools/docker-entrypoint.sh /usr/local/bin/
COPY tools/healthcheck.sh /usr/local/bin/
COPY conf/* /etc/nginx/
RUN chown -R nginx:nginx /etc/nginx

USER nginx

EXPOSE 443
EXPOSE 80

# ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
