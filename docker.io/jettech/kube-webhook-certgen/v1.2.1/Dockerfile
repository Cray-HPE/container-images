FROM jettech/kube-webhook-certgen:v1.2.1 as upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream /kube-webhook-certgen /kube-webhook-certgen
ENTRYPOINT ["/kube-webhook-certgen"]
