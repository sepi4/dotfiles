let mapleader = " "

set guicursor+=n-v-c:blinkon0
set nocompatible
filetype on
filetype plugin on


"Better copy & paste
set pastetoggle=<F2>
set autoread

set tabstop=2
set expandtab
set shiftwidth=2
set fileformats=unix
set linespace=0
set ignorecase smartcase
set textwidth=78
set number
set mouse=a
set smartindent
set autoindent

augroup numbertoggle
  autocmd BufEnter,FocusGained,InsertLeave * setlocal relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * setlocal norelativenumber
augroup END

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

Plug 'tpope/vim-fugitive'

Plug 'mattn/emmet-vim'
Plug 'kien/ctrlp.vim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

Plug 'takac/vim-hardtime'

Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'




" colorschemes
Plug 'patstockwell/vim-monokai-tasty'
Plug 'chriskempson/base16-vim'

Plug 'sheerun/vim-polyglot'
Plug 'OmniSharp/omnisharp-vim'

" Initialize plugin system
call plug#end()

let g:SuperTabDefaultCompletionType = "<c-n>"

" ALE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" " Run prettier async before saving
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.json,*.graphql,*.md PrettierAsync
" autocmd BufWritePre .babelrc,.eslintrc,.prettierrc PrettierAsync

nnoremap <leader>py :PrettierAsync<cr>

"-- FOLDING --
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=syntax "syntax highlighting items specify folds
" set foldcolumn=1 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened

""""""""""""""""""""""""""""""""""""""""""""""""""""""
"nerdtree

let NERDTreeWinSize = 20
let NERDTreeShowHidden=1
nnoremap <leader><tab> :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:material_theme_style = 'darker'
" colorscheme base16-material-darker
colorscheme sepi-material-2
" colorscheme keltainen


nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" inoremap <esc> <nop>
inoremap jk <esc>

" let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "CustomPatt[ae]rn", "NERD.*" ]
" let g:hardtime_maxcount = 2


" terminal"""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :split term://bash<cr><C-w>J6<C-w>_
tnoremap <esc> <C-\><C-n>
tnoremap jk <C-\><C-n>

set showbreak=+++\

nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <F9> :colorscheme vim-monokai-tasty<cr>
nnoremap <F10> :colorscheme base16-gruvbox-dark-hard<cr>
nnoremap <F11> :colorscheme keltainen<cr>
nnoremap <F12> :colorscheme sepi-material-2<cr>

nnoremap <silent> <esc> :nohlsearch<cr>


" move selected lines
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Automatically indent pasted lines
" nnoremap p p=`]
" nnoremap P P=`]
nnoremap p ]p
nnoremap <c-p> p

" Re-select the last pasted text
nnoremap gp `[v`]

" Toggle wrapping with <Leader>w
noremap <Leader>w :set wrap!<CR>
nmap <Leader>a <Plug>(EasyAlign)

let g:OmniSharp_server_stdio = 1

let g:user_emmet_settings = {
  \  'html': {
  \      'block_all_childless' : 1,
  \  },
  \}


set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
 \   'dir' : '\.git$\|build$\|bower_components\|node_modules\|dist\|target' ,
 \  'file' : '\v\.(exe|dll|lib)$'
 \ }
