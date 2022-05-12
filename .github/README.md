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
  <a href="#windows-11">Windows 11</a> •
  <a href="#chocolatey">Chocolatey</a> •
  <a href="#ubuntu">Ubuntu</a> •
  <a href="#todo">Todo</a>
</p>

## About

These are the dotfiles that I use when I set up a new environment using Windows
and [WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions) with Ubuntu.
The setup is mainly focused on [IntelliJ IDEA](https://www.jetbrains.com/idea/features) being the primary working tool and for tasks related to programming,
for other tasks I am using [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal).

## Windows 11

To set up Windows 11 after fresh install in automatic mode,
let's download the [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows).

Download and expand the latest Powershell module of the script:
```powershell
irm script.sophi.app | iex
```

> Command below are meant to be executed in Administrator mode.

Set execution policy, get into the module directory, download our custom script preset and launch it:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Set-Location -Path ((New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path + '\Sophi*'); (New-Object System.Net.WebClient).DownloadString('https://gist.githubusercontent.com/aubique/871ad87ef7a801d17942ca3974cd9909/raw/345cb427742f6c835456bb5850737c9f13933bd1/Sophie.ps1') | Out-File .\Sophie.ps1; .\Sophie.ps1
```

Script will set up environment, customize appearance, remove telemetry and UWPApp bloatware.
For WSL2 it installs Virtual Machine Platform, WSL Kernel and GUI App Support (WSLg).
After you've completed running script functions, restart the PC and proceed with Linux distribution installation:
```powershell
wsl --install -d Ubuntu
```

<details>
  <summary>Install WSL2 manually</summary>

  Enable __WSL__ and __VirtualMachinePlatform__ features in Powershell console:

  ```powershell
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
  ```

  Reboot your PC. Download and install the
  [Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi):

  Install the update via Powershell:
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

- [Install Ubuntu from __Microsoft Store__](https://www.microsoft.com/fr-fr/p/ubuntu/9nblggh4msv6)
- [Install Ubuntu from __Chocolatey__](https://community.chocolatey.org/packages/wsl-ubuntu-2004)
</details>

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
for s in source "/etc/profile" "$HOME/.profile"; do source $s; done
dotfiles config status.showUntrackedFiles no
rm -r tempfiles
```

Get back to $HOME and synchronize the sub-modules:
```bash
cd && dotfiles submodule update --init
```

<details>
  <summary>Install <b>Vim</b> plugins</summary>

  This repo contains a [Vundle](https://github.com/gmarik/Vundle.vim) sub-module repository.
  That's an extension manager that helps to manage environment with plugins properly.

  In case you didn't get managed to download Vundle plugin during the [set above](#dotilfes),
  clone it directly from GitHub:
  ```bash
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.local/share/vim/bundle/Vundle.vim
  ```

  Afterwards, you have to open **Vim** and run `:PluginInstall`
  that downloads automatically the plugins listed in your `$VIMDOTDIR/vimrc`.

  If you've got `Warning: Cannot find word list` error message,
  create *spell* folder and download the files:
  ```bash
  mkdir -pv ~/.config/vim/spell
  vim 1.md +'set spell'
  ```
</details>

### User Shell Folders

There is no point to keep all the user files on drive `C:\` or the same partition that has the Windows directory.
You can't move all user files but you can certainly relocate Documents,
Pictures, Videos, Downloads, Music to a different partition (drive).

While you allocate a distinct partition with `diskmgmt.msc`,
you may find more intuitive to adopt Linux Filesystem Hierarchy Standard (FHS) on it.
Then synchronize the Windows user shell folders with WSL home user folders.

You can change user folder programmatically executing the script with interactive prompt:
```bash
bash $RUNSCRIPTS_PATH/relocate_user_shell_folders.sh
```

> The bash script is provided with `ps1` scripts, so make sure that Powershell is initialized properly.

The script automates such tasks:

1. Move User Shell folder location to another drive or directory
2. Link the $HOME user folders for WSL to the existing Windows user shell folders
3. Update Windows system PATH environment variable with the links on new partition

## Chocolatey

[Chocolatey](https://github.com/chocolatey/choco)
is software management automation for Windows that wraps installers,
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
Get-Content \\wsl$\Ubuntu\home\*\pub\pkglist_choco.txt | Select-String -NotMatch '^#.*' | ForEach {iex "choco install -y $_"}
```

### Context Menu & Fixes

After having installed Chocolatey and packages,
you may want to clean up the context menu.

<details>
  <summary>Remove <b>VLC</b> from context menu.</summary>

  ```powershell
  New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
  Remove-Item HKCR:\Directory\shell\AddToPlaylistVLC\ -Recurse
  Remove-Item HKCR:\Directory\shell\PlayWithVLC\ -Recurse
  ```
</details>

<details>
  <summary>Hide <b>7-Zip</b> cascaded context menu.</summary>

  With `regedit.exe` you can find `HKEY_CLASSES_ROOT\CLSID{23170F69-40C1-278A-1000-000100020000}`
  that's linked to the 7-Zip DLL file. All 7-Zip context menu options are defined in this DLL file,
  they're invoked every time Windows needs to show the menu and thus not static.

  You can disable these options with 7-Zip GUI (as Admin) via menu
  __Tools -- Options -- 7-Zip -- Integrate 7-Zip to shell context menu__
</details>

<details>
  <summary>Bypass Windows requirements check in <b>Ventoy</b></summary>

  Ventoy is a good solution for installing Windows 11 on incompatible devices.
  That said we have to explicitly set in JSON config the parameter `VTOY_WIN11_BYPASS_CHECK`,
  that creates certain Registry keys to bypass RAM, TMP, Secure Boot, CPU and Storage checks on the machine.

  Run this in WSL2 to add the configuration JSON file to the `ventoy` subfolder installed with Chocolatey:
  ```bash
  powershell.exe "choco list -lo" | grep ventoy && \
  cp -fT ~/pub/etc/ventoy.json "$(readlink -e /mnt/c/Users/*/AppData/Local/ventoy/ventoy)/ventoy.json"
  ```
</details>

> For Windows 10 you can use another [Powershell debloater](https://github.com/Sycnex/Windows10Debloater) from GitHub.

### Windows Terminal

In order to open the administrative shell in Windows Terminal you may want to use
[Gsudo](https://github.com/gerardog/gsudo), `sudo` equivalent for Windows.
It allows to run commands with elevated permissions,
or to elevate the current shell, in the current console window or a new one.

> In case you it's not installed with other packages, you can run `choco install gsudo`

Now you can elevate permissions `powershell.exe gsudo powershell.exe -nologo`.
If you set it up in `settings.json` you can launch it on Windows Terminal.
To do that, you can paste the content of profiles.

- Windows 11: `$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
- WSL 2: `/mnt/c/Users/*/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json`

<details>
  <summary><b><code>settings.json</code></b></summary>

```
{
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "launchMode": "maximized",
    "defaultProfile": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "profiles":
    {
        "defaults":
        {
            "closeOnExit": "graceful",
            "cursorColor": "#FFFFFF",
            "cursorShape": "filledBox",
            "font": 
            {
                "face": "Cascadia Code",
                "size": 12
            },
            "hidden": false,
            "snapOnInput": true
        },
        "list":
        [
            {
                "name": "Ubuntu WSL \ud83d\udccc",
                "commandline": "wsl genie -c ~/.config/scripts/genie-tmux.sh",
                "guid": "{2862b68e-b019-4846-bbdd-5f10c363cb1a}",
                "bellStyle": 
                [
                    "window",
                    "taskbar"
                ],
                "font": 
                {
                    "face": "Lucida Console"
                },
                "icon": "https://assets.ubuntu.com/v1/49a1a858-favicon-32x32.png",
                "acrylicOpacity": 0.90000000000000002,
                "suppressApplicationTitle": true,
                "useAcrylic": true
            },
            {
                "name": "Ubuntu WSL \u25a4",
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
                "source": "Windows.Terminal.Wsl",
                "colorScheme": "Raspberry"
            },
            {
                "name": "PowerShell \u26a1",
                "commandline": "powershell.exe gsudo powershell.exe -nologo",
                "guid": "{a266a539-53e6-4b70-abf9-dfd2f76a2b97}",
                "icon": "ms-appx:///Images/Square44x44Logo.targetsize-32.png",
                "suppressApplicationTitle": true,
                "padding": "0, 0, 0, 0"
            },
            {
                "name": "PowerShell",
                "commandline": "powershell.exe",
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "colorScheme": "Campbell Powershell"
            }
        ]
    },
    "schemes": 
    [
        {
            "name" : "Raspberry",
            "background" : "#3C0315",
            "black" : "#282A2E",
            "blue" : "#0170C5",
            "brightBlack" : "#676E7A",
            "brightBlue" : "#80c8ff",
            "brightCyan" : "#8ABEB7",
            "brightGreen" : "#B5D680",
            "brightPurple" : "#AC79BB",
            "brightRed" : "#BD6D85",
            "brightWhite" : "#FFFFFD",
            "brightYellow" : "#FFFD76",
            "cyan" : "#3F8D83",
            "foreground" : "#FFFFFD",
            "green" : "#76AB23",
            "purple" : "#7D498F",
            "red" : "#BD0940",
            "white" : "#FFFFFD",
            "yellow" : "#E0DE48"
        }
    ],
```
</details>

The WSL environment we're about to setup has an environment variable -
`${WIN_TERM}` that stores in `.bashrc` a path to the Windows Terminal `settings.json`.
Follow the steps above to get Ubuntu and dotfiles installed.

> WSL2 startup `genie-tmux.sh` script uses __Genie__ systemd and __Tmux__ multiplexer,
>mostly described in the [Genie installation step](#systemd).

Check out [docs.microsoft.com](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/profile-appearance)
to figure out the profile settings in Windows Terminal.

### Windows Firewall

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
sudo apt update && grep -vE '^#' ~/pub/pkglist_apt.txt | xargs sudo apt install -y
```

### SSH Server

To run `sshd` on WSL2 machine, you should generate and upload the SSH key to your WSL2 environment.
It's well described in the ["How To Generate and Upload SSH keys" gist](https://gist.github.com/aubique/b3ce68a043c46d7ae537bc98e7b4285d).

For the first connection you can enable SSH password authentication via port 32022:

```bash
sudo ssh-keygen -A
sudo sed -E -e 's/^[# ]*(Port )[0-9]+$/\132022/g' -e 's/^[# ]*(PasswordAuthentication )no/\1yes/g' -i /etc/ssh/sshd_config
```

Execute the alias `sshd_up` to run SSH server.

### Git

Configure Git:
```bash
git config --global push.default current
git config --global core.pager /usr/bin/less
```

Set username and email:
```bash
git config --global user.email "{{EMAIL}}"
git config --global user.name "{{USERNAME}}"
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
> For title you can pick a name of the key, such as `WSL2 (gl-au.pub): 2022-05-12`

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

### Systemd

Allow starting services like Docker with a systemd "bottle",
[arkane-systems/genie](https://github.com/arkane-systems/genie).

Set up Microsoft repository (Genie depends on .NET)
```bash
curl -sL -o /tmp/packages-microsoft-prod.deb "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb
```

Set up Arkane-Systems GPG key:
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

Copy the custom config to the system one:
```bash
sudo cp -f ~/pub/etc/genie.ini /etc/genie.ini
```

<details>
  <summary>Disable unwanted <code>systemd</code> services</summary>

  Services without `#` are supposed to be disabled, the ones with `#` are for complete masking:
  ```bash
  grep -vE '^#' ~/pub/systemd_disabled.txt | xargs sudo systemctl disable
  sed -En 's/#([a-z0-9\.-])/\1/p' pub/systemd_disabled.txt | xargs sudo systemctl mask
  ```
</details>


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

  E.g. in `/etc/apt/preferences.d/` have a file named `docker` with the command:
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
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
```

Now you can start Docker daemon via [Systemd](#systemd).

### Docker compose

```bash
sudo curl -sL -o /usr/local/bin/docker-compose \
  $(curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep -i "browser_download_url.*$(uname -s)-$(uname -m)" | grep -v sha \
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
curl -sSL "https://get.sdkman.io?rcupdate=false" | bash
```

To initialize SDKMAN module scripts open a new terminal.
Otherwise, run the following in the existing one:
```bash
source $SDKMAN_DIR/bin/sdkman-init.sh
```

Install AdoptOpenJDK 11:
```bash
sdk install java 11.0.11.hs-adpt
```

## TODO

- [x] Upgrade the [Windows Tweaks part](#tweaks) with refined integration scripts for Windows 11.
- [ ] Explain how to use git repository to [sync IDE settings](#intellij-idea).

## Resources

### Examples
- https://github.com/daniellwdb/dotfiles
- https://github.com/Alex-D/dotfiles

### Useful links and docs
- https://github.com/microsoft/wslg
- https://github.com/arkane-systems/genie/wiki
- https://github.com/abergs/ubuntuonwindows
- https://docs.docker.com/engine/install/ubuntu
- https://github.com/jonaspetersorensen/dotfiles-wsl
- https://stackoverflow.com/questions/37776684/which-intellij-config-files-should-i-save-in-my-dotfiles
- https://askubuntu.com/questions/759880/where-is-the-ubuntu-file-system-root-directory-in-windows-subsystem-for-linux-an
- https://stefanos.cloud/kb/how-to-clear-the-powershell-command-history
- https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver15#ubuntu
