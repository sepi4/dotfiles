let mapleader = " "
inoremap jk <esc>

set guicursor+=n-v-c:blinkon0
set nocompatible
filetype on
filetype plugin on
let g:asmsyntax = 'nasm'


"Better copy & paste
set pastetoggle=<F2>
set autoread

set tabstop=4
set expandtab
set shiftwidth=4
set fileformats=unix
set linespace=0
set ignorecase smartcase
set textwidth=80
set number
set mouse=a
set smartindent
set autoindent


if !has('nvim')
  set fileencoding=utf8
  set encoding=utf8

  set ttymouse=xterm2
  set visualbell
  set hlsearch
  set incsearch
  set ruler
endif

syntax enable

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
if (has('termguicolors'))
  set termguicolors
endif

set directory^=$HOME/.nvim/config/tmp//


set nowrap
set colorcolumn=80
set clipboard=unnamedplus


"=============================================================
"statusline to show BOM
if has("statusline")
  set statusline=
  set statusline+=%{FugitiveStatusline()}
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
endif


" ================ PLUGINS =====================
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'dense-analysis/ale' " eslint

Plug 'mattn/emmet-vim'

Plug 'kien/ctrlp.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive' " for git
Plug 'tpope/vim-repeat'

" Plug 'prettier/vim-prettier', { 'do': 'npm install' }
" Plug 'jiangmiao/auto-pairs'

" table mode
Plug 'dhruvasagar/vim-table-mode'

Plug 'vim-airline/vim-airline'
" Plug 'itchyny/lightline.vim'

" colorschemes
Plug 'patstockwell/vim-monokai-tasty'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'

" colorization for programming languages
Plug 'sheerun/vim-polyglot'


" Plug 'diepm/vim-rest-console'
" Plug 'tomasiser/vim-code-dark'


" Initialize plugin system
call plug#end()

let g:SuperTabDefaultCompletionType = "<c-n>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
nnoremap <C-p> :FZF<CR>
let g:fzf_layout = { 'down': '~40%' }
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE
" In ~/.vim/vimrc, or somewhere similar.
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}
" let g:ale_fix_on_save = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prettier

" Make vim-prettier use prettier defaults
let g:prettier#config#bracket_spacing="true"
let g:prettier#config#jsx_bracket_same_line="false"
let g:prettier#config#parser="babylon"
let g:prettier#config#single_quote="true"
let g:prettier#config#trailing_comma="all"
let g:prettier#config#semi="false"

" " Don't use vim-prettier's auto-formatting
let g:prettier#autoformat=0

nnoremap <leader>py :PrettierAsync<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-- FOLDING --
set foldmethod=syntax "syntax highlighting items specify folds
" set foldcolumn=1 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nerdtree

let NERDTreeWinSize = 20
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
nnoremap <silent> <leader><tab> :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" for CtrlP to ingnore files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
 \   'dir' : '\.git$\|build$\|bower_components\|node_modules\|dist\|target' ,
 \  'file' : '\v\.(exe|dll|lib)$'
 \ }
let g:ctrlp_max_files=0
let g:ctrlp_show_hidden = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORSCHEME
colorscheme sepi-material-2
" colorscheme base16-material-darker
" colorscheme dracula
" colorscheme keltainen
nnoremap <F9> :colorscheme vim-monokai-tasty<cr>
nnoremap <F10> :colorscheme vihrea<cr>
nnoremap <F11> :colorscheme keltainen<cr>
nnoremap <F12> :colorscheme valkoinen<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TERMINAL
" nnoremap <leader>t :split term://bash<cr><C-w>J6<C-w>_
tnoremap <esc> <C-\><C-n>
" tnoremap jk <C-\><C-n>
"""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "CustomPatt[ae]rn", "NERD.*" ]
" let g:hardtime_maxcount = 2

set showbreak=+++\

nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


nnoremap <silent> <esc> :nohlsearch<cr>

" move selected lines
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Automatically indent pasted lines
nnoremap p p=`]
nnoremap P P=`]
" nnoremap p ]p
" nnoremap <c-p> p




" Re-select the last pasted text
nnoremap gp `[v`]

" open current file in firefox
noremap <Leader>of :silent !firefox %<cr>
noremap <Leader>oc :silent !chromium %<cr>

nmap <leader>]  <Plug>(coc-diagnostic-next-error)
nmap <leader>[  <Plug>(coc-diagnostic-prev-error)

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
