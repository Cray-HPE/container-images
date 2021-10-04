#!/bin/bash
# title         :purge_old_jobs.sh
# description   :This script cleans up old workflows on github action
# author        :broadwing
# date          :20210923
# version       :1.0

IFS=$'\n'
IMAGE_AGE_LIMIT=15 # Days
UNIXTIME_NOW=$(date +%s)

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  SED_BIN="gsed"
  DATE_BIN="gdate"
else
  SED_BIN="sed"
  DATE_BIN="date"
fi

calculate () {
    DATE_CREATED=$1
    UNIXTIME_CREATED=$(gdate -d $DATE_CREATED '+%s')
    UNIXTIME_NOW=$(date +%s)
    AGE=$(expr \( $UNIXTIME_NOW - $UNIXTIME_CREATED \) / 60 / 60 / 24 )
    echo "$AGE"
}

for IMAGE in $(grep "^name: " .github/workflows/*.yaml -h | grep '/' | awk {'print $2'} )
    do
        ALGOL60_IMAGE="artifactory.algol60.net/csm-docker/stable/${IMAGE}"
        docker pull $ALGOL60_IMAGE >/dev/null 2>&1
        DATE_IMAGE_CREATED=$(docker inspect ${ALGOL60_IMAGE} | jq -r '.[0].Created')
        AGE=$(calculate $DATE_IMAGE_CREATED)
done
