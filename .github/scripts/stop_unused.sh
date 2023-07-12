#!/bin/bash
#
# MIT License
#
# (C) Copyright 2023 Hewlett Packard Enterprise Development LP
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
if [ $# -ne 1 ] || ( [ "$1" != "--dry-run" ] && [ "$1" != "--update" ] ) ; then
    echo "Disable scheduled workflows, which produce images not mentioned neither in CSM releases nor in FROM statements in Dockerfiles"
    echo "Usage: $0 --dry-run|--update"
    exit 1
fi

function acurl {
    curl -Ss -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" $@
}

images="docker.io/jenkins/jenkins:lts-jdk11"

echo "Retrieving image references from csm releases ..."
csm_folders=$(acurl "https://artifactory.algol60.net/artifactory/api/storage/csm-releases/csm" | jq -r '.children[] | select(.folder==true) | .uri ')
for csm_folder in $csm_folders; do
    image_file=$(acurl "https://artifactory.algol60.net/artifactory/api/search/artifact?name=csm-${csm_folder#/}.*-images.txt&repos=csm-releases" | jq -r '.results[].uri' | sort -u | head -1)
    if [ -n "${image_file}" ]; then
        images=$( (echo "${images}"; acurl "${image_file/\/api\/storage/}" | awk '{ print $1 }') | sort -u)
    fi
done

echo "Retrieving image references from Dockerfiles ..."
for ref in $(gh api --paginate "search/code?q=org:Cray-HPE+path:/+filename:Dockerfile" \
    -t '{{ range .items }}{{ .repository.name }}/contents/{{ .name }}{{ "\n" }}{{ end }}' | sort); do
    for image in $(gh api "repos/Cray-HPE/${ref}" -t "{{ .content }}" | base64 -d | grep -i '^FROM [a-z\.:\$/]*[\.:\$/]' | awk '{ print $2 }'); do
        images="${images}
${image}"
    done
done

images=$(echo "${images}" | sed -e 's|artifactory.algol60.net/csm-docker/stable/||' | sort -u)

for workflow in $(gh workflow list --limit 500 | grep '/' | awk '{ print $1 }' | sort -u); do
    echo -ne "-> Inspecting $workflow ... "
    if echo "${images}" | grep -F -x -q "$workflow"; then
        echo "ok"
    else
        echo "unneeded"
        if [ "$1" != "--dry-run" ]; then
            gh workflow disable "${workflow}"
        fi
    fi
done
