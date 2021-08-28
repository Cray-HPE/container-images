FROM k8s.gcr.io/kube-controller-manager:v1.18.3
RUN apt-get update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/*