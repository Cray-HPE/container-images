FROM ubuntu:20.04

CMD ["bash"]
RUN groupadd -r mysql \
    && useradd -r -g mysql mysql
RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg dirmngr \
    && rm -rf /var/lib/apt/lists/*
ENV GOSU_VERSION=1.7
RUN set -x   \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*      \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"   \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"   \
    && export GNUPGHOME="$(mktemp -d)"  \
    && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc      \
    && chmod +x /usr/local/bin/gosu     \
    && gosu nobody true         \
    && apt-get purge -y --auto-remove ca-certificates wget
RUN mkdir /docker-entrypoint-initdb.d
RUN apt-get update \
    && apt-get install -y --no-install-recommends pwgen perl libaio1 libncurses5     \
    && rm -rf /var/lib/apt/lists/*
ENV MYSQL_MAJOR=5.5
ENV MYSQL_VERSION=5.5.61
RUN apt-get update \
    && apt-get install -y ca-certificates wget --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*      \
    && wget "https://cdn.mysql.com/Downloads/MySQL-$MYSQL_MAJOR/mysql-$MYSQL_VERSION-linux-glibc2.12-x86_64.tar.gz" -O mysql.tar.gz     \
    && wget "https://cdn.mysql.com/Downloads/MySQL-$MYSQL_MAJOR/mysql-$MYSQL_VERSION-linux-glibc2.12-x86_64.tar.gz.asc" -O mysql.tar.gz.asc     \
    && apt-get purge -y --auto-remove ca-certificates wget      \
    && export GNUPGHOME="$(mktemp -d)"  \
    && rm -rf "$GNUPGHOME" mysql.tar.gz.asc     \
    && mkdir /usr/local/mysql   \
    && tar -xzf mysql.tar.gz -C /usr/local/mysql --strip-components=1   \
    && rm mysql.tar.gz  \
    && rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench    \
    && rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded      \
    && find /usr/local/mysql -type f -name "*.a" -delete        \
    && apt-get update \
    && apt-get install -y binutils \
    && rm -rf /var/lib/apt/lists/*      \
    && { find /usr/local/mysql -type f -executable -exec strip --strip-all '{}' + || true; }    \
    && apt-get purge -y --auto-remove binutils
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/mysql/bin:/usr/local/mysql/scripts
RUN mkdir -p /etc/mysql/conf.d       \
    && { \
            echo '[mysqld]'; \
            echo 'skip-host-cache'; \
            echo 'skip-name-resolve'; \
            echo 'datadir = /var/lib/mysql'; \
            echo '!includedir /etc/mysql/conf.d/'; \
        } > /etc/mysql/my.cnf
RUN mkdir -p /var/lib/mysql /var/run/mysqld  \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld      \
    && chmod 777 /var/run/mysqld
VOLUME [/var/lib/mysql]
COPY files/docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3306/tcp
CMD ["mysqld"]
