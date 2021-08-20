#!/bin/bash


#IMAGE="$1"
#if [ -z "$IMAGE" ]; then
#    echo "Usage: $0 <image name>"
#    exit 1
#fi

WORKFLOWURL="https://github.com/Cray-HPE/container-images/actions/workflows"

echo ""
echo "| Image Name | Github Action Workflow | Issues Found | "
echo "|--------|--------:|:--------|"

for IMAGE in `ls -1 ../.github/workflows/*.yaml  | grep -Eo "([a-z]|-|_)+\." | sed s,.$,,`
do
    RUNID=`gh run list -w=${IMAGE} -L 1 | grep -Eo "\s[0-9]+\s"`
    RUNLOG=`gh run view ${RUNID} --log-failed | sed -n -e 's/^.*issues, found //p'`

    if [ -z "$RUNLOG" ]; then
        echo "| ${IMAGE} | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) | 0 issues. |"
    else
        echo "| ${IMAGE} | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) | ${RUNLOG} |"
    fi
done

echo 
echo "Last update at `date`"
echo