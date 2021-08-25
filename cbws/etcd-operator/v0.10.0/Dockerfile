FROM cbws/etcd-operator:v0.10.0
USER root
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
USER etcd-operator
