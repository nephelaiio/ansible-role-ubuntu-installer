export 

UBUNTU_DISTRO ?= noble
UBUNTU_SHASUMS = https://releases.ubuntu.com/${UBUNTU_DISTRO}/SHA256SUMS
UBUNTU_MIRROR = $$(dirname ${UBUNTU_SHASUMS})
UBUNTU_ISO = $$(curl -s ${UBUNTU_SHASUMS} | grep "live-server-amd64" | awk '{print $$2}' | sed -e 's/\*//g')
MOLECULE_DISTRO = ${UBUNTU_DISTRO}
MOLECULE_ISO = ${UBUNTU_MIRROR}/${UBUNTU_ISO}

include ${MAKEFILE}
