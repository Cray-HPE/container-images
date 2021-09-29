FROM docker.io/library/alpine@sha256:e841d0f0881ea22080e84088337646ada15871abbc3ce19b3219e8fc2cb0cc22

RUN apk update && \
    apk add --upgrade apk-tools &&  \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*
