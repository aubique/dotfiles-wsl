![2019-11-19-002159_1366x768_scrot](https://user-images.githubusercontent.com/36281550/69102426-b7815280-0a62-11ea-985b-8ecdc5f0cc09.png)

# Configuration files

That's the repository that helps to maintain my linux desktop environment. Most of the instructions are written for my personal workflow.

## Features

- Customize minimalist IDE with essential tools
- Manage multiple terminal sessions
- Configure and automate development workflow

## Prerequisites

This repository consists a configuration for various applications most of which need the packages listed below:

 1. SVN system -`git`
 2. Based text editor - `vim`
 3. Terminal multiplexer - `tmux`
 4. Session manager - `tmuxp`
 5. Python package installer - `pip`

## Installation

Well, we wanna make `$HOME` the git *work-tree* but we don't want the entire user folder to be in a repo?

That's where a git *bare* repository comes to play, the method I came across with recently. That looks more simple and elegant for versioning your configuration that symlink though.

So let's get started!

### Git Bare Repository

We create a dummy folder and initialize a *bare git repository*, essentially a repo with no working directory in there.

We gonna set an alias with a *dummy folder* for git files and *$HOME* for work directory. We don't mess up other repos and git commands in *$HOME* if we run the git commands this way.

So let's get started!

#### First Time Setup

Create a git bare repository.

```bash
$ mkdir .dotfiles
$ git init --bare $HOME/.dotfiles
```
Append the alias to `.bashrc`:

```bash
$ echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"' >> $HOME/.bashrc
$ source $HOME/.bashrc
```

Then using this command add a remote and set *status* not to show untracked files:

```bash
$ dotfiles config --local status.showUntrackedFiles no
$ dotfiles remote add origin git@github.com:aubique/dotfiles.git
```

### Setting Up a New Machine

There are like two ways of fetching your dotfiles on your new machine. The first one is simply clone to your user folder.

> Your alias in `$HOME/.bashrc` should be already set up.
> The commands you can find in section above.

However, in your *$HOME* directory git might find existing config files. So you can clone it to a temporary folder:

```bash
$ git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aubique/dotfiles.git tmpdotfiles
```

Copy by `rsync` your configs to *$HOME*-directory.

Once we're done with synchronizing our config files we delete temporary folder:

```bash
$ rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
$ rm -r tmpdotfiles
```

#### Git and Bash configuration

Restore the custom git configuration:

```bash
$ git config --global uesr.user=aubique
$ git config --global user.email=email
$ git config --global push.default=current
$ git config --global alias.l=log --all --decorate --oneline --graph
```

For git-completion showing a current active git branch add the lines listed below to `.bashrc`:

```bash
[[ -f /usr/share/git/completion/git-completion.bash ]] && . /usr/share/git/completion/git-completion.bash
[[ -f /usr/share/git/completion/git-prompt.sh ]] && . /usr/share/git/completion/git-prompt.sh
PS1='\t \[\033[01;32m\]\u\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
```

#### Putting Vim on its Feet

This repo contains a [Vundle](https://github.com/gmarik/Vundle.vim) submodule repository.
That's an extenstion manager that helps to manage environment with plugins properly.

Let's get it installed:
```bash
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Afterward, you have to open **Vim** and run `:PluginInstall` that downloads the plugins listed in your `.vimrc`.

### GitHub SSH key

In case you access a github server via SSH you should generate a new key on your new machine.
GitHub documentation proposes to use a `ssh-agent` for managing keys.
That's a temporary solution that has to be done every session.

Beforehand you should generate a new SSH key:
```bash
$ ssh-keygen -t rsa -b 4096 -C "email"
```

Then it would propose you to choose a directory and filename for the key.
> For directory you should use absolute path from the root

Once generated you can force the key files to be kept permanently in your `~/.ssh/config` file.
To set the key specific to one host, you can do the following in config:
```
Host github.com
    User git
    IdentityFile ~/.ssh/id_rsa_github
```

After setting up a local configuration for SSH you should add the private key to GitHub account.
Copy the SSH key to your clipboard:

> Make sure you have `xclip` installed.
```bash
$ xclip -sel c < ~/.ssh/id_rsa_github.pub
```

Then go to GitHub account, click **Settings -> SSH and GPG keys -> New SSH Key** and paste it into the **Key** field.

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
$ setxkbmap -model pc105 -layout us,ru -variant ,, -option grp:alt_shift_toggle -option compose:ralt
```

### Hardware Database files
> **This section is deprecated!**

`hwdb` is a key-value store for associating modalias-like keys to `udev`-property-like values. It maps the scan codes from your keyboard to standard key codes, and `/etc/udev/hwdb.d/` provides a means of customization, which allows overriding the way scan codes are mapped.

> Key mappings can be changed using `xmodmap` in the **Xorg** layer even though it's a considerably outdated method.

#### Try out the new keymapping

The actual rules read by udev upon boot is a compiled binary file called `hwdb.bin`, so one will need to compile the configuration files into binary.

Copy `90-isa-aerbook.hwdb` to the local administration directory `/etc/udev/hwdb.d/` then run commands to make the changes take effect immediately:
```
# systemd-hwdb update
# udevadm trigger
```

To verify whether keycodes are working in the intended way watch X display events with `xev`:
```bash
$ xev | grep -Fi key
```

## Multimedia

**VLC** is a default video player in the most of Linux distros.

### Streaming to Chromecast

Starting with 3.0 release (Vetinari branch), **VLC** can stream to chromecast devices on the same wireless network.

Install packages:
 1. `libmicrodns` - VLC can find the chromecast device and it shows up in **Playback > Renderer** menu
 2. `protobuf` - enables streaming to the selected device in **Playback > Renderer** menu

## Sources

[ArchWiki](https://wiki.archlinux.org/) always helps a lot to get valuable information that is collected in a single place.

I've got inspired by the [the unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/) to make my own backup for the system configuration files I'm currently using and therefore make it more easy to pass them on other machines.

I also used these articles to create my own dotfiles configuration:

- RealPython: [VIM and Python – A Match Made in Heaven](https://realpython.com/vim-and-python-a-match-made-in-heaven/).
- Anand Iyer Blog: [A simpler way to manage your dotfiles](https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html)
- Github docs: [Generating a new SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Yulistic Gitlab: [Linux keymapping with udev hwdb](https://yulistic.gitlab.io/2017/12/linux-keymapping-with-udev-hwdb/)
- Zhanghai blog: [Remapping ThinkPad Keys with udev hwdb](https://blog.zhanghai.me/remapping-keys-with-udev-hwdb)

## TODO

- [x] Merge with `xubuntu` branch
- [x] Add screenshots with Cirno
- [x] Generate SSH keys for Github with an example of `.ssh/config`
- [ ] Describe how to switch between JVM
- [ ] Throw away the outdated `hwdb` section
