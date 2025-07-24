.PHONY: all ${MAKECMDGOALS}

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR := $(dir $(MAKEFILE_PATH))

MOLECULE_SCENARIO ?= default
GALAXY_API_KEY ?=
GITHUB_REPOSITORY ?= $$(git config --get remote.origin.url | cut -d':' -f 2 | cut -d. -f 1)
GITHUB_ORG = $$(echo ${GITHUB_REPOSITORY} | cut -d/ -f 1)
GITHUB_REPO = $$(echo ${GITHUB_REPOSITORY} | cut -d/ -f 2)
REQUIREMENTS = requirements.yml
UBUNTU_DISTRO ?= noble
UBUNTU_SHASUMS = https://releases.ubuntu.com/${UBUNTU_DISTRO}/SHA256SUMS
UBUNTU_MIRROR = $$(dirname ${UBUNTU_SHASUMS})
UBUNTU_ISO = $$(curl -s ${UBUNTU_SHASUMS} | grep "live-server-amd64" | awk '{print $$2}' | sed -e 's/\*//g')
COLLECTION_PATH = $(MAKEFILE_DIR)
ROLE_PATH = $(MAKEFILE_DIR)/roles

LOGIN_ARGS ?=

all: install version lint test

shell:
	DEVBOX_USE_VERSION=0.13.1 devbox shell

test: lint
	MOLECULE_DISTRO=${UBUNTU_DISTRO} \
	MOLECULE_ISO=${UBUNTU_MIRROR}/${UBUNTU_ISO} \
	uv run molecule $@ -s ${MOLECULE_SCENARIO}

install:
	@uv sync

lint: install
	uv run yamllint .
	uv run ansible-lint .
	uv run molecule syntax


ifeq (login,$(firstword $(MAKECMDGOALS)))
    LOGIN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(subst $(space),,$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))):;@:)
endif

dependency create prepare converge idempotence side-effect verify destroy login reset:
	MOLECULE_DISTRO=${UBUNTU_DISTRO} \
	MOLECULE_ISO=${UBUNTU_MIRROR}/${UBUNTU_ISO} \
	ANSIBLE_COLLECTIONS_PATH=$(COLLECTION_PATH) \
	ANSIBLE_ROLES_PATH=$(ROLE_PATH) \
	uv run molecule $@ -s ${MOLECULE_SCENARIO} ${LOGIN_ARGS}

ignore:
	uv run ansible-lint --generate-ignore

publish:
	@echo publishing repository ${GITHUB_REPOSITORY}
	@echo GITHUB_ORGANIZATION=${GITHUB_ORG}
	@echo GITHUB_REPOSITORY=${GITHUB_REPO}
	@uv run ansible-galaxy role import \
		--api-key ${GALAXY_API_KEY} ${GITHUB_ORG} ${GITHUB_REPO}

version:
	@uv run molecule --version
