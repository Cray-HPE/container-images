#!/bin/bash

function error() {
	echo "Cannot parse image info"
	exit 1
}

function help() {
	echo "Usage: $0 [image full name]"
	echo "       $0 confluentinc/cp-kafka:6.1.1"
	exit 1
}

INPUT="$1"
[[ -z "$INPUT" ]] && help

function run_with_org() {
    [[ ! -d $IMAGE_ORG/$IMAGE_NAME/$IMAGE_TAG ]] && mkdir -p $IMAGE_ORG/$IMAGE_NAME/$IMAGE_TAG
    echo "FROM $INPUT" > $IMAGE_ORG/$IMAGE_NAME/$IMAGE_TAG/Dockerfile
    docker build $IMAGE_ORG/$IMAGE_NAME/$IMAGE_TAG 2>&1 | tee temp_log
    IMAGE_SHA256="$(awk '/writing image/ { print $4 }' temp_log)"
    docker scan $IMAGE_SHA256
    WORKFLOW_NAME="${IMAGE_ORG}-${IMAGE_NAME}_${IMAGE_TAG}"
    cp .github/workflows/{curlimages-curl_7.73.0,$WORKFLOW_NAME}.yaml
    sed -i.bkp "s/curlimages/${IMAGE_ORG}/g" .github/workflows/$WORKFLOW_NAME.yaml
    sed -i.bkp "s/curl/${IMAGE_NAME}/g" .github/workflows/$WORKFLOW_NAME.yaml
    sed -i.bkp "s/7.73.0/${IMAGE_TAG}/g" .github/workflows/$WORKFLOW_NAME.yaml
    rm -vf .github/workflows/$WORKFLOW_NAME.yaml.bkp
    exit 0
}

function run_without_org() {
    [[ ! -d $IMAGE_NAME/$IMAGE_TAG ]] && mkdir -p $$IMAGE_NAME/$IMAGE_TAG
    echo "FROM $INPUT" > $IMAGE_NAME/$IMAGE_TAG/Dockerfile
    docker build $IMAGE_NAME/$IMAGE_TAG 2>&1 | tee temp_log
    IMAGE_SHA256="$(awk '/writing image/ { print $4 }' temp_log)"
    docker scan $IMAGE_SHA256
    WORKFLOW_NAME="${IMAGE_ORG}-${IMAGE_NAME}_${IMAGE_TAG}"
    cp .github/workflows/{curlimages-curl_7.73.0,$WORKFLOW_NAME}.yaml
    sed -i.bkp "s/curlimages/${IMAGE_ORG}/g" .github/workflows/$WORKFLOW_NAME.yaml
    sed -i.bkp "s/curl/${IMAGE_NAME}/g" .github/workflows/$WORKFLOW_NAME.yaml
    sed -i.bkp "s/7.73.0/${IMAGE_TAG}/g" .github/workflows/$WORKFLOW_NAME.yaml
    rm -vf .github/workflows/$WORKFLOW_NAME.yaml.bkp
    exit 0
}

IMAGE_FULL_NAME=$(echo $INPUT | cut -d: -f1)
IMAGE_ORG=$(echo $IMAGE_FULL_NAME | cut -d/ -f1)
IMAGE_NAME=$(echo $IMAGE_FULL_NAME | cut -d/ -f2)
IMAGE_TAG="$(echo $INPUT | cut -d: -f2)"

if [[ "$IMAGE_NAME" == "$IMAGE_ORG" ]]; then
    run_without_org
else
    run_with_org
fi
