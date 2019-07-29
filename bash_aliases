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
alias l='ls -l'
alias les="less"
alias ll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias lll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias lses="less"
alias sl='ls'

# revisions
alias df='df -h'
alias dstat='dstat -c --top-cpu -dn --top-mem'
alias grep='grep --color=auto'
alias ls='ls --color'
alias mv="mv -i"
alias rm="rm -i"
alias vi='vim'
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20'
alias xterm='xterm -bg black -fg white'

# misc
alias d="date +'%l:%M'"
alias da="date +'%A %m/%d/%y'"
alias f='vim $(fzf)'
alias ff='~/firefox*/firefox & disown ; exit'
alias g='cd ~/repos'
alias get='sudo apt-get install'
alias gip='curl -s ipinfo.io'
alias h='htop'
alias p='ps axuf'
alias pia='curl privateinternetaccess.com -L -s | grep topbar__item | grep protected | sed "s/.*\">//g" | sed "s/<.*//g"'
alias pw='pwgen 32 1 --capitalize --numerals --symbols  --ambiguous'
alias search='apt-cache search'
alias sk='screenkey'
alias skk='pkill screenkey'
alias testssl='docker run -ti drwetter/testssl.sh'
alias ww='curl http://wttr.in/nyc'
alias www='curl http://wttr.in/nyc?format=4'

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
alias gg='cd ~/repos'
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

# virtualization
alias vb='virtualbox'
alias vd="vagrant destroy"
alias vdf="vagrant destroy -f"
alias vp="vagrant provision"
alias vv="vagrant ssh"
alias vs="vagrant status"
alias vu="vagrant up"

# tmux
alias tl='tmux list-windows'

# kube
alias hl='helm ls'
alias k='kubectl'
alias ka='kubectl get all --all-namespaces'
alias kae='kubectl get all --all-namespaces -o wide'
alias kaee='kubectl get all --all-namespaces -o wide --show-labels'
alias kd='kp | grep " [0-9]h" ; kp | grep " [0-9]s"'
alias kgc='kops --state s3://kubernetes-`aws sts get-caller-identity --output text --query "Account"` get cluster'
alias ki='kubectl get ing --all-namespaces'
alias kie='kubectl get ing --all-namespaces -o wide'
alias kiee='kubectl get ing --all-namespaces -o wide --show-labels'
alias kkp='kubectl patch pod -p "{"metadata":{"finalizers":null}}" -n '
alias kn='kubectl get nodes'
alias kne='kubectl get nodes -o wide'
alias knee='kubectl get nodes -o wide --show-labels'
alias kns='kubens'
alias kp='kubectl get pods --all-namespaces'
alias kpe='kubectl get pods --all-namespaces -o wide'
alias kpee='kubectl get pods --all-namespaces -o wide --show-labels'
alias ks='kubectl get svc --all-namespaces'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias kse='kubectl get svc --all-namespaces -o wide'
alias ksee='kubectl get svc --all-namespaces -o wide --show-labels'
alias ksm='kubectl get servicemonitors --all-namespaces'

# terraform
alias tp='rm -rf .terragrunt-cache ; terragrunt plan --terragrunt-source ../../../../../../terraform-modules/modules/networking/ '
alias ta='terragrunt apply --terragrunt-source-update '

# docker
alias di='docker images'
alias dp='docker ps'
alias dc='docker system prune --volumes -a'
alias dn='docker network ls'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# transmission
alias tm='transmission-remote localhost:8080 -l'

# aws
alias awsl='grep "\[" ~/.aws/credentials'
alias at='aws s3 ls'
