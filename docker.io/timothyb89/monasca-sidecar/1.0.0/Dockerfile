FROM timothyb89/monasca-sidecar:1.0.0 as upstream

FROM python:3.9.9-alpine
RUN apk add --upgrade apk-tools &&  \
    apk update && apk -U upgrade && \
    rm -rf /var/cache/apk/*
COPY --from=upstream /monasca_sidecar /monasca_sidecar
COPY --from=upstream /sidecar_requirements.txt /sidecar_requirements.txt
RUN pip install -r /sidecar_requirements.txt
ENV DECAY_SECONDS="60"
EXPOSE 4888
CMD hug -p 4888 -f /monasca_sidecar/sidecar.py
