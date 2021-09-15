FROM registry.opensource.zalan.do/acid/spilo-12:1.6-p3
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    # pbbouncer auto upgrade can not be run in noninteractive mode
    # force upgrade/reinstall
    apt-get -o Dpkg::Options::="--force-confnew" install pgbouncer && \ 
    apt-get upgrade -y && rm -rf /var/lib/apt/lists/* && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 && locale -a