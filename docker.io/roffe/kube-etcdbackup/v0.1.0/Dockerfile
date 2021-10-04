FROM docker.io/roffe/kube-etcdbackup@sha256:0dea4ae3e64d945dc9e7b9e2df524339c8b54499e2e6759fac44514bae423888

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
