FROM quay.io/kiali/kiali:v1.25.0
USER root
RUN microdnf clean all && \
    microdnf update --nodocs && \
    microdnf clean all
USER kiali
