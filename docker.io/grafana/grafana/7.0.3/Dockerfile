FROM docker.io/grafana/grafana:7.0.3

USER root

RUN apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER grafana
