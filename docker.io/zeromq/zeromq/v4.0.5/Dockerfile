FROM docker.io/zeromq/zeromq:v4.0.5

# Ubuntu 14 upgrade
RUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/

# Ubuntu 16 upgrade
RUN  apt-get -y update && apt-get -y install update-manager-core && \
    do-release-upgrade -f DistUpgradeViewNonInteractive && \
    apt-get -y update && apt-get upgrade -y && apt full-upgrade -y && \
    rm -rf /var/lib/apt/lists/

# Ubuntu 18 upgrade
RUN  apt-get -y update && apt-get -y install update-manager-core && \
    do-release-upgrade -f DistUpgradeViewNonInteractive && \
    apt-get -y update && apt-get upgrade -y && apt full-upgrade -y && \
    rm -rf /var/lib/apt/lists/

# Ubuntu 20 upgrade
RUN  apt-get -y update && apt-get -y install update-manager-core && \
    do-release-upgrade -f DistUpgradeViewNonInteractive && \
    apt-get -y update && apt-get upgrade -y && apt full-upgrade -y && \
    rm -rf /var/lib/apt/lists/
