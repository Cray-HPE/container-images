#
# MIT License
#
# (C) Copyright 2025 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
FROM ghcr.io/zalando/spilo-15:3.0-p1
ENV DEBIAN_FRONTEND=noninteractive

# pgbouncer auto upgrade can not be run in noninteractive mode
# force upgrade/reinstall
RUN apt-get -o Dpkg::Options::="--force-confnew" install pgbouncer && \
    rm -rf /var/lib/apt/lists/*

# Overwrite the pgq_ticker.ini file in the postgres container due to change in pgqd:3.5-1
# https://github.com/zalando/spilo/issues/838
RUN mkdir /home/postgres/log /home/postgres/pid
RUN chown -R 101:103 /home/postgres/log /home/postgres/pid
COPY ./pgq_ticker.ini /home/postgres/pgq_ticker.ini

# Capture psql version and packages to the build logs
RUN psql --version && dpkg -l

USER 101:103
