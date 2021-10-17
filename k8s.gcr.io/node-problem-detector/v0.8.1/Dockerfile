FROM k8s.gcr.io/node-problem-detector:v0.8.1 as upstream

FROM golang:1.17-buster as builder
RUN git clone https://github.com/kubernetes/node-problem-detector.git /opt/node-problem-detector\
    && cd /opt/node-problem-detector\
    && git checkout v0.8.1\
    && ENABLE_JOURNALD=0 make vet fmt version test build-binaries

FROM gcr.io/distroless/static
COPY --from=builder /opt/node-problem-detector/bin/node-problem-detector /
COPY --from=upstream /home/kubernetes /home/kubernetes
COPY --from=upstream /config /config

USER 65534:65534

ENTRYPOINT ["/node-problem-detector","--system-log-monitors=/config/kernel-monitor.json"]
