FROM docker.io/velero/velero-plugin-for-aws:v1.1.0

USER root
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/
USER nobody
