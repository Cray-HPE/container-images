#!/bin/bash

REPO_DIR="$( cd -- "$(dirname "../../$0")" >/dev/null 2>&1 ; pwd -P )"
STATUS_FILE="$REPO_DIR/status.md"
REGISTRY_DIRECTORIES=('docker.io' 'gcr.io' 'k8s.gcr.io' 'quay.io' 'registry.opensource.zalan.do')

REGISTRY_PREFIX="artifactory.algol60.net/csm-docker/stable"
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
          IMAGES_TO_SCAN+=("$IMAGE")
        else

          # In an org level folder
          for ORG_IMAGE_DIR in $VERSION_OR_ORG_DIR/*; do
            ORG_IMAGE_VERSION="$(basename $ORG_IMAGE_DIR)"

            if [ -f "$ORG_IMAGE_DIR/Dockerfile" ]; then
              IMAGE="$REGISTRY/$ORG_OR_IMAGE_NAME/$VERSION_OR_ORG_NAME:$ORG_IMAGE_VERSION"
              echo "Found $IMAGE"
              IMAGES_TO_SCAN+=("$IMAGE")
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

cat <<EOT > $STATUS_FILE
# Snyk Status
Automatically run by github actions _status_update.yaml worfklow

Last update on `date`

| Docker Repo | Version | OK | Total Issues | Critical | High | Medium | Low | Base Image |
|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|
EOT

for IMAGE in "${IMAGES_TO_SCAN[@]}"; do
  FULL_IMAGE="$REGISTRY_PREFIX/$IMAGE"
  IMAGE_PARTS=(${FULL_IMAGE//:/ })

  echo "Scanning $FULL_IMAGE"
  RESULT=$(snyk --json container test $FULL_IMAGE)
  OK=$(echo $RESULT | jq -r .ok)

  UNIQUE_COUNT=$(echo $RESULT | jq -r .uniqueCount)
  UNIQUE_ISSUES=$(echo $RESULT | jq -r '.vulnerabilities | unique_by(.id)')
  CRITICAL=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="critical")] | length')
  HIGH=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="high")] | length')
  MEDIUM=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="medium")] | length')
  LOW=$(echo $UNIQUE_ISSUES | jq -r '[ .[] | select(.severity=="low")] | length')

  BASE_IMAGE=$(echo $RESULT | jq -r .docker.baseImage)

  SYMBOL=$([[ $OK = "true" ]] && echo ':white_check_mark:' || echo ':x:')
  RESULT_ROW="|${IMAGE_PARTS[0]}|${IMAGE_PARTS[1]}|${SYMBOL}|${UNIQUE_COUNT}|${CRITICAL}|${HIGH}|${MEDIUM}|${LOW}|${BASE_IMAGE}|"
  echo $RESULT_ROW
  echo $RESULT_ROW >> $STATUS_FILE
done
