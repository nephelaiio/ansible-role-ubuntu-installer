set allow-duplicate-variables := true

import ".devbox/virtenv/pokerops.ansible-utils.molecule/justfile"

UBUNTU_DISTRO := env_var_or_default("UBUNTU_DISTRO", "noble")
UBUNTU_MIRROR := "https://releases.ubuntu.com/" + UBUNTU_DISTRO
UBUNTU_ISO := ```
  curl -s "https://releases.ubuntu.com/${UBUNTU_DISTRO:-noble}/SHA256SUMS" \
    | grep "live-server-amd64" \
    | awk '{print $2}' \
    | sed -e 's/\*//g' \
    | sort \
    | tail -1
```

MOLECULE_DISTRO := UBUNTU_DISTRO
MOLECULE_ISO := UBUNTU_MIRROR + "/" + UBUNTU_ISO
