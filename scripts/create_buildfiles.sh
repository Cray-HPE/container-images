#!/bin/bash

IMAGE="$1"
TAG="$2"

if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image name>"
    echo "or"
    echo "$0 <image name> tag"
    exit 1
fi

if [ "$TAG" = "tag" ]; then
    IMGTAG=`echo $IMAGE | grep -Eo "_.*" | sed -e s,^_,, -e  s,_,\.,g`
    IMGNAME=`echo $IMAGE | sed s,_.*,,g`
fi

if [ ! -d "../$IMAGE" ]; then
    echo "INFO: Creating directory and files..."
    mkdir -v ../${IMAGE}
    cp template/Dockerfile ../${IMAGE}

    if [ -z "$IMGTAG" ]; then
        cp template/imagename.yaml ../.github/workflows/${IMAGE}.yaml
        sed -i s,IMGNAME,${IMAGE},g ../.github/workflows/${IMAGE}.yaml
    else
        cp template/imagename-tag.yaml ../.github/workflows/${IMAGE}.yaml
        sed -i s,IMAGE,${IMAGE},g ../.github/workflows/${IMAGE}.yaml
        sed -i s,IMGTAG,${IMGTAG},g ../.github/workflows/${IMAGE}.yaml
        sed -i s,IMGNAME,${IMGNAME},g ../.github/workflows/${IMAGE}.yaml
    fi

    echo "INFO: Script finished succesfully."
    echo ""
    echo "Now, go to work on your Dockerfile located at ../${IMAGE}/Dockerfile"
else 
    echo "ERROR: Folder image already exists!"
    exit 1
fi

