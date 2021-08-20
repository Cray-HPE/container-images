FROM k8s.gcr.io/kube-controller-manager-amd64:v1.18.6
RUN apt-get update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/*