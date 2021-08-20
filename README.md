# container-images

## Goal:
### Rebuild public images without vulnerabilities!

## What are the steps to do?

* Discover image from Cray-HPE needs.
* Write a Dockerfile.
* Run github actions workflow and fix vulnerabilites.

```
git clone https://github.com/Cray-HPE/container-images.git
cd scripts
./create_buildfiles.sh <imagename>
```

## Images already passed by Snyk check

| Github Action WorkFlow |
| [![curl image build](https://github.com/Cray-HPE/container-images/actions/workflows/curl.yaml/badge.svg)](https://github.com/Cray-HPE/container-images/actions/workflows/curl.yaml) |
|[![cephfs-provisioner](https://github.com/Cray-HPE/container-images/actions/workflows/cephfs-provisioner.yaml/badge.svg)](https://github.com/Cray-HPE/container-images/actions/workflows/cephfs-provisioner.yaml)|
|[![mc minio client image build](https://github.com/Cray-HPE/container-images/actions/workflows/mc.yaml/badge.svg)](https://github.com/Cray-HPE/container-images/actions/workflows/mc.yaml)|
|[![external-dns](https://github.com/Cray-HPE/container-images/actions/workflows/external-dns.yaml/badge.svg)](https://github.com/Cray-HPE/container-images/actions/workflows/external-dns.yaml)|
|[![nexus3](https://github.com/Cray-HPE/container-images/actions/workflows/nexus3.yaml/badge.svg)](https://github.com/Cray-HPE/container-images/actions/workflows/nexus3.yaml)|
