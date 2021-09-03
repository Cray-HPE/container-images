#!/bin/bash

WORKFLOWURL="https://github.com/Cray-HPE/container-images/actions/workflows"

echo ""
echo "| Docker Repo | Version | Issues | Github Action Workflow | "
echo "|--------|:--------|--------|--------:|"

for IMAGE in `grep -h ^name ../workflows/*yaml | awk {'print $2'}`
do
    RUNID=`gh run list -w=${IMAGE} -L 1 | grep -Eo "\s[0-9]+\s"`
    RUNLOG=`gh run view ${RUNID} --log-failed | sed -n -e 's/^.*issues, found //p'`
    FILE=`echo ${IMAGE} | sed -e s,\/,\.,g -e s,:,\.,g`
    DOCKER_REPO=`grep "DOCKER_REPO: artifactory" ../workflows/$FILE.yaml | cut -d : -f 2 | head -1`
    DOCKER_VERSION=`egrep " DOCKER_TAG: " ../workflows/$FILE.yaml | cut -d : -f 2 | head -1`

    if [ -z "$RUNLOG" ]; then
        echo "| ${DOCKER_REPO} | $DOCKER_VERSION | 0 issues. | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    else
        echo "| ${DOCKER_REPO} | $DOCKER_VERSION | ${RUNLOG} | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    fi
done

echo 
echo "Last update on `date`"
echo
