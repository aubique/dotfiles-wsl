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

Personal dotfiles for setting up a development environment on Windows 11 using WSL2 with Ubuntu. Primary development tools:

- VSCode
- Windows Terminal

## Windows 11

### 1. [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)

Download **Sophia Script**:

```powershell
iwr script.sophia.team -useb | iex
```

Run customized preset (as Administrator):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; (New-Object System.Net.WebClient).DownloadString('https://gist.githubusercontent.com/aubique/871ad87ef7a801d17942ca3974cd9909/raw/e7d2d14297f6b098972dae0213f0072716b6a186/Sophie.ps1') | Out-File .\Sophie.ps1; .\Sophie.ps1
```

### 2. [WSL2](https://github.com/microsoft/wslg)

After restart, install [Ubuntu](https://docs.microsoft.com/en-us/windows/wsl/compare-versions):

```powershell
wsl --install -d Ubuntu
```

### 3. Dotfiles

Download and unpack dotfiles:

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aubique/dotfiles-wsl.git /tmp/tmpdotfiles \
&& rsync -vah --exclude '.git' /tmp/tmpdotfiles/ $HOME/ \
&& sudo rsync -vah $HOME/pub/etc/ /etc/
```

Run, configure and clean dotfiles:

```bash
for s in source "/etc/profile" "$HOME/.profile"; do source $s; done \
&& dotfiles config status.showUntrackedFiles no \
&& rm -r /tmp/tmpdotfiles \
&& cd $HOME \
&& dotfiles submodule update --init
```

### 4. User Shell Folders

Relocate default Windows shell folders (Documents, Downloads, etc.) to a dedicated partition while adopting Linux FHS structure:

```bash
bash $RUNSCRIPTS_PATH/relocate_user_shell_folders.sh
```

Features:

- Moves user folders to new partition/drive 🗂️
- Symlinks WSL `$HOME` directories to Windows shell folders 🔗
- Updates Windows PATH with new locations for cross-system access ⚙️
- Maintains Linux-style directory hierarchy (`/etc`, `/usr/local`, etc.) 🐧

## Package Management

### [Chocolatey](https://chocolatey.org/install)

Install **Chocolatey**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install **Windows apps and tools**:

```powershell
Get-Content \\wsl$\Ubuntu\home\*\pub\pkglist_choco.txt | Select-String -NotMatch '^#.*' | ForEach {iex "choco install -y $_"}
```

<details>
<summary>🛠️ Post-Install Tweaks</summary>

### VLC

Remove <b>VLC Media Player</b> Context Entries (as Administrator):

```powershell
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
Remove-Item HKCR:\Directory\shell\AddToPlaylistVLC\, HKCR:\Directory\shell\PlayWithVLC\ -Recurse
```

### 7-Zip

To simplify 7-Zip Context Menu open **7-Zip GUI** (as Administrator):

`Tools` → `Options` → `7-Zip` → [Uncheck `Integrate to shell context menu`]

</details>

### WSL2 Ubuntu

Install required **Ubuntu apt-packages**:

```bash
sudo apt update && grep -vE '^#' ~/pub/pkglist_apt.txt | xargs sudo apt install -y
```

## Dev Setup

### Git

Basic **Git** configuration:

```bash
git config --global push.default current
git config --global core.pager /usr/bin/less
```

Set username and email:

```bash
git config --global user.email "{{EMAIL}}"
git config --global user.name "{{USERNAME}}"
```

### SSH

Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "$(hostname | sed 's/^DESKTOP-//; s/.*/\L&/'):$(date -I)" -f ~/.ssh/id_ed25519_serv-user
```

### GitHub / GitLab

Copy SSH key to clipboard and add it:

```bash
xclip -sel c < ~/.ssh/id_ed25519_gl-user.pub
```

- [GitHub](https://github.com/settings/ssh/new)
- [GitLab](https://gitlab.com/-/user_settings/ssh_keys)

### [Docker](https://docs.docker.com/engine/install/ubuntu)

Remove any previous **Docker** installations:

```bash
sudo apt remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
```

Add **Docker**'s official GPG key:

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
```

Install **Docker** packages:

```bash
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Run **Docker** without `sudo`:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Verify installation:

```bash
docker run hello-world
```

### [Volta](https://docs.volta.sh/advanced/installers#skipping-volta-setup)

Install **Volta**, Node version manager:

```bash
mkdir -p $VOLTA_HOME
curl https://get.volta.sh | bash -s -- --skip-setup
```

Then install package managers and Angular:

```bash
volta install node npm @angular/cli
```

### [SDKMan](https://sdkman.io/install)

Install **SDKMan**, Java version manager:

```bash
curl -sSL "https://get.sdkman.io?rcupdate=false" | bash
```

Then install **JDK 21** of [Eclipse Temurin](https://sdkman.io/jdks/#tem) (formerly AdoptOpenJDK):

```bash
sdk install java 21.0.5-tem
```

### GPG keys

> If you have GPG keys for signing commits or password manager, backup to restore them on the new machine:
>
> ```bash
> gpg --list-secret-keys
> gpg --export-secret-keys {{KEY_ID}} > /tmp/private.key
> ```

Verify permissions for `gnupg`:

```bash
gpg --card-status
```

If you have "**Permission Denied**" problem, type:

```bash
mkdir -pv ~/.config/gnupg
find $GNUPGHOME -type d -exec sudo chown $USER:$USER {} \; -exec chmod 700 {} \;
find $GNUPGHOME -type f -exec sudo chown $USER:$USER {} \; -exec chmod 600 {} \;
```

Import GPG keys for signing:

```bash
gpg --import /tmp/private.key
```

## Troubleshooting

If you have problem with clipboard, for example when typing `echo foobar | wl-copy`, then you need to run:

```bash
sudo chmod +rx /mnt/wslg/runtime-dir
ln -s /mnt/wslg/runtime-dir/wayland-0* /run/user/1000/
```

> - [Cannot use GUI apps/tools as Wayland socket doesn't exist in `XDG_RUNTIME_DIR`](https://github.com/microsoft/WSL/issues/11261#issuecomment-2233443300)

## TODO

- [x] Upgrade Windows Tweaks
- [ ] Decouple `relocate_user_shell_folders.sh` from gist
