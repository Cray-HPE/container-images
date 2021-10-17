FROM quay.io/k8scsi/csi-attacher:v2.1.1 as upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream ./csi-attacher* .

USER 65534:65534

ENTRYPOINT ["/csi-attacher"]
