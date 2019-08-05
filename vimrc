"" VUNDLE #####################################################################

" START - Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if iCanHazVundle == 0
  echo "Installing Bundles, please ignore error messages"
  echo ""
  :source $MYVIMRC
  :PluginInstall
endif
" END - Setting up Vundle - the vim plugin bundler

"" PLUGINS #####################################################################

Plugin 'scrooloose/nerdtree' " file drawer
Plugin 'morhetz/gruvbox' " colors
Plugin 'pseewald/vim-anyfold' " folding
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plugin 'junegunn/fzf.vim' " fzf
Plugin 'itchyny/lightline.vim' " statusbar
Plugin 'ervandew/supertab' " tabbing
Plugin 'davidhalter/jedi-vim' " completion
Plugin 'scrooloose/syntastic' " syntax
Plugin 'fatih/vim-go' " go

"" AUTO-INITIALIZATION ########################################################

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

"" GENERAL CONFIGURATION ######################################################

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

"" PLUGIN CONFIGURATION #######################################################

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
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_go_checkers = ['govet', 'errcheck', 'go']
let g:go_version_warning = 0

"" REMAPPINGS #################################################################

" fzf set location to ~
noremap <C-P> :Files ~<CR>

" nerdtree toggle
nmap <C-W> :NERDTreeToggle<CR>

" folding toggle
noremap <C-F> :set foldlevel=0<CR>
noremap <C-G> :set foldlevel=99<CR>

" generic saving force W and Q lowercase
cmap W w " remap W to w
cmap Q q " remap Q to q

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
