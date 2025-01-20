<div align="center">
  <h1>WSL2 Ubuntu Environment</h1>
</div>
<div align="center">
  <img src="https://img.shields.io/github/license/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub license" />
  <img src="https://img.shields.io/github/stars/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub stars" />
  <img src="https://img.shields.io/github/last-commit/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub commits" />
</div>
<p align="center">
  <a href="#about">About</a> •
  <a href="#windows-11">Windows 11</a> •
  <a href="#chocolatey">Chocolatey</a> •
  <a href="#ubuntu">Ubuntu</a> •
  <a href="#todo">Todo</a>
</p>

## About

This repository contains configuration files for setting up a development environment on Windows using [WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions) with Ubuntu. Main tools are [Visual Studio Code](https://code.visualstudio.com/docs) and [IntelliJ IDEA](https://www.jetbrains.com/idea/features).

## Windows 11

Install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions) with Ubuntu:

```powershell
wsl --install -d Ubuntu
```

### Dotfiles

Download and synchronize dotfiles:

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aubique/dotfiles-wsl.git /tmp/tmpdotfiles \
&& rsync -vah --exclude '.git' /tmp/tmpdotfiles/ $HOME/ \
&& sudo rsync -vah $HOME/pub/etc/ /etc/
```

Finalize setup:

```bash
for s in source "/etc/profile" "$HOME/.profile"; do source $s; done \
&& dotfiles config status.showUntrackedFiles no \
&& rm -r /tmp/tmpdotfiles \
&& cd $HOME \
&& dotfiles submodule update --init
```

## Chocolatey

Install [Chocolatey](https://chocolatey.org/install):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install applications from `pkglist_choco.txt`:

```powershell
Get-Content \\wsl$\Ubuntu\home\*\pub\pkglist_choco.txt | Select-String -NotMatch '^#.*' | ForEach {iex "choco install -y $_"}
```

## Ubuntu

### Common Dependencies

Install common dependencies:

```bash
sudo apt update && grep -vE '^#' ~/pub/pkglist_apt.txt | xargs sudo apt install -y
```

### Git

Configure Git:

```bash
git config --global user.email "{{EMAIL}}"
git config --global user.name "{{USERNAME}}"
```

#### SSH Key

Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "$(hostname | sed 's/^DESKTOP-//; s/.*/\L&/'):$(date -I)" -f ~/.ssh/id_ed25519_serv-user
```

#### GitHub / GitLab

Copy SSH key to clipboard and add it:

```bash
xclip -sel c < ~/.ssh/id_ed25519_gl-user.pub
```
- [GitHub](https://github.com/settings/ssh/new)
- [GitLab](https://gitlab.com/-/user_settings/ssh_keys)

### GPG keys

Import GPG keys for signing:

```bash
gpg --import /tmp/private.key
```

## Docker

### Install Docker

Remove any previous Docker installations:

```bash
sudo apt remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
```

Add Docker's official GPG key:

```bash
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add the repository to Apt sources:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
```

Install Docker:

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Run Docker without `sudo`:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Verify installation:

```bash
docker run hello-world
```

## TODO

- [x] Upgrade Windows Tweaks
- [ ] Decouple `relocate_user_shell_folders.sh` from gist

## Useful Links & Examples

- https://github.com/microsoft/wslg
- https://docs.docker.com/engine/install/ubuntu
- https://github.com/daniellwdb/dotfiles
