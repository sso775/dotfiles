"------------------------------------------------------------------------------
"
" .vimrc for Mac OS and Ubuntu Server
"
"------------------------------------------------------------------------------


"------------------------------------------------------------------------------
"  基本設定 general config
"------------------------------------------------------------------------------

let mapleader = ","                  " Leaderキー明示
set scrolloff=5                      " スクロール時の余白確保
set textwidth=0                      " 自動折り返しオフ
set backupskip=/tmp/*,/private/tmp/* " バックアップ時に任意のディレクトリをスキップ
set nobackup                         " バックアップ作成無効
set noswapfile                       " スワップファイル作成無効
set hidden                           " 編集中でも別ファイルを開けるように
set backspace=indent,eol,start       " バックスペースで色々消せるように
set browsedir=buffer                 " Explorer初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]        " カーソルを行頭行末で止まらないように
set autoread                         " 他で書き換えられたら自動で読み込み
set showcmd                          " コマンドをステータスラインに
set showmode                         " モード表示
set modelines=0                      " モードライン非表示
set notitle                          " ターミナルのウィンドウタイトル変更無し

" ターミナルでマウスを使用できるように
set mouse=a
set guioptions+=a
set ttymouse=xterm2

noremap ; :
noremap : ;

"------------------------------------------------------------------------------
"  文字コード・改行文字 text encoding
"------------------------------------------------------------------------------

set ffs=unix,dos,mac " 改行文字
set encoding=utf-8   " デフォルトエンコーディング


" 文字コード関連

" 文字コードの自動認識

if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp

" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932


"------------------------------------------------------------------------------
"  表示・アピアランス apperance
"------------------------------------------------------------------------------

" ターミナルタイプによるカラー設定
if &term =~ "xterm-256color" || "screen-256color"
  " 256色
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

set showmatch                                     " 括弧の対応をハイライト
set matchtime=3                                   " 対応括弧のハイライトを3秒に
set list                                          " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字表示形式設定
set number                                        " 行数表示
set cursorline                                    " カーソル行ハイライト

" カレントウィンドウのみに罫線
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" コマンド中の再描画オフ
:set lazyredraw

" シンタックス有効
syntax enable

" 補完候補の色づけ
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

"------------------------------------------------------------------------------
"  ステータスライン status line
"------------------------------------------------------------------------------

" ステータスライン常時表示
set laststatus=2

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc


"------------------------------------------------------------------------------
"  インデント indent
"------------------------------------------------------------------------------

set autoindent                           " オートインデント
set smartindent                          " 新しい行開始時にインデントを合わせる
set cindent                              " プログラムファイルの自動インデント
set tabstop=2 shiftwidth=2 softtabstop=0 " インデント量
                                         " softtabstopはtabキーでの空白数, 0であればtabstopと同じ
set expandtab                            " tabを空白文字に変換

" ファイルタイプの検索を有効化・タイプに合わせたインデントを利用
if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif


"------------------------------------------------------------------------------
"  補完・履歴 completing
"------------------------------------------------------------------------------

set wildmenu           " コマンド補完強化
set wildchar=<tab>     " tabキーで補完
set wildmode=list:full " リスト表示・最長マッチ
set history=1000       " 履歴数
set complete+=k        " 補完に辞書ファイル追加

" -- tabでオムニ補完
function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>


"------------------------------------------------------------------------------
"  検索 search
"------------------------------------------------------------------------------

set wrapscan   " 最後まで検索したら最初に戻る
set ignorecase " 大文字・小文字無視
set smartcase  " 大文字で検索する時は区別する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字ハイライト

" esc二度押しで検索ハイライトクリア
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" 選択文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

" 選択文字列を置換
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

" "s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'


"------------------------------------------------------------------------------
"  編集関連 edit utility
"------------------------------------------------------------------------------

nnoremap <C-i> :<C-u>help<Space>    " Ctlr-iでヘルプ
autocmd BufWritePre * :%s/\s\+$//ge " 保存時に行末の空白を削除
autocmd BufWritePre * :%s/\t/  /ge  " 保存時にtabをスペースに変換
set backspace=2                     " deleteでインデント・改行を削除
set clipboard+=unnamed              " ヤンク・ペーストのシステムクリップボードクリップボードとの連携

" ref: http://relaxedcolumn.blog8.fc2.com/blog-entry-125.html
" if has('mac') && !has('gui')
  " nnoremap <silent> <Space>y :w !pbcopy<CR><CR>
  " vnoremap <silent> <Space>y :w !pbcopy<CR><CR>
  " nnoremap <silent> <Space>p :r !pbpaste<CR>
  " vnoremap <silent> <Space>p :r !pbpaste<CR>
" else
  " noremap <Space>y
  " noremap <Space>p
" endif

" insertモードを抜けるとIMEオフ
" KeyRemap4MacBookの custom xml で設定する
"http://d.hatena.ne.jp/r7kamura/20110217/1297910068

"------------------------------------------------------------------------------
"  シンタックス syntax
"------------------------------------------------------------------------------

" どげんかせんといかん

autocmd BufRead,BufNewFile *.mkd  setfiletype mkd
autocmd BufRead,BufNewFile *.md  setfiletype mkd
autocmd BufRead,BufNewFile *.markdown  setfiletype mkd

autocmd BufRead,BufNewFile *.vimp setfiletype vimperator

"------------------------------------------------------------------------------
"  プラグイン plugins
"------------------------------------------------------------------------------

set nocompatible
filetype off

if has ('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git

  call neobundle#rc(expand('~/.vim/bundle'))
endif

NeoBundle 'git://github.com/vim-jp/vimdoc-ja.git'

NeoBundle 'ack.vim'
NeoBundle 'Align'
NeoBundle 'AutoComplPop'
NeoBundle 'cocoa.vim'
NeoBundle 'EasyMotion'
NeoBundle 'JavaScript-syntax'
NeoBundle 'minibufexpl.vim'
NeoBundle 'LaTeX-Suite-aka-Vim-LaTeX'
NeoBundle 'taglist.vim'
NeoBundle 'vtreeexplorer'
NeoBundle 'YankRing.vim'
NeoBundle 'yanktmp.vim'

NeoBundle 'basyura/bitly.vim'
NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'choplin/unite-vim_hacks'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'kana/vim-arpeggio'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'mattn/benchvimrc-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'mattn/hahhah-vim'
NeoBundle 'mattn/vdbi-vim'
NeoBundle 'mattn/vim-metarw'
NeoBundle 'mattn/vimplenote-vim'
NeoBundle 'mattn/mkdpreview-vim'
NeoBundle 'mattn/tablist-vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'pangloss/vim-javascript'
" NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
" NeoBundle 'Shougo/vimproc.vim', {
"     \ 'build' : {
"     \     'windows' : 'make -f make_mingw32.mak',
"     \     'cygwin' : 'make -f make_cygwin.mak',
"     \     'mac' : 'make -f make_mac.mak',
"     \     'unix' : 'make -f make_unix.mak',
"     \   },
"     \ }
" NeoBundle 'Shougo/vimproc'
" NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/banban.vim'
NeoBundle 'tyru/DumbBuf.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'thinca/vim-openbuf'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'ujihisa/vimshell-ssh'

NeoBundle 'desert256.vim'
NeoBundle 'mrkn256.vim'
NeoBundle 'pyte'
NeoBundle 'Zenburn'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'tomasr/molokai'
NeoBundle 'yuroyoro/yuroyoro256.vim'

filetype plugin indent on

colorscheme yuroyoro256

" / Align
" ---------------------------------------------------------

" http://nanasi.jp/articles/vim/align/align_vim.html
" http://nanasi.jp/articles/vim/align/align_vim_summary.html

" :Align | などコマンド引数に区切り文字で整形
" \tsp で空白文字を基準に整形, \tab でタブ文字を基準に整形

" 日本語環境用設定
:let g:Align_xstrlen = 3

" / caw.vim
" ---------------------------------------------------------

nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)


" / yanktmp.vim
" ---------------------------------------------------------

" vimプロセスをまたいでヤンク・ペースト

map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>


" / yankring.vim
" ---------------------------------------------------------

" ヤンクの履歴を保存, ペーストしてそのまま Ctrl + n,p で選択

" 再起動後も履歴保持
set viminfo+=!

" / vim-powerline.vim"
" ---------------------------------------------------------

let g:Powerline_symbols = 'fancy'
"自動的に QuickFix リストを表示する
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

" / vimshell.vim"
" ---------------------------------------------------------

" if has('mac')
"   let g:vimproc_dll_path = $HOME . '/.vim/bundle/vimproc/autoload/proc_mac.so'
"   " let g:vimproc_dll_path = $VIMRUNTIME . '/autoload/proc.so'
" elseif has('unix')
"   let g:vimproc_dll_path = $HOME . '/.vim/bundle/vimproc/autoload/proc.so'
" endif
"
" ":VS でvimshell起動
" command! VS :VimShell
"
" let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
" let g:vimshell_enable_smart_case = 1
"
" if has('win32') || has('win64')
"   " Display user name on Windows.
"   let g:vimshell_prompt = $USERNAME." % "
" else
"   " Display user name on Linux.
"   let g:vimshell_prompt = $USER." % "
"
"   call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
"   call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
"   let g:vimshell_execute_file_list['zip'] = 'zipinfo'
"   call vimshell#set_execute_file('tgz,gz', 'gzcat')
"   call vimshell#set_execute_file('tbz,bz2', 'bzcat')
" endif
"
" function! g:my_chpwd(args, context)
"   call vimshell#execute('echo "chpwd"')
" endfunction
" function! g:my_emptycmd(cmdline, context)
"   call vimshell#execute('echo "emptycmd"')
"   return a:cmdline
" endfunction
" function! g:my_preprompt(args, context)
"   call vimshell#execute('echo "preprompt"')
" endfunction
" function! g:my_preexec(cmdline, context)
"   call vimshell#execute('echo "preexec"')
"
"   if a:cmdline =~# '^\s*diff\>'
"     call vimshell#set_syntax('diff')
"   endif
"   return a:cmdline
" endfunction
"
" autocmd FileType vimshell
" \ call vimshell#altercmd#define('g', 'git')
" \| call vimshell#altercmd#define('i', 'iexe')
" \| call vimshell#altercmd#define('l', 'll')
" \| call vimshell#altercmd#define('ll', 'ls -l')
" \| call vimshell#hook#set('chpwd', ['g:my_chpwd'])
" \| call vimshell#hook#set('emptycmd', ['g:my_emptycmd'])
" \| call vimshell#hook#set('preprompt', ['g:my_preprompt'])
" \| call vimshell#hook#set('preexec', ['g:my_preexec'])

" / vtreeexplorer.vim"
" ---------------------------------------------------------

" :VST コマンドでツリー表示

" 縦に分割して表示
let g:treeExplVertical=1

" 分割のサイズ
let g:treeExplWinSize=30


" / minibufexpl.vim
" ---------------------------------------------------------

" C-w C-w や C-w j,k でタブへ移動し選択する

" hjklで移動
let g:miniBufExplMapWindowNavVim=1

" Put new window above
let g:miniBufExplSplitBelow=0

let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

" vimp風にH,Lで移動できるように
nnoremap J :bprevious<CR>
nnoremap K :bnext<CR>

":BT でMiniBufExplorerの表示・非表示
command! BT :TMiniBufExplorer


" / minibufexpl.vim
" ---------------------------------------------------------

" http://blog.glidenote.com/blog/2012/03/26/memolist.vim/
" let g:memolist_memo_suffix = "mkd"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_qfixgrep = 1
" let g:memolist_template_dir_path = "path/to/dir"


" / dumbbuf.vim
" ---------------------------------------------------------

"<Leader>b<Space>でBufferList
let dumbbuf_hotkey = '<Leader>b<Space>'
let dumbbuf_mappings = {
      \ 'n': {
        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
    \}
\}
let dumbbuf_single_key  = 1
" &updatetimeの最小値
let dumbbuf_updatetime  = 1
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1


" / open-browser.vim
" ---------------------------------------------------------

" カーソル下のURLをブラウザで開く
nmap fu <Plug>(openbrowser-open)
vmap fu <Plug>(openbrowser-open)

" カーソル下のキーワードでGoogle検索
nnoremap fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>


" / neocomplcache.vim
" ---------------------------------------------------------

" AutoComplPopを無効にする
" let g:acp_enableAtStartup = 0
" NeoComplCacheを有効にする
let g:neocomplcache_enable_at_startup = 1
" smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
let g:neocomplcache_enable_camel_case_completion = 1
" _(アンダーバー)区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
" neocomplcacheを自動的にロックするバッファ名のパターン
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" -入力による候補番号の表示
" let g:neocomplcache_enable_quick_match = 1
" 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
let g:neocomplcache_enable_auto_select = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scala' : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml' : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Define keyword.
" if !exists('g:neocomplcache_keyword_patterns')
" let g:neocomplcache_keyword_patterns = {}
" endif
" let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

" スニペット
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" 補完を選択しpopupを閉じる
inoremap <expr><C-y> neocomplcache#close_popup()
" 補完をキャンセルしpopupを閉じる
inoremap <expr><C-e> neocomplcache#cancel_popup()
" TABで補完できるようにする
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" undo
inoremap <expr><C-g> neocomplcache#undo_completion()
" 補完候補の共通部分までを補完する
inoremap <expr><C-l> neocomplcache#complete_common_string()
" SuperTab like snippets behavior.
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" C-kを押すと行末まで削除
inoremap <C-k> <C-o>D
" C-nでneocomplcache補完
inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が出ていたら確定、なければ改行
inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "<CR>"

" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()

" FileType毎のOmni補完を設定
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType ruby set omnifunc=rubycomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'



" / unite.vim
" ---------------------------------------------------------

" http://d.hatena.ne.jp/ruedap/20110117/vim_unite_plugin_1_week

" 起動時にインサートモードで開始
let g:unite_enable_start_insert = 1

" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>

" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction


" / quickrun.vim
" ---------------------------------------------------------

" ノーマルモード中<Leader>rで実行

" Objective-Cを今マイルする設定
let g:quickrun_config = {
  \   'objc': {
  \     'command': 'cc',
  \     'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
  \     'tempfile': '{tempname()}.m',
  \   }
  \ }

" / vim-latex
" ---------------------------------------------------------

" コンパイル・pdf作成の設定
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
"let g:Tex_CompileRule_pdf='xelatex $*'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_FormatDependency_pdf='dvi,pdf'
let g:Tex_CompileRule_pdf = '/Applications/pTeX.app/teTeX/bin/dvipdfmx $*.dvi'
let g:Tex_CompileRule_dvi = '/Applications/pTeX.app/teTeX/bin/platex --interaction=nonstopmode $*'
let g:Tex_ViewRule_dvi = 'open -a /Applications/TeX/TeXShop.app'

" pdfをプレビュー.appとTeXShop.appのどちらかで見る設定
let g:Tex_ViewRule_pdf='open -a /Applications/TeX/TeXShop.app'
"let g:Tex_ViewRule_pdf='open -a /Applications/Preview.app'


" / jscomplete
" ---------------------------------------------------------

" /autoload/js 以下から読み込む
let g:jscomplete_use = ['dom', 'moz', 'xpcom']
