FROM alpine:3.23

RUN addgroup -S grafana && \
	adduser  -s /bin/false -S grafana -G grafana -h /usr/share/grafana
WORKDIR /usr/share/grafana

RUN apk add --no-cache grafana envsubst

RUN mv /usr/share/grafana /usr/share/grafana-default
COPY conf/custom.ini /usr/share/grafana-default/conf/custom.ini.template
COPY provisioning/dashboard.yml /usr/share/grafana-default/conf/provisioning/dashboards/dashboard.yml
COPY provisioning/datasource.yml /usr/share/grafana-default/conf/provisioning/datasources/datasource.yml.template
COPY dashboards/* /usr/share/grafana-default/dashboards/

RUN mkdir -p /usr/share/grafana /etc/grafana/ /var/log/grafana /var/lib/grafana/
RUN chown -R grafana:grafana /usr/share/grafana /etc/grafana/ /var/lib/grafana/ /var/log/grafana

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

USER grafana

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD ["grafana-server"]
