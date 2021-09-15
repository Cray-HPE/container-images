FROM docker.io/grafana/grafana:7.0.3

USER root

RUN apk update && \
    apk add --upgrade apk-tools &&  \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER grafana
