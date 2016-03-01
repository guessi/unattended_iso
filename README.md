# Unattended ISO

a simple script for creating unattended iso file for Ubuntu Server LTS


### Why drop suuport for some version?

* 12.04, 12.04.1, 12.04.2: they're consider to be too old
* 14.04, 14.04.1: a known issue about partition [LP#1265192](https://bugs.launchpad.net/bugs/1265192)


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


### Reference

* https://help.ubuntu.com/lts/installation-guide/example-preseed.txt
