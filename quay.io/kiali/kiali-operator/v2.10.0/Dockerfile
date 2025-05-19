#
# MIT License
#
# (C) Copyright [2025] Hewlett Packard Enterprise Development LP
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
FROM quay.io/kiali/kiali-operator:v2.10.0 AS base

# Rebuild operator image with newer base image
FROM quay.io/openshift/origin-ansible-operator:4.16

USER root
# See https://github.com/operator-framework/operator-sdk/issues/5745
RUN yum remove -y subscription-manager python3-subscription-manager-rhsm && \
    yum update -y && \
    yum install -y python3-setuptools && \
    yum clean all
USER ${USER_UID}

COPY --from=base ${HOME}/roles/ ${HOME}/roles/
COPY --from=base ${HOME}/playbooks/ ${HOME}/playbooks/
COPY --from=base ${HOME}/watches-k8s.yaml ${HOME}/watches-k8s.yaml

COPY --from=base ${HOME}/requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml --force \
 && chmod -R ug+rwx ${HOME}/.ansible

RUN cp /etc/ansible/ansible.cfg ${HOME}/ansible-profiler.cfg && echo "callbacks_enabled = profile_tasks" >> ${HOME}/ansible-profiler.cfg && echo "callback_whitelist = profile_tasks" >> ${HOME}/ansible-profiler.cfg
