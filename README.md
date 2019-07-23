# Config files backup

A repository helping to set up and maintain the linux desktop environment. Most of the instructions are written for my personal workflow.

## Features

- Set of `Vim` extensions to create **a minimalist developer IDE**.
- `Tmux` terminal multiplexer build which is **an appropriate alternative of `Screen`**.
- `Tmuxp` session manager designed for **automation and configuration of `Tmux` workflow**.

## Tech

This repository consists configuration for applications and requires the preinstalled packages listed below:

 1. Git
 2. Pip for Python 3.7
 3. [Tmux](https://github.com/tmux/tmux/wiki)
 4. [Tmuxp](https://tmuxp.git-pull.com/en/latest/)
 5. Vim 8+

## Installation

Clone this project to your preferred folder. You can choose user download folder, `$HOME/Downloads`:
```bash
$ git clone https://github.com/aubique/dotfiles.git ~/Downloads/dotfiles/
$ cd ~/Downloads/dotfiles
```

Check out the downloaded files and pick some of them to the home-directory. For example, copy the content of repo:
```bash
$ cp -r * ~/
```

### Putting VIM on its feet

If you'd like to set up your Vim-environment properly you need to install [Vundle](https://github.com/VundleVim/Vundle.vim) extension manager. Let's get it installed:
```bash
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Afterward, you have to open **Vim** and run `:PluginInstall` what would let you download and  all the plugins listed in *.vimrc*.

## Keyboard Layouts

Adding one more language to `i3wm` set of keyboard layouts is some kind of tricky process.

There are two common ways to do that:

 1. Override system-wide configration with `localectl`
 2. Explicitly set XKB configration on start-up with `setxkbmap`

### Xorg/Keyboard configuration

The **Xorg** server uses the X keyboard extension (**XKB**) to define keyboard layouts.

You can use the following command to see the actual XKB settings:
```bash
$ setxkbmap -print -verbose 10
```

The simplest and explicit way to set multiple keyboard-layouts is `setxkbmap` included in i3-config:
```bash
$ setxkbmap -model pc105 -layout us,ru -variant ,, -option grp:alt_shift_toggle
```

### Hardware Database files

`hwdb` is a key-value store for associating modalias-like keys to `udev`-property-like values. It maps the scan codes from your keyboard to standard key codes, and `/etc/udev/hwdb.d/` provides a means of customization, which allows overriding the way scan codes are mapped.

> Key mappings can be changed using `xmodmap` in the **Xorg** layer even though it's a considerably outdated method.

#### Try out the new keymapping

The actual rules read by udev upon boot is a compiled binary file called `hwdb.bin`, so one will need to compile the configuration files into binary.

Copy `90-isa-aerbook.hwdb` to the local administration directory `/etc/udev/hwdb.d/` then run commands to make the changes take effect immediately:
```bash
# systemd-hwdb update
# udevadm trigger
```

To verify whether keycodes are working in the intended way watch X display events with `xev`:
```bash
xev | grep -Fi key
```

## Multimedia

**VLC** is a default video player in the most of Linux distros.

### Streaming to Chromecast

Starting with 3.0 release (Vetinari branch), **VLC** can stream to chromecast devices on the same wireless network.

Install packages:
 1. `libmicrodns` - VLC can find the chromecast device and it shows up in **Playback > Renderer** menu
 2. `protobuf` - enables streaming to the selected device in **Playback > Renderer** menu

## Sources

I've got quite a lot from [the unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/) to make a backup of my system configuration. And the whole idea of putting Vim to a good use as IDE was inspired particularly by RealPython article called [VIM and Python – A Match Made in Heaven](https://realpython.com/vim-and-python-a-match-made-in-heaven/).

[ArchWiki](https://wiki.archlinux.org/) always helps a lot to get valuable information that is collected in a single place.

I also used these articles to create my own dotfiles configuration:
- Yulistic Gitlab: [Linux keymapping with udev hwdb](https://yulistic.gitlab.io/2017/12/linux-keymapping-with-udev-hwdb/)
- Zhanghai blog: [Remapping ThinkPad Keys with udev hwdb](https://blog.zhanghai.me/remapping-keys-with-udev-hwdb)

## TODO

- [ ] Fill the features paragraph
- [ ] Add screenshots of Vim-IDE
