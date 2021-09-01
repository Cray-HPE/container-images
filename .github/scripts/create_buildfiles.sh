#!/bin/bash

set -e

function usage(){
    cat <<EOF
Usage:

    create_buildfiles.sh

    Uses templates to generate files needed for github workflow

    -i|--image <string>  Required: The name of the image
    -t|--tag <string>    Required: The name of the tag

    [-r|--registry <string>]              The registry to use. Defaults to docker.io
    [-o|--org <string>]                   The docker org. If not set assumes official image with no org (eg alpine)
    [-p|--package-manager <apk|apt|yum>]  The package manager to use whene generating a docker template. Defaults to apk

    Examples

    ./.github/scripts/create_buildfiles.sh -o unguiculus -i docker-python3-phantomjs-selenium -t v1 -p apk

EOF
}

REGISTRY="docker.io"
ORG=""
PACKAGE_MANAGER="apk"

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  SED_BIN="gsed"
else
  SED_BIN="sed"
fi

while [[ "$#" -gt 0 ]]
do
  case $1 in
    -h|--help)
      usage
      exit
      ;;
    -i|--image)
      IMAGE="$2"
      ;;
    -t|--tag)
      TAG="$2"
      ;;
    -r|--registry)
      REGISTRY="$2"
      ;;
    -o|--org)
      ORG="$2"
      ;;
    -p|--package-manager)
      PACKAGE_MANAGER="$2"
      ;;
  esac
  shift
done

if [[ -z "$IMAGE" ]]; then
  echo "Missing Image"
  usage
  exit 1
fi

if [[ -z "$TAG" ]]; then
  echo "Missing Tag"
  usage
  exit 1
fi

if [[ ! -z "$ORG" ]]; then
  IMAGE="${ORG}/${IMAGE}"
fi


CONTEXT_PATH="${REGISTRY}/${IMAGE}/${TAG}"
UPSTREAM_IMAGE="${REGISTRY}/${IMAGE}:${TAG}"

echo "Creating ${CONTEXT_PATH}"
mkdir -p ${CONTEXT_PATH}

echo "Creating ${CONTEXT_PATH}/Dockerfile for ${PACKAGE_MANAGER} package manager"
echo "Using upstream image ${UPSTREAM_IMAGE}"

cp .github/scripts/template/Dockerfile.${PACKAGE_MANAGER} ${CONTEXT_PATH}/Dockerfile
$SED_BIN -i "s|<<UPSTREAM_IMAGE>>|${UPSTREAM_IMAGE}|g" ${CONTEXT_PATH}/Dockerfile

WORKFLOW_NAME=${UPSTREAM_IMAGE////.}
WORKFLOW_NAME=${WORKFLOW_NAME//:/.}
WORKFLOW_PATH=".github/workflows/${WORKFLOW_NAME}.yaml"

echo "Creating workflow ${WORKFLOW_PATH}"
cp .github/scripts/template/workflow.yaml ${WORKFLOW_PATH}
$SED_BIN -i "s|<<NAME>>|${UPSTREAM_IMAGE}|g" ${WORKFLOW_PATH}
$SED_BIN -i "s|<<WORKFLOW>>|${WORKFLOW_NAME}|g" ${WORKFLOW_PATH}
$SED_BIN -i "s|<<CONTEXT_PATH>>|${CONTEXT_PATH}|g" ${WORKFLOW_PATH}
$SED_BIN -i "s|<<IMAGE>>|${REGISTRY}/${IMAGE}|g" ${WORKFLOW_PATH}
$SED_BIN -i "s|<<TAG>>|${TAG}|g" ${WORKFLOW_PATH}
