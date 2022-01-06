FROM bitnami/external-dns:0.10.2-debian-10-r23

USER root
RUN apt-get update && apt-get upgrade -y && apt full-upgrade -y \
    && rm -rf /var/lib/apt/lists/*
USER 1001
