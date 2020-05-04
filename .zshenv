
# / 環境変数 lang and load path
# ---------------------------------------------------------

# 環境変数LANG
# rootではLANG=C
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

export PATH=$HOME/bin:$PATH
export PATH=$HOME/local:$PATH

# エディタ
case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
  ;;
# Linux
linux*)
  export EDITOR=vim
esac

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - zsh)"

export PYTHONPATH="/usr/local/lib/python";

# pyenv
export PYENV_ROOT=${HOME}/.pyenv
if [ -d "${PYENV_ROOT}" ]; then
  export PATH=${PYENV_ROOT}/bin:$PATH
  eval "$(pyenv init -)"
fi

# gisty
# http://d.hatena.ne.jp/kshimo69/20110412/1302614690
export GISTY_DIR=$HOME/gists
export GISTY_SSL_CA=/opt/local/etc/openssl/cert.pem
export GISTY_SSL_VERIFY="none"

# tex
export PATH=/usr/texbin:$PATH
