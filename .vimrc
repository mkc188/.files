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

" -------- vim-bracketed-paste --------
let &t_ti .= "\<Esc>[?2004h"
let &t_te = "\e[?2004l" . &t_te

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" -------- plugin manager --------
silent! if plug#begin('~/.vim/plugged')
"Plug 'noahfrederick/vim-noctu'
call plug#end()
endif

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
\ 'source':  printf('ag --nogroup --column --nocolor "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--exact',
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
"set t_Co=0
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
nnoremap <silent> \ :FZF!<CR>
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
  "syntax off
  if !empty(glob('~/.vim/plugged/vim-noctu'))
    "colorscheme noctu
  endif

  set background=dark
  hi! clear
  if exists("syntax_on")
    syntax reset
  endif
  let g:colors_name = "noctu"
  "}}}
  " Vim UI {{{
  hi Normal              ctermfg=7
  hi Cursor              ctermfg=7     ctermbg=1
  hi CursorLine          ctermbg=0     cterm=NONE
  hi MatchParen          ctermfg=7     ctermbg=NONE  cterm=underline
  hi Pmenu               ctermfg=15    ctermbg=0
  hi PmenuThumb          ctermbg=7
  hi PmenuSBar           ctermbg=8
  hi PmenuSel            ctermfg=0     ctermbg=4
  hi ColorColumn         ctermbg=0
  hi SpellBad            ctermfg=1     ctermbg=NONE  cterm=underline
  hi SpellCap            ctermfg=10    ctermbg=NONE  cterm=underline
  hi SpellRare           ctermfg=11    ctermbg=NONE  cterm=underline
  hi SpellLocal          ctermfg=13    ctermbg=NONE  cterm=underline
  hi NonText             ctermfg=8
  hi LineNr              ctermfg=8     ctermbg=NONE
  hi CursorLineNr        ctermfg=11    ctermbg=0
  hi Visual              ctermfg=0     ctermbg=12
  hi IncSearch           ctermfg=0     ctermbg=13    cterm=NONE
  hi Search              ctermfg=0     ctermbg=10
  hi StatusLine          ctermfg=7     ctermbg=0     cterm=bold
  hi StatusLineNC        ctermfg=8     ctermbg=0     cterm=bold
  hi VertSplit           ctermfg=0     ctermbg=0     cterm=NONE
  hi TabLine             ctermfg=8     ctermbg=0     cterm=NONE
  hi TabLineSel          ctermfg=7     ctermbg=0
  hi Folded              ctermfg=6     ctermbg=0     cterm=bold
  hi Conceal             ctermfg=6     ctermbg=NONE
  hi Directory           ctermfg=12
  hi Title               ctermfg=3     cterm=bold
  hi ErrorMsg            ctermfg=15    ctermbg=1
  hi DiffAdd             ctermfg=0     ctermbg=2
  hi DiffChange          ctermfg=0     ctermbg=3
  hi DiffDelete          ctermfg=0     ctermbg=1
  hi DiffText            ctermfg=0     ctermbg=11    cterm=bold
  hi User1               ctermfg=1     ctermbg=0
  hi User2               ctermfg=4     ctermbg=0
  hi User3               ctermfg=2     ctermbg=0
  hi User4               ctermfg=3     ctermbg=0
  hi User5               ctermfg=5     ctermbg=0
  hi User6               ctermfg=6     ctermbg=0
  hi User7               ctermfg=7     ctermbg=0
  hi User8               ctermfg=8     ctermbg=0
  hi User9               ctermfg=15    ctermbg=5
  hi! link CursorColumn  CursorLine
  hi! link SignColumn    LineNr
  hi! link WildMenu      Visual
  hi! link FoldColumn    SignColumn
  hi! link WarningMsg    ErrorMsg
  hi! link MoreMsg       Title
  hi! link Question      MoreMsg
  hi! link ModeMsg       MoreMsg
  hi! link TabLineFill   StatusLineNC
  hi! link SpecialKey    NonText
  "}}}
  " Generic syntax {{{
  hi Delimiter       ctermfg=7
  hi Comment         ctermfg=8
  hi Underlined      ctermfg=4   cterm=underline
  hi Type            ctermfg=4
  hi String          ctermfg=11
  hi Keyword         ctermfg=2
  hi Todo            ctermfg=15  ctermbg=NONE     cterm=bold,underline
  hi Function        ctermfg=4
  hi Identifier      ctermfg=7   cterm=NONE
  hi Statement       ctermfg=2   cterm=bold
  hi Constant        ctermfg=13
  hi Number          ctermfg=12
  hi Boolean         ctermfg=4
  hi Special         ctermfg=13
  hi Ignore          ctermfg=0
  hi PreProc         ctermfg=8   cterm=bold
  hi! link Operator  Delimiter
  hi! link Error     ErrorMsg
endif
