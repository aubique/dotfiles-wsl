"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Filename: ~/.vimrc                                                                                        "
" Maintainer: Alexandre M. <alexander.matveev@univ-ubs.fr>                                                    "
"        URL: http://github.com/aubique/dotfiles/                                                             "
"                                                                                                             "
" Settings of the based editor aka VIM-Improved                                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
" Set syntax, UTF8-encoding, Line Numbering, Text Width, modelines
language en_US.UTF-8
syntax on
set encoding=utf-8
set number
set modelines=0

" Make backspace more powerful
set backspace=indent,eol,start

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5

" Automatically wrap text that extends beyond the screen length.
set wrap

" Highlight matces, incremental, case-insenstive and smartcase search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Display different types of white spaces
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" Store info from no more than 100 files, 9999 text lines, 100kb data.
set viminfo='100,<9999,s100

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_X

" Mouse controller and cursor position
set mouse=a
set ttymouse=xterm2
set ruler

" Press the <F2> key to toggle paste mode on/off for proper indentation
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

"----------Add the VirtualEnv site-packages to vim-path-----------------
"if has('python3')
"py3 << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
"    project_base_dir = os.environ['VIRTUAL_ENV']
"    sys.path.insert(0, project_base_dir)
"    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"    execfile(activate_this, dict(__file__=activate_this))
"EOF
"endif
"--------------End-of-Python-script-------------------------------------

" ---------------------------------- "
" Vim-GTK Clipboard
" ---------------------------------- "
set clipboard=unnamed,unnamedplus
" Use the system clipboard for yank/delete/paste operations
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" ---------------------------------- "
" Python PEP 8
" ---------------------------------- "
" More syntax highlighting.
au BufRead,BufNewFile *.py let python_highlight_all=1
" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4
" Spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4
" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw, set textwidth=72
au BufRead,BufNewFile *.py,*.pyw, set colorcolumn=73
" Use UNIX (\n) line endings
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix
" Keep Pythonic indentation level and folding based on indentation
autocmd FileType python set autoindent
autocmd FileType python set foldmethod=indent
" Make sure all types of requirements.txt files get syntax highlighting
au BufNewFile,BufRead requirements*.txt set syntax=python
" HTML/CSS/JS filetype indentation and highlight
au BufNewFile,BufRead *.mako,*.mak,*.jinja2 setlocal ft=html
au BufRead,BufNewFile,BufReadPost *.json set syntax=json
au FileType javascript setlocal shiftwidth=2 tabstop=2
au FileType html,xhtml,xml,css,htmldjango setlocal shiftwidth=2 tabstop=2
au FileType html,xhtml,xml,css,htmldjango,javascript,json setlocal expandtab
" Ensure tabs don't get converted to spaces in Makefiles
autocmd FileType make setlocal noexpandtab
" Spell check per filetype
autocmd FileType markdown,gitcommit setlocal spell

" ---------------------------------- "
" Configure VUNDLE
" ---------------------------------- "
filetype off
filetype plugin indent on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Fuzzy Finder
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'
" Custom IDE
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'tmhedberg/SimpylFold'
" Python
Plugin 'vim-scripts/indentpython.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'
"Plugin 'python/black'
" HTML/CSS
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'gko/vim-coloresque'
" JS
Plugin 'elzr/vim-json'
Plugin 'pangloss/vim-javascript'
" Markdown
Plugin 'plasticboy/vim-markdown'
" Color themes
Plugin 'vim-airline/vim-airline-themes'
Plugin 'morhetz/gruvbox'
" Finish loading VUNDLE
call vundle#end()

" ---------------------------------- "
" Configure SimplylFold
" ---------------------------------- "
let g:SimpylFold_docstring_preview = 0
" Use <space> to open/close folds
nnoremap <space> za
" Set SimplylFold to work along with mouse
set foldcolumn=2

" ---------------------------------- "
" Configure GruvBox colors
" ---------------------------------- "
let g:gruvbox_italic=1
let g:gruvbox_termcolors=256
let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=1
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox

" ---------------------------------- "
" Configure Tagbar
" ---------------------------------- "
nnoremap <F9> :TagbarToggle<CR>
" Minimum indent and width required to get along with 73 colorcolumn
let g:tagbar_width = 15
"let g:tagbar_indent = 0
"let g:tagbar_compact = 1

" ---------------------------------- "
" Configure NERDTree
" ---------------------------------- "
nnoremap <F8> :NERDTreeToggle<CR>
" Open NERDTree when Vim startsup and no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close Vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ---------------------------------- "
" Configure Jedi-vim
" ---------------------------------- "
let g:jedi#auto_initialization = 1
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#popup_select_first = 1
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "1"
let g:jedi#force_py_version = 3
"autocmd FileType python setlocal completeopt-=preview
let g:jedi#goto_command = "<localleader>gt"
let g:jedi#goto_assignments_command = "<localleader>ga"
let g:jedi#goto_definitions_command = "<localleader>gg"
let g:jedi#documentation_command = "<localleader>gd"
let g:jedi#usages_command = "<localleader>U"
let g:jedi#rename_command = "<localleader>R"

" ---------------------------------- "
" Configure Emmet-vim
" ---------------------------------- "
let g:user_emmet_settings = {
\ 'html' : {
\     'block_all_childless' : 1
\   }
\}

" python/Black formatting settings
"let g:black_linelength = 72
