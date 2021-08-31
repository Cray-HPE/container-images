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

## Naming conventions
Base images can come from multiple places docker.io, quay.io, or arti (both custom and original community cached images). Some images are also

In order to standardize on a naming convention the following directory structure in `container-images` should be maintained

`<registry>/<org>|<official image>/<image>`
```bash
container-images
├── .github
├── scripts
├── docker.io
│   ├── nginx (offical image)
│   │   ├── 1.18.0-alpine
│   │   └── 1.18.0
│   └── gitea (org)
│       └── gitea
│           └── 1.9.3
├── quay.io
│   └── coreos
│       └── etcd
│           └── v3.5.0
├── k8s.gcr.io
│   └── kube-scheduler
│       └── v1.18.0
└── shasta-1.3
│   └── cray
│       └── cray-capmc
│           └── 1.17.7
```

These would then match up the algol registry url of

```bash
artifactory.algol60.net
└── stable
    ├── shasta-1.3
    │   └── cray
    │       └── cray-capmc:1.17.7
    ├── quay.io
    │   └── coreos
    │       └── etcd:v3.5.0
    ├── k8s.gcr.io
    │   └── kube-scheduler:v1.18.0
    └── docker.io
        ├── nginx:1.18.0-alpine
        ├── nginx:1.18.0
        └── gitea
            └── gitea:1.9.3
```

In the case of `shasta-1.3` we will pull unpatched images from `artifactory.algol60.net/shatsa-1.3/cray-campc` for example and push the patched image to `artifactory.algol60.net/stable/shasta-1.3/cray-campc`



## Images status from Snyk check
[Status](/Status.md)
