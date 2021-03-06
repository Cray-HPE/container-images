# container-images

## Goal:

### Rebuild public images without vulnerabilities!

## What are the steps to add a new image?

1. Discover the upstream image that needs to be rebuilt for Cray-HPE needs.
1. Run `create-buildfiles.sh` script (If you're on mac, `brew install gnu-sed` to get the prereq command.)
1. Update Dockerfile if needed to address other vulnerabilities
1. Create PR to see if job runs and see snyk scan results
1. Merge PR to trigger build and push
1. Update CSM references to use new algol60 reference

```
git clone https://github.com/Cray-HPE/container-images

# Script for automation:
    create_buildfiles.sh

    Uses templates to generate files needed for github workflow

    -i|--image <string>  Required: The name of the image
    -t|--tag <string>    Required: The name of the tag

    [-r|--registry <string>]              The registry to use. Defaults to docker.io
    [-o|--org <string>]                   The docker org. If not set assumes official image with no org (eg alpine)
    [-g|--generate <string>]              What should be generate. Valid options are "both", "dockerfile" or "workflow"

    Examples

    ./.github/scripts/create_buildfiles.sh -o unguiculus -i docker-python3-phantomjs-selenium -t v1
```

## Naming conventions

Base images can come from multiple places docker.io, quay.io, or arti (both custom and original community cached images). Some images are also

In order to standardize on a naming convention the following directory structure in `container-images` should be maintained

`<registry>/<org>/<image>/<tag>`

```bash
container-images
├── .github
├── scripts
├── docker.io
│   ├── library (official image)
│   │   ├── centos
│   │   │   └── 7
│   │   ├── memcached
│   │       └── 1.5.0-alpine
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
        └── library
        |   ├── nginx:1.18.0-alpine
        |   ├── nginx:1.18.0
        └── gitea
            └── gitea:1.9.3
```

In the case of `shasta-1.3` we will pull unpatched images from `artifactory.algol60.net/shatsa-1.3/cray-campc` for example and push the patched image to `artifactory.algol60.net/stable/shasta-1.3/cray-campc`

## Images status from Snyk check

[Status](/status.md)
