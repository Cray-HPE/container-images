#!/bin/bash
# title         :purge_old_jobs.sh
# description   :This script cleans up old workflows on github action
# author        :broadwing
# date          :20210923
# version       :1.0

IFS=$'\n'

workflow_verify() {
    IMAGE=$1
    WORKFLOW_ID=$3

    if ! grep --quiet $IMAGE .github/workflows/*
    then
        echo "Purge jobs for workflow id $WORKFLOW_ID ($IMAGE)"
        purge_job $WORKFLOW_ID
    fi
}

purge_job() {
    WORKFLOW_ID=$1
    for JOB_ID in `gh run list -w ${WORKFLOW_ID} -L 100 | grep -Eo '[0-9]{10}'`
    do 
        echo ${JOB_ID} 
        gh api repos/Cray-HPE/container-images/actions/runs/${JOB_ID} -X DELETE >/dev/null
    done 
}

for WORKFLOW_LINE in `gh workflow list -L 500`
do  
    unset IFS
    workflow_verify $WORKFLOW_LINE
done
