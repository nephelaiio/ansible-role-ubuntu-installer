# nephelaiio.ubuntu-installer

[![Build Status](https://github.com/nephelaiio/ansible-role-ubuntu-installer/workflows/.github/workflows/main.yml/badge.svg)](https://travis-ci.org/nephelaiio/ansible-role-ubuntu-installer)
[![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-nephelaiio.ubuntu-installer-blue.svg)](https://galaxy.ansible.com/nephelaiio/ubuntu-installer/)

An [ansible role](https://galaxy.ansible.com/nephelaiio/ubuntu-installer) to generate unattended installation isos for Ubuntu server.

## Role Variables

Please refer to the [defaults file](/defaults/main.yml) for an up to date list of input parameters.

## Example Playbook

The following example will create an unattended iso for deploying nuc.nephelai.io with Xenial

```
- hosts: localhost
  roles:
     - role: nephelaiio.ubuntu-installer
  vars:
    ubuntu_installer_release: 16.04.3
    ubuntu_installer_hostname: nuc.nephelai.io
    ubuntu_installer_timezone: America/Costa_Rica
    ubuntu_installer_disk: /dev/nvme0n1
```

It has been tested on NUC7I3BNH with NVMe storage

The following example will create an unattended iso for deploying vm.nephelai.io with Aartful

```
- hosts: localhost
  roles:
     - role: nephelaiio.ubuntu-installer
  vars:
    ubuntu_installer_release: 17.10
    ubuntu_installer_hostname: vm.nephelai.io
    ubuntu_installer_timezone: America/Costa_Rica
    ubuntu_installer_disk: /dev/sda
    ubuntu_installer_interface:
      static: true
      ipaddress: 10.40.0.22
      netmask: 255.255.255.0
      gateway: 10.40.0.254
      nameservers: 8.8.8.8 8.8.4.8.8.8.8 8.8.4.4
```

It has been tested on ESXi6.5 with a VM with default settings for Ubuntu

## Testing

Please make sure your environment has [docker](https://www.docker.com) installed in order to run role validation tests. Additional python dependencies are listed in the [requirements file](/requirements.txt)

Role is tested against the following distributions (docker images):
  * Ubuntu Bionic
  
It's designed to work on any recent Ubuntu release

You can test the role directly from sources using command ` molecule test `

## License

This project is licensed under the terms of the [MIT License](/LICENSE)
