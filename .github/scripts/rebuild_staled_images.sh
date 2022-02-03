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
AGE_LIMIT=7 # Days
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
done
