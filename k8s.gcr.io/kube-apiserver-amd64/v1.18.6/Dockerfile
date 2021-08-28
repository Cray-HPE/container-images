FROM k8s.gcr.io/kube-apiserver-amd64:v1.18.6
RUN apt-get update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/*