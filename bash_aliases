# corrections
alias a-l='-la'
alias elss="less"
alias erg='grep --color=auto'
alias grep='grep --color=auto'
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
alias rnano='vi'
alias nano='vi'

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
alias gstat='for i in `find ~/repos -name .git | grep -v forge` ; do cd $i/../ ; pwd ; git shortlog -s -n --all --no-merges ; done'
alias gcf='git clean -df'
alias gbr-f='git branch | grep -v "master" | xargs git branch -D'

# virtualization
alias vb='virtualbox'
alias vd="vagrant destroy"
alias vdf="vagrant destroy -f"
alias vp="vagrant provision"
alias vv="vagrant ssh"
alias vs="vagrant status"
alias vu="vagrant up"
alias au="bash test.sh"

# firefox
alias    f='~/firefox*/firefox & disown ; exit'
alias   ff='~/firefox*/firefox & disown ; exit'
alias  fff='~/firefox*/firefox & disown ; exit'
alias ffff='~/firefox*/firefox & disown ; exit'

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
alias a='acpi | awk "{print \$4,\$3}" | sed s'/,//'g'
alias am='alsamixer'
alias b='~/repos/buku/buku.py'
alias c='cal'
alias cal='cal -3'
alias d="date '+%l:%M%P   %A   %m/%d/%y'"
alias dict='dict -d gcide'
alias dotfiles-list='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -l'
alias dotfiles-sync='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -s'
alias dotfiles-force='dotfiles -R ~/repos/personal/dotfiles/ -C ~/repos/personal/dotfiles/.dotfilessrc -s -f'
alias dwm_script='cd ~/repos/personal/misc/ ; bash dwm_script.sh  & disown ; exit'
alias e='extract'
alias fuck='sudo $(history -p \!\!)'
alias get='sudo apt-get install'
alias _information-game='ls /mnt/games/pc/* | grep -i'
alias _information-ip="curl -s ipinfo.io"
alias _information-location="curl https://whatismycountry.com/ -s | grep -i typed | sed 's/.*from//g' | sed 's/\\,.*//g'  "
alias _information-movie='ls /mnt/videos/movies/* | grep -i'
alias _information-music='find /mnt/music/ /mnt/music/_metal/ -maxdepth 2 | grep -i'
alias gip='_information-ip'
alias google='~/repos/googler/googler'
alias h='htop'
alias movie='~/repos/Govie/bin/govie -d '
alias p='pwd'
alias please='sudo $(history -p !-1)'
alias pp='ps axuf'
alias pw='pwgen 32 1 --capitalize --numerals --symbols  --ambiguous'
alias pwdb='kpcli --kdb ~/repos/personal/misc/pwdb.kdbx'
alias sa='ssh-agent /bin/bash'
alias search='apt-cache search'
alias symlink_buku='ln -sf ~/repos/misc/bookmarks.db ~/.local/share/buku/bookmarks.db'
alias thesaurus='dict -d moby-thesaurus'
alias u='uptime'
alias webserver='python ~/repos/personal_code/python/simple_https_server.py '
alias ww='curl http://wttr.in/nyc'
alias xfishtank='xfishtank -c black -r .1 -i .1 -b 20 -f 20 & disown ; exit'
alias netcat_give='nc -l -p 12345 -q 1 > file'
alias cc='chromium --enable-remote-extensions & disown ; exit'
alias lp='i3lock'
alias vi='vim'
alias nb='newsbeuter -r -C ~/repos/personal/misc/newsbeuter_config -u ~/repos/personal/misc/newsbeuter_urls -c ~/repos/personal/misc/newsbeuter_cachedb'
alias btc='curl -sSL https://coinbase.com/api/v1/prices/historical | head -n 1 | sed "s|^.*,|$|" | sed "s|\(\.[0-9]$\)|\10|"'
alias xterm='xterm -bg black -fg white'
alias b='mvn clean package -DskipTests=true'
alias bb='mvn clean package -DskipTests=true ; find target/ -name *.jar | xargs java -jar'
alias db='sudo docker build .'
alias pia='curl privateinternetaccess.com -L -s | grep topbar__item | grep protected | sed "s/.*\">//g" | sed "s/<.*//g"'

# kube
alias kp='watch kubectl get pods --all-namespaces'
alias ka='watch kubectl get all --all-namespaces'
alias ks='watch kubectl get svc --all-namespaces'
alias ki='watch kubectl get ing --all-namespaces'
alias kn='watch kubectl get nodes'
alias kp='kubectl get pods --all-namespaces'
alias kl='kubectl logs'
alias ki='kubectl get ing --all-namespaces'
alias ka='kubectl get all --all-namespaces'
alias ks='kubectl get svc --all-namespaces'
alias ksa='kubectl get serviceaccounts --all-namespaces'
alias ksm='kubectl get servicemonitors --all-namespaces'
alias kn='kubectl get nodes'
alias kgc='kops --state s3://kubernetes-`aws sts get-caller-identity --output text --query "Account"` get cluster'
alias kx='kubectx'
alias ke='kubectl exec -ti'
alias k='kubectx'
alias kkp='kubectl patch pod -p "{"metadata":{"finalizers":null}}" -n '

# docker
alias docker_cleanup='sudo docker rm $(sudo docker ps -a -q) ; sudo docker rmi $(sudo docker images -a -q)'
