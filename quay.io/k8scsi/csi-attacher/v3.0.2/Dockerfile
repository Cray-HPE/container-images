FROM quay.io/k8scsi/csi-attacher:v3.0.2 as upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream ./csi-attacher* .
ENTRYPOINT ["/csi-attacher"]
