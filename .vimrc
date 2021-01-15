""TODO: implement easymotion

"" PLUG INIT ------------------------------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | :q
endif

"" PLUG START -----------------------------------------------------------------

call plug#begin('~/.vim/plugged')

"" PLUGINS --------------------------------------------------------------------

Plug 'morhetz/gruvbox' " colors
Plug 'pseewald/vim-anyfold' " folding
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'itchyny/lightline.vim' " statusbar
Plug 'ervandew/supertab' " tabbing
Plug 'scrooloose/syntastic' " syntax
Plug 'Valloric/YouCompleteMe', { 'commit':'d98f896' } " completion
Plug 'nvie/vim-flake8' " flake8
Plug 'vim-scripts/indentpython.vim' " python indentation
Plug 'easymotion/vim-easymotion' " easymotion

"" PLUG END

call plug#end()

"" VIMRC START

if !empty(glob('~/.vim/plugged/'))

"" AUTO-INITIALIZATION --------------------------------------------------------

" file tree
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" Automatic reloading of .vimrc
autocmd! bufwritepost _vimrc source %

" Show whitespace, MUST be inserted BEFORE the colorscheme command
autocmd BufWritePre * :%s/\s\+$//e
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" folding
autocmd Filetype * AnyFoldActivate "activate for all filetypes

" autocompile suckless
autocmd! bufwritepost config.h !make clean install

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

" youcompleteme
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let python_highlight_all=1
set encoding=utf-8

" file tree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

"" REMAPPINGS -----------------------------------------------------------------

" fzf set location to ~/repos
noremap <C-P> :Files ~/repos<CR>

" file tree toggle
noremap <silent> <C-W> :call ToggleNetrw()<CR>

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

"" VIMRC END
endif
