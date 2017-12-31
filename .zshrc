#option
setopt auto_cd
setopt auto_pushd

#補完
#for-zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)
#補完 メニューの選択モード
zstyle ':completion:*:default' menu select=2

#補完機能を有効にする
#autoload -Uz compinit
#if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
#	compinit -d ~/.zcompdump
#else
#  compinit -Cu;
#fi;

#文字の区切り設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "/=;@;{}.|"
zstyle ':zle:*' word-style unspecified

#大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#プロンプトの表示
PROMPT="%f%b%F{green}%n%f %b%F{166}%(5~,%-2~/.../%2~,%~)%f%B%b%F{033}%@%f %F{magenta}>> %f"

#コマンド履歴の保存
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

#dirctory履歴
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

#複数rename機能
autoload -Uz zmv

#ブランチ情報
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*:' formats '(%s)-[%b]'
zstyle ':vcs_info:*:' actionformats '(%s)-[%b|%a]'
function _update_vcs_info_msg(){
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%v"

#gitのroot repositoryに移動する
function cdg()
{
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

#エイリアス
alias ls='ls -Fh'
alias la='ls -ah'
alias ll='ls -lh'
alias -g G='|grep'
alias gs='git status'
alias gr='git rebase -i'
alias gp='git pull'
alias gc='git co'
alias gst='git stash'
alias gsp='git stash pop'
alias tm='/usr/local/bin/tmuxx'
alias diff='diff -u'
alias vim='nvim'
alias gpush='git push origin `git symbolic-ref --short HEAD` -f'

# prevent .configure script from orverriding *-config
# remove pyenv path when using Homebrew
alias brew="env PATH=${PATH/\/usr\/local\/var\/pyenv\/shims:/} brew"

#function
function zman(){
    PAGER="less -g -s '+/^{7}"$1"'" man zshall
}
export PATH="/usr/local/sbin:$PATH"

#環境変数読み込み
if [ -f ~/.webapi.env ]; then
  source ~/.webapi.env
fi
if [ -f ~/.*/env ]; then
  source ~/.*/env
fi

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

#コマンドラインsyntax
zplug "zsh-users/zsh-syntax-highlighting", defer:2
#zplug管理
if ! zplug check; then
    zplug install
fi
# プラグインを読み込み、コマンドにパスを通す
zplug load

#ruby
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init --no-rehash -)"

#python
export PYENV_ROOT="/usr/local/var/pyenv"
if which pyenv > /dev/null; then eval "$(pyenv init --no-rehash -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init --no-rehash -)"; fi

#node grobal path
export NODE_PATH=$(npm root -g)
#export PATH=$HOME/.nodebrew/current/bin:$PATH

#iEx shell_history
export ERL_AFLAGS="-kernel shell_history enabled"
export ELIXIR_EDITOR="vim +__LINE__ __FILE__"

#asdf
source /usr/local/opt/asdf/asdf.sh
export PATH="/usr/local/sbin:$PATH"

#posgre
export PGDATA=/usr/local/var/postgres

#go
export GOPATH=$HOME/.go

#if type zprof > /dev/null 2>&1; then
#  zprof | less
#fi
