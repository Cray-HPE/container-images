FROM k8s.gcr.io/node-problem-detector:v0.8.0 as upstream

FROM debian:stable-slim
COPY --from=upstream /node-problem-detector /node-problem-detector
COPY --from=upstream /home/kubernetes /home/kubernetes
COPY --from=upstream /config /config
ENTRYPOINT ["/node-problem-detector" "--system-log-monitors=/config/kernel-monitor.json"]
