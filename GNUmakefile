#
# MIT License
#
# (C) Copyright 2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

# Commands in case anyone wants to change them
INSTALL:=install
MAKE:=make

# Swap this out with podman or whatever if needed, just used to probe for
# package manager commands on image adds
CONTAINERCMD:=docker

# What args to use when pulling images
CONTAINERCMD_PULL_ARGS:=pull

# And what args to use when running images
CONTAINERCMD_RUN_ARGS:=run -ti --entrypoint

# Set this if you want to be explicit about the package manager used for add,
# wouldn't recommend using this for all.
PACKAGE_MANAGER:=

# nop for now (eventually this will scan all existing files so we can rebuild everything in one go)
.default: all
.PHONY: all
all:
	$(error default update target not yet implemented)

# Boilerplate test function for checking if vars are set or not
is_defined = $(strip $(foreach 1,$1, $(call __is_defined,$1,$(strip $(value 2)))))
__is_defined = $(if $(value $1),, $(error Required var not set $1$(if $2, ($2))))

# Default prefix/registry to use
REGISTRY:=docker.io

define split_image
	$(eval NAME=$(shell echo "$(IMAGE)" | awk -F: '{print $$1}' || echo $(IMAGE)))
	$(eval TAG=$(shell echo "$(IMAGE)" | awk -F: '{print $$2}' || echo $(IMAGE)))
endef

# Generate the license fragment from the base LICENSE file.
template/fragment-license: LICENSE
	@printf "#\n" > $@
	@cat $< | sed -e 's/^/# /' -e 's/[[:blank:]]*$$//' -e "s/\[.*\]/\[$$(date +%Y)\]/" >> $@
	@printf "#\n" >> $@

GHWORKFLOWDIR:=.github/workflows

$(GHWORKFLOWDIR):
	$(INSTALL) -dm755 $@

# Note these targets are only useful in sub makes
$(GHWORKFLOWDIR)/$(GHACTIONFILE): $(GHWORKFLOWDIR) .github/workflows template/fragment-license template/fragment-workflow
	$(call gen_gh_update_workflow, $@)

define gen_gh_update_workflow
	$(eval PPATH=$(shell echo $(DOCKERDIR)))
	@cat template/fragment-license > $1
	@printf "\n# Generated with: $(MAKE) $(TOPFLAGS)\n" >> $1
	@printf "#\n---\n" >> $1
	@printf "name: $(REGISTRY)/$(IMAGE)\n" >> $1
	@printf "on:\n" >> $1
	@printf "  push:\n" >> $1
	@printf "    paths:\n" >> $1
	@printf "      -$(1)\n" >> $1
	@printf "      - $(PPATH)/**\n" >> $1
	@printf "  workflow_dispatch:\n" >> $1
	@printf "jobs:\n" >> $1
	@printf "  build:\n" >> $1
	@printf "    runs-on: ubuntu-latest\n" >> $1
	@printf "    permissions:\n" >> $1
	@printf "      contents: read\n" >> $1
	@printf "      id-token: write\n" >> $1
	@printf "    env:\n" >> $1
	@printf "      CONTEXT_PATH: $(DOCKERDIR)\n" >> $1
	@printf "      DOCKER_REPO: artifactory.algol60.net/csm-docker/$$\x7B\x7B github.ref == 'refs/heads/main' && 'stable' || 'unstable' \x7D\x7D/$(REGISTRY)/$(NAME)\n" >> $1
	@printf "      DOCKER_TAG: \"$(TAG)\"\n" >> $1
	@cat template/fragment-workflow >> $1
endef

# Note these targets are only useful in sub makes
$(DOCKERDIR):
	$(INSTALL) -dm755 $@

define gen_dockerfile
	@cat template/fragment-license > $1
	@printf "\n# Generated with: $(MAKE) $(TOPFLAGS)\n" >> $1
	@printf "#\n" >> $1
	@printf "FROM $(REGISTRY)/$(NAME):$(TAG)\n" >> $1
endef

# Expects the image to be pulled locally already, only if not specified.
ifndef PACKAGE_MANAGER
define detect_image_package_manager
	$(eval PACKAGE_MANAGER:=$(shell if [ "$(PACKAGE_MANAGER)" = "" ]; then\
	  for pkgmgr in apk apt yum microdnf; \
	  do $(CONTAINERCMD) $(CONTAINERCMD_RUN_ARGS) $$pkgmgr $(REGISTRY)/$(IMAGE) > /dev/null 2>&1;\
	    if [ $$? == 127 ]; then\
	      continue;\
	    elif [ $$? == 125 ]; then\
	      continue;\
	    else\
	      echo $$pkgmgr;\
	      break;\
	    fi\
	  done\
	fi))
endef
else
# nop
define detect_image_package_manager
endef
endif

# For now users forcibly specify the package manager in use. Will add auto
# detection in a future pr. Didn't need it for this initial bunch of images so
# skipped it. Will likely just be a function that sets this same var.
ifndef PACKAGE_MANAGER
$(DOCKERDIR)/Dockerfile: $(DOCKERDIR) template/fragment-license
	$(call gen_dockerfile, $@)
else
$(DOCKERDIR)/Dockerfile: $(DOCKERDIR) template/fragment-license template/dockerfile/fragment-$(PACKAGE_MANAGER)
	$(call gen_dockerfile, $@)
	cat template/dockerfile/fragment-$(PACKAGE_MANAGER) >> $@
endif

ifeq ($(V),1)
CHATTY=
else
CHATTY=> /dev/null 2>&1
endif

define pull_image
	$(CONTAINERCMD) $(CONTAINERCMD_PULL_ARGS) $(REGISTRY)/$(NAME):$(TAG) $(CHATTY)
endef

# Add a new image, user ux target
.PHONY: add
add:
	$(call is_defined, IMAGE, docker image name)
	$(call split_image)
	$(eval DOCKERDIR=$(REGISTRY)/$(NAME)/$(TAG))
	$(call pull_image)
	$(call detect_image_package_manager)
	$(eval GHACTIONFILE=$(shell echo $(DOCKERDIR) | tr '/' '.'))
	$(MAKE) _update IMAGE=$(IMAGE) REGISTRY=$(REGISTRY) NAME=$(NAME) TAG=$(TAG) DOCKERDIR=$(DOCKERDIR) GHACTIONFILE=$(GHACTIONFILE).yaml PACKAGE_MANAGER=$(PACKAGE_MANAGER) TOPFLAGS="$@ IMAGE=$(IMAGE) REGISTRY=$(REGISTRY) PACKAGE_MANAGER=$(PACKAGE_MANAGER)"

# The actual target used for adds/updates for individual "things", doesn't check
# for anything, and callers need to provide everything needed. See above for
# example usage.
_update: $(DOCKERDIR)/Dockerfile $(GHWORKFLOWDIR)/$(GHACTIONFILE)

# TODO: How do we template out an update/gh pr action?
# Data needed:
# - How do we find any/all versions/tags for each thing, e.g. like curl --silent 'https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest' | jq -r '.tag_name'
# - The image registry/name/tag then can be used to call make add IMAGE=registry/name:tagfound to generate files
# - git add -A and iff there is a git diff then create a commit and pr it so we know when upstreams change or add a new version
#
# That seems to be the overall logic

# Second TODO: Need to setup all as the target that updates each existing
# Dockerfiles and workflow files. Skipped for now as we don't yet need it but it
# will make it so we can update existing files with new workflow layouts/setups,
# or if the license changes whatever. Also a future pr task. I have wip versions
# but won't commit it until this bare version is in.
