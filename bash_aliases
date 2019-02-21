# corrections
alias a-l='-la'
alias elss="less"
alias erg='grep --color=auto'
alias grep='grep --color=auto'
alias gep='grep --color=auto'
alias grpe='grep'
alias gerp='grep'
alias l='ls -ls --color'
alias ll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias lll='ls -la | grep "^d" && ls -la | grep "^-" && ls -la | grep "^l"'
alias les="less"
alias ls='ls --color'
alias lses="less"
alias rm="rm -i"
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
alias gpa='for i in `find ~/repos -name .git | grep -v forge | grep -v "\.terraform"` ; do cd $i/../ ; pwd ; git pull ; done'
alias gs='git status'
alias gsa='for i in `find ~/repos -maxdepth 3 -name .git | grep -v forge` ; do cd $i/../ ; pwd ; git status ; echo ; done'
alias ggsa='for i in `find ~/repos -name .git | grep -v forge` ; do cd $i/../ ; git status | grep "On branch" | grep -v master ; done'
alias gstat='for i in `find ~/repos -name .git | grep -v forge | grep -v "\.terraform" ` ; do cd $i/../ ; pwd ; git shortlog -s -n --all --no-merges ; done'
alias gcf='git clean -df'
alias gbd-f='git branch | grep -v "master" | xargs git branch -D ; git fetch -p'

# virtualization
alias vb='virtualbox'
alias vd="vagrant destroy"
alias vdf="vagrant destroy -f"
alias vp="vagrant provision"
alias vv="vagrant ssh"
alias vs="vagrant status"
alias vu="vagrant up"
alias au="bash test.sh"

# tmux
alias t0='tmux attach -t 0'
alias tl='tmux list-windows'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
alias ............='cd ../../../../../../../../../../..'
alias .............='cd ../../../../../../../../../../../..'

# misc
alias _information-game='ls /mnt/games/pc/* | grep -i'
alias _information-ip="curl -s ipinfo.io"
alias _information-location="curl https://whatismycountry.com/ -s | grep -i typed | sed 's/.*from//g' | sed 's/\\,.*//g'  "
alias _information-movie='ls /mnt/videos/movies/* | grep -i'
alias _information-music='find /mnt/music/ /mnt/music/_metal/ -maxdepth 2 | grep -i'
alias am='alsamixer'
alias b='~/repos/buku/buku.py'
alias c='cal'
alias cal='cal -3'
alias d="date '+%l:%M%P   %A   %m/%d/%y'"
alias db='sudo docker build .'
alias dict='dict -d gcide'
alias dotfiles-force='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -s -f'
alias dotfiles-list='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -l'
alias dotfiles-sync='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -s'
alias e='extract'
alias f='~/firefox*/firefox & disown ; exit'
alias fuck='sudo $(history -p \!\!)'
alias get='sudo apt-get install'
alias gip='_information-ip'
alias google='~/repos/googler/googler'
alias h='htop'
alias movie='~/repos/Govie/bin/govie -d '
alias nb='newsbeuter -r -C ~/repos/personal/misc/newsbeuter_config -u ~/repos/personal/misc/newsbeuter_urls -c ~/repos/personal/misc/newsbeuter_cachedb'
alias p='pwd'
alias pia='curl privateinternetaccess.com -L -s | grep topbar__item | grep protected | sed "s/.*\">//g" | sed "s/<.*//g"'
alias please='sudo $(history -p !-1)'
alias pp='ps axuf'
alias pw='pwgen 32 1 --capitalize --numerals --symbols  --ambiguous'
alias search='apt-cache search'
alias symlink_buku='ln -sf ~/repos/misc/bookmarks.db ~/.local/share/buku/bookmarks.db'
alias thesaurus='dict -d moby-thesaurus'
alias u='uptime'
alias vi='vim'
alias ww='curl http://wttr.in/nyc'
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20 & disown ; exit'
alias xterm='xterm -bg black -fg white'
alias dstat='dstat -c --top-cpu -dn --top-mem'

# kube
alias kp='watch kubectl get pods --all-namespaces'
alias ka='watch kubectl get all --all-namespaces'
alias ks='watch kubectl get svc --all-namespaces'
alias ki='watch kubectl get ing --all-namespaces'
alias kn='watch kubectl get nodes'
alias kp='kubectl get pods --all-namespaces'
alias ki='kubectl get ing --all-namespaces'
alias ka='kubectl get all --all-namespaces'
alias ks='kubectl get svc --all-namespaces'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias ksm='kubectl get servicemonitors --all-namespaces'
alias kn='kubectl get nodes'
alias kgc='kops --state s3://kubernetes-`aws sts get-caller-identity --output text --query "Account"` get cluster'
alias kkp='kubectl patch pod -p "{"metadata":{"finalizers":null}}" -n '
alias kc='aws eks update-kubeconfig --region us-east-1 --name '
alias kl='aws eks list-clusters --region us-east-1 | jq -r ".clusters| .[]"'
alias awsl='ls -la ~/.aws/credentials.*'

# terraform
alias tp='terragrunt plan --terragrunt-source-update '
alias ta='terragrunt apply --terragrunt-source-update '

# docker
alias docker_stop='docker stop $(docker ps -aq)'
