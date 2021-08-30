FROM banzaicloud/vault-operator:1.1.0
USER root
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
USER nobody
