" -------- basic initialization --------
silent! let g:loaded_getscriptPlugin = 1
silent! let loaded_gzip = 1
silent! let loaded_logiPat = 1
silent! let g:loaded_matchparen = 1
silent! let g:loaded_netrw = 1
silent! let g:loaded_netrwPlugin = 1
silent! let loaded_rrhelper = 1
silent! let loaded_spellfile_plugin = 1
silent! let g:loaded_tarPlugin = 1
silent! let g:loaded_tar = 1
silent! let g:loaded_2html_plugin = 1
silent! let g:loaded_vimballPlugin = 1
silent! let g:loaded_vimball = 1
silent! let g:loaded_zipPlugin = 1
silent! let g:loaded_zip = 1

" -------- plugin manager --------
if has('autocmd')

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })

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
set completeopt=longest
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
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
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
set wildmode=list:longest
set wildcharm=<Tab>
set wildignorecase
set splitbelow
set splitright
set visualbell
set t_vb=
set nohlsearch
set incsearch
set ignorecase
set smartcase
set noswapfile
set eventignore=all
if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
if v:version < 704 || v:version == 704 && !has('patch276')
  set shell=/usr/bin/env\ bash
endif
set runtimepath+=/usr/local/opt/fzf,~/.fzf

" -------- ui configuration --------
set t_Co=0
set showtabline=0
if has('folding')
  set nofoldenable
endif
set synmaxcol=180
set lazyredraw
if has('statusline') && !&cp
  set laststatus=2
  set statusline=%t\ %m%r\ %l,%v\ %<%=
endif

" -------- mappings --------
inoremap <C-U> <C-G>u<C-U>
nnoremap <silent> <BS> :checktime<CR>
nnoremap <silent> \ :FZF<CR>
nnoremap <silent> <C-\> :Ag<CR>
nnoremap - :e %:p:h<Tab><Tab>
noremap <Space> :
inoremap <C-C> <Esc>
nnoremap <Tab> <C-^>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap x "_x
xnoremap x "_x
nnoremap Y y$
xnoremap Y "+y
nnoremap Q @q

" -------- color schemes --------
if has('syntax')
  syntax off
endif
