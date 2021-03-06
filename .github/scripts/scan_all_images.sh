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
REPO_DIR="$( cd -- "$(dirname "../../$0")" >/dev/null 2>&1 ; pwd -P )"
STATUS_FILE="$REPO_DIR/status.md"
STATUS_BRANCH="scan-status"
REGISTRY_DIRECTORIES=('docker.io' 'gcr.io' 'ghcr.io' 'k8s.gcr.io' 'quay.io' 'registry.opensource.zalan.do' 'github.com')
REGISTRY_PREFIX="artifactory.algol60.net/csm-docker/stable"
GITHUB_URL_WORKFLOWS="https://github.com/Cray-HPE/container-images/actions/workflows"
IMAGES_TO_SCAN=()

echo "=========================================="
echo "Searching for image directoriries"
echo "=========================================="
for REGISTRY in "${REGISTRY_DIRECTORIES[@]}"; do
  for ORG_OR_IMAGE_DIR in $REPO_DIR/$REGISTRY/*; do
    if [ -d "$ORG_OR_IMAGE_DIR" ]; then
      ORG_OR_IMAGE_NAME="$(basename $ORG_OR_IMAGE_DIR)"

      # Loop through version or org images
      for VERSION_OR_ORG_DIR in $ORG_OR_IMAGE_DIR/*; do
        VERSION_OR_ORG_NAME="$(basename $VERSION_OR_ORG_DIR)"

        # Is an official image with no org the Dockerfile will exist
        if [ -f "$VERSION_OR_ORG_DIR/Dockerfile" ]; then
          IMAGE="$REGISTRY/$ORG_OR_IMAGE_NAME:$VERSION_OR_ORG_NAME"
          echo "Found $IMAGE"
          IMAGES_TO_SCAN+=("$IMAGE|$VERSION_OR_ORG_DIR")
        else

          # In an org level folder
          for ORG_IMAGE_DIR in $VERSION_OR_ORG_DIR/*; do
            ORG_IMAGE_VERSION="$(basename $ORG_IMAGE_DIR)"

            if [ -f "$ORG_IMAGE_DIR/Dockerfile" ]; then
              IMAGE="$REGISTRY/$ORG_OR_IMAGE_NAME/$VERSION_OR_ORG_NAME:$ORG_IMAGE_VERSION"
              echo "Found $IMAGE"
              IMAGES_TO_SCAN+=("$IMAGE|$ORG_IMAGE_DIR")
            fi
          done

        fi
      done
    fi
  done
done

echo "=========================================="
echo "Scanning images for image directoriries"
echo "=========================================="

RESULT_ROWS=()
for IMAGE_DIR in "${IMAGES_TO_SCAN[@]}"; do
  IMAGE_DIR_PARTS=(${IMAGE_DIR//|/ })
  IMAGE=${IMAGE_DIR_PARTS[0]}
  IMAGE_DIR=${IMAGE_DIR_PARTS[1]}

  FULL_IMAGE="$REGISTRY_PREFIX/$IMAGE"
  IMAGE_PARTS=(${FULL_IMAGE//:/ })

  WORKFLOW_YAML="$(echo ${IMAGE} | tr '[/|:]' '.').yaml"
  WORKFLOW_URL="${GITHUB_URL_WORKFLOWS}/${WORKFLOW_YAML}"
  ## If image was not build on the node status job
  ## is running it may get old metadata
  echo "Ensure local image cache is updated for ${FULL_IMAGE}"
  docker pull ${FULL_IMAGE}

  echo "Scanning $FULL_IMAGE"
  set +e
  RESULT=$(snyk --json container test $FULL_IMAGE)
  RESULT_STATUS=$?
  if jq -e . >/dev/null 2>&1 <<<"$RESULT"; then
      echo "Valid snyk json returned"
      RESULT_JSON=0
  else
      echo "ERROR!!! Failed to parse snyk json"
      RESULT_JSON=1
  fi
  set -e

  if ([ $RESULT_STATUS == 0 ] || [ $RESULT_STATUS == 1 ]) && [ $RESULT_JSON == 0 ]; then
    UNIQUE_COUNT=$(echo $RESULT | jq -r .uniqueCount)
    UNIQUE_ISSUES=$(echo $RESULT | jq -r '.vulnerabilities | unique_by(.id)')
    CRITICAL=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="critical")] | length')
    HIGH=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="high")] | length')
    MEDIUM=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="medium")] | length')
    LOW=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="low")] | length')

    BASE_IMAGE=$(echo $RESULT | jq -r .docker.baseImage)

    SYMBOL=':white_check_mark:'
    if [ "$CRITICAL" != "0" ] || [ "$HIGH" != "0" ]; then
      SYMBOL=':x:'
    fi
  else
    UNIQUE_COUNT=""
    UNIQUE_ISSUES=""
    CRITICAL=""
    HIGH=""
    MEDIUM=""
    LOW=""
    BASE_IMAGE=""
    SYMBOL=""
  fi

  echo "Scanning $IMAGE_DIR"
  TRIVY_OUTPUT=$(TRIVY_NEW_JSON_SCHEMA=true trivy -q config -f json -s 'CRITICAL,HIGH' $IMAGE_DIR)

  TRIVY_MISCONFIGS=$(echo $TRIVY_OUTPUT | jq '.Results[0].Misconfigurations | length')
  if [[ "$TRIVY_MISCONFIGS" == "0" ]]; then
    NON_ROOT_SYMBOL=':white_check_mark:'
  else
    TRIVY_IS_ROOT=$(echo $TRIVY_OUTPUT | jq '.Results[0].Misconfigurations | any(.ID | contains("DS002"))')
    NON_ROOT_SYMBOL=':white_check_mark:'
    if [ "$TRIVY_IS_ROOT" == "true" ]; then
      NON_ROOT_SYMBOL=':x:'
    fi
  fi

  echo "Gathering build info"
  BUILD_DATE=$(docker inspect ${FULL_IMAGE} | jq -r '.[0].Created' | cut -d. -f1)
  BUILD_STATE=$(gh workflow view ${IMAGE} | grep -A 1 'Recent runs' | tail -n 1 | grep success >/dev/null 2>&1 && echo ':white_check_mark:' || echo ':x:')
  RESULT_ROW="|${IMAGE_PARTS[0]}|${IMAGE_PARTS[1]}|[${BUILD_DATE}]($WORKFLOW_URL)|${BUILD_STATE}|${SYMBOL}|${NON_ROOT_SYMBOL}|${UNIQUE_COUNT}|${CRITICAL}|${HIGH}|${MEDIUM}|${LOW}|${BASE_IMAGE}|${TRIVY_MISCONFIGS}|"
  echo $RESULT_ROW
  RESULT_ROWS+=("$RESULT_ROW")

  echo "Cleaning up"
  docker rmi ${FULL_IMAGE}
done
git fetch origin "${STATUS_BRANCH}"
git checkout -B "${STATUS_BRANCH}" -t "origin/${STATUS_BRANCH}"
cat <<EOT > $STATUS_FILE
# Snyk Status
Automatically run by github actions _status_update.yaml worfklow

Last update on `date`

| Docker Repo | Version | Build Date | Last Run | Last Scan | Non ROOT User| Total Issues | Critical | High | Medium | Low | Base Image | Trivy Misconfigurations
|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|
EOT
printf "%s\n" "${RESULT_ROWS[@]}" | sort --key 9 --key 10 --key 11 --key 12 -t '|' -n -r >> $STATUS_FILE
