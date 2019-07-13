" Leader
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

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
map <leader>h :%s///<left><left>
nmap <silent> <leader>/ :nohlsearch<CR>
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

call plug#begin('~/.vim/plugged')
  " defx
  if has('nvim')
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'ress997/defx-icons'
  Plug 'kristijanhusak/defx-git'

  " coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  nmap coci :CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css<CR>

  " fzf
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'

  " vim-repeat
  Plug 'tpope/vim-repeat'

  " vim-surround
  Plug 'tpope/vim-surround'

  " vim-easymotion
  Plug 'Lokaltog/vim-easymotion'

  " display git diff
  Plug 'airblade/vim-gitgutter'

  " syntax, indent and more
  Plug 'sheerun/vim-polyglot'

  " auto close
  Plug 'Townk/vim-autoclose'

  " status line
  Plug 'itchyny/lightline.vim'

  " help in Japanese
  Plug 'vim-jp/vimdoc-ja'

  " color
  Plug 'w0ng/vim-hybrid'

call plug#end()

" defx setting
nnoremap <silent> <C-h> :Defx -split=vertical -winwidth=30 -direction=topleft <CR>
nnoremap <silent> sf :Defx -split=vertical -winwidth=30 -direction=topleft <CR>

let g:defx_git#indicators = {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ }
call defx#custom#column('icon', {
   \ 'directory_icon': '▸',
   \ 'opened_icon': '▾',
   \ 'root_icon': ' ',
   \ })
call defx#custom#column('filename', {
    \ 'min_width': 40,
    \ 'max_width': 40,
    \ })
call defx#custom#option('_', {
    \ 'columns': 'indent:git:icon:filename:type:size:time',
    \ })
autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
   	nnoremap <silent><buffer><expr> ~ defx#async_action('cd')
   	" nnoremap <silent><buffer><expr> h defx#async_action('cd', ['..'])
   	nnoremap <silent><buffer><expr> h defx#async_action('close_tree')
   	" nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
   	nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
   	" nnoremap <silent><buffer><expr> l defx#async_action('drop')
    nnoremap <silent><buffer><expr> l
		\ defx#is_directory() ?
		\ defx#do_action('open_tree') :
		\ defx#do_action('multi', ['drop'])

   	nnoremap <silent><buffer><expr> <C-l> '<C-w>l'
   
   	nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
   	nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ? ':<C-u>wincmd w<CR>' : ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
   	nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
   	nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
   	nnoremap <silent><buffer><expr> q defx#do_action('quit')
   
   	nnoremap <silent><buffer><expr> o defx#async_action('open_or_close_tree')
   	nnoremap <silent><buffer><expr> O defx#async_action('open_tree_recursive')
   
   	nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
   	nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
   	nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
   	" nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
   	nnoremap <silent><buffer><expr> E defx#do_action('open', 'vsplit')
   	nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
   	nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
   	nnoremap <silent><buffer><expr> N defx#do_action('new_file')
   	nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
   	nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'Time')
   	nnoremap <silent><buffer><expr> c defx#do_action('copy')
   	nnoremap <silent><buffer><expr> d defx#do_action('remove_trash')
   	nnoremap <silent><buffer><expr> m defx#do_action('move')
   	nnoremap <silent><buffer><expr> p defx#do_action('paste')
   	nnoremap <silent><buffer><expr> r defx#do_action('rename')
   	nnoremap <silent><buffer><expr> se defx#do_action('save_session')
   	nnoremap <silent><buffer><expr> sl defx#do_action('load_session')
   	nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
   	nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  endfunction

" coc
command! -nargs=0 Prettier :CocCommand ~/.prettierrc.js
" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=200
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" fzf
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Rg!<CR>
nmap <Leader>c :Colors<CR>

" vim-easymotion
map <leader>f <Plug>(easymotion-bd-w)

" vim-gitgutter
set updatetime=250

" lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

" color
set background=dark
colorscheme hybrid

