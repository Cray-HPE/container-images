FROM docker.io/velero/velero-plugin-for-aws:v1.1.0 as source

FROM gcr.io/distroless/static
COPY --from=source /plugins/velero-plugin-for-aws /plugins/velero-plugin-for-aws
USER nobody
CMD ["/plugins/velero-plugin-for-aws"]
