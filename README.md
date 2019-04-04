# Config files backup
A repository helping to set up and maintain the linux desktop environment. Most of the instructions are written for my personal workflow.
## Features
- A synergy of `Vim` extensions to create **a minimalist developper IDE**.
- `Tmux` terminal muiltiplexer build which is **an appropriate alternative of `Screen`**.
- `Tmuxp` session manager designed for **automation and configuration of `Tmux` workflow**.
## Tech
This repository consists configuration for applications and requires the preinstalled packages listed below:
 1. Git
 2. Pip for python 3
 3. [Tmux](https://github.com/tmux/tmux/wiki)
 4. [Tmuxp](https://tmuxp.git-pull.com/en/latest/)
 5. Vim ver. 7.4+
 > The VIM version should be higher than 7.4.1578+ to be working properly with ***YouCompleteMe*** extension. Currently CentOS 7 doesn't support such version.
## Installation
Clone this project to your preferred folder. You can choose user download folder, `$HOME/Downloads`:
```bash
$ cd ~/Downloads
$ git clone https://github.com/ubqwita/dotfiles.git
$ cd dotfiles
```
Check out the downloaded files and pick some of them to the root-directory. For example, copy configs of Vim and Tmux over there:
```bash
cp .vimrc .tmux.conf ~/
```
### Putting VIM on its feet
If you'd like to set up your Vim-environment properly you need to install [Vundle](https://github.com/gmarik/Vundle.vim) extension manager. Let's get it installed:
```bash
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Afterward, you have to open Vim and run `:PluginInstall` what would let you download and  all the plugins listed in *.vimrc*.
## Sources
I've got quite a lot from [the unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/) to make a backup of my system configuration. And the whole idea of putting Vim to a good use as IDE was inspired particularly by RealPython article called [VIM and Python – A Match Made in Heaven](https://realpython.com/vim-and-python-a-match-made-in-heaven/).
## TODO
- [ ] Fill the features paragraph
- [ ] List VIM-extensions
- [ ] Add screenshots of Vim-IDE
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY4ODY1NzAzNSwtMTI1Nzg4MDQwNiw3ND
MzMDIwNTYsMTA0MDU4NzU5Nl19
-->