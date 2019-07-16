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

"" code tab completion
""Plugin 'ervandew/supertab'

"" status bar
""Plugin 'powerline/powerline'

"" linter
"" Plugin 'scrooloose/syntastic'

"" colors
Plugin 'michalbachowski/vim-wombat256mod'

"" folding (zc to close, zo to open)
Plugin 'tmhedberg/SimpylFold'

"" puppet
"" Plugin 'rodjek/vim-puppet'

"" completer
"" Plugin 'davidhalter/jedi-vim'

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

"" PLUGIN CONFIGURATION #######################################################

"" powerline
set laststatus=2

"" wombat256mod
set t_Co=256
colorscheme wombat256mod

"" folding
set nofoldenable

"" fzf
"" set key at location "~"
noremap <C-P> :Files ~<CR>

""" nerdtree
nmap <C-W> :NERDTreeToggle<CR>

"" SORT OUT ####################################################################

" Mouse and backspace
" set mouse=r  " on OSX press ALT and click
"" set bs=2     " make backspace behave like normal again


" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
"" let mapleader = ','


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
"" noremap <C-n> :nohl<CR>
"" vnoremap <C-n> :nohl<CR>
"" inoremap <C-n> :nohl<CR>


" Quicksave command
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" Quick quit command
noremap <C-Q> :quit<CR>  " Quit current window

" Enable syntax highlighting
" You need to reload this file for the change to apply
"" filetype off
"" filetype plugin indent on
"" syntax on
