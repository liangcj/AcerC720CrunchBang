CrunchBang Linux on the Acer C720 Chromebook
===
This is a guide for installing and configuring [CrunchBang](http://crunchbang.org/) Linux on the [Acer C720](http://www.theverge.com/2013/10/23/4948120/acer-c720-chromebook-review) [Chromebook](http://en.wikipedia.org/wiki/Chromebook). The majority of the information is combined from various sources and I created this as a central reference. Issues and pull requests are welcome.

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

Sound keyboard shortcuts
---
We combine the highly customizable Openbox keyboard shortcuts with the command-line `amixer` function. You can manually toggle mute from the command line with `amixer sset Master toggle` and adjust sound up and down by 5% increments using `amixer sset Master 5%+ unmute` and `amixer sset Master 5%- unmute`. The `unmute` part is optional: leaving it in means that if you adjust the sound while muted, you will automatically unmute. Of course you can also change the 5% to be coarser or finer.

Since it is inconvenient to use the command line each time you want to adjust sound, most will want to map them to keyboard shortcuts. Even though the first row of keys have shortcut (brightness, volume, etc.) icons on them, they in fact physically trigger F1-F10 signals (note there are no F11 or F12 keys). To see this, execute `xev` at the terminal to start a program that captures and outputs key press signals.

I prefer to hold down the Super key (physically located where Caps Lock is usually found but sends the same signal as the Windows key) while hitting F8-F10 to trigger the volume shortcuts. Instructions for creating these shortcuts are below:

In the `/home/username/.config/openbox/rc.xml` file, place the following code chunk between `<keyboard>` and `</keyboard>`:
```
    <keybind key="W-F8">
      <action name="Execute">
        <command>amixer sset Master toggle</command>
      </action>
    </keybind>
    <keybind key="W-F9">
      <action name="Execute">
        <command>amixer sset Master 5%- unmute</command>
      </action>
    </keybind>
    <keybind key="W-F10">
      <action name="Execute">
        <command>amixer sset Master 5%+ unmute</command>
      </action>
    </keybind>
```

Make sure you restart Openbox (`Super-Space` ==> Settings ==> Openbox ==> Restart) to put the changes into effect.

See the `rc.xml` file in this repository for the full, edited file (will also contain other shortcuts for brightness, page-up/down, home/end, delete, and caps lock). 

Source: [CrunchBang forums](http://crunchbang.org/forums/viewtopic.php?pid=50246) (slightly modified)

Brightness keyboard shortcuts
---
Just like the sound shortcuts, we edit the `rc.xml` file, but instead of `amixer` we will use `xbacklight`. A side

There are two options I know of: `xrandr` and `xbacklight`. According to `xrandr`'s man page and my own testing, `xbacklight` **is preferred**. This is because `xrandr` only adjusts brightness via software while `xbacklight` actually makes hardware changes. One way to see this is to compare `xrandr --output 0x46 --brightness 0` with `xbacklight -set 0`. Both claim to set the rightness to zero but `xrandr` only makes everything black while it is clear that the backlight is still on. It appears to only change the gamma settings without physically dimming the backlight. The `xbacklight` method actually turns off the backlight completely.

To try `xrandr` for yourself, replace `0x42` with your monitor's identification code (which can be found in the "Screen 0" entry after using `xrandr --verbose`). One other way to verify that `xbacklight` is better is to look at how `/sys/class/backlight/intel_backlight/brightness` changes. Its value does not change when using `xrandr`, but it does when using `xbacklight`.

Steps:

* Install `xbacklight` using `sudo apt-get install xbacklight`
* Add the following between `<keyboard>` and `</keyboard>` in `rc.xml`.

    ```
        <keybind key="W-F6">
          <action name="Execute">
            <command>xbacklight - 10</command>
          </action>
        </keybind>
        <keybind key="W-F7">
          <action name="Execute">
            <command>xbacklight + 10</command>
          </action>
        </keybind>
    ```

* Restart Openbox (`Super-Space` ==> Settings ==> Openbox ==> Restart) to put the changes into effect.

See the `rc.xml` file in this repository for the full, edited file (will also contain other shortcuts for sound, page-up/down, home/end, delete, and caps lock). 

Keyboard shortcuts for Page-Up, Page-Down, Home, End, Delete, Caps Lock
---
The C720 keyboard does not have keys for these functions, so I use the following mappings. The page-up/down and home/end keys are the same default shortcuts that ChromeOS uses. Delete and caps lock are different:

* Page-up: `alt-up`
* Page-down: `alt-down`
* Home: `ctrl-alt-up`
* End: `ctrl-alt-down`
* Delete: `shift-backspace` (won't be able to hold it down though)
* Caps lock: `super-F4` (very important for yelling on the internet)

To do so we will take advantage of `xdotool`, which allows you to run keyboard or mouse events from the terminal. Steps:

* `ctrl-alt-up` and `ctrl-alt-down` are already mapped to something else in `rc.xml` that I don't use (they are mapped to workspace switching, but I prefer `ctrl-alt-left` and `ctrl-alt-righ` for workspace switching anyway), so comment them out. Roughly lines 196-207, near the start of the `<keyboard>` section. Comment a chunk by enclosing the lines between `<!--` and `-->`
* Add the following between `<keyboard>` and `</keyboard>` in `rc.xml`.

    ```
        <keybind key="A-Up">
          <action name="Execute">
            <command>xdotool key --clearmodifiers Page_Up</command>
          </action>
        </keybind>
        <keybind key="A-Down">
          <action name="Execute">
            <command>xdotool key --clearmodifiers Page_Down</command>
          </action>
        </keybind>
        <keybind key="C-A-Up">
          <action name="Execute">
            <command>xdotool key --clearmodifiers Home</command>
          </action>
        </keybind>
        <keybind key="C-A-Down">
          <action name="Execute">
            <command>xdotool key --clearmodifiers End</command>
          </action>
        </keybind>
        <keybind key="S-BackSpace">
          <action name="Execute">
            <command>xdotool key --clearmodifiers Delete</command>
          </action>
        </keybind>
        <keybind key="W-F4">
          <action name="Execute">
            <command>xdotool key Caps_Lock</command>
          </action>
        </keybind>
    ```

* Restart Openbox (`Super-Space` ==> Settings ==> Openbox ==> Restart) to put the changes into effect.

See the `rc.xml` file in this repository for the full, edited file (will also contain other shortcuts for brightness, and sound).

Source: [xdotool documentation](https://github.com/jordansissel/xdotool) (hosted on GitHub)
