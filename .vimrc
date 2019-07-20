set nocompatible
" Set syntax, UTF8-encoding, Line Numbering, Text Width, modelines
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

" Clipboard working quite good with vim-gtk
set clipboard=unnamed,unnamedplus
" Use the system clipboard for yank/delete/paste operations
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

"------------Start Python PEP 8 stuff-----------------------------------
" More syntax highlighting.
au BufRead,BufNewFile *.py let python_highlight_all=1
" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4
" Spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4
" JS indentations
au FileType javascript setlocal shiftwidth=2 tabstop=2
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw, set textwidth=72
au BufRead,BufNewFile *.py,*.pyw, set colorcolumn=73
" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix
" Keep Pythonic indentation level and folding based on indentation
au FileType python set autoindent
au FileType python set foldmethod=indent
"------------Stop python PEP 8 stuff------------------------------------

" ---------------------------------- "
" Configure SimplylFold
" ---------------------------------- "
let g:SimpylFold_docstring_preview = 1
" Use <space> to open/close folds
nnoremap <space> za
" Set SimplylFold to work along with mouse
set foldcolumn=1

" ---------------------------------- "
" Configure VUNDLE
" ---------------------------------- "
filetype off
filetype plugin indent on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" List of Vundle-plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'chrisbra/csv.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Pythonic IDE
Plugin 'vim-scripts/indentpython.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'davidhalter/jedi-vim'
Plugin 'nvie/vim-flake8'
Plugin 'python/black'
" Colors
Plugin 'morhetz/gruvbox'
" Finish loading VUNDLE
call vundle#end()

" ---------------------------------- "
" Configure GruvBox colors
" ---------------------------------- "
let g:gruvbox_italic=1
let g:gruvbox_termcolors=256
let g:gruvbox_improved_strings=0
let g:gruvbox_improved_warnings=1

" Choose a colorcheme-theme
"set t_Co=16        "Get colors from ~/.Xresources
set background=dark
colorscheme gruvbox

" ---------------------------------- "
" Configure Tagbar
" ---------------------------------- "
nnoremap <F9> :TagbarToggle<CR>
" Minimum indent and width required to get along with 73 colorcolumn
let g:tagbar_width = 25
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

" python/Black formatting settings
let g:black_linelength = 72
