# Frequently Asked Questions

### What's the default user name/password

Username: **ubuntu**, Password: **ubuntu**


### How do I change default username and password

modify the following lines in preseed files:

    d-i passwd/username string <plaintext-username>
    d-i passwd/user-password-crypted password <encrypted-password>

### How do I customized disk partitioning layout

modify the following lines in preseed files:

    d-i partman-auto/expert_recipe <recipe>


### Why dropped some release versions?

- Ubuntu 12.04.x have been marked as End-of-Life, that's why it I dropped it
- Ubuntu 14.04.5 have longest kernel support schedule, see [Ubuntu Kernel Support](https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Kernel.2FSupport.A14.04.x_Ubuntu_Kernel_Support)
- Ubuntu 16.04.0 have disk partitioning issue, see [LP#1265192](https://bugs.launchpad.net/bugs/1265192)
