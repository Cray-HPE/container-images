FROM quay.io/k8scsi/csi-attacher:v2.1.1 AS upstream

FROM gcr.io/distroless/static:latest
COPY --from=upstream /csi-attacher /csi-attacher
ENTRYPOINT ["/csi-attacher"]


