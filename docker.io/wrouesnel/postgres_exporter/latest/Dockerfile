FROM docker.io/wrouesnel/postgres_exporter@sha256:54bd3ba6bc39a9da2bf382667db4dc249c96e4cfc837dafe91d6cc7d362829e0

USER root
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/
USER postgres_exporter
