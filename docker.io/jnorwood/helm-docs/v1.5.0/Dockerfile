FROM artifactory.algol60.net/docker.io/library/alpine

ARG version=1.5.0
RUN wget -O- https://github.com/norwoodj/helm-docs/releases/download/v${version}/helm-docs_${version}_Linux_x86_64.tar.gz \
    | tar -C /usr/bin -xvzf - helm-docs \
    && chmod +x /usr/bin/helm-docs

WORKDIR /helm-docs

ENTRYPOINT ["helm-docs"]
