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

nnoremap ss :split<CR>
nnoremap sv :vsplit<CR>

nnoremap c :tabnew<CR>

nnoremap sf :VimFiler<CR>

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



if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

" editor
  call dein#add('Shougo/vimfiler')
  call dein#add('Shougo/unite.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('tpope/vim-surround')
  call dein#add('thinca/vim-quickrun')
  call dein#add('junegunn/fzf.vim')
  call dein#add('mattn/emmet-vim')
  call dein#add('hail2u/vim-css3-syntax')

" coding
  call dein#add('jason0x43/vim-js-indent')
  call dein#add('w0rp/ale')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('sheerun/vim-polyglot')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

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
