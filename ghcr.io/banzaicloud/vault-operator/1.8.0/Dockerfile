FROM ghcr.io/banzaicloud/vault-operator:1.8.0 as upstream

FROM artifactory.algol60.net/docker.io/library/alpine

RUN apk update && \
    apk add --upgrade --no-cache \
        apk-tools \
        ca-certificates && \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*

COPY --from=upstream /usr/local/bin/vault-operator /usr/local/bin/vault-operator

USER 65534

ENTRYPOINT ["/usr/local/bin/vault-operator"]
