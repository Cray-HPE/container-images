FROM jettech/kube-webhook-certgen:v1.2.1 as upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream /kube-webhook-certgen /kube-webhook-certgen

USER 65534:65534

ENTRYPOINT ["/kube-webhook-certgen"]
