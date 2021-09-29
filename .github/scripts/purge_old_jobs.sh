#!/bin/bash
# title         :purge_old_jobs.sh
# description   :This script cleans up old workflows on github action
# author        :broadwing
# date          :20210923
# version       :1.0

IFS=$'\n'
JOB_AGE_LIMIT=15 # Days

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  SED_BIN="gsed"
else
  SED_BIN="sed"
fi

workflow_verify() {
    IMAGE=$1
    WORKFLOW_ID=$3

    if ! grep --quiet $IMAGE .github/workflows/*
    then        
        purge_job $WORKFLOW_ID
    fi
}

purge_job() {
    WORKFLOW_ID=$1
    for JOB_ID in `gh run list -w ${WORKFLOW_ID} -L 100 | grep -Eo '[0-9]{10}'`
    do 
        echo "Job ${JOB_ID} / Workflow $WORKFLOW_ID ($IMAGE)"
        JOB_ELAPSED=`gh run view 1273430453 | grep Triggered | ${SED_BIN} -e s,".*\([0-9]\) days ago","\1",`
        if [[ "${JOB_AGE}" > "${JOB_AGE_LIMIT}" ]]
        then
            echo "Purge jobs for workflow id $WORKFLOW_ID ($IMAGE)"
            gh api repos/Cray-HPE/container-images/actions/runs/${JOB_ID} -X DELETE >/dev/null
        else
            echo "Job ${JOB_ID} under workflow_id $WORKFLOW_ID ($IMAGE) has less than ${JOB_AGE_LIMIT} days"
        fi
    done 
}

for WORKFLOW_LINE in `gh workflow list -L 500`
do  
    unset IFS
    workflow_verify $WORKFLOW_LINE
done
