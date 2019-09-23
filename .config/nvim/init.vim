set guicursor+=n-v-c:blinkon0
set nocompatible 
filetype on

filetype plugin on
" set omnifunc=syntaxcomplete#Complete
" set completefunc=syntaxcomplete#Complete

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
  set autoindent
  set fileencoding=utf8
  set encoding=utf8

  set ttymouse=xterm2
  set visualbell
  set hlsearch
  set incsearch
  set ruler
endif

set directory^=$HOME/.nvim/config/tmp//


set nowrap
set colorcolumn=80
set clipboard=unnamedplus

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"=============================================================
"statusline to show BOM
if has("statusline")
  set statusline=
  set statusline+=%<  " truncate if too long
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
  " set statusline+=%#PmenuSel#
  " set statusline+=%{StatuslineGit()}
  " set statusline+=%#LineNr#
endif


" ================ PLUGINS =====================
call plug#begin('~/.config/nvim/plugged')
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'

Plug 'dense-analysis/ale' " eslint

Plug 'tpope/vim-sensible' 
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'


" colorschemes
Plug 'morhetz/gruvbox'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'chriskempson/base16-vim'

" recommended by vim-monokai-tayty for react
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
" Plug 'elzr/vim-json'
Plug 'jparise/vim-graphql'

" Initialize plugin system
call plug#end()



let NERDTreeWinSize = 20
let NERDTreeShowHidden=1



syntax enable
set background=dark    " Setting dark mode
set termguicolors

" colorscheme gruvbox
" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_italic = 1
" let g:gruvbox_bold = 1
" let g:gruvbox_underline = 1

let g:vim_monokai_tasty_italic = 1
colorscheme vim-monokai-tasty
"
" colorscheme sublimemonokai
" colorscheme dracula
" colorscheme base16-monokai
" colorscheme base16-synth-midnight-dark
"base16-gruvbox-dark-hard

" colorscheme monochrome

"============LEARN VIMSCRIPTHE HARD WAY stuff=======================
"++++++++ use 'nore' mapping ALWAYS (no recursive)
let mapleader = " "
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" inoremap <esc> <nop>
inoremap jk <esc>

" nerdtree
nnoremap <leader><tab> :NERDTreeToggle<cr>



" terminal
nnoremap <leader>t :split term://bash<cr><C-w>J6<C-w>_
tnoremap <esc> <C-\><C-n>
tnoremap jk <C-\><C-n>

" set showbreak=+++\ 

nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <F9> :colorscheme vim-monokai-tasty<cr>
nnoremap <F10> :colorscheme base16-gruvbox-dark-hard<cr>
nnoremap <F11> :colorscheme base16-grayscale-dark<cr>
nnoremap <F12> :colorscheme base16-monokai<cr>

" autoindent when pasting
nnoremap p p=`]



" statusline
" highlight StatusLineNC cterm=bold ctermfg=white ctermbg=darkgray
