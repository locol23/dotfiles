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
  au BufNewFile,BufRead *.ts setlocal filetype=typescript
  au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
  autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_expand_or_edit)
  autocmd VimEnter * VimFilerExplorer
augroup END

if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('neoclide/coc.nvim', {'merge':0, 'build': './install.sh nightly'})
  call dein#add('leafgarland/typescript-vim', {'for': ['typescript', 'typescript.tsx']})

  " editor
  call dein#add('Shougo/unite.vim')
  " call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif
  call dein#add('Shougo/vimfiler')
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

" vimfiler
let g:vimfiler_as_default_explorer = 1
noremap <C-X><C-T> :VimFiler -split -simple -winwidth=45 -no-quit<ENTER>
nmap sf :VimFilerExplorer -split -winwidth=45 -no-quit<ENTER><CR>

" vim-autoclose
let g:on_i = 1

" coc
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

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

