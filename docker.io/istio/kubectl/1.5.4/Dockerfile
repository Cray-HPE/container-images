FROM docker.io/istio/kubectl:1.5.4 as source

FROM gcr.io/distroless/static
COPY --from=source /usr/bin/kubectl /usr/bin/kubectl
CMD ["/usr/bin/kubectl"]
