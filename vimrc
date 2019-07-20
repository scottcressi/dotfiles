"" VUNDLE #####################################################################

"" required by Vundle
set nocompatible
filetype off

"" add runtime path to include Vundle and initalize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"" plugins

"" plugin manager
Plugin 'gmarik/Vundle.vim'

"" file drawer
Plugin 'scrooloose/nerdtree'

"" colors
Plugin 'michalbachowski/vim-wombat256mod'

"" folding (zc to close, zo to open)
Plugin 'pseewald/vim-anyfold'

"" fzf
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

"" reactive stuff after vunlde has completed
call vundle#end()

"" AUTO-INITIALIZATION ########################################################

"" nerdtree
"" autocmd vimenter * NERDTree

"" Automatic reloading of .vimrc
autocmd! bufwritepost _vimrc source %

"" Show whitespace
"" MUST be inserted BEFORE the colorscheme command
autocmd BufWritePre * :%s/\s\+$//e
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

"" GENERAL CONFIGURATION ######################################################

"" History
set history=700
set undolevels=700

"" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab " conflicts with tab arrows

"" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Disable stupid backup and swap files - they trigger too many events
"" for file system watchers
set nobackup
set nowritebackup
set noswapfile

"" Colors
syntax enable
set background=dark

"" Showing line numbers and length
set tw=79   " width of document (used by gd)
set wrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=233

"" Better copy & paste
"" When you want to paste large blocks of code into vim, press F2 before you
"" paste. At the bottom you should see ``-- INSERT (paste) --``.
set paste
" set pastetoggle=<F2>
" set clipboard=unnamed

"" disable Ex mode
noremap Q <NOP>

"" show relative line numbers
set number "relativenumber

"" show tabs as arrows
set list
"set listchars=tab:▸\ ,eol:¬
set listchars=tab:▸\ ,

" Quicksave command
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" Quick quit command
noremap <C-Q> :quit<CR>  " Quit current window

" Mouse and backspace
set mouse=r  " on OSX press ALT and click
set bs=2     " make backspace behave like normal again

"" PLUGIN CONFIGURATION #######################################################

"" wombat256mod
set t_Co=256
colorscheme wombat256mod

"" folding
filetype plugin indent on " required
syntax on                 " required
autocmd Filetype * AnyFoldActivate " activate for all filetypes
set foldlevel=0  " close all folds
set foldlevel=99 " Open all folds

"" fzf
"" set key at location "~"
noremap <C-P> :Files ~<CR>

""" nerdtree
nmap <C-W> :NERDTreeToggle<CR>
