FROM docker.io/grafana/grafana:7.0.5

USER root

RUN apk add --upgrade apk-tools && \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER grafana
