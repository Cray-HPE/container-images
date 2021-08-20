#!/bin/bash

WORKFLOWURL="https://github.com/Cray-HPE/container-images/actions/workflows"

echo ""
echo "| Image Name | Github Action Workflow | Issues Found | "
echo "|--------|:--------|--------:|"

for IMAGE in `ls -1 ../.github/workflows/*.yaml |  grep -Eo "s/([a-z]|-|_).+\." | sed -e s,.$,, -e s,s/,,`
do
    RUNID=`gh run list -w=${IMAGE} -L 1 | grep -Eo "\s[0-9]+\s"`
    RUNLOG=`gh run view ${RUNID} --log-failed | sed -n -e 's/^.*issues, found //p'`

    if [ -z "$RUNLOG" ]; then
        echo "| ${IMAGE} | 0 issues. | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    else
        echo "| ${IMAGE} | ${RUNLOG} | [![${IMAGE}](${WORKFLOWURL}/${IMAGE}.yaml/badge.svg?branch=main)](${WORKFLOWURL}/${IMAGE}.yaml) |"
    fi
done

echo 
echo "Last update on `date`"
echo