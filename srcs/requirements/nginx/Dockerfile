FROM alpine:3.23

RUN addgroup -S nginx && \
	adduser -S nginx -G nginx -h /var/lib/nginx

RUN apk add --no-cache nginx

RUN chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

COPY conf/nginx.conf /etc/nginx/
COPY conf/http.d/default.conf /etc/nginx/http.d/

RUN mkdir -p /var/www/static
COPY static/index.html /var/www/static/index.html

RUN ln -s /run/secrets/nginx_key /etc/nginx/key.pem
RUN ln -s /run/secrets/nginx_cert /etc/nginx/cert.pem

RUN chown -R nginx:nginx /etc/nginx

USER nginx
WORKDIR /var/www/

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]
