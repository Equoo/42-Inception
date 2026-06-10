FROM alpine:3.23

RUN addgroup -S grafana && \
	adduser  -s /bin/false -S grafana -G grafana -h /usr/share/grafana

RUN apk add --no-cache grafana

RUN mv /usr/share/grafana /usr/share/grafana-default
COPY conf/custom.ini /usr/share/grafana-default/conf/custom.ini

RUN mkdir -p /usr/share/grafana /etc/grafana/ /var/log/grafana
RUN chown -R grafana:grafana /usr/share/grafana /etc/grafana/ /var/log/grafana

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

USER grafana
WORKDIR /usr/share/grafana

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["grafana-server"]
