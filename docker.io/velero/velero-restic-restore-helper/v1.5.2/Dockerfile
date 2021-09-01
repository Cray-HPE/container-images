FROM docker.io/velero/velero-restic-restore-helper:v1.5.2
USER root
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/
USER nobody
