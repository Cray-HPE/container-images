FROM docker.io/wrouesnel/postgres_exporter@sha256:54bd3ba6bc39a9da2bf382667db4dc249c96e4cfc837dafe91d6cc7d362829e0 as source

FROM gcr.io/distroless/static
COPY --from=source /postgres_exporter /
CMD ["/postgres_exporter"]
