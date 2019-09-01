set guicursor+=n-v-c:blinkon0
set nocompatible 
filetype on

filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete


"Better copy & paste
set pastetoggle=<F2>

set tabstop=2
set expandtab
set shiftwidth=2
set fileformats=unix
set linespace=0
set ignorecase smartcase
set textwidth=78
set number
set mouse=a

augroup numbertoggle
  autocmd BufEnter,FocusGained,InsertLeave * setlocal relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal norelativenumber
augroup END

if !has('nvim') 
  syntax on
  set autoindent
  set fileencoding=utf8
  set encoding=utf8

  set ttymouse=xterm2
  set visualbell
  set hlsearch
  set incsearch
  set ruler
endif
set directory^=$HOME/.vim/tmp//


set nowrap
set colorcolumn=80
set clipboard=unnamedplus


"=============================================================
"statusline to show BOM
if has("statusline")
  set statusline=%<  " truncate if too long
  set statusline+=%f\  " path to file
  set statusline+=%h  " help buffer flag, text is 'help'
  set statusline+=%m " modified flag [+] or [-]
  set statusline+=%r " readonly [RO]
  set statusline+=%=  " separator point between left and right aligned items
  " fenc - fileencoding
  " enc - encoding
  set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}
  set statusline+=%k\ " value of keymap
  set statusline+=%-14.(%l/%L,\ %c%) " l linenumber, c columnnumber, virtual colunm number
endif
" set laststatus=2


" ================ PLUGINS =====================
call plug#begin('~/.vim/plugged')
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'

Plug 'tpope/vim-sensible' 
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'

Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

colorscheme monokai
" colorscheme gruvbox
" colorscheme dracula
set background=dark    " Setting dark mode

"============LEARN VIMSCRIPTHE HARD WAY stuff=======================
"++++++++ use 'nore' mapping ALWAYS (no recursive)
let mapleader = " "
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" jos halua harjotella
" inoremap <esc> <nop>
inoremap jk <esc>

" set showbreak=+++\ 

nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
