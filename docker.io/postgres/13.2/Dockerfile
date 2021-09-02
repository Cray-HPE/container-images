FROM docker.io/postgres:13.2

RUN apt-get -y update\
    && apt-mark hold libpq5 postgresql-common postgresql-client-common postgresql-13\
    && apt-get upgrade -y\
    && apt full-upgrade -y\
    && rm -rf /var/lib/apt/lists/
