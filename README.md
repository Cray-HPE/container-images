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

### Simple Example Adding an Alpine Image

```text
> make add IMAGE=library/alpine:3.21
> git add .github/ docker.io/
> git commit -a
> git push
```

## What are the steps to modify attributes of an existing image?

Edit the GitHub workflow you wish to modify.  In the example below we make a change to produce ARM images:

```text
> vi .github/workflows/docker.io.library.alpine.3.21.yaml
> git diff
diff --git a/.github/workflows/docker.io.library.alpine.3.21.yaml b/.github/workflows/docker.io.library.alpine.3.21.yaml
index aedcdb64..bef618fb 100644
--- a/.github/workflows/docker.io.library.alpine.3.21.yaml
+++ b/.github/workflows/docker.io.library.alpine.3.21.yaml
@@ -49,6 +49,7 @@ jobs:
           context_path: ${{ env.CONTEXT_PATH }}
           docker_repo: ${{ env.DOCKER_REPO }}
           docker_tag: ${{ env.DOCKER_TAG }}
+          docker_build_platforms: linux/arm64,linux/amd64
           docker_username: ${{ secrets.ARTIFACTORY_ALGOL60_USERNAME }}
           docker_password: ${{ secrets.ARTIFACTORY_ALGOL60_TOKEN }}
           sign: ${{ github.ref == 'refs/heads/main' }}
```

Do not run ```make add```.  Just commit and push:

```text
> vi .github/workflows/docker.io.library.alpine.3.21.yaml
> git commit -a
> git push
```

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
