FROM docker.io/library/memcached:1.5.0-alpine
USER root
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
USER memcached
