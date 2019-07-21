set nocompatible

set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undo

set incsearch
set ignorecase
set smartcase

set listchars=tab:>.,trail:.,nbsp:.
set list

set scrolloff=4
set tabstop=4
set shiftwidth=4
set expandtab
set numberwidth=1

set title
set titlestring=%F
set titleold=

set autochdir
set hidden

let base16colorspace=256
colorscheme base16-google-dark

filetype plugin indent on
syntax on

map <silent> - :silent set hlsearch! hlsearch?<cr>
map <silent> <tab> :set invnumber<cr>
map <silent> q :xa<cr>
map <silent> й :xa<cr>

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

let g:netrw_banner = 0

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
