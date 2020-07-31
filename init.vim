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
nnoremap \r :QuickRun<CR>
nnoremap ` @q
nnoremap runc :call RunCpp()<CR>
nnoremap runj :call RunJs()<CR>
nnoremap accn :call AccNext()<CR>

function! RunCpp()
    let result = system('g++ ' . bufname("") . '&& ./a.out && oj t -d ./tests')
    echo result
endfunction

function! RunJs()
    let result = system("oj t -d ./tests -c 'sh -c 'npx ts-node main.ts'")
    echo result
endfunction

function! AccNext()
    let result = system('acc add -c next')
    echo result
endfunction

call plug#begin('~/.vim/plugged')
  " denite
  if has('nvim')
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/denite.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

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

"  nerdtree
"   Plug 'preservim/nerdtree'
"   Plug 'Xuyuanp/nerdtree-git-plugin'

  " coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  nmap coci :CocInstall coc-tsserver coc-eslint coc-json coc-prettier coc-css coc-jest<CR>

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
  Plug 'cohama/lexima.vim'

  " status line
  Plug 'itchyny/lightline.vim'

  " playground
  Plug 'thinca/vim-quickrun'

  " help in Japanese
  Plug 'vim-jp/vimdoc-ja'

  " color
  Plug 'w0ng/vim-hybrid'

call plug#end()

" denite
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> l
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> a
  \ denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> e
  \ denite#do_map('do_action', 'edit')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> N
  \ denite#do_map('do_action', 'new')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> '
  \ denite#do_map('quick_move')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> r
  \ denite#do_map('do_action', 'quickfix')
  nnoremap <silent><buffer><expr> <C-r>
  \ denite#do_map('restore_sources')
  nnoremap <silent><buffer><expr> <C-l>
  \ denite#do_map('redraw')
endfunction

"  nerdtree
" let g:NERDTreeGitStatusWithFlags = 1
" autocmd VimEnter * execute 'NERDTree'
" nnoremap <silent> sf :NERDTreeToggle<CR>
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" autocmd FileType denite call s:nerdtree_my_settings()
" function! s:nerdtree_my_settings() abort
"   nnoremap <silent><buffer><expr> l <Enter> 
" endfunction

" defx setting
" nnoremap <silent> sf :Defx -split=vertical -winwidth=30 -direction=topleft -search=`expand('%:p')` -ignored-files=.git <CR>
" nnoremap <silent> sf :Defx -resume -search=`expand('%:p')` -ignored-files=.git <CR>
nnoremap <silent> sf :Defx -listed -resume -buffer-name=tab`tabpagenr()`<CR>
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
call defx#custom#column('filename', {
    \ 'min_width': 40,
    \ 'max_width': 40,
    \ })
call defx#custom#option('_', {
    \ 'columns': 'indent:git:icons:filename:type:size:time',
    \ })
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> ~ defx#async_action('cd')
  nnoremap <silent><buffer><expr> h defx#async_action('cd', ['..'])
  " nnoremap <silent><buffer><expr> h defx#async_action('close_tree')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> l
  \ defx#async_action('open')
  " nnoremap <silent><buffer><expr> l
  " \ defx#is_directory() ?
  " \ defx#do_action('open_tree') :
  " \ defx#do_action('multi', ['drop'])
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> <C-l> '<C-w>l'
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ? ':<C-u>wincmd w<CR>' : ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  " nnoremap <silent><buffer><expr> <CR> defx#do_action('open')
  nnoremap <silent><buffer><expr> <CR>
  \ defx#is_directory() ?
  \ defx#do_action('open_tree') :
  \ defx#do_action('multi', ['drop'])
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
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent> <Leader>gr :<C-u>Denite -buffer-name=search -no-empty grep<CR>
endfunction

" coc
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" command! -nargs=0 Prettier :CocCommand ~/.prettierrc.js
" " if hidden is not set, TextEdit might fail.
" set hidden
" " Some servers have issues with backup files, see #649
" set nobackup
" set nowritebackup
" " Better display for messages
" set cmdheight=2
" " You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=200
" " don't give |ins-completion-menu| messages.
" set shortmess+=c
" " always show signcolumns
" set signcolumn=yes
" " Use tab for trigger completion with characters ahead and navigate.
" " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()
" nmap <silent> <leader>dd <Plug>(coc-definition)
" nmap <silent> <leader>dr <Plug>(coc-references)
" nmap <silent> <leader>dj <Plug>(coc-implementation)
" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
" " Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
" lexima
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': '{', 'input': '{'})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': '(', 'input': '('})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': "'", 'input': "'"})
call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': '"', 'input': '"'})

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

" vim-quickrun
let g:quickrun_config = {}
let g:quickrun_config['typescript'] = { 'type' : 'typescript/tsc' }
let g:quickrun_config['typescript/tsc'] = {
\   'command': './node_modules/typescript/bin/tsc',
\   'exec': ['%c --target esnext --module commonjs %o %s', 'node %s:r.js'],
\   'tempfile': '%{tempname()}.ts',
\   'hook/sweep/files': ['%S:p:r.js'],
\ }

" color
set background=dark
colorscheme hybrid

