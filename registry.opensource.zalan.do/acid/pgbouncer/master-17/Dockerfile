FROM registry.opensource.zalan.do/acid/pgbouncer:master-17

USER root

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER pgbouncer
