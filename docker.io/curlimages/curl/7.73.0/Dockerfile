FROM docker.io/curlimages/curl:7.73.0

USER root

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER curl_user
