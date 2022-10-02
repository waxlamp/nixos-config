set encoding=utf-8

set nocompatible
filetype off

set shell=/bin/bash

" Plugins
call plug#begin()

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'vimwiki/vimwiki', {'branch': 'dev'}
Plug 'mattn/calendar-vim'
Plug 'tpope/vim-speeddating'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'posva/vim-vue'
Plug 'vim-scripts/gitignore'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'

call plug#end()

" Keyboard shortcuts
"
" Use comma as map leader.
let mapleader=","

" Enable easy editing/reloading of vimrc file.
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Easy window navigation.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Easy line navigation
nmap j gj
nmap k gk

" Shortcut for reformatting block of text.
nmap Q gqap

" Yank to system clipboard.
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Paste from system clipboard.
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Allow for Alt-l to exit from normal mode (personal habit of mine in vim; not
" supported natively by Neovim).
vnoremap <A-l> <esc>

" Insert the current date or time.
inoremap jkd <C-r>=strftime("%Y-%m-%d")<CR>
inoremap jkt <C-r>=strftime("%H:%M:%S")<CR>

" Activate filetype plugin, and syntax highlighting.
filetype indent plugin on
syntax on

" Activate solarized colorscheme.
syntax enable
set background=dark
set termguicolors
colorscheme solarized

" Disable highlighting of search results.
set nohlsearch

" Fix for gitgutter issues
set shell=/bin/bash

au FileType rst setlocal formatoptions-=a

" This causes vim to check for the file having been changed if the cursor does
" not move in Insert mode for 200 milliseconds.  Unfortunately, the updatetime
" variable is also used by vim to know when to write the .swp file to disk.
" This might cause disk performance issues (?) or some other problem.  The
" vimdocs mention that some day CursorHold and CursorHoldI may get their own
" interval variable, rather than double-dipping like this.
"set updatetime=200
set updatetime=1200
autocmd CursorHoldI,CursorHold * :checktime

set autoread

set ignorecase
set smartcase

set directory=~/.config/nvim/swapfile//

set nofoldenable

" Maintain equal-sized split window when the terminal window size changes.
autocmd VimResized * wincmd =

" General text settings (compatible with python editing as well).
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set textwidth=80

" Hide buffers instead of closing.
set hidden

" Incremental search.
set incsearch

" Infinite undo.
set undofile
set undodir=~/.vim/undofiles

" Prevent black hole edit combos.
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Vimwiki options.
let g:vimwiki_list = [
  \   {'path': '~/vimwiki/kitware', 'path_html': '/home/roni/vimwiki/html/kitware'},
  \   {'path': '~/vimwiki/personal', 'path_html': '/home/roni/vimwiki/html/personal'}
  \ ]

augroup VimwikiKeyMap
    autocmd!
    autocmd FileType vimwiki inoremap <silent><buffer> <CR>
                \ <C-]><Esc>:VimwikiReturn 3 5<CR>
augroup END

" Better Whitespace options.
let g:better_whitespace_enabled=1
nnoremap <leader>ss :StripWhitespace<CR>

" Nerdcommenter options
let g:NERDCustomDelimiters = {'javascript': { 'left': '// ', 'leftAlt': '/*', 'rightAlt': '*/' }}

" Nerdtree keybindings.
nnoremap <leader>nn :NERDTreeToggle<CR>
nnoremap <leader>nm :NERDTreeFind<CR>

" Vim compatibility.
cnoremap <A-l> <Esc>
tnoremap <A-l> <Esc>

" FZF options
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" gitgutter options
let g:gitgutter_max_signs = 500

" vim-vue options
let g:vue_pre_processors = 'detect_on_enter'
autocmd Filetype vue set ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.typescript.css

" Filetype settings
autocmd Filetype javascript set ts=2 sw=2 sts=2
au BufRead,BufNewFile Vagrantfile set ft=ruby
autocmd Filetype markdown set fo=tqn2 ts=2 sw=2 tw=80
autocmd Filetype python set fo=crqal
