FROM k8s.gcr.io/kube-proxy:v1.19.9 as source

FROM gcr.io/distroless/static
COPY --from=source /usr/local/bin/kube-proxy /usr/local/bin/kube-proxy

USER 65534:65534

CMD ["/usr/local/bin/kube-proxy"]
