#
# MIT License
#
# (C) Copyright [2022] Hewlett Packard Enterprise Development LP
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
FROM docker.io/grafana/grafana:9.3.2

USER root

RUN apk add --upgrade apk-tools && \
    apk add wget zip unzip mysql-client nodejs npm git

RUN mkdir /var/lib/grafana-plugins

#Vonage-status-panel
RUN wget -nv https://grafana.com/api/plugins/vonage-status-panel/versions/latest/download -O /var/lib/grafana-plugins/vonage-status-panel-1.0.11.zip
RUN unzip /var/lib/grafana-plugins/vonage-status-panel-1.0.11.zip -d /var/lib/grafana-plugins/
RUN rm -rf /var/lib/grafana-plugins/vonage-status-panel-1.0.11.zip

#Cluster-view-panel
COPY plugins/hpe-grafana-clusterview-panel.zip /var/lib/grafana-plugins/
RUN unzip /var/lib/grafana-plugins/hpe-grafana-clusterview-panel.zip -d /var/lib/grafana-plugins/
RUN rm -rf /var/lib/grafana-plugins/hpe-grafana-clusterview-panel.zip

RUN apk update && \
    apk -U upgrade && \
    rm -rf /var/cache/apk/*

USER grafana
