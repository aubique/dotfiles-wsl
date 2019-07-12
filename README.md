# Config files backup
A repository helping to set up and maintain the linux desktop environment. Most of the instructions are written for my personal workflow.
## Features
- Set of `Vim` extensions to create **a minimalist developper IDE**.
- `Tmux` terminal muiltiplexer build which is **an appropriate alternative of `Screen`**.
- `Tmuxp` session manager designed for **automation and configuration of `Tmux` workflow**.
## Tech
This repository consists configuration for applications and requires the preinstalled packages listed below:
 1. Git
 2. Pip for Python 3.7
 3. [Tmux](https://github.com/tmux/tmux/wiki)
 4. [Tmuxp](https://tmuxp.git-pull.com/en/latest/)
 5. Vim
## Installation
Clone this project to your preferred folder. You can choose user download folder, `$HOME/Downloads`:
```bash
$ git clone https://github.com/aubique/dotfiles.git ~/Downloads/dotfiles/
$ cd ~/Downloads/dotfiles
```
Check out the downloaded files and pick some of them to the home-directory. For example, copy the content of repo:
```bash
cp -r * ~/
```
### Putting VIM on its feet
If you'd like to set up your Vim-environment properly you need to install [Vundle](https://github.com/VundleVim/Vundle.vim) extension manager. Let's get it installed:
```bash
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Afterward, you have to open Vim and run `:PluginInstall` what would let you download and  all the plugins listed in *.vimrc*.
## Sources
I've got quite a lot from [the unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/) to make a backup of my system configuration. And the whole idea of putting Vim to a good use as IDE was inspired particularly by RealPython article called [VIM and Python – A Match Made in Heaven](https://realpython.com/vim-and-python-a-match-made-in-heaven/).
## TODO
- [ ] Fill the features paragraph
- [ ] List VIM-extensions
- [ ] Add screenshots of Vim-IDE
