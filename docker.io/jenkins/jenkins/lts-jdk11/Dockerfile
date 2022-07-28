#
# MIT License
#
# (C) Copyright [2022] Hewlett Packard Enterprise Development LP
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
FROM docker.io/jenkins/jenkins:lts-jdk11
USER root
# Need Python 3 and gsutil for controller backups
RUN apt-get -y update \
    && apt-get upgrade -y && apt full-upgrade \
    && apt-get -y install python3 \
    && rm -rf /var/lib/apt/lists/
RUN curl -LSsf -O https://storage.googleapis.com/pub/gsutil.tar.gz \
    && tar xfz gsutil.tar.gz -C /usr/lib \
    && rm gsutil.tar.gz \
    && ln -s /usr/lib/gsutil/gsutil /usr/local/bin
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref
RUN jenkins-plugin-cli --verbose --plugin-file /usr/share/jenkins/ref/plugins.txt
WORKDIR /var/jenkins_home
