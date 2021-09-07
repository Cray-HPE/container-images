FROM quay.io/k8scsi/csi-attacher:v2.1.1 as upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream ./csi-attacher* .
ENTRYPOINT ["/csi-attacher"]
