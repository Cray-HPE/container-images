FROM grafana/grafana:6.7.4
USER root
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
USER grafana
