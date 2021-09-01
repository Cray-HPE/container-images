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

    Examples

    ./.github/scripts/create_buildfiles.sh -o unguiculus -i docker-python3-phantomjs-selenium -t v1

EOF
}

REGISTRY="docker.io"
ORG=""

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

echo "Figure out package manager"
for PKG_MGM in apk apt yum; do
  set +e
  docker run -ti --entrypoint ${PKG_MGM} ${UPSTREAM_IMAGE} >/dev/null 2>&1
  if [[ "$?" != 127 ]]; then
    PACKAGE_MANAGER=${PKG_MGM}
  fi
  set -e
done

echo "Creating ${CONTEXT_PATH}"
mkdir -p ${CONTEXT_PATH}

echo "Creating ${CONTEXT_PATH}/Dockerfile for ${PACKAGE_MANAGER} package manager"
echo "Using upstream image ${UPSTREAM_IMAGE}"

cp .github/scripts/template/Dockerfile.${PACKAGE_MANAGER} ${CONTEXT_PATH}/Dockerfile
sed -i "s|<<UPSTREAM_IMAGE>>|${UPSTREAM_IMAGE}|g" ${CONTEXT_PATH}/Dockerfile

WORKFLOW_NAME=${UPSTREAM_IMAGE////.}
WORKFLOW_NAME=${WORKFLOW_NAME//:/.}
WORKFLOW_PATH=".github/workflows/${WORKFLOW_NAME}.yaml"

echo "Creating workflow ${WORKFLOW_PATH}"
cp .github/scripts/template/workflow.yaml ${WORKFLOW_PATH}
sed -i "s|<<NAME>>|${UPSTREAM_IMAGE}|g" ${WORKFLOW_PATH}
sed -i "s|<<WORKFLOW>>|${WORKFLOW_NAME}|g" ${WORKFLOW_PATH}
sed -i "s|<<CONTEXT_PATH>>|${CONTEXT_PATH}|g" ${WORKFLOW_PATH}
sed -i "s|<<IMAGE>>|${REGISTRY}/${IMAGE}|g" ${WORKFLOW_PATH}
sed -i "s|<<TAG>>|${TAG}|g" ${WORKFLOW_PATH}
