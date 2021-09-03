FROM quay.io/keycloak/keycloak-gatekeeper:9.0.0

USER root

RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER gatekeeper
