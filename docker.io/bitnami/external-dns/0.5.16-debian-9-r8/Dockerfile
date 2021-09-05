FROM debian:11-slim

RUN apt-get -y update  && apt-get -y install wget ca-certificates

RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/external-dns-0.5.16-0-linux-amd64-debian-9.tar.gz && \
    echo "31e9a54ae456da21d5eec817c88bec91cfccf868c7ad06015fa44e647e8e3ad3  /tmp/bitnami/pkg/cache/external-dns-0.5.16-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/external-dns-0.5.16-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/external-dns-0.5.16-0-linux-amd64-debian-9.tar.gz

RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/

ENV BITNAMI_APP_NAME=external-dns BITNAMI_IMAGE_VERSION=0.5.16-debian-9-r8 \
    PATH=/opt/bitnami/external-dns/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin     
                                                                                                                          
EXPOSE 7979
WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT ["external-dns"]
