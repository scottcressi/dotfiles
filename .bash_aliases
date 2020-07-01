#!/usr/bin/env bash

# single letters
alias l='ls -lh --color=auto'
alias g='cd ~/repos'

# misc
alias am='pulsemixer'
alias fz='vim $(fzf)'
alias get='sudo apt-get install'
alias gip='curl -s ipinfo.io'
alias ipa='ip -family inet -oneline addr | grep -v docker | grep -v 127.0.0.1 | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*"'
alias pf='pip freeze'
alias search='apt-cache search'
alias tm='transmission-remote debian:8080 -l'
alias ww='curl http://wttr.in/'
alias xrandr-tv='xrandr -s 1280x800'
alias ycm='cd ~/.vim/plugged/YouCompleteMe && python3 install.py --all'

# revisions
alias dd='dd status="progress"'
alias df='df -h'
alias dstat='dstat --net --disk --top-bio --top-cpu --top-cputime --top-io --top-latency --top-mem --top-oom'
alias firefox='~/firefox/firefox -ProfileManager & disown ; exit'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mpv='mpv --ytdl-format="bestvideo[height<=?360]+bestaudio/best"'
alias mv="mv -i"
alias pwgen='pwgen 32 1 --no-capitalize --no-numerals --ambiguous'
alias rm="rm -i"
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
alias gd='git diff'
alias gdc='git diff --cached'
alias ggsa='for i in $(find ~/repos -type d -name .git) ; do cd $i/../ ; echo $i ; git status | grep "On branch" | grep -v master ; echo ; done'
alias gl='git log'
alias glf='git log -p --name-only'
alias gll='git log -p'
alias glll='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x1b[33m[%an]%x1b[39m%x20%s"'
alias gm='git merge'
alias gp='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gpa='for i in $(find ~/repos/ -type d -name .git) ; do cd $i/../ ; echo $PWD ; git pull ; echo ; done'
alias gpp='git pull'
alias gpu='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gs='git status'
alias gsa='for i in $(find ~/repos/ -type d -name .git) ; do cd $i/../ ; echo $PWD ; git status ; echo ; done'
alias gstat='for i in $(find ~/repos -type d -name .git) ; do cd $i/../ ; pwd ; git shortlog -s -n --all --no-merges ; done'
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
alias dp='docker ps --all'
alias dc='docker system prune --volumes -a'
alias dn='docker volume ls'
alias dv='docker network ls'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcp='docker-compose pull --include-deps'
alias dcr='docker-compose restart'

# bookmarks
alias bl='7z a -p`cat ~/.bookmarkspasswd` ~/repos/personal/buku/places.sqlite.7z $(find ~/.mozilla/firefox/*.default/ -maxdepth 0)/places.sqlite'
alias bu='cd ~/repos/personal/buku ; 7z x -p`cat ~/.bookmarkspasswd` ~/repos/personal/buku/places.sqlite.7z ; mv ~/repos/personal/buku/places.sqlite $(find ~/.mozilla/firefox/*.default/ -maxdepth 0)/places.sqlite'
