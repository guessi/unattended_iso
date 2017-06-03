# Unattended ISO

a simple script for creating unattended iso file for Ubuntu Server LTS


### Supported versions

| Distro Version            | Input Filename                  | Remark   |
|---------------------------|---------------------------------|----------|
| Ubuntu Server 12.04.5 LTS | ubuntu-12.04.5-server-amd64.iso | EOL      |
| Ubuntu Server 14.04.5 LTS | ubuntu-14.04.5-server-amd64.iso |          |
| Ubuntu Server 16.04.1 LTS | ubuntu-16.04.1-server-amd64.iso |          |
| Ubuntu Server 16.04.2 LTS | ubuntu-16.04.2-server-amd64.iso |          |
| Ubuntu Server 16.04 Daily | xenial-server-amd64.iso         | Unstable |


### Usage

    $ chmod +x gen.sh
    $ sudo ./gen.sh <iso>


### FAQ

* default user name/password is: ubuntu/ubuntu

* if you want to change default user name and password, change the following lines in preseed files:

    d-i passwd/username string <plaintext-username>
    d-i passwd/user-password-crypted password <encrypted-password>

* if you want to change disk partitioning layout, change the following section in preseed files:

    d-i partman-auto/expert_recipe <recipe>


* why drop suuport for some version?

    it is more secure and safe to follow up upstream changes, and some of them have disk partitioning issue, see [LP#1265192](https://bugs.launchpad.net/bugs/1265192)


### Reference

* https://help.ubuntu.com/lts/installation-guide/example-preseed.txt
