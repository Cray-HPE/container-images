FROM golang:1.17-buster as builder
RUN git clone https://github.com/kubernetes-sigs/external-dns.git\
    && cd external-dns\
    && git checkout v0.5.16\
    && make build

FROM gcr.io/distroless/static
COPY --from=builder /go/external-dns/build/external-dns /
ENTRYPOINT ["/external-dns"]
