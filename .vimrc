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
"Plug 'romainl/Apprentice'
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
set t_Co=16
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
  if !empty(glob('~/.vim/plugged/Apprentice'))
    "colorscheme apprentice
  endif

  hi Normal ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi NonText ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi EndOfBuffer ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi LineNr ctermbg=black ctermfg=lightgrey cterm=NONE
  hi FoldColumn ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Folded ctermbg=black ctermfg=lightgrey cterm=NONE
  hi MatchParen ctermbg=black ctermfg=yellow cterm=NONE
  hi SignColumn ctermbg=black ctermfg=lightgrey cterm=NONE
  hi Comment ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi Conceal ctermbg=NONE ctermfg=lightgrey cterm=NONE
  hi Constant ctermbg=NONE ctermfg=red cterm=NONE
  hi Error ctermbg=NONE ctermfg=darkred cterm=reverse
  hi Identifier ctermbg=NONE ctermfg=darkblue cterm=NONE
  hi Ignore ctermbg=NONE ctermfg=NONE cterm=NONE
  hi PreProc ctermbg=NONE ctermfg=darkcyan cterm=NONE
  hi Special ctermbg=NONE ctermfg=darkgreen cterm=NONE
  hi Statement ctermbg=NONE ctermfg=blue cterm=NONE
  hi String ctermbg=NONE ctermfg=green cterm=NONE
  hi Todo ctermbg=NONE ctermfg=NONE cterm=reverse
  hi Type ctermbg=NONE ctermfg=magenta cterm=NONE
  hi Underlined ctermbg=NONE ctermfg=darkcyan cterm=underline
  hi Pmenu ctermbg=darkgrey ctermfg=lightgrey cterm=NONE
  hi PmenuSbar ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi PmenuSel ctermbg=darkcyan ctermfg=black cterm=NONE
  hi PmenuThumb ctermbg=darkcyan ctermfg=darkcyan cterm=NONE
  hi ErrorMsg ctermbg=black ctermfg=darkred cterm=reverse
  hi ModeMsg ctermbg=black ctermfg=green cterm=reverse
  hi MoreMsg ctermbg=NONE ctermfg=darkcyan cterm=NONE
  hi Question ctermbg=NONE ctermfg=green cterm=NONE
  hi WarningMsg ctermbg=NONE ctermfg=darkred cterm=NONE
  hi TabLine ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi TabLineFill ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi TabLineSel ctermbg=darkyellow ctermfg=black cterm=NONE
  hi ToolbarLine ctermbg=black ctermfg=NONE cterm=NONE
  hi ToolbarButton ctermbg=darkgrey ctermfg=lightgrey cterm=NONE
  hi Cursor ctermbg=lightgrey ctermfg=NONE cterm=NONE
  hi CursorColumn ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi CursorLineNr ctermbg=darkgrey ctermfg=cyan cterm=NONE
  hi CursorLine ctermbg=darkgrey ctermfg=NONE cterm=NONE
  hi helpLeadBlank ctermbg=NONE ctermfg=NONE cterm=NONE
  hi helpNormal ctermbg=NONE ctermfg=NONE cterm=NONE
  hi StatusLine ctermbg=darkyellow ctermfg=black cterm=NONE
  hi StatusLineNC ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi StatusLineTerm ctermbg=darkyellow ctermfg=black cterm=NONE
  hi StatusLineTermNC ctermbg=darkgrey ctermfg=darkyellow cterm=NONE
  hi Visual ctermbg=black ctermfg=blue cterm=reverse
  hi VisualNOS ctermbg=NONE ctermfg=NONE cterm=underline
  hi VertSplit ctermbg=darkgrey ctermfg=darkgrey cterm=NONE
  hi WildMenu ctermbg=blue ctermfg=black cterm=NONE
  hi Function ctermbg=NONE ctermfg=yellow cterm=NONE
  hi SpecialKey ctermbg=NONE ctermfg=darkgrey cterm=NONE
  hi Title ctermbg=NONE ctermfg=white cterm=NONE
  hi DiffAdd ctermbg=black ctermfg=green cterm=reverse
  hi DiffChange ctermbg=black ctermfg=magenta cterm=reverse
  hi DiffDelete ctermbg=black ctermfg=darkred cterm=reverse
  hi DiffText ctermbg=black ctermfg=red cterm=reverse
  hi IncSearch ctermbg=darkred ctermfg=black cterm=NONE
  hi Search ctermbg=yellow ctermfg=black cterm=NONE
  hi Directory ctermbg=NONE ctermfg=cyan cterm=NONE
  hi debugPC ctermbg=darkblue ctermfg=NONE cterm=NONE
  hi debugBreakpoint ctermbg=darkred ctermfg=NONE cterm=NONE
  hi SpellBad ctermbg=NONE ctermfg=darkred cterm=undercurl
  hi SpellCap ctermbg=NONE ctermfg=cyan cterm=undercurl
  hi SpellLocal ctermbg=NONE ctermfg=darkgreen cterm=undercurl
  hi SpellRare ctermbg=NONE ctermfg=red cterm=undercurl
  hi ColorColumn ctermbg=black ctermfg=NONE cterm=NONE
endif
