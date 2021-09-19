FROM docker.io/monasca/job-cleanup:1.2.1

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
