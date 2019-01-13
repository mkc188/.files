" -------- basic initialization --------
let g:loaded_getscriptPlugin = 1
let loaded_gzip = 1
let loaded_logiPat = 1
let g:loaded_matchparen = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let loaded_rrhelper = 1
let loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_tar = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_vimball = 1
let g:loaded_zipPlugin = 1
let g:loaded_zip = 1

" -------- plugin manager --------
silent! if plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
let g:rsi_no_meta = 1
Plug 'thinca/vim-visualstar'
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
let g:undotree_SetFocusWhenToggle = 1
nnoremap <silent> <F5> :UndotreeToggle<CR>
Plug 'jeetsukumaran/vim-filebeagle'
let g:filebeagle_suppress_keymaps = 1
nmap <silent> - <Plug>FileBeagleOpenCurrentBufferDir
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <silent> <F3> :Files<CR>
nnoremap <silent> <F4> :Ag<CR>
Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }
Plug 'mbbill/fencview', { 'on': ['FencAutoDetect', 'FencView'] }
Plug 'tpope/vim-sleuth'
Plug 'sickill/vim-pasta'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-eunuch'
Plug 'Canop/patine'

call plug#end()
endif

" -------- base configuration --------
set ttimeoutlen=10
set history=1000
set encoding=utf-8
set hidden
set autoread
set fileformats=unix,dos,mac
set nrformats-=octal
set noshowcmd
set nomodeline
set complete=.
set completeopt=menu,noinsert
set tabpagemax=50
set sessionoptions-=options
set virtualedit=block,onemore
if v:version + has('patch541') >= 704
  set formatoptions+=j
endif
set nojoinspaces
set noshelltemp
set backspace=indent,eol,start
set autoindent
set smarttab
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set shiftround
set linebreak
if exists('+breakindent')
  set breakindent
  set showbreak=\ +
endif
set scrolloff=1
set sidescrolloff=5
set sidescroll=1
set display+=lastline
set wildmenu
set wildmode=longest,full
set splitbelow
set splitright
set visualbell
set t_vb=
set hlsearch
set incsearch
set ignorecase
set smartcase
set noswapfile
if exists('+undofile')
  set undofile
  set undodir=~/tmp,~/,.
endif
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
if v:version < 704 || v:version == 704 && !has('patch276')
  set shell=/usr/bin/env\ bash
endif

" -------- ui configuration --------
set showtabline=0
set nofoldenable
set synmaxcol=180
set lazyredraw
if has('statusline') && !&cp
  set laststatus=2
  set statusline=%t\ %m%r\ %l,%v\ %<%=
  set statusline+=%{&tabstop}:%{&shiftwidth}:%{&softtabstop}:%{&expandtab?'et':'noet'}
  set statusline+=\ %{&fileformat}
  set statusline+=\ %{strlen(&filetype)?&filetype:'None'}
endif

" -------- mappings --------
inoremap <C-U> <C-G>u<C-U>
nnoremap <silent> <BS> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><BS>
noremap <F1> :checktime<CR>
noremap <Space> :
inoremap <C-C> <Esc>
nnoremap <Tab> <C-^>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

xmap s "_d"0P
nnoremap x "_x
xnoremap x "_x

nnoremap Y y$
xnoremap Y "+y
noremap H ^
noremap L $
xnoremap L g_
nnoremap Q @q

" -------- autocmd --------
if has('autocmd')
  filetype plugin indent on

  augroup global_settings
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe 'normal! g`"zvzz' |
          \ endif
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
  augroup END

  augroup filetype_settings
    autocmd!
    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType cpp setlocal commentstring=//\ %s
  augroup END
endif

" -------- color schemes --------
if has('syntax')
  syntax enable
  syntax sync maxlines=200
  syntax sync minlines=50
  if !empty(glob('~/.vim/plugged/patine'))
    colorscheme patine
  endif
endif
