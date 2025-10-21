#!/bin/bash
set -e +xv
trap "rm -rf /root/.zypp" EXIT

SLES_REPO_USERNAME=$(cat /run/secrets/SLES_REPO_USERNAME)
SLES_REPO_PASSWORD=$(cat /run/secrets/SLES_REPO_PASSWORD)
SLES_MIRROR="https://${SLES_REPO_USERNAME:-}${SLES_REPO_PASSWORD+:}${SLES_REPO_PASSWORD}@artifactory.algol60.net/artifactory/sles-mirror"
ARCH=x86_64
zypper --non-interactive rr --all
zypper --non-interactive ar ${SLES_MIRROR}/Products/SLE-Module-Basesystem/15-SP7/${ARCH}/product?auth=basic sles15sp7-Module-Basesystem-product
zypper --non-interactive ar ${SLES_MIRROR}/Updates/SLE-Module-Basesystem/15-SP7/${ARCH}/update?auth=basic sles15sp7-Module-Basesystem-update
zypper update -y
zypper clean -a
zypper --non-interactive rr --all
rm -f /etc/zypp/repos.d/*
