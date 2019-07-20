# corrections
alias a-l='-la'
alias elss="less"
alias erg='grep --color=auto'
alias grep='grep --color=auto'
alias gep='grep --color=auto'
alias gre='grep --color=auto'
alias grpe='grep'
alias gerp='grep'
alias l='ls -ls --color'
alias ll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias lll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias les="less"
alias ls='ls --color'
alias lses="less"
alias rm="rm -i"
alias mv="mv -i"
alias sl='ls'
alias iv='vi'

# git
alias g='cd ~/repos'
alias ga='git add --all'
alias gb='git branch -a'
alias gc='git commit'
alias gco='git checkout'
alias gd='clear ; git diff'
alias gdc='clear ; git diff --cached'
alias gl='git log'
alias gll='git log -p'
alias glf='git log -p --name-only'
alias glll='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x1b[33m[%an]%x1b[39m%x20%s"'
alias gm='git merge'
alias gp='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias gpp='git pull'
alias gpu='git push origin `git rev-parse --abbrev-ref HEAD`'
alias gt='git tag -l'
alias gpa='for i in `find ~/repos -maxdepth 3 -name .git | grep -v forge | grep -v "\.terraform"` ; do cd $i/../ ; pwd ; git pull ; done'
alias gs='git status'
alias gsa='for i in `find ~/repos -maxdepth 3 -name .git | grep -v forge` ; do cd $i/../ ; pwd ; git status ; echo ; done'
alias ggsa='for i in `find ~/repos -name .git | grep -v forge` ; do cd $i/../ ; git status | grep "On branch" | grep -v master ; done'
alias gstat='for i in `find ~/repos -name .git | grep -v forge | grep -v "\.terraform" ` ; do cd $i/../ ; pwd ; git shortlog -s -n --all --no-merges ; done'
alias gcf='git clean -df'
alias gbd-f='git branch | grep -v "master" | xargs git branch -D ; git fetch -p'
alias gcom='git checkout master'
alias changes='git log -p --since 1.day | grep diff | grep stable | sort | uniq'
alias charts='git log -p --since 7.day | grep diff | grep stable | sort | uniq | grep Chart.yaml'

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

# misc
alias da="date '+%A %m/%d/%y'"
alias d="date '+%l:%M'"
alias e='extract'
alias f='vim $(fzf)'
alias ff='~/firefox*/firefox & disown ; exit'
alias get='sudo apt-get install'
alias gip='curl -s ipinfo.io'
alias h='htop'
alias pia='curl privateinternetaccess.com -L -s | grep topbar__item | grep protected | sed "s/.*\">//g" | sed "s/<.*//g"'
alias p='ps axuf'
alias pw='pwgen 32 1 --capitalize --numerals --symbols  --ambiguous'
alias search='apt-cache search'
alias vi='vim'
alias ww='curl http://wttr.in/nyc'
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20'
alias xterm='xterm -bg black -fg white'
alias dstat='dstat -c --top-cpu -dn --top-mem'
alias df='df -h'
alias testssl='docker run -ti drwetter/testssl.sh'
alias sk='screenkey'
alias ksk='pkill screenkey'

# kube
alias kd='kp | grep " [0-9]h" ; kp | grep " [0-9]s"'
alias kp='kubectl get pods --all-namespaces -o wide --show-labels'
alias ki='kubectl get ing --all-namespaces -o wide --show-labels'
alias ka='kubectl get all --all-namespaces -o wide --show-labels'
alias ks='kubectl get svc --all-namespaces -o wide --show-labels'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias ksm='kubectl get servicemonitors --all-namespaces'
alias kn='kubectl get nodes -o wide --show-labels'
alias kgc='kops --state s3://kubernetes-`aws sts get-caller-identity --output text --query "Account"` get cluster'
alias kkp='kubectl patch pod -p "{"metadata":{"finalizers":null}}" -n '
alias hl='helm ls'

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
