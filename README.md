# container-images

## Goal:
### Rebuild public images without vulnerabilities!

## What are the steps to add a new image?

1. Discover the upstream image that needs to be rebuilt for Cray-HPE needs.
1. Run `create-buildfiles.sh` script
1. Update Dockerfile if needed to address other vulnerabalities
1. Create PR to see if job runs and see snyk scan results
1. Merge PR to trigger build and push
1. Update CSM references to use new algol60 reference

```
git clone https://github.com/Cray-HPE/container-images

# Example
./.github/scripts/create_buildfiles.sh -o unguiculus -i docker-python3-phantomjs-selenium -t v1
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
[Status](/status.md)
