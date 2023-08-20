# nephelaiio.ubuntu-installer

[![Build Status](https://github.com/nephelaiio/ansible-role-ubuntu-installer/workflows/CI/badge.svg)](https://github.com/nephelaiio/ansible-role-ubuntu-installer/actions)
[![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-nephelaiio.ubuntu-installer-blue.svg)](https://galaxy.ansible.com/nephelaiio/ubuntu-installer/)

An [ansible role](https://galaxy.ansible.com/nephelaiio/ubuntu-installer) to generate unattended installation isos for Ubuntu server.

## Role Variables

Please refer to the [defaults file](/defaults/main.yml) for a full list of input parameters.

## Example Playbook

The following example will create an unattended iso for deploying vm.nephelai.io with Ubuntu Focal (22.04.3) pulled from releases.ubuntu.com (default)

```
- hosts: localhost
  roles:
     - role: nephelaiio.ubuntu_installer
  vars:
    ubuntu_installer_hostname: vm.nephelai.io
    ubuntu_installer_interface:
      static: true
      ipaddress: 10.40.0.22
      netmask: 255.255.255.0
      gateway: 10.40.0.254
      nameservers: 8.8.8.8 8.8.4.8.8.8.8 8.8.4.4
```

Images are tested by provisioning kvm guests on github actions large runners

## Testing

Please make sure your environment has [docker](https://www.docker.com) installed in order to run role validation tests. Additional python dependencies are listed in the [requirements file](/requirements.txt)

Role is tested from an Ansible controller running Ubuntu Focal. Target iso flavors are:
  * Ubuntu Focal
  * Ubuntu Jammy
  
It's designed to work on a controller running any recent Ubuntu release (Bionic/Focal)

You can test the role directly from sources using command ` molecule test `. Note that this will reconfigure networking for network 192.168.255.0/24 which will be directly connected to a local bridge interface

## License

This project is licensed under the terms of the [MIT License](/LICENSE)
