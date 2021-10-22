FROM docker.io/istio/kubectl:1.5.4 as source

FROM docker.io/ubuntu:20.04
COPY --from=source /usr/bin/kubectl /usr/bin/kubectl
RUN apt update -y && apt install sudo -y \
    && useradd -m --uid 1337 istio-proxy \
    && echo "istio-proxy ALL=NOPASSWD: ALL" >> /etc/sudoers
USER istio-proxy
CMD ["/usr/bin/kubectl"]
