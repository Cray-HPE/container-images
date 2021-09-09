FROM docker.io/openpolicyagent/opa:0.24.0-envoy-1 as upstream

FROM gcr.io/distroless/base-debian11
COPY --from=upstream /app /app
WORKDIR /app
ENTRYPOINT ["./opa_envoy_linux_amd64"]
CMD ["run"]
