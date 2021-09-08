FROM docker.io/velero/velero-restic-restore-helper:v1.5.2 as source

FROM gcr.io/distroless/static
COPY --from=source /velero-restic-restore-helper /
CMD ["/velero-restic-restore-helper"]
