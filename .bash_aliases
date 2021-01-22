#!/usr/bin/env sh

# single letters
alias f='vim $(fzf)'
alias g='cd ~/repos'
alias l='ls -lh --color=auto'

# misc
alias am='pulsemixer'
alias get='sudo apt-get install'
alias gip='curl -s ipinfo.io'
alias home='ssh -l debian home'
alias pf='pip3 freeze'
alias pi='ssh -l pi raspberrypi'
alias pl='pip3 freeze'
alias search='apt-cache search'
alias test-cpu='for i in 1 2 3 4; do while : ; do : ; done & done'
alias test-disk-speed='dd if=/dev/zero of=~/tmp/testfile.bin bs=1M count=4K conv=fdatasync status=progress;rm -f ~/tmp/testfile.bin'
alias testssl='docker run -ti drwetter/testssl.sh'
alias tm='transmission-remote debian:9091 -l'
alias vf='vifm .'
alias xrandr-tv='xrandr -s 1360x768'
alias ycm='python3 ~/.vim/plugged/YouCompleteMe/install.py --all'

# revisions
alias cp='cp -i'
alias dd='dd status="progress"'
alias df='df -h'
alias dstat='dstat --net --disk --top-bio --top-cpu --top-cputime --top-io --top-latency --top-mem --top-oom'
alias firefox='~/firefox/firefox -ProfileManager & disown ; exit'
alias gource='gource -1280x720 --seconds-per-day 0.1 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 ~/tmp/gource.mp4'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mpv-term='mpv --vo=tct --vo-tct-width=160 --vo-tct-height=50 --vo-tct-256=yes'
alias mv="mv -i"
alias pwgen='pwgen 32 1 --no-capitalize --no-numerals --ambiguous'
alias rm="rm -i"
alias top="top -i"
alias tty-clock="tty-clock -s -c"
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20'

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
alias ggsa='for i in $(find ~/repos/personal -maxdepth 1 -mindepth 1 -type d) ; do echo $i ; git -C $i branch | grep "*" ; done'
alias gl='git log'
alias glf='git log -p --name-only'
alias gll='git log -p'
alias glll='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x1b[33m[%an]%x1b[39m%x20%s"'
alias gm='git merge'
alias gp='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gpa='for i in $(find ~/repos/personal -maxdepth 1 -mindepth 1 -type d) ; do echo $i ; git -C $i pull ; done'
alias gpp='git pull'
alias gpu='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gs='git status'
alias gsa='for i in $(find ~/repos/personal -maxdepth 1 -mindepth 1 -type d) ; do echo $i ; git -C $i status ; done'
alias gstat='for i in $(find ~/repos/personal -maxdepth 1 -mindepth 1 -type d) ; do echo $i ; git -C $i shortlog -s -n --all --no-merges ; done'
alias gt='git tag -l'

# tmux
alias tl='tmux list-windows'

# helm
alias hl='helm ls -A'
alias hlw='watch -n 1 "helm ls -A"'
alias hdp='helm delete'

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
alias knw='watch -n 1 kubectl get nodes'
alias kne='kubectl get nodes -o wide'
alias knee='kubectl get nodes -o wide --show-labels'
alias kns='kubectl get namespaces --show-labels'
alias kp='kubectl get pods --all-namespaces'
alias kpw='watch -n 1 "kubectl get pods --all-namespaces"'
alias kpe='kubectl get pods --all-namespaces -o wide'
alias kpee='kubectl get pods --all-namespaces -o wide --show-labels'
alias ks='kubectl get svc --all-namespaces'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias kse='kubectl get svc --all-namespaces -o wide'
alias ksee='kubectl get svc --all-namespaces -o wide --show-labels'
alias ksm='kubectl get servicemonitors --all-namespaces'
alias ktest='kubectl run -it foo --image=debian:stable-slim --restart=Never -- /bin/bash'
alias kl='kubectl config get-contexts'
alias kc='kubectl config use-context'
alias kpn='watch -n 1 "kubectl get pods --all-namespaces | grep 0\/ | grep -v Completed"'

# terraform
alias tp='terraform init -upgrade && terraform fmt && terraform plan'
alias ta='terraform init -upgrade && terraform fmt && terraform apply'
alias taa='terraform init -upgrade && terraform fmt && terraform apply -auto-approve'
alias ti='terraform init -upgrade'
alias td='terraform destroy'

# docker
alias di='docker images'
alias dp='docker ps --all'
alias dc='docker container prune -f && docker network prune -f && docker volume prune -f'
alias dca='docker system prune --volumes --all'
alias dn='docker volume ls'
alias dv='docker network ls'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcp='docker-compose pull --include-deps'
alias dcr='docker-compose restart'
alias dl='docker network ls && echo && docker image ls --all && echo && docker container ls --all && echo && docker volume ls'

# vagrant
alias vp='vagrant up --provision'
alias vu='vagrant up --provision'
alias vd='vagrant destroy -f'
alias vs='vagrant status'
alias vc='vagrant destroy -f ; vagrant up --provision'
