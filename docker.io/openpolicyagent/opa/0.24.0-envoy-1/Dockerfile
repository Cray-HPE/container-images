FROM golang:1.17-buster as builder
RUN git clone https://github.com/open-policy-agent/opa-envoy-plugin /opt/opa-envoy-plugin\
    && cd /opt/opa-envoy-plugin\
    && git checkout v0.24.0-envoy-1\
    && CGO_ENABLED=0 make

FROM gcr.io/distroless/static
COPY --from=builder /opt/opa-envoy-plugin/opa_envoy_linux_amd64 /app/opa_envoy_linux_amd64
WORKDIR /app

USER 65534:65534
ENTRYPOINT ["./opa_envoy_linux_amd64"]
CMD ["run"]
