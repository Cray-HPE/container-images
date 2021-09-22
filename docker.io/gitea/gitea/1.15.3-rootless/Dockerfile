# Copied from https://github.com/go-gitea/gitea/blob/v1.15.3/Dockerfile.rootless
# Modifications are marked with # MODIFIED

###################################
#Build stage
FROM golang:1.16-alpine3.13 AS build-env

ARG GOPROXY
ENV GOPROXY ${GOPROXY:-direct}

ARG GITEA_VERSION
ARG TAGS="sqlite sqlite_unlock_notify"
ENV TAGS "bindata timetzdata $TAGS"
ARG CGO_EXTRA_CFLAGS

#Build deps
RUN apk --no-cache add build-base git nodejs npm

#Setup repo
# MODIFIED (add cloning of code)
RUN git clone https://github.com/go-gitea/gitea.git ${GOPATH}/src/code.gitea.io/gitea\
    && cd ${GOPATH}/src/code.gitea.io/gitea\
    && git checkout v1.15.3
# COPY /opt/gitea ${GOPATH}/src/code.gitea.io/gitea
# END MODIFIED
WORKDIR ${GOPATH}/src/code.gitea.io/gitea

#Checkout version if set
RUN if [ -n "${GITEA_VERSION}" ]; then git checkout "${GITEA_VERSION}"; fi \
 && make clean-all build

# Begin env-to-ini build
RUN go build contrib/environment-to-ini/environment-to-ini.go

FROM alpine:3.13
LABEL maintainer="maintainers@gitea.io"

EXPOSE 2222 3000

# MODIFIED (add apk update for vulnerabilities)
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
# END MODIFIED

RUN apk --no-cache add \
    bash \
    ca-certificates \
    gettext \
    git \
    curl \
    gnupg

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /var/lib/gitea/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git

RUN mkdir -p /var/lib/gitea /etc/gitea
RUN chown git:git /var/lib/gitea /etc/gitea

# MODIFIED (Copy files from cloned code in build-env)
COPY --from=build-env /go/src/code.gitea.io/gitea/docker/rootless /
# END MODIFIED
COPY --from=build-env --chown=root:root /go/src/code.gitea.io/gitea/gitea /usr/local/bin/gitea
COPY --from=build-env --chown=root:root /go/src/code.gitea.io/gitea/environment-to-ini /usr/local/bin/environment-to-ini

#git:git
USER 1000:1000
ENV GITEA_WORK_DIR /var/lib/gitea
ENV GITEA_CUSTOM /var/lib/gitea/custom
ENV GITEA_TEMP /tmp/gitea
ENV TMPDIR /tmp/gitea

#TODO add to docs the ability to define the ini to load (usefull to test and revert a config)
ENV GITEA_APP_INI /etc/gitea/app.ini
ENV HOME "/var/lib/gitea/git"
VOLUME ["/var/lib/gitea", "/etc/gitea"]
WORKDIR /var/lib/gitea

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD []