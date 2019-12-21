export GOPATH=/workspace
# export GO111MODULE=on
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
source ~/.git-prompt.sh
TERM=xterm-256color
PS1='\[\e[32m\]\u\[\e[m\]\[\e[35m\]@\h\[\e[m\]:\w$(__git_ps1 " (%s)")\n $ '

# git
alias gl="git log --graph --pretty=format:'%Cred%h%Creset [%C(magenta)%G?%Creset] -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"