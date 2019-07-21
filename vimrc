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
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :source $MYVIMRC
  :PluginInstall
endif
" END - Setting up Vundle - the vim plugin bundler

"" PLUGINS #####################################################################

" file drawer
Plugin 'scrooloose/nerdtree'

" colors
Plugin 'morhetz/gruvbox'

" folding (zc to close, zo to open)
Plugin 'pseewald/vim-anyfold'

" fzf
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

" statusbar
Plugin 'itchyny/lightline.vim'

" tabbing for completion
Plugin 'ervandew/supertab'

" completion
Plugin 'davidhalter/jedi-vim'

" reactive stuff after vunlde has completed
call vundle#end()

"" AUTO-INITIALIZATION ########################################################

" nerdtree
" autocmd vimenter * NERDTree

" Automatic reloading of .vimrc
autocmd! bufwritepost _vimrc source %

" Show whitespace, MUST be inserted BEFORE the colorscheme command
autocmd BufWritePre * :%s/\s\+$//e
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

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

" disable Ex mode
noremap Q <NOP>

" line numbers
set number

" Quick save
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" Quick quit
noremap <C-Q> :quit<CR>

" escape key responsiveness for switching modes
set timeoutlen=1000 ttimeoutlen=0

"" PLUGIN CONFIGURATION #######################################################

" color scheme
set t_Co=256 "256 terminal colors, hard requirement for color scheme
colorscheme gruvbox "color scheme
set background=dark "color scheme dark more

" folding
filetype plugin indent on
syntax on
autocmd Filetype * AnyFoldActivate "activate for all filetypes
set foldlevel=0  " close all folds
set foldlevel=99 " Open all folds

" fzf , sets location to ~
noremap <C-P> :Files ~<CR>

" nerdtree
nmap <C-W> :NERDTreeToggle<CR>

" lightline status bar fix
set laststatus=2
