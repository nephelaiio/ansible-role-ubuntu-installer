export 

UBUNTU_DISTRO ?= noble
UBUNTU_SHASUMS := https://releases.ubuntu.com/${UBUNTU_DISTRO}/SHA256SUMS
$(eval UBUNTU_MIRROR := $(shell dirname ${UBUNTU_SHASUMS}))
$(eval UBUNTU_ISO := $(shell curl -s ${UBUNTU_SHASUMS} | grep "live-server-amd64" | awk '{print $$2}' | sed -e 's/\*//g' | sort | tail -1))
MOLECULE_DISTRO := ${UBUNTU_DISTRO}
MOLECULE_ISO := ${UBUNTU_MIRROR}/${UBUNTU_ISO}

include ${MAKEFILE}
