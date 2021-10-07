#!/bin/bash
# title         :rebuild_staled_images.sh
# description   :This script triggers staled images
# author        :broadwing
# date          :20211005
# version       :1.0

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  SED_BIN="gsed"
  DATE_BIN="gdate"
else
  SED_BIN="sed"
  DATE_BIN="date"
fi

IFS=$'\n'
AGE_LIMIT=15 # Days
UNIXTIME_NOW=$(${DATE_BIN} +%s)
DOCKER_REGISTRY="artifactory.algol60.net"

calculate () {
    BUILD_DATE=$1
    UNIXTIME_BUILD_DATE=$(${DATE_BIN} -d $BUILD_DATE '+%s')
    UNIXTIME_NOW=$(${DATE_BIN} +%s)
    AGE=$(expr \( $UNIXTIME_NOW - $UNIXTIME_BUILD_DATE \) / 60 / 60 / 24 )
    echo $AGE
}

for IMAGE in $(grep "^name: " .github/workflows/*.yaml -h | grep '/' | awk {'print $2'} )
    do
        IMAGE_PATH="${DOCKER_REGISTRY}/csm-docker/stable/${IMAGE}"

        echo "-> checking image: ${IMAGE_PATH}"
        $(docker pull ${IMAGE_PATH} >/dev/null 2>&1)

        BUILD_DATE=$(docker inspect --format='{{.Config.Labels.buildDate}}' ${IMAGE_PATH})
        if [[ "$BUILD_DATE" == "<no value>" ]]
          then
            echo "Triggering workflow ${IMAGE} - No such label buildDate"
            gh workflow run $IMAGE
            continue
        fi

        AGE=$(calculate $BUILD_DATE)
        if [[ "$AGE" -gt "${AGE_LIMIT}" ]]
          then
            echo "Triggering workflow ${IMAGE} - Image is $AGE days old"
            gh workflow run $IMAGE
        fi

        if [[ "$IMAGE_PATH" == "artifactory.algol60.net/csm-docker/stable/registry.suse.com/suse/sle15:15.2" ]]
          then
            echo "Triggering workflow ${IMAGE} - manual test"
            gh workflow run $IMAGE
        fi
done
