ARG ARCH
FROM golang:1.16 as builder
ARG ARCH

WORKDIR /sigs.k8s.io/external-dns

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN make test build.$ARCH

# final image
FROM $ARCH/alpine:3.14

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /sigs.k8s.io/external-dns/build/external-dns /bin/external-dns

# Run as UID for nobody since k8s pod securityContext runAsNonRoot can't resolve the user ID:
# https://github.com/kubernetes/kubernetes/issues/40958
USER 65534

ENTRYPOINT ["/bin/external-dns"]