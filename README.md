AcerC720CrunchBang
==================
Installing and configuring [CrunchBang](http://crunchbang.org/) Linux on the [Acer C720](http://www.theverge.com/2013/10/23/4948120/acer-c720-chromebook-review) [Chromebook](http://en.wikipedia.org/wiki/Chromebook)

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
Booting from a USB drive is not enabled by default. Steps to enable:

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
Basically the key is to modify one of the boot parameters with `mem=1536m`, or else you will get a "not enough memory" error when you try to install or even run a live demo.

* Create CrunchBang [.iso](http://crunchbang.org/download/) (64-bit) using [Universal USB Installer](http://www.pendrivelinux.com/universal-usb-installer-easy-as-1-2-3/)
* Reboot computer with USB drive plugged in
* At white splash screen press `ctrl-L` (note, NOT `ctrl-D`) to boot from USB drive
* Highlight "install CrunchBang" option (don't select it yet!)
* Press `Tab`, which will bring up a prompt at the bottom of your screen. Add a space to the end of the command and then add

    ```
    mem=1536m
    ```
    
* Hit enter to begin installation

Rest assured this will not affect the amount of memory available to your system once everything is installed. For example, I have the 4GB RAM Acer C720 and all of my RAM was available to me.

Also **NOTE**: once CrunchBang is installed, when you turn on your computer you will see a white splash screen. Continue using `ctrl-L` instead of `ctrl-D` to fire up GRUB, from where you can then boot up CrunchBang.

Sources: [CrunchBang forum post](http://crunchbang.org/forums/viewtopic.php?pid=348696) (post #8 - actually uses `mem=1075m`; either one should work) and [Arch Linux Acer C720 wiki](https://wiki.archlinux.org/index.php/Acer_C720_Chromebook)

Getting the touchpad working
---
CrunchBang Waldorf uses a fairly old kernel (3.2) so we need to update the kernel (to 3.12 at time of this post), and then run a patching script (originally written for Ubuntu and slightly modified to work with CrunchBang). Steps:

* Modify `/etc/apt/sources.list` and `/etc/apt/preferences` so that `waldorf` is replaced with `janice`, and `wheezy` is replaced with `jessie`. Leave the Debian security sources as `wheezy` though. Also uncomment the debian-src lines.
* Run `sudo apt-get update` to download list of upgrades
* Run `sudo apt-get dist-upgrade` to upgrade your kernel
* Reboot
* Run the c720crunchbangtp script

Source: [Comment in reddit.com/r/CrunchBang](http://www.reddit.com/r/CrunchBang/comments/1qogy6/crunchbang_on_the_acer_c720_chromebookso_close/) (see post by user ngorgi). I also have copied his modified script to this repo in case it gets taken down.

Improving the touchpad performance
---
These are more personal preferences. Once the touchpad is working via the above steps, some may find the touchpad to still be a bit unresponsive. Here are the `synclient` parameters I use.

* Edit autostart config file: change `touchpad` to `trackpad`

Fixing wireless, synaptics, and others
---
Once the kernel is updated, [GTK+](http://en.wikipedia.org/wiki/GTK%2B) (graphics-related toolkit) causes issues with the default Waldorf theme, leading to segmentation faults for some programs. Notably, `nm-applet` (the wireless icon in the taskbar) and `synaptics` (package manager) are among the affected.

Wireless still works, but it would be nice to have the `nm-applet` GUI to make changes. To bring it back (and fix segfaults for other programs too), just select a theme other than Waldorf. This needs to be done as both normal user and sudo though. In terminal:
```
lxappearance
```
Select a theme other than Waldorf, apply and close
```
sudo lxappearance
``` 
Select a theme other than Waldorf, apply and close. `alt-F2` and then run `nm-applet`.

Not a very elegant solution but it works. This also has the added benefit of fixing `synaptic` and other programs. For more technical details see the second link below.

Source: [CrunchBang forum post](http://crunchbang.org/forums/viewtopic.php?id=27765) and [another CrunchBang forum post](http://crunchbang.org/forums/viewtopic.php?pid=310612#p310612)

Fixing suspend
---
Steps:

* Update the `rc.local` file in `/etc` to look like the [version in this repository](https://github.com/liangcj/AcerC720CrunchBang/blob/master/rc.local). Check the [history](https://github.com/liangcj/AcerC720CrunchBang/commits/master/rc.local) for the original version if curious. Basically you add the following lines to the file:

    ```
    echo EHCI > /proc/acpi/wakeup
    echo HDEF > /proc/acpi/wakeup
    echo XHCI > /proc/acpi/wakeup
    echo LID0 > /proc/acpi/wakeup
    echo TPAD > /proc/acpi/wakeup
    echo TSCR > /proc/acpi/wakeup
    echo 300 > /sys/class/backlight/intel_backlight/brightness
    rfkill block bluetooth
    /etc/init.d/bluetooth stop
    ```

* Create a `05_sound` file in `/etc/pm/sleep.d` using the file of the [same name in this repository](https://github.com/liangcj/AcerC720CrunchBang/blob/master/05_sound). Then make the file executable by running
    
    ```
    sudo chmod +x /etc/pm/sleep.d/05_sound
    ```

* In /etc/default/grub, replace the line
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
    ```
    by
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic"
    ```
    And then update grub by entering `sudo update-grub` in the terminal.

The last step by itself will kind of fix suspend in that the first time you close the lid everything will come back fine when you open the lid back up. However, if you then close the lid again, it will only lock the screen rather than suspend. Plus, you may also have issues trying to shut down the system. The first two steps will fix this problem to allow "unlimited suspends and resumes". Others reported issues with USB and sound after resuming. Mine worked fine, possibly because I am on a newer kernel (3.12).

Source: [Pedro Larroy's Google+ post](https://plus.google.com/+PedroLarroy/posts/6CgQypQukMa) (make sure to check Mike Lim's comments too) and [Arch Linux forums](https://bbs.archlinux.org/viewtopic.php?pid=1370148)
