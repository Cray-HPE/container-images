FROM debian:buster-slim


RUN apt-get -q update && \
    apt-get install -y --no-install-recommends smartmontools nvme-cli jq moreutils git ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /scripts && \
    git clone --depth 1 --branch master --single-branch \
        https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git \
        /scripts && \
    chmod 755 /scripts/*

COPY file/entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

VOLUME ["/var/lib/node_exporter"]

USER 65534:65534

ENTRYPOINT ["/entrypoint.sh"]
