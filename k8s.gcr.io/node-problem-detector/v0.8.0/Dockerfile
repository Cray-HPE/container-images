FROM k8s.gcr.io/node-problem-detector:v0.8.0

RUN apt-get -y update && apt-get install --allow-change-held-packages -y apt passwd\
    && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/*
