FROM docker.io/istio/proxyv2:1.2.4
RUN rm -vf /etc/apt/sources.list.d/*
COPY /files/sources.list /etc/apt/
RUN apt-get update && apt-get -y install apt-transport-https curl
RUN apt -y autoremove && apt -y upgrade