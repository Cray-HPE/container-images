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
function usage() {
    echo "* Disable scheduled workflows, which produce images not mentioned neither in CSM releases nor in FROM statements in Dockerfiles"
    echo "* Enable scheduled workflows, which produce images mentioned either in CSM releases or in FROM statements in Dockerfiles"
    echo "Usage: $0 [--dry-run] [--enable] [--disable]"
    exit 1
}

function acurl {
    curl -Ss -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" $@
}

dry_run=0
enable=0
disable=0

if [ $# -eq 0 ]; then
    usage
fi
for param in "$@"; do
    case "${param}" in
        --dry-run)
            dry_run=1
            ;;
        --enable)
            enable=1
            ;;
        --disable)
            disable=1
            ;;
        *)
            usage
            ;;
    esac
done


images=""

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

gh workflow list --limit 1000  --all | grep '/' | sort -u | while read -r workflow status id; do
    echo -ne "-> Inspecting $workflow ... "
    used=$(echo "${images}" | grep -F -x "$workflow" || true)
    if [ -n "${used}" ] && [ "$status" == "active" ]; then
        echo "active, used - no change"
    elif [ -z "${used}" ] && [ "$status" == "disabled_manually" ]; then
        echo "inactive, unused - no change"
    elif [ "$status" == "active" ]; then
        echo "active, unused - disabling"
        if [ $dry_run -eq 0 ] && [ $disable -eq 1 ]; then
            gh workflow disable "${workflow}"
        fi
    elif [ "$status" == "disabled_manually" ]; then
        echo "inactive, used - enabling"
        if [ $dry_run -eq 0 ] && [ $enable -eq 1 ]; then
            gh workflow enable "${workflow}"
        fi
    else
        echo "unrecognized status $status"
    fi
done
