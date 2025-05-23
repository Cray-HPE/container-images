#
# MIT License
#
# (C) Copyright 2025 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

FROM docker.io/sonatype/nexus3:3.70.4

# Install the Keycloak plugin, see https://github.com/flytreeleft/nexus3-keycloak-plugin
ARG KEYCLOAK_PLUGIN_VERSION=0.5.0
COPY ./nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}-bundle.kar /opt/sonatype/nexus/deploy/

USER root

# This Nexus image is based on the RHEL Universal Base Image (UBI).
# Update any base image packagess now so that we keep our Nexus image
# current.
RUN microdnf update -y
RUN microdnf install jq -y

RUN chown nexus:nexus /opt/sonatype/nexus/deploy/nexus3-keycloak-plugin-${KEYCLOAK_PLUGIN_VERSION}-bundle.kar

# The plugin requires an updated JVM cacerts file and credential
# which must be referenced from nexus.vmoptions.  The nexus user
# will need to modify the file so it makes sense that nexus
# should just own the file.
RUN chown nexus:nexus /opt/sonatype/nexus/bin/nexus.vmoptions
RUN microdnf install -y openssl

# Allow nexus to modify the logging properties for debugging purposes.
RUN chown nexus:nexus /opt/sonatype/nexus/etc/logback/logback.xml

COPY create-trust-store.sh /usr/local/bin/

RUN microdnf clean all

USER nexus
