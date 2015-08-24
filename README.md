# Unattended ISO

a simple script for creating unattended iso file for Ubuntu Server 12.04/14.04 LTS


### Why drop suuport for some version, 12.04.x and 14.04.x?

* 12.04, 12.04.1, 12.04.2: they're consider to be too old
* 14.04, 14.04.1: a known issue about partition [LP#1265192](https://bugs.launchpad.net/bugs/1265192)


### Usage

    $ chmod +x gen.sh
    $ sudo ./gen.sh ubuntu-14.04.3-server-amd64.iso
