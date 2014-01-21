AcerC720CrunchBang
==================
Installing and configuring CrunchBang Linux on the Acer C720

Putting Chromebook in developer mode
---
Steps:

* Boot up Chromebook as you normally would, login, and install all updates (not sure if this is necessary but can't hurt)
* Press `esc-f3-powerbutton` to get to white splash screen
* Press `ctrl-D` to get to "warning" splash screen
* Press `enter` to confirm
* Press `ctrl-D` again to boot ChromeOS in developer mode

Source: [Chromium.org Acer C720 site](http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/acer-c720-chromebook)

Enable booting from a USB drive
---
Steps:

* Make sure you are logged in under developer mode
* Press `ctrl-alt-T` to bring up `crosh` in a tab
* Type `shell` to bring up the  shell
* Type in the following to enable booting from a USB drive

    ```
    sudo su
    crossystem dev_boot_usb=1 dev_boot_legacy=1
    ```

Note: if you have [upgraded](http://www.amazon.com/MyDigitalSSD-Super-Cache-Solid-State/dp/B00EZ2E8NO/ref=sr_1_2?ie=UTF8&qid=1390279531&sr=8-2&keywords=mydigitalssd) your machine's SSD you will need to install ChromeOS on it first and perform the above steps.

Installation
---
* Create CrunchBang [.iso](http://crunchbang.org/download/) (64-bit) using [Universal USB Installer](http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/)
* Reboot computer with USB drive plugged in
* At white splash screen press `ctrl-L` (note, NOT `ctrl-D`) to boot from USB drive
* Choose "install CrunchBang" option

Fixing touchpad
---
instructions here

Fixing wireless
---
Wireless works at first but then once kernel is updated (as part of touchpad fix), the wireless icon in the toolbar disappears (though wireless still works). To bring it back (the program is `nm-applet`), just select a theme other than Waldorf. This needs to be done as both normal user and sudo though. In terminal:
```
lxappearance
```
Select a theme other than Waldorf, apply and close
```
sudo lxappearance
``` 
Select a theme other than Waldorf, apply and close.

Not a very elegant solution but it works. This also has the added benefit of fixing `synaptic`, which for some reason also stops working after the kernel upgrade.

Source: [CrunchBang forums](http://crunchbang.org/forums/viewtopic.php?id=27765)

Fixing suspend
---
In /etc/default/grub, replace the line
```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```
by
```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic"
```
And then update grub by entering `sudo update-grub` in the terminal.

Source: [Pedro Larroy's Google+ post](https://plus.google.com/+PedroLarroy/posts/6CgQypQukMa) and [Arch Linux forums](https://bbs.archlinux.org/viewtopic.php?pid=1370148)

