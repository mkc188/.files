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

" -------- vim-rsi --------
inoremap <C-A> <C-O>^
inoremap <C-X><C-A> <C-A>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>

inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
cnoremap <C-B> <Left>

inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

" -------- plugin manager --------
"silent! if plug#begin('~/.vim/plugged')
""Plug 'romainl/Apprentice'
"call plug#end()
"endif

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
set softtabstop=2
set expandtab
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set shiftround
set nowrap
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
"set eventignore=all
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
set t_Co=16
set showtabline=0
if has('folding')
  set nofoldenable
endif
set synmaxcol=180
set lazyredraw
set regexpengine=0
if has('statusline') && !&cp
  set laststatus=2
  set statusline=%t\ %m%r\ %l,%v\ %<%=
endif

" -------- mappings --------
inoremap <C-U> <C-G>u<C-U>
nnoremap <silent> <BS> :checktime<CR>
nnoremap <silent> \ :FZF!<CR>
nnoremap <silent> <C-\> :Ag<CR>
nnoremap - :e %:p:h/<Tab>
noremap <Space> :
nnoremap <silent> <Enter> :set wrap!<CR>
inoremap <C-C> <Esc>
inoremap <C-P> <Up>
inoremap <C-N> <Down>
inoremap <C-]> <C-N>
nnoremap <Tab> <C-^>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap x "_x
xnoremap x "_x
nnoremap Y y$
xnoremap Y "+y
nnoremap Q @q
xnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

" -------- color schemes --------
if has('syntax')
  "syntax off
  if !empty(glob('~/.vim/plugged/Apprentice'))
    "colorscheme apprentice
  endif

  set background=dark
  highlight clear
  if exists("syntax_on")
    syntax reset
  endif
  let g:colors_name = "k16"

  hi Comment       cterm=None ctermfg=DarkGrey
  hi Identifier    cterm=Bold ctermfg=Grey
  hi Special       cterm=None ctermfg=Grey
  hi Statement     cterm=None ctermfg=Grey
  hi PreProc       cterm=None ctermfg=Grey
  hi Type          cterm=None ctermfg=Grey
  hi Constant      cterm=None ctermfg=Grey
  hi LineNr        cterm=None ctermfg=Blue
  hi String        cterm=None ctermfg=Green
  hi phpFunctions  cterm=Bold ctermfg=Yellow
  hi Pmenu         cterm=None ctermfg=Lightgrey   ctermbg=DarkGrey
  hi PmenuSel      cterm=None ctermfg=Black       ctermbg=LightGrey
  hi Visual        cterm=None ctermfg=Black       ctermbg=LightGrey
  hi DiffAdd       cterm=None ctermfg=Black       ctermbg=DarkGreen
  hi DiffDelete    cterm=None ctermfg=DarkRed     ctermbg=None
  hi DiffChange    cterm=None ctermfg=LightGrey   ctermbg=None
  hi DiffText      cterm=None ctermfg=Black       ctermbg=White
  hi TabLineSel    cterm=None ctermfg=White       ctermbg=None
  hi Todo          cterm=None ctermfg=Black       ctermbg=Red

  syntax sync minlines=200
  syntax sync maxlines=500

  silent! syntax on
endif

if has('autocmd')

" -------- vim-bracketed-paste --------
silent! let &t_ti .= "\<Esc>[?2004h"
silent! let &t_te = "\e[?2004l" . &t_te

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

silent! execute "set <f28>=\<Esc>[200~"
silent! execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" -------- fzf.vim --------
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
\ 'source':  printf('ag --nogroup --column --nocolor "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--exact',
\ 'down':    '50%'
\ })

augroup filetype_settings
  autocmd!
  autocmd FileType html :syntax sync fromstart
augroup END

endif

