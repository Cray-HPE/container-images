FROM quay.io/coreos/etcd:v3.3.22

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
