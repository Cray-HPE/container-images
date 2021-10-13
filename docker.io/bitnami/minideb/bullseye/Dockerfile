FROM docker.io/bitnami/minideb:bullseye

RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/

USER 65534:65534
