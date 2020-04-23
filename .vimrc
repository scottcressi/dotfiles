"" PLUG INIT ------------------------------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"" PLUG START -----------------------------------------------------------------

call plug#begin('~/.vim/plugged')

"" PLUGINS --------------------------------------------------------------------

Plug 'scrooloose/nerdtree' " file drawer
Plug 'morhetz/gruvbox' " colors
Plug 'pseewald/vim-anyfold' " folding
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'itchyny/lightline.vim' " statusbar
Plug 'ervandew/supertab' " tabbing
Plug 'davidhalter/jedi-vim' " completion
Plug 'scrooloose/syntastic' " syntax
" Plugin 'fatih/vim-go' " go

"" PLUG END

call plug#end()

"" AUTO-INITIALIZATION --------------------------------------------------------

" nerdtree
" autocmd vimenter * NERDTree

" Automatic reloading of .vimrc
autocmd! bufwritepost _vimrc source %

" Show whitespace, MUST be inserted BEFORE the colorscheme command
autocmd BufWritePre * :%s/\s\+$//e
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" folding
autocmd Filetype * AnyFoldActivate "activate for all filetypes

"" GENERAL CONFIGURATION ------------------------------------------------------

" history
set history=7000 "history
set undolevels=7000 "undo history

" tabs and spaces
set tabstop=4
set shiftwidth=4
set shiftround
set expandtab
set smarttab

" search
set hlsearch "highlight search
set incsearch "search as your type
set ignorecase "ignore case
set smartcase

" backup files
set nobackup "no backup file
set nowritebackup "no backup file on write
set noswapfile "no swap file

" wrap
set textwidth=79 " width of document
set wrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing

" color column
set colorcolumn=80 "color column placement
highlight ColorColumn guibg=Black
let &colorcolumn="80,".join(range(120,120),",") "second color column

" escape key responsiveness for switching modes
set timeoutlen=1000 ttimeoutlen=0

"" PLUGIN CONFIGURATION -------------------------------------------------------

" color scheme
set t_Co=256 "256 terminal colors, hard requirement for color scheme
colorscheme gruvbox "color scheme
set background=dark "color scheme dark more

" folding
filetype plugin indent on " required
syntax on " required
set foldlevel=99 " Open all folds by default, set to 0 to close by default

" lightline
set laststatus=2 " status bar fix

" syntactic
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_error_symbol = "✗"
" let g:syntastic_warning_symbol = "⚠"
" let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']
" let g:go_version_warning = 0

"" REMAPPINGS -----------------------------------------------------------------

" fzf set location to ~/repos
noremap <C-P> :Files ~/repos<CR>

" nerdtree toggle
nmap <C-W> :NERDTreeToggle<CR>

" folding toggle
noremap <C-F> :set foldlevel=0<CR>
noremap <C-G> :set foldlevel=99<CR>

" generic quick quit
noremap <C-Q> :quit<CR>

" generic toggle line numbers
noremap <C-L> :set number<CR>
noremap <C-K> :set nonumber<CR>

" generic quick save
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" generic disable ex mode
noremap Q <NOP>
