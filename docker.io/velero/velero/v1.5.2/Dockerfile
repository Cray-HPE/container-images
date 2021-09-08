FROM docker.io/velero/velero:v1.5.2 as source

# Now copy it into our base image.
FROM gcr.io/distroless/static
COPY --from=source /velero /
USER nobody
CMD ["/velero"]
