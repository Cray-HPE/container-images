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
    [-g|--generate <string>]              What should be generate. Valid options are "both", "dockerfile" or "workflow"

    Examples

    ./.github/scripts/create_buildfiles.sh -o unguiculus -i docker-python3-phantomjs-selenium -t v1

EOF
}

REGISTRY="docker.io"
ORG=""

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
    -g|--generate)
      GENERATE="$2"
      ;;
  esac
  shift
done

if [[ -z "$IMAGE" ]]; then
  echo "Error!! Missing Image"
  usage
  exit 1
fi

if [[ -z "$TAG" ]]; then
  echo "Error!! Missing Tag"
  usage
  exit 1
fi

if [[ ! -z "$ORG" ]]; then
  IMAGE="${ORG}/${IMAGE}"
fi

if [[ -z "$GENERATE" ]]; then
  GENERATE="both"
fi

CONTEXT_PATH="${REGISTRY}/${IMAGE}/${TAG}"
UPSTREAM_IMAGE="${REGISTRY}/${IMAGE}:${TAG}"

echo "Using upstream image ${UPSTREAM_IMAGE}"
if [ "$GENERATE" == "dockerfile" ] || [ "$GENERATE" == "both" ]; then
  echo "Running container locally to determine package manager"

  for PKG_MGM in foobar apk apt yum microdnf; do
    set +e
    docker run -ti --entrypoint ${PKG_MGM} ${UPSTREAM_IMAGE} >/dev/null 2>&1
    EXIT_CODE=$?

    if [[ "$EXIT_CODE" == 125 ]]; then
      echo "Error!! Could not pull image ${UPSTREAM_IMAGE}"
      exit 1
    fi

    if [[ "$EXIT_CODE" != 127 ]]; then
      PACKAGE_MANAGER=${PKG_MGM}
      echo "Using package manager ${PACKAGE_MANAGER}"
      break
    fi
    set -e
  done

  if [[ -z "$PACKAGE_MANAGER" ]]; then
    echo ""
    echo "Warning!! Could not determine pacakge manager for ${UPSTREAM_IMAGE}"
    echo "Update the Dockerfile manually to address updates"
    echo ""
    TEMPLATE="Dockerfile"
  else
    TEMPLATE="Dockerfile.${PACKAGE_MANAGER}"
  fi

  echo "Creating folder ${CONTEXT_PATH}"
  mkdir -p ${CONTEXT_PATH}

  echo "Creating ${CONTEXT_PATH}/Dockerfile for ${PACKAGE_MANAGER} package manager"

  cp .github/scripts/template/${TEMPLATE} ${CONTEXT_PATH}/Dockerfile
  $SED_BIN -i "s|<<UPSTREAM_IMAGE>>|${UPSTREAM_IMAGE}|g" ${CONTEXT_PATH}/Dockerfile
fi
if [ "$GENERATE" == "workflow" ] || [ "$GENERATE" == "both" ]; then
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
fi

