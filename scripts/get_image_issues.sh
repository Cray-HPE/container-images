#!/bin/bash

WORKFLOWURL="https://github.com/Cray-HPE/container-images/actions/workflows"

echo ""
echo "| Docker Repo | Version | Issues | Github Action Workflow | "
echo "|--------|:--------|--------|--------:|"

for IMAGE in `ls -1 ../.github/workflows/*.yaml |  grep -Eo "s/([a-z]|-|_).+\." | sed -e s,.$,, -e s,s/,,`
do
    RUNID=`gh run list -w=${IMAGE} -L 1 | grep -Eo "\s[0-9]+\s"`
    RUNLOG=`gh run view ${RUNID} --log-failed | sed -n -e 's/^.*issues, found //p'`
    DOCKER_REPO=`grep "DOCKER_REPO: artifactory" ../.github/workflows/$IMAGE.yaml | cut -d : -f 2 | head -1`
    DOCKER_VERSION=`egrep " DOCKER_TAG: " ../.github/workflows/$IMAGE.yaml | cut -d : -f 2 | head -1`

    if [ -z "$RUNLOG" ]; then
        echo "| ${DOCKER_REPO} | $DOCKER_VERSION | 0 issues. | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    else
        echo "| ${DOCKER_REPO} | $DOCKER_VERSION | ${RUNLOG} | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    fi
done

echo 
echo "Last update on `date`"
echo
