# ------------------------------------------------------------------------------
#
# .zshrc for Mac OS and Ubuntu Server
#
# ------------------------------------------------------------------------------


# / ターミナル設定 terminal
# ---------------------------------------------------------

# ビープ音無効
setopt nolistbeep


# ------------------------------------------------------------------------------
# 履歴・補完 history and completing
# ------------------------------------------------------------------------------

# / 履歴 history
# ---------------------------------------------------------

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history

# root時は履歴保存しない
if [ $UID = 0 ]; then
  unset HISTFILE
  SAVEHIST=0
fi

# ディレクトリ履歴
setopt auto_pushd

setopt hist_ignore_dups     # 直前と同じコマンドは履歴保存しない
setopt hist_ignore_space    # spaceで始めたコマンドは履歴保存しない
setopt hist_ignore_all_dups # 重複するコマンド行は古い方を削除

# Ctrl + p で履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


# / 補完 completing
# ---------------------------------------------------------

# 補完有効
autoload -U compinit
compinit

# コマンド先方予測
autoload predict-on
predict-on

# 補完候補のカラー表示
# ls -G の色の合わせる
# di-ディレクトリ ln-シンボリックリンク so-ソケットファイル pi-FIFOファイル ex-実行ファイル
# bd-ブロックスペシャルファイル cd-キャラクタスペシャルファイル
# su-setuid付き実行ファイル sg-setgid付き実行ファイル
# tw-other書込み権限付きディレクトリ(スティッキービットあり)
# ow-other書込み権限付きディレクトリ(スティッキービットなし)
zstyle ':completion:*' list-colors 'di=34' 'ln=35'

# 補完で大文字小文字を区別しない - 大文字を打った場合は小文字に変換しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# setopt correct          # コマンド入力ミス修正
setopt list_packed      # 補完候補を詰めて表示
setopt auto_param_slash # ディレクトリ名末尾の/を自動付加
setopt mark_dirs        # ファイル名展開でディレクトリにマッチした際末尾に/を付加
setopt list_types       # 補完候補一覧でファイル識別マークを表示
unsetopt menu_complete  # 最初にマッチしたものを自動挿入しない
setopt auto_menu        # tabキータイプで補完候補から順に補完
setopt auto_param_keys  # 括弧の対応などを自動補完


# ------------------------------------------------------------------------------
# 操作関連 utility functions
# ------------------------------------------------------------------------------

# emacsキーバインド
bindkey -e

# ディレクトリ移動のcdコマンド省略
setopt auto_cd


source $HOME/.zsh.d/zsh.alias

# OS毎に置いた設定ファイルを読み込む
case "${OSTYPE}" in
# osx
darwin*)
  source $HOME/.zsh.d/zshrc.osx
  ;;
# linux
linux*)
  source $HOME/.zsh.d/zshrc.linux
  ;;
# cygwin
cygwin*)
  source $HOME/.zsh.d/zshrc.win
esac
