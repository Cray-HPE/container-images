# container-images

## Goal:

### Rebuild public images without vulnerabilities!

## What are the steps to add a new image?

1. Find the image name and registry that needs to be mirrored and/or updated from upstream.
1. `make add` with that image and registry name.
1. Create PR to ensure the update job runs and view snyk scan results.
1. Merge PR to trigger build and push to algol60.
1. Update CSM references to use mirrored algol60 references.

To add a new image run:

```text
git clone https://github.com/Cray-HPE/container-images
cd container-images
make add IMAGE=container/image:tag REGISTRY=some-registry.tld
```

Note `REGISTRY` is optional and set to `docker.io` by default. `PACKAGE_MANAGER` is also optional and will auto detect the package manager but can be set manually to force the generated `Dockerfile` to use that package manager.

```text
make add IMAGE=container/image:tag
```

Note: The make setup is an mvp working towards fully automating image detection and adding of images without direct human intervention. The other goal for it is to update all existing files that however doesn't work in the current implementation as-is.

You may also set `V=1` for more output as far as what make is doing as well as output from commands run.

## Naming conventions

Base images can come from multiple places docker.io, quay.io, or arti (both custom and original community cached images). Some images are also ???

In order to standardize on a naming convention the following directory structure in `container-images` should be maintained

`<registry>/<org>/<image>/<tag>`

```text
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

```text
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
