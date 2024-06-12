#
# MIT License
#
# (C) Copyright [2024] Hewlett Packard Enterprise Development LP
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
FROM quay.io/strimzi/kafka:0.41.0-kafka-3.6.2
USER root
RUN microdnf -y update && microdnf -y install zip && microdnf clean all

# Mitigation for CVE-2021-4104
#RUN zip -q -d /opt/kafka/libs/log4j-1.2.17.jar org/apache/log4j/net/JMSAppender.class

# Mitigation for CVE-2022-23305
#RUN zip -q -d /opt/kafka/libs/log4j-1.2.17.jar org/apache/log4j/jdbc/JDBCAppender.class

# Mitigation for CVE-2022-23307
#RUN zip -q -d /opt/kafka/libs/log4j-1.2.17.jar org/apache/log4j/chainsaw\*

# Mitigation for CVE-2022-23302
#RUN zip -q -d /opt/kafka/libs/log4j-1.2.17.jar org/apache/log4j/net/JMSSink.class

USER 1001
