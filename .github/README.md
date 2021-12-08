<div align="center">
  <h1>WSL2 Ubuntu environment</h1>
</div>

<div align="center">
  <img src="https://img.shields.io/github/license/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub license" />
  <img src="https://img.shields.io/github/stars/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub stars" />
  <img src="https://img.shields.io/github/last-commit/aubique/dotfiles-wsl?style=for-the-badge" alt="GitHub commits" />
</div>

<p align="center">
  <a href="#about">About</a> •
  <a href="#wsl2">WSL2</a> •
  <a href="#chocolatey">Chocolatey</a> •
  <a href="#ubuntu">Ubuntu</a> •
  <a href="#todo">Todo</a>
</p>

## About

These are the dotfiles that I use when I set up a new environment using Windows
and [WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions) with Ubuntu.
The setup is mainly focused on [IntelliJ IDEA](https://www.jetbrains.com/idea/features) being the primary working tool and for tasks related to programming,
for other tasks I am using [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal).

## WSL2

### Install Windows Linux Subversion 2

Enable __WSL__ and __VirtualMachinePlatform__ features in Powershell console:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```
> Commands are meant to be executed as Administrator

Reboot your PC. Download and install the
[Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi):

<details>
  <summary>Install the update via Powershell (as admin).</summary>

  ```powershell
  $wslUpdateInstallerUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
  $downloadFolderPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
  $wslUpdateInstallerFilePath = "$downloadFolderPath/wsl_update_x64.msi"
  $wc = New-Object System.Net.WebClient
  $wc.DownloadFile($wslUpdateInstallerUrl, $wslUpdateInstallerFilePath)
  Start-Process -Filepath "$wslUpdateInstallerFilePath"
  ```
</details>

Set WSL default version to __2__
```powershell
wsl --set-default-version 2
```

- [Install Ubuntu from __Microsoft Store__](https://www.microsoft.com/fr-fr/p/ubuntu/9nblggh4msv6)
- [Install Ubuntu from __Chocolatey__](https://community.chocolatey.org/packages/wsl-ubuntu-2004)

### Dotfiles

As soon as Ubuntu distribution is installed you can download the dotfiles.
To avoid conflict with the existing files you can clone it the temporary folder.
Then copy with `rsync` your dotfiles to $HOME directory.

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aubique/dotfiles-wsl.git tempfiles
rsync -vah --exclude '.git' tempfiles/ $HOME/
sudo rsync -vah $HOME/pub/etc/ /etc/
```

Once we're done with synchronizing our config files,
we delete temporary folder, update configs, sub-modules and aliases.

```bash
rm -r tempfiles
for s in source "/etc/profile" "$HOME/.profile"; do source $s; done
dotfiles submodule update --init
```

## Chocolatey

Chocolatey is software management automation for Windows that wraps installers,
executables, zips and scripts into compiled packages.

### Install Chocolatey CLI

First, ensure that you are using an administrative shell.

To [install Chocolatey](https://chocolatey.org/install#individual)
with `powershell.exe` paste the copied text into your shell and press Enter:
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Now you can manage Windows applications and [packages](https://community.chocolatey.org/packages)
using Chocolatey in administrative shell, check out a list of installed packages with `choco list --local`.

Install a pack of applications listed in `pkglist_choco.txt`:
```ps1
Get-Content \\wsl$\Ubuntu*\home\*\pub\pkglist_choco.txt | Select-String -NotMatch '^#.*' | ForEach {choco install -y $_}
```

### Tweaks

You may want to clean up the context menu and make some useful tweaks for Windows 11.

<details>
  <summary>Remove <b>VLC</b> from context menu.</summary>

  ```powershell
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
  Remove-Item HKCR:\Directory\shell\AddToPlaylistVLC\ -Recurse
  Remove-Item HKCR:\Directory\shell\PlayWithVLC\ -Recurse
  ```
</details>

> Prior to running any of the scripts below please inspect files to ensure safety.

Commit some tweaks to the Registry Editor by importing the gist.
```powershell
Invoke-Command {reg import https://gist.github.com/aubique/cb81f8064cc0e034eb0b2660037c8f33/raw/64c7b9680122eb3d49a63d94f1163d4567385540/windows-tweaks.reg *>&1 | Out-Null}
```

Then, we debloat Windows and remove unwanted apps:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://gist.githubusercontent.com/y0lopix/bca18265869e5da9068de0a6729bc262/raw/64c7b9680122eb3d49a63d94f1163d4567385540/windows-uninstall-apps.ps1'))
```

> For Windows 11 you can also use the fine-tuning [__Sophia Script__](https://github.com/farag2/Sophia-Script-for-Windows.git) from GitHub.

#### Windows Firewall

You can set a rule in `wf.msc` by subnet and interface dedicated to WSL2:
```powershell
New-NetFirewallRule -DisplayName "from WSL2" -Direction Inbound -Action Allow -LocalAddress "172.16.0.0/12" -InterfaceAlias "vEthernet (WSL)"
```

You can also allow SSH connections on 32022 and open other ports to access VMWare virtual machines.
```powershell
New-NetFirewallRule -DisplayName "SSH/RDP > WSL2" -Direction Inbound -Action Allow -Protocol TCP -LocalAddress 192.168.1.0/24,172.16.0.0/12 -LocalPort 32022,3389
New-NetFirewallRule -DisplayName "SSH/HTTP(S) > VMWare" -Direction Inbound -Action Allow -Protocol TCP -LocalAddress 192.168.1.0/24,172.16.0.0/12,172.28.144.0/24 -LocalPort 32020,32021,32023-32025,32080,32443,64190
```

> To set up SSH Server on WSL2, [check out the step describing it below](#ssh-server).

### Windows Terminal

In order to open the administrative shell in Windows Terminal you may want to use
[Gsudo](https://github.com/gerardog/gsudo), `sudo` equivalent for Windows.
It allows to run commands with elevated permissions,
or to elevate the current shell, in the current console window or a new one.

> In case you it's not installed with other packages, you can run `choco install gsudo`

Now you can elevate permissions `powershell.exe gsudo powershell.exe -nologo`.
If you set it up in `settings.json` you can launch it on Windows Terminal.

To do that, you can paste the content of profiles to
`C:\Users\YOUR-USER\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`:

<details>
  <summary><b><code>settings.json</code></b></summary>

  ```
  {
      "profiles":
      {
          "defaults":
          {
              ...,
              "cursorColor": "#FFFFFF",
              "cursorShape": "bar",
              "font":
              {
                  "face": "Cascadia Code",
                  "size": 12
              },
              ...
          },
          "list":
          [
              {...},
              {
                  "name": "PowerShell \u26a1",
                  "commandline": "powershell.exe gsudo powershell.exe -nologo",
                  "guid": "{a266a539-53e6-4b70-abf9-dfd2f76a2b97}",
                  "icon": "ms-appx:///Images/Square44x44Logo.targetsize-32.png",
                  "suppressApplicationTitle": true,
                  "padding": "0, 0, 0, 0"
              },
              {
                  "name": "Ubuntu WSL \ud83d\udccc",
                  "commandline": "wsl genie -c ~/.config/scripts/genie-tmux.sh",
                  "guid": "{2862b68e-b019-4846-bbdd-5f10c363cb1a}",
                  "icon": "ms-appdata:///roaming/ubuntu_32px.png",
                  "suppressApplicationTitle": true
              },
              {
                  "name": "Ubuntu WSL \u25a4",
                  "source": "Windows.Terminal.Wsl",
              }
          ]
      }
  }
  ```
</details>

The WSL environment we're about to setup has an environment variable -
`${WIN_TERM}` that stores in `.bashrc` a path to the Windows Terminal `settings.json`.
Follow the steps above to get Ubuntu and dotfiles installed.

> WSL2 startup `genie-tmux.sh` script uses __Genie__ systemd and __Tmux__ multiplexer,
>mostly described in the [Genie installation step](#systemd).

Check out [docs.microsoft.com](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/profile-appearance)
to figure out the profile settings in Windows Terminal.

### IntelliJ IDEA

To synchronize IDE settings between different machines you can use 2 ways:
1. IDE Settings Sync plugin
2. Git repository for settings

If you have [JetBrains Account](https://account.jetbrains.com/login) with license activated,
the no-brainer would be to link the settings to your account, since no additional configuration is required.

> Check out [JetBrains Docs](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html)
>for more info about sharing IDE settings.

## Ubuntu

Install Ubuntu packages and proceed with setup of the WSL2 environment.

#### Common dependencies

Now we can install common dependencies and packages to setup our environment:
```bash
grep -vE '^#' ~/pub/pkglist_apt.txt | xargs sudo apt install -y
```

### Vim

This repo contains a [Vundle](https://github.com/gmarik/Vundle.vim) sub-module repository.
That's an extension manager that helps to manage environment with plugins properly.

In case you couldn't download Vundle plugin during the [Dotfiles installation step](#dotilfes),
clone it directly from GitHub:
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.local/share/vim/bundle/Vundle.vim
```

Afterwards, you have to open **Vim** and run `:PluginInstall` that downloads the plugins listed in your `$VIMDOTDIR/vimrc`.

### GPG keys

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

> You can check permissions for gnupg with `gpg --card-status`

If you have __"Permission Denied"__ problem then you can type:
```bash
mkdir -pv ~/.config/gnupg
find $GNUPGHOME -type d -exec sudo chown $USER:$USER {} \; -exec chmod 700 {} \;
find $GNUPGHOME -type f -exec sudo chown $USER:$USER {} \; -exec chmod 600 {} \;
```

### Git

Configure Git and set username/email:
```bash
git config --global user.email "{{EMAIL}}"
git config --global user.name "{{USERNAME}}"
git config --global push.default current
git config --global core.pager /usr/bin/less
```

#### SSH Key

In order to manage your git repositories via SSH you should generate a new key on your new machine.

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

#### GitHub / GitLab

Copy the public key to the clipboard:
```bash
xclip -sel c < ~/.ssh/id_rsa_gl-user.pub
```

Add the generated pubic SSH keys to your profile:
- [Add your key to __GitHub__](https://github.com/settings/ssh/new)
- [Add your key to __GitLab__](https://gitlab.com/-/profile/keys)
> For title you can pick a name of the key, such as `WSL2 (gl-au.pub): 2021-12-07`

### SSH Server

To run `sshd` on WSL2 machine, you should generate and upload the SSH key to your WSL2 environment.
It's well described in the ["How To Generate and Upload SSH keys" gist](https://gist.github.com/aubique/b3ce68a043c46d7ae537bc98e7b4285d).

For the first connection you can enable SSH password authentication via port 32022:

```bash
sudo ssh-keygen -A
sudo sed -E -e 's/^[# ]*(Port )[0-9]+$/\132022/g' -e 's/^[# ]*(PasswordAuthentication )no/\1yes/g' -i /etc/ssh/sshd_config
sudo service ssh restart
```

### Systemd

Allow starting services like Docker with a systemd "bottle",
[arkane-systems/genie](https://github.com/arkane-systems/genie).

Setup Microsoft repository (Genie depends on .NET)
```bash
curl -sL -o /tmp/packages-microsoft-prod.deb "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb
```

Setup Arkane-Systems GPG key:
```bash
sudo curl -sL -o /usr/share/keyrings/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
```

Add its repository to the sources.list:
```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/wsl-transdebian.gpg] \
  https://arkane-systems.github.io/wsl-transdebian/apt/  $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/wsl-transdebian.list > /dev/null
```

[Install __Genie__](https://github.com/arkane-systems/genie#debian):
```bash
sudo apt update && sudo apt install -y systemd-genie
```

Disable unwanted `systemd` services:
```bash
cat ~/pub/systemd_disabled.txt | xargs sudo systemctl disable
```

Install custom config by replacing the system one:
```bash
sudo cp /pub/etc/genie.ini /etc/genie.ini
```

Or by linking it:
```bash
sudo ln -sf ~/pub/etc/genie.ini /etc/genie.ini
```

### Docker

First, download a repository key into individual file in a directory dedicated for them.

> On __Ubuntu__ the standard convention is `/usr/share/keyrings`
>but any directory works (aside from `/etc/apt/trusted.gpg` which is the system keystore)

For the key provided in ascii-armor, like Docker's is, you'll need to dearmor the key to create a binary version, e.g.:
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Then update your source file to refer to the Docker's key.
E.g., in `/etc/apt/sources.list.d/` have a file named `docker.list` with the contents:
```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

> This ensure that only files downloaded from official Docker repository can be signed by the that gpg key.
>Having the key in the system keystore allows any package in any repository to be signed by the docker key.
>Should that key ever compromised, it could be used to sign *anything*, coming from *anywhere*, like a hacked version of your kernel.

<details>
  <summary><b>Optional step</b>. For further security, create a <i>preferences</i> file.</summary>

  E.g. in `/etc/apt/preferences.d/` have a file named `docker` with the contents:
  ```
  sudo tee /etc/apt/preferences.d/docker <<EOF
  Package: *
  Pin: origin "download.docker.com"
  Pin-Priority: 100
  EOF
  ```
  
  > Setting the `Pin-Priority` to a value less than other repositories, which are 500 by default,
  >prevents packages in the Docker repository from overriding packages with the same name from default repositories.
  >This way you don't get the standard system package (e.g. new version of openssl) from Docker repository unless you specifically request it.
</details>

Update the `apt` package index, install the latest version of Docker Engine
and containerd and add user to `docker` group:
```bash
sudp apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
```

Now you can start Docker daemon via [Systemd](#systemd).

### Docker compose

```bash
sudo curl -sL -o /usr/local/bin/docker-compose \
  $(curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep "browser_download_url.*$(uname -s)-$(uname -m)" | grep -v sha \
  | cut -d: -f2,3 | tr -d \")
```

Make `docker-compose` executable:
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

### Volta

[Volta](https://github.com/volta-cli/volta) is a fast and reliable JavaScript tool manager.

[Install __Volta__](https://docs.volta.sh/advanced/installers#skipping-volta-setup) while skipping `volta setup`:
```bash
mkdir -p $VOLTA_HOME
curl https://get.volta.sh | bash -s -- --skip-setup
```

Install package managers and `ng-cli`:
```bash
volta install node npm @angular/cli
```

### SDKman

[SDKman](https://github.com/sdkman/sdkman-cli) is a tool for managing
parallel versions of multiple Software Development Kits for the JVM such as Java,
Gradle, Maven, Spring Boot and others.

[Install __SDKman__](https://sdkman.io/install) without modifying shell config:
```bash
mkdir -p $SDKMAN_DIR
curl -s "https://get.sdkman.io?rcupdate=false" | bash
```

Install AdoptOpenJDK 11:
```bash
sdk install java 11.0.11.hs-adpt
```

## TODO

- [ ] Upgrade the [Windows Tweaks part](#tweaks) with refined integration scripts for Windows 11.
- [ ] Add a license and animated GIF screenshot of the IDE.
- [ ] Explain how to use git repository to [sync IDE settings](#intellij-idea).

## Resources

### Examples
- https://github.com/daniellwdb/dotfiles
- https://github.com/Alex-D/dotfiles

### Useful links and docs
- https://github.com/abergs/ubuntuonwindows
- https://github.com/arkane-systems/genie/wiki
- https://docs.docker.com/engine/install/ubuntu
- https://github.com/jonaspetersorensen/dotfiles-wsl
- https://stackoverflow.com/questions/37776684/which-intellij-config-files-should-i-save-in-my-dotfiles
- https://askubuntu.com/questions/759880/where-is-the-ubuntu-file-system-root-directory-in-windows-subsystem-for-linux-an
