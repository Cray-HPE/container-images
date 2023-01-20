#!/bin/bash
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
set -e

export CI=true
export JFROG_CLI_LOG_LEVEL=ERROR

skopeo="docker run --rm quay.io/skopeo/stable:latest"
for image in $(grep --color=never "^name: " .github/workflows/*.yaml -h | grep --color=never '/' | awk '{ print $2 }' | awk -F: '{ print $1 }' | sort -u); do
    echo "-> Inspecting $image ..."
    tags=$(jfrog rt curl -Ss api/docker/csm-docker/v2/stable/${image}/tags/list | jq -r '.tags[]')
    declare -a sig_tags=()
    declare -a nonsig_tags=()
    declare -a sig_tags_valid=()
    for tag in ${tags}; do
        if [[ ${tag} =~ sha256-[a-f0-9]{64}\.sig ]]; then
            sig_tags+=(${tag})
        else
            nonsig_tags+=(${tag})
        fi
    done
    for tag in ${nonsig_tags[@]}; do
        digest=$(${skopeo} inspect --creds "${ARTIFACTORY_USERNAME}:${ARTIFACTORY_TOKEN}" docker://artifactory.algol60.net/csm-docker/stable/${image}:${tag} --format '{{ .Digest }}')
        echo "    Tag ${tag} has digest ${digest}"
        sig_tags_valid+=(${digest//:/-}.sig)
    done
    for tag in ${sig_tags[@]}; do
        if [[ " ${sig_tags_valid[*]} " =~ " ${tag} " ]]; then
            echo "    Preserving ${tag}"
        elif [ "${DRY_RUN}" == "true" ]; then
            echo "    Not deleting ${tag} in DRY_RUN mode"
        else
            echo "    Deleting ${tag}"
            jfrog rt delete "csm-docker/stable/${image}/${tag}" > /dev/null
        fi
    done
done
