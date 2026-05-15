FROM alpine:3.23.3

RUN addgroup -S nginx && \
	adduser -S nginx -G nginx -h /var/lib/nginx

RUN apk add --no-cache nginx bash

RUN chown -R nginx:nginx /var/lib/nginx /var/log/nginx /run/nginx

COPY tools/healthcheck.sh /usr/local/bin/
COPY conf/nginx.conf /etc/nginx/
COPY conf/http.d/default.conf /etc/nginx/http.d/

RUN ln -s /run/secrets/nginx_key /etc/nginx/key.pem
RUN ln -s /run/secrets/nginx_cert /etc/nginx/cert.pem

RUN chown -R nginx:nginx /etc/nginx

USER nginx

WORKDIR /var/lib/nginx/html

CMD ["nginx", "-g", "daemon off;"]
