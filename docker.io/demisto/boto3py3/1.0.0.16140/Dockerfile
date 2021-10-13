FROM docker.io/demisto/boto3py3:1.0.0.16140

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER 65534:65534
