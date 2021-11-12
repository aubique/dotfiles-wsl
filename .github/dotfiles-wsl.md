<div align="center">
  <h1>WSL Ubuntu environment</h1>
</div>

<div align="center">
  <img src="https://img.shields.io/github/license/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub license" />
  <img src="https://img.shields.io/github/stars/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub stars" />
  <img src="https://img.shields.io/github/last-commit/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub commits" />
</div>

<p align="center">
  <a href="#about">About</a> •
  <a href="#install">Install</a> •
  <a href="#setup">Setup</a> •
  <a href="#todo">Todo</a>
</p>

## About

These are the dotfiles that I use when I set up a new environment using Windows
and [WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions) with Ubuntu.
The setup is mainly focused on [IntelliJ IDEA](https://www.jetbrains.com/idea/features) being the primary working tool and for tasks related to programming,
for other tasks I am using [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal).

## Install

### WSL 2

> Command below are meant to be executed as Administrator

Enable __WSL__ and __VirtualMachinePlatform__ features in Powershell console:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Download and install the [Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi):

```powershell
$wslUpdateInstallerUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$downloadFolderPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$wslUpdateInstallerFilePath = "$downloadFolderPath/wsl_update_x64.msi"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($wslUpdateInstallerUrl, $wslUpdateInstallerFilePath)
Start-Process -Filepath "$wslUpdateInstallerFilePath"
```

Set WSL default version to __2__
```powershell
wsl --set-default-version 2
```

- [Install Ubuntu from Microsoft Store](https://www.microsoft.com/fr-fr/p/ubuntu/9nblggh4msv6)
- [Install Ubuntu from Chocolatey](https://community.chocolatey.org/packages/wsl-ubuntu-2004)

### Setup

#### Dotfiles

As soon as Ubuntu distribution is installed you can download the dotfiles.
To avoid conflict with the existing files you can clone it the temporary folder.
Then copy with `rsync` your dotfiles to $HOME directory.

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aubique/dotfiles-wsl.git tempfiles
rsync -vah --exclude '.git' tempfiles/ $HOME/
sudo rsync -vah $HOME/pub/etc/ /etc/
```

Once we're done with synchronizing our config files we delete temporary folder,
update configs, sub-modules and aliases.

```bash
rm -r tempfiles
dotfiles git submodule update --init
source /etc/profile /etc/bash.bashrc .profile .bashrc
```

#### Common dependencies

Now we can install common dependencies and packages to setup our environment:

```bash
grep -vE '^#' ~/pub/pkglist_apt.txt | xargs sudo apt install -y
```

#### Vim

This repo contains a [Vundle](https://github.com/gmarik/Vundle.vim) sub-module repository.
That's an extension manager that helps to manage environment with plugins properly.

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.local/share/vim/bundle/Vundle.vim
```

Afterward, you have to open **Vim** and run `:PluginInstall` that downloads the plugins listed in your `.vimrc`.

#### GPG keys

If you have GPG secret keys for signing commits or password manager, restore them.

On old system, create a backup of a GPG key:

```bash
gpg --list-secret-keys
gpg --export-secret-keys {{KEY_ID}} > /tmp/private.key
```

On new system, import the key:

```bash
gpg --import /tmp/private.key
```

Delete the `/tmp/private.key` on both side and install password manager you prefer.

> You can check gnupg with `gpg --card-status`.

If you have __"Permission Denied"__ problem then you can type:

```bash
mkdir -pv ~/.config/gnupg
find $GNUPGHOME -type d -exec sudo chown $USER:$USER {} \; -exec chmod 700 {} \;
find $GNUPGHOME -type f -exec sudo chown $USER:$USER {} \; -exec chmod 600 {} \;
```

#### Git

Configure Git and set username/email:

```bash
git config --global user.email "{{EMAIL}}"
git config --global user.name "{{USERNAME}}"
git config --global push.default=current
git config --global core.pager /usr/bin/less
```

##### SSH Key

In order to manage your git-repositories via SSH you should generate a new key on your new machine.

Generate a new SSH key:

```bash
ssh-keygen -t rsa -b 4096 -C "$(lsb_release -cs):$(date -I)" -f ~/.ssh/id_rsa_serv-user
```

Once generated you can force the key files to be kept permanently in your `~/.ssh/config` file.
To set the key specific to one host, you can do the following in config:

```
Host gitlab
	User git
	HostName gitlab.com
	PreferredAuthentications publickey
	IdentityFile ~/.ssh/id_rsa_gl-user
```

##### GitHub / GitLab

Copy the public key to the clipboard:

```bash
xclip -sel c < ~/.ssh/id_rsa_gl-user.pub
```

Add the generated pubic SSH keys to your profile:

- [Add your key to __GitHub__](https://github.com/settings/ssh/new)
- [Add your key to __GitLab__](https://gitlab.com/-/profile/keys)

> For title you can pick a name of the key, such as `WSL2 (gl-au.pub): 2021-12-07`

## TODO

- [x] Add link `.profile` -> `~/.config/profile` and commit changes
- [x] Update `~/pub/pkglist_apt.txt` with common dependencies
- [ ] Install `nvm`, `sdkman`
- [ ] Describe the installation of __Genie__, __Docker__ and other tools for Windows

## Resources

### Sources
- https://github.com/daniellwdb/dotfiles
- https://github.com/Alex-D/dotfiles

### Useful links
- https://github.com/dencold/dotfiles
- https://github.com/jonaspetersorensen/dotfiles-wsl
