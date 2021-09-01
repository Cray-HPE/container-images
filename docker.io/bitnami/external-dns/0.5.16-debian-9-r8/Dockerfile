FROM docker.io/bitnami/external-dns:0.5.16-debian-9-r8
USER root
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/
USER 1001
