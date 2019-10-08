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
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/syntastic'

Plug 'dense-analysis/ale' " eslint

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'takac/vim-hardtime'

Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'ervandew/supertab'

Plug 'jiangmiao/auto-pairs'

Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'

" colorschemes
Plug 'patstockwell/vim-monokai-tasty'
Plug 'chriskempson/base16-vim'

" recommended by vim-monokai-tayty for react
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'mxw/vim-jsx'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

" Initialize plugin system
call plug#end()

let g:SuperTabDefaultCompletionType = "<c-n>"

 " In ~/.vim/vimrc, or somewhere similar.
" let g:ale_fixers = {
" \   'javascript': ['eslint'],
" \}
" let g:ale_fix_on_save = 1



" PRETTIER
" let g:prettier#autoformat = 0
" autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" max line length that prettier will wrap on
" Prettier default: 80
let g:prettier#config#print_width = 80

" number of spaces per indentation level
" Prettier default: 2
let g:prettier#config#tab_width = 2

" use tabs over spaces
" Prettier default: false
let g:prettier#config#use_tabs = 'false'

" print semicolons
" Prettier default: true
let g:prettier#config#semi = 'false'

" single quotes over double quotes
" Prettier default: false
let g:prettier#config#single_quote = 'true'

" print spaces between brackets
" Prettier default: true
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
" Prettier default: false
let g:prettier#config#jsx_bracket_same_line = 'false'

" avoid|always
" Prettier default: avoid
let g:prettier#config#arrow_parens = 'avoid'

" none|es5|all
" Prettier default: none
let g:prettier#config#trailing_comma = 'all'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown
" Prettier default: babylon
let g:prettier#config#parser = 'flow'

" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence = 'prefer-file'

" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'

" css|strict|ignore
let g:prettier#config#html_whitespace_sensitivity = 'css'




" nerdtree
let NERDTreeWinSize = 20
let NERDTreeShowHidden=1
nnoremap <leader><tab> :NERDTreeToggle<cr>


syntax enable
" set background=dark    " Setting dark mode
" set termguicolors

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
if (has('termguicolors'))
  set termguicolors
endif


" let g:vim_monokai_tasty_italic = 1
" colorscheme vim-monokai-tasty

" let g:material_terminal_italics = 1
" let g:material_theme_style = 'darker'
" colorscheme base16-material-darker
colorscheme sepi-material-2






"============LEARN VIMSCRIPTHE HARD WAY stuff=======================
"++++++++ use 'nore' mapping ALWAYS (no recursive)
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


" inoremap <esc> <nop>
inoremap jk <esc>

" nnoremap jj <nop>
" nnoremap kk <nop>
let g:hardtime_default_on = 1
let g:hardtime_ignore_buffer_patterns = [ "CustomPatt[ae]rn", "NERD.*" ]
let g:hardtime_maxcount = 2



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
nnoremap <F11> :colorscheme base16-material-darker<cr>
nnoremap <F12> :colorscheme base16-monokai<cr>

nnoremap <esc> :nohlsearch<cr>


vnoremap <C-k> dkkpV`[`]0
vnoremap <C-k> dpV`[`]0

" autoindent when pasting
" nnoremap p p=`]
set smartindent
