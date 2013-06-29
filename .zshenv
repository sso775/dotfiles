
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

# perlbrew
# perl -MLocal::lib で出力される場所へパスを通す
source $HOME/perl5/perlbrew/etc/bashrc
export PERLBREW_ROOT=${HOME}/perl5/perlbrew
export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PATH="$HOME/perl5/bin:$PATH";
case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  export PERL5LIB="$HOME/perl5/lib/perl5/darwin-2level:$HOME/perl5/lib/perl5";
  ;;
# Linux
linux*)
  export PERL5LIB="$HOME/perl5/lib/perl5/x86-64-linux:$HOME/perl5/lib/perl5";
esac

# pybrew
if [[ -s $HOME/.pythonbrew/etc/bashrc ]]; then
  source $HOME/.pythonbrew/etc/bashrc
  pybrew switch 2.7.2 >/dev/null
fi
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - zsh)"
source ~/.rbenv/completions/rbenv.zsh

export PYTHONPATH="/usr/local/lib/python";

# gisty
# http://d.hatena.ne.jp/kshimo69/20110412/1302614690
export GISTY_DIR=$HOME/gists
export GISTY_SSL_CA=/opt/local/etc/openssl/cert.pem
export GISTY_SSL_VERIFY="none"
