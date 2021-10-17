FROM docker.io/weaveworks/weave-npc:2.8.0

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534:65534
