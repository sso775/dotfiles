set lines=70                   " ウィンドウ高さ
set columns=140                " ウィンドウ横幅
" set transparency=25            " ウィンドウ透過度
set guifont=Ricty\ Regular:h18 " フォント
set antialias                  " アンチエイリアス有効
set imdisable                  " IM無効化
set guioptions-=T              " ツールバー非表示
set background=dark            " ダークテーマ使用

set mouse=a                    " 全てのモードでマウス利用可能に
set nomousefocus               " マウス移動によるフォーカス切り替え無効

" ウィンドウフォーカス毎の透過度設定
" http://vim-users.jp/2011/10/hack234/
augroup hack234
  autocmd!
  if has('mac')
    autocmd FocusGained * set transparency=25
    autocmd FocusLost * set transparency=50
  endif
augroup END
