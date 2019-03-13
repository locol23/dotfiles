" Leader
let mapleader = ","
let maplocalleader = ","

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
set clipboard+=unnamed

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

inoremap <C-e> <Esc><RIGHT>a

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap ss :split<CR>
nnoremap sv :vsplit<CR>

" Buffer
:set hidden
nnoremap ; :Buffers<CR>
nnoremap <silent> [b :bprev<CR>
nnoremap <silent> ]b :bnext<CR>

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
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('scrooloose/nerdtree')
  call dein#add('itchyny/lightline.vim')
  call dein#add('tomasr/molokai')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('thinca/vim-quickrun')
  call dein#add('junegunn/fzf.vim')
  call dein#add('mattn/emmet-vim')
  call dein#add('hail2u/vim-css3-syntax')
  call dein#add('qpkorr/vim-bufkill')
  call dein#add('mileszs/ack.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('tpope/vim-eunuch')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-commentary')

  " coding
  call dein#add('jason0x43/vim-js-indent')
  call dein#add('w0rp/ale')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('Townk/vim-autoclose')

  " others
  call dein#add('vim-jp/vimdoc-ja')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

" vim-autoclose
let g:on_i = 1

" deoplete
set completeopt+=noinsert
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_auto_select = 1
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><CR>  pumvisible() ? deoplete#close_popup() : "<CR>"

" ale
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
nmap ]w :ALENextWrap<CR>
nmap [w :ALEPreviousWrap<CR>
nmap <Leader>f <Plug>(ale_fix)

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

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1

" vim-bufkill
nmap <Esc>w :BD<CR>
nmap <M-w>  :BD<CR>
nmap ∑      :BD<CR>

" vimdoc-ja
:set helplang=ja,en

" fzf
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Rg!<CR>
nmap <Leader>c :Colors<CR>
let $FZF_DEFAULT_COMMAND = 'rg --files --follow -g "!{.git,node_modules}/*" 2>/dev/null'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -g "!{*.lock,*-lock.json}" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:40%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" nerdtree
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMarkBookmarks = 0
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeStatusLine = -1
let NERDTreeShowHidden=1
highlight def link NERDTreeRO NERDTreeFile
nmap sf :NERDTree<CR>

" ack
let g:ackprg = 'rg --vimgrep --no-heading'
nmap <M-k>    mo:Ack! "\b<cword>\b" <CR>
nmap <Esc>k   mo:Ack! "\b<cword>\b" <CR>
nmap ˚        mo:Ack! "\b<cword>\b" <CR>
nmap <M-S-k>  mo:Ggrep! "\b<cword>\b" <CR>
nmap <Esc>K   mo:Ggrep! "\b<cword>\b" <CR>

syntax enable
set background=dark
colorscheme molokai

