#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o pipefail
set -o nounset

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libetcd.sh


# Load etcd environment settings
. /opt/bitnami/scripts/etcd-env.sh

#
# Can remove this when chart allows passing in ETCD_SNAPSHOTS_DIR
# to the CronJob env.
#
if [ -z ${ETCD_SNAPSHOTS_DIR-} ]; then
  ETCD_SNAPSHOTS_DIR="/snapshots/${MY_STS_NAME}"
else
  if [[ ! $(echo $ETCD_SNAPSHOTS_DIR | grep -q $MY_STS_NAME) ]]; then
    ETCD_SNAPSHOTS_DIR="/snapshots/${MY_STS_NAME}"
  fi
fi

endpoints="$(etcdctl_get_endpoints)"
read -r -a endpoints_array <<< "$(tr ',;' ' ' <<< "$endpoints")"
for e in "${endpoints_array[@]}"; do
    debug "Using endpoint $e"
    read -r -a extra_flags <<< "$(etcdctl_auth_flags)"
    extra_flags+=("--endpoints=$e")
    if etcdctl endpoint health "${extra_flags[@]}"; then
        info "Snapshotting the keyspace"
        current_time="$(date -u "+%Y-%m-%d_%H-%M")"
        etcdctl snapshot save "${ETCD_SNAPSHOTS_DIR}/db-${current_time}" "${extra_flags[@]}"
        find "${ETCD_SNAPSHOTS_DIR}/" -maxdepth 1 -type f -name 'db-*' \! -name "db-${current_time}" \
            | sort -r \
            | tail -n+$((1 + ${ETCD_SNAPSHOT_HISTORY_LIMIT})) \
            | xargs rm -f
        exit 0
    else
        warn "etcd endpoint $e not healthy. Trying a different endpoint"
    fi
done
error "all etcd endpoints are unhealthy!"
exit 1
