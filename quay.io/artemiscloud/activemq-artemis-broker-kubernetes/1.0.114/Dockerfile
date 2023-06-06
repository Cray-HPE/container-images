FROM quay.io/artemiscloud/activemq-artemis-broker-kubernetes:1.0.14

USER root

RUN microdnf -y update && microdnf clean all

# This adds a check to the readinessProbe to see if the broker is marked as
# backup. This allows the backup broker to show as 2/2 Ready in kubernetes.
COPY readinessProbe.sh /opt/amq/bin/readinessProbe.sh
RUN chmod 755 /opt/amq/bin/readinessProbe.sh

USER 185
