FROM docker.io/kiwigrid/k8s-sidecar:0.1.151

USER root

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER nobody
