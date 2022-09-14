#!/usr/bin/env sh
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

_base=$(basename "$0")
_dir=$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P || exit 126)
export _base _dir
set "${SETOPTS:--eu}"

# As we will be updating k8s more often, make it easier to do. Just use env vars
# and bail if missing.
k8sversion="${k8sversion?}"

randint() {
  rinput="$(tr -dc _A-Z-a-z-0-9 < /dev/urandom | head -c1024) $(date +%s)"
  awk "BEGIN{srand(\"${rinput}\"); printf \"%i\n\", (rand()*${1-10})}"
}

for f in k8s.gcr.io/kube-controller-manager k8s.gcr.io/kube-proxy k8s.gcr.io/kube-apiserver k8s.gcr.io/kube-scheduler; do
  prefix="${f}/v${k8sversion}"
  install -dm755 "${prefix}"
  dockerfile="${prefix}/Dockerfile"
  # Useless cat is not a concern for this.
  #shellcheck disable=SC2002
  cat "${_dir}/LICENSE" | sed -e 's/^/# /' -e 's/[[:blank:]]*$//' -e "s/\[.*\]/\[$(date +%Y)\]/" | tee "${dockerfile}"

  printf "\n# DO NOT EDIT DIRECTLY update via k8sversion=%s ./k8s.sh at the root of this repo\n" "${k8sversion?}" | tee -a "${dockerfile}"
  printf "\nFROM %s:v%s\n" "${f}" "${k8sversion?}" | tee -a "${dockerfile}"

  # kube-proxy should get periodic apt updates too, but as of 1.25 it is distroless
  # https://github.com/kubernetes/kubernetes/blob/a304fdd8671873d80ba8a0579298d0b5aaa2d91e/CHANGELOG/CHANGELOG-1.25.md#kube-proxy-images-are-now-based-on-distroless-images
  if [ $(echo "${k8sversion}" | awk -F. '{print $1$2}') -lt 125 ] && echo "${f}" | grep kube-proxy > /dev/null 2>&1; then
    printf "\nRUN apt-get -y update && apt-get upgrade -y && apt full-upgrade -y && rm -rf /var/lib/apt/lists/\n" | tee -a "${dockerfile}"
  fi

  wprefix=".github/workflows"
  install -dm755 "${wprefix}"
  workflow="${wprefix}/$(echo ${f} | tr / .).v${k8sversion}.yaml"
  #shellcheck disable=SC2002
  cat "${_dir}/LICENSE" | sed -e 's/^/# /' -e 's/[[:blank:]]*$//' -e "s/\[.*\]/\[$(date +%Y)\]/" | tee "${workflow}"

  printf "\n# DO NOT EDIT DIRECTLY update via k8sversion=%s ./k8s.sh at the root of this repo\n" "${k8sversion?}" | tee -a "${workflow}"

  colonver="${f}:v${k8sversion}"
  dirver="${f}/v${k8sversion}"

  min=$(randint 60)
  hour=$(randint hour)

  cat << FIN | tee -a "${workflow}"

name: ${colonver}

on:
  push:
    branches:
      - main
    paths:
      - ${workflow}
      - ${dirver}/**
  pull_request:
    branches:
      - main
    paths:
      - ${workflow}
      - ${dirver}/**
  workflow_dispatch:
  schedule:
    - cron: '${min} ${hour} * * *'

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    env:
      CONTEXT_PATH: ${dirver}
      DOCKER_REPO: artifactory.algol60.net/csm-docker/stable/${f}
      DOCKER_TAG: v${k8sversion}
    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: build-sign-scan
        uses: Cray-HPE/github-actions/build-sign-scan@main
        with:
          # Only push on main builds
          docker_push: \${{ github.ref == 'refs/heads/main' }}
          context_path: \${{ env.CONTEXT_PATH }}
          docker_repo: \${{ env.DOCKER_REPO }}
          docker_tag: \${{ env.DOCKER_TAG }}
          artifactory_algol60_token: \${{ secrets.ARTIFACTORY_ALGOL60_TOKEN }}
          cosign_gcp_workload_identity_provider: \${{ secrets.COSIGN_GCP_WORKLOAD_IDENTITY_PROVIDER }}
          cosign_gcp_service_account: \${{ secrets.COSIGN_GCP_SERVICE_ACCOUNT }}
          cosign_key: \${{ secrets.COSIGN_KEY }}
          snyk_token: \${{ secrets.SNYK_TOKEN }}
          github_sha: \$GITHUB_SHA
          fail_on_snyk_errors: true
FIN
done
