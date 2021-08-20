#!/bin/bash

IMAGE="$1"
if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image name>"
    exit 1
fi

if [ ! -d "../$IMAGE" ]; then
    echo "INFO: Creating directory and files..."
    mkdir -v ../${IMAGE}
    cp template/Dockerfile ../${IMAGE}
    cp template/imagename.yaml ../.github/workflows/${IMAGE}.yaml
    sed -i s,IMGNAME,${IMAGE},g ../.github/workflows/${IMAGE}.yaml
    echo "INFO: Script finished succesfully."
    echo ""
    echo "Now, go work on your Dockerfile located at ../${IMAGE}/Dockerfile"
else 
    echo "ERROR: Folder image already exists!"
    exit 1
fi

