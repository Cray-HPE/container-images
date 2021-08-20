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

* curl
* cephfs-provisioner
* external-dns
* mc
* nexus3