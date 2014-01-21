AcerC720CrunchBang
==================
Installing and configuring CrunchBang Linux on the Acer C720

Installation
---
instructions here

Fixing touchpad
---
instructions here

Fixing wireless
---
Wireless works at first but then once kernel is updated (as part of touchpad fix), the wireless icon in the toolbar disappears (though wireless still works). To bring it back (the program is nm-applet), just select a theme other than Waldorf. This needs to be done as both normal user and sudo though. In terminal:

    lxappearance
    
Select a theme other than Waldorf, apply and close

    sudo lxappearance
    
Select a theme other than Waldorf, apply and close.

Not a very elegant solution but it works. This also has the added benefit of fixing 'synaptic', which for some reason also stops working after the kernel upgrade.

Source: [CrunchBang forums](http://crunchbang.org/forums/viewtopic.php?id=27765)

Fixing suspend
---
In /etc/default/grub, replace the line

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

by

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic"

And then update grub by entering in the terminal:

    sudo update-grub

Source: [Pedro Larroy's Google+ post](https://plus.google.com/+PedroLarroy/posts/6CgQypQukMa) and [Arch Linux forums](https://bbs.archlinux.org/viewtopic.php?pid=1370148)

