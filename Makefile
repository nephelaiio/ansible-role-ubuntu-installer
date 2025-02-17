.PHONY: all ${MAKECMDGOALS}

HOST_DISTRO = $$(grep ^ID /etc/os-release | cut -d '=' -f 2)
PKGMAN = $$(if [ "$(HOST_DISTRO)" = "fedora" ]; then echo "dnf" ; else echo "apt-get"; fi)
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

all: install version lint test

shell:
	DEVBOX_USE_VERSION=0.13.1 devbox shell

test: lint
	MOLECULE_DISTRO=${UBUNTU_DISTRO} \
	MOLECULE_ISO=${UBUNTU_MIRROR}/${UBUNTU_ISO} \
	poetry run molecule $@ -s ${MOLECULE_SCENARIO}

install:
	@sudo ${PKGMAN} install -y $$(if [[ "${HOST_DISTRO}" == "fedora" ]]; then echo libvirt-devel; else echo libvirt-dev; fi)
	@poetry install --no-root

lint: install
	poetry run yamllint .
	poetry run ansible-lint .
	poetry run molecule syntax

dependency create prepare converge idempotence side-effect verify destroy login reset:
	MOLECULE_DISTRO=${UBUNTU_DISTRO} \
	MOLECULE_ISO=${UBUNTU_MIRROR}/${UBUNTU_ISO} \
	poetry run molecule $@ -s ${MOLECULE_SCENARIO}

ignore:
	poetry run ansible-lint --generate-ignore

clean: destroy reset
	@poetry env remove $$(which python) >/dev/null 2>&1 || exit 0

publish:
	@echo publishing repository ${GITHUB_REPOSITORY}
	@echo GITHUB_ORGANIZATION=${GITHUB_ORG}
	@echo GITHUB_REPOSITORY=${GITHUB_REPO}
	@poetry run ansible-galaxy role import \
		--api-key ${GALAXY_API_KEY} ${GITHUB_ORG} ${GITHUB_REPO}

version:
	@poetry run molecule --version

debug: install version
	@poetry export --dev --without-hashes || exit 0
	sudo ufw status
