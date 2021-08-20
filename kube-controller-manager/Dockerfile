#FROM k8s.gcr.io/kube-controller-manager-amd64:v1.18.6
FROM gcr.io/google-containers/kube-controller-manager-amd64:v1.18.6-rc.0
RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

