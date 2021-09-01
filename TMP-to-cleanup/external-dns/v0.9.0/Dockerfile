FROM k8s.gcr.io/external-dns/external-dns:v0.9.0
USER root
RUN apk add --upgrade apk-tools && rm -rf /var/cache/apk/*
USER nobody
ENTRYPOINT ["external-dns"]


