" Indent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2

" Editor
set termguicolors
set number
set title
set t_Co=256
set ruler
set showcmd
set showmatch
set wrap
set cursorline
set laststatus=2
set autochdir
set display=lastline
set pumheight=15
set grepprg=git\ grep\ --no-index\ -I\ --line-number

" Encode
set encoding=utf-8
set fileencodings=utf-8,sjis
set fileformats=unix,mac

" Map
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap <C-e> <Esc><RIGHT>a

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap s :split<CR>
nnoremap v :vsplit<CR>

nnoremap c :tabnew<CR>

" Buffer
:set hidden
nnoremap <silent> <C-n> :bprev<CR>
nnoremap <silent> <C-p> :bnext<CR>

if &compatible
  set nocompatible
endif

" reset augroup
augroup locol23
  autocmd!
augroup END

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" editor
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-surround'
Plugin 'thinca/vim-quickrun'
Plugin 'scrooloose/nerdtree'
Plugin 'junegunn/fzf.vim'
Plugin 'mattn/emmet-vim'
Plugin 'hail2u/vim-css3-syntax'

" coding
Plugin 'jason0x43/vim-js-indent'
Plugin 'w0rp/ale'
Plugin 'airblade/vim-gitgutter'
Plugin 'sheerun/vim-polyglot'

call vundle#end()

filetype plugin indent on

" lightline
let g:lightline = {
  \'active': {
  \  'left': [
  \    ['mode', 'paste'],
  \    ['readonly', 'filename', 'modified'],
  \    ['ale'],
  \  ]
  \},
  \'component_function': {
  \  'ale': 'ALEStatus'
  \}
  \ }

syntax enable
set background=dark
colorscheme solarized
