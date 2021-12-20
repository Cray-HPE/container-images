FROM quay.io/strimzi/operator:0.15.0
USER root
RUN yum -y update && yum -y install zip && yum clean all
# Fix: CVE-2021-45105 Remove JdniLookup class from log4j
RUN zip -q -d /opt/strimzi/lib/*log4j-core-*.jar org/apache/logging/log4j/core/lookup/JndiLookup.class
USER 1001
