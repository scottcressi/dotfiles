#!/usr/bin/env bash

# single letters
alias l='ls -lh --color=auto'
alias g='cd ~/repos'

# misc
alias am="alsamixer"
alias fz='vim $(fzf)'
alias ff='firefox & disown ; exit'
alias get='sudo apt-get install'
alias gip='curl -s ipinfo.io'
alias pp='ps axuf'
alias search='apt-cache search'
alias testssl='docker run -ti drwetter/testssl.sh'
alias vpn='curl -s https://mullvad.net/ -L | grep "has-text-weight-bold has-text-danger" | sed "s/.*\">//g" | sed "s/<.*//g"'
alias ww='curl http://wttr.in/'

# corrections
alias a-l='-la'
alias elss="less"
alias erg='grep --color=auto'
alias gep='grep --color=auto'
alias gerp='grep'
alias gre='grep --color=auto'
alias grep='grep --color=auto'
alias grpe='grep'
alias iv='vi'
alias les="less"
alias ll='ls -lh'
alias lll='ls -lah | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias lses="less"
alias sl='ls'
alias sduo='sudo'
alias suod='sudo'

# revisions
alias dd='dd status="progress"'
alias df='df -h'
alias dstat='dstat -c --top-cpu -dn --top-mem'
alias feh='feh --randomize --bg-max ~/wallpapers/'
alias firefox='~/firefox/firefox -ProfileManager'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias maim='maim -s ~/screenshot-$(date "+%Y-%m-%d-%H-%M-%S").png'
alias mpv='mpv --ytdl-format="bestvideo[height<=?360]+bestaudio/best"'
alias mv="mv -i"
alias pwgen='pwgen 32 1 --no-capitalize --no-numerals --ambiguous'
alias rm="rm -i"
alias vi='vim'
alias weather='weather $(curl -s ipinfo.io | jq .postal -r)'
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20'
alias xterm='xterm -bg black -fg white'

# git
alias ga='git add --all'
alias gb='git branch -a'
alias gbd-f='git branch | grep -v "master" | xargs git branch -D ; git fetch -p'
alias gc='git commit'
alias gcf='git clean -df'
alias gco='git checkout'
alias gcom='git checkout master'
alias gd='clear ; git diff'
alias gdc='clear ; git diff --cached'
alias ggsa='for i in `find ~/repos -name .git | grep -v forge` ; do cd $i/../ ; git status | grep "On branch" | grep -v master ; done'
alias gl='git log'
alias glf='git log -p --name-only'
alias gll='git log -p'
alias glll='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x1b[33m[%an]%x1b[39m%x20%s"'
alias gm='git merge'
alias gp='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gpa='for i in `find ~/repos -maxdepth 3 -name .git | grep -v forge | grep -v "\.terraform"` ; do cd $i/../ ; pwd ; git pull ; done'
alias gpp='git pull'
alias gpu='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gs='git status'
alias gsa='for i in `find ~/repos -maxdepth 3 -name .git | grep -v forge` ; do cd $i/../ ; pwd ; git status ; echo ; done'
alias gstat='for i in `find ~/repos -name .git | grep -v forge | grep -v "\.terraform" ` ; do cd $i/../ ; pwd ; git shortlog -s -n --all --no-merges ; done'
alias gt='git tag -l'

# tmux
alias tl='tmux list-windows'

# helm
alias hl='helm ls'
alias hdp='helm delete --purge'

# kops
alias kgc='kops --state s3://kubernetes-`aws sts get-caller-identity --output text --query "Account"` get cluster'

# kube
alias ka='kubectl get all --all-namespaces'
alias kae='kubectl get all --all-namespaces -o wide'
alias kaee='kubectl get all --all-namespaces -o wide --show-labels'
alias kd='kp | grep " [0-9]h" ; kp | grep " [0-9]s"'
alias ki='kubectl get ing --all-namespaces'
alias kie='kubectl get ing --all-namespaces -o wide'
alias kiee='kubectl get ing --all-namespaces -o wide --show-labels'
alias kkp='kubectl patch pod -p "{"metadata":{"finalizers":null}}" -n '
alias kn='kubectl get nodes'
alias kne='kubectl get nodes -o wide'
alias knee='kubectl get nodes -o wide --show-labels'
alias kns='kubectl get namespaces --show-labels'
alias kp='kubectl get pods --all-namespaces'
alias kpe='kubectl get pods --all-namespaces -o wide'
alias kpee='kubectl get pods --all-namespaces -o wide --show-labels'
alias ks='kubectl get svc --all-namespaces'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias kse='kubectl get svc --all-namespaces -o wide'
alias ksee='kubectl get svc --all-namespaces -o wide --show-labels'
alias ksm='kubectl get servicemonitors --all-namespaces'
alias ktest='kubectl run -it foo --image=centos --restart=Never -- /bin/bash'
alias kl='kubectl config get-contexts'
alias kc='kubectl config use-context'

# terraform
alias tfp='rm -rf .terragrunt-cache ; terragrunt plan --terragrunt-source ../../../../../../terraform-modules/modules/networking/ '
alias tfa='terragrunt apply --terragrunt-source-update '

# docker
alias di='docker images'
alias dp='docker ps'
alias dpa='docker ps --all'
alias dc='docker system prune --volumes -a'
alias dn='docker network ls'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcp='docker-compose pull ; docker-compose restart'

# aws
alias awst='aws s3 ls'