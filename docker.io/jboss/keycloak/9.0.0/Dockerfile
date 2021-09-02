FROM docker.io/jboss/keycloak:9.0.0
USER root
RUN microdnf update\
    && microdnf clean all
USER jboss
