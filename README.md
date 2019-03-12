# Config files backup
A repository helping to set up and maintain the linux desktop environment. Most of the instructions are written for my own personal usage.
## Features
A copy of working space so there is no need to reconfigure most of the applications I work on with.
Tmux + Vim is representing itself a replacement of IDE for Python developing.
Bunch of Vim extensions get along with creating a minimalist IDE.
## Tech
This repository consists configuration for  applications and requires such preinstalled packages:
 1. Git
 2. Pip for python 3
 3. [Tmux](https://github.com/tmux/tmux/wiki)
 . [Tmuxp](https://tmuxp.git-pull.com/en/latest/)
 . Vim ver. 7.4+
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
If you'd like to set up your VIM-environment properly you need to install [Vundle](https://github.com/gmarik/Vundle.vim) extension manager. Let's get it installed:
```bash
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
Afterward, you have to open VIM and run `:PluginInstall` what would let you download and  all the plugins listed in *.vimrc*.
## Sources
I've got a lot for my system config back-up from [the unofficial guide to dotfiles on GitHub](https://dotfiles.github.io/). And the whole idea of exploiting at its finest VIM-based IDE was inspired particularly by RealPython article called [VIM and Python – A Match Made in Heaven](https://realpython.com/vim-and-python-a-match-made-in-heaven/).
## TODO
- [ ] Fill the features paragraph
- [ ] List VIM-extensions
- [ ] Add screenshots of IDE
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTg0NjQ0MTc5Niw3NDMzMDIwNTYsMTA0MD
U4NzU5Nl19
-->