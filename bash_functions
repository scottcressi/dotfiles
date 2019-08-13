#!/bin/bash

# git branch for PS1
parse_git_branch_and_add_brackets() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

-extract(){
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"        ;;
            *.Z)         uncompress "$1"   ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi

}

-down() {
    curl -s https://isitdown.site/api/v3/"$1" | jq

}

-cert-local() {
    openssl x509 -in "$1" -text -noout

}

-package-thirdparty-firefox() {
    wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O - | bunzip2 | tar xv
    mv firefox firefox-"$(date +%Y-%m-%d-%H-%M-%S)"

}

-package-pip-packages(){
    virtualenv ~/python
    # shellcheck source=/dev/null
    source ~/python/bin/activate
    pip install --upgrade \
    awscli \
    bpython \
    demjson \
    doge \
    dotfiles \
    flake8 \
    ipython \
    modernize \
    pip \
    s-tui \
    socli \
    speedtest-cli \
    yamllint \
    youtube-dl \


}

-package-thirdparty-vagrant(){
    VERSION="$(curl -s https://releases.hashicorp.com/vagrant/ | grep vagrant | head -1 | sed 's/.*vagrant_//g' | sed 's/<.*//g')"
    curl -s -L https://releases.hashicorp.com/vagrant/$VERSION/vagrant_"$VERSION"_x86_64.deb -o /tmp/vagrant_"$VERSION"_x86_64.deb
    sudo dpkg -i /tmp/vagrant_"$VERSION"_x86_64.deb

}

-package-thirdparty-virtualbox(){
    VERSION=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
    PACKAGE=$(curl -s https://download.virtualbox.org/virtualbox/"$VERSION"/ | grep rpm | grep el7 | sed 's/rpm.*/rpm/g' | sed 's/.*Virt/Virt/g')
    sudo yum install https://download.virtualbox.org/virtualbox/"$VERSION"/"$PACKAGE"

}

-package-debian-gui(){
    sudo apt-get update
    sudo apt-get install \
    abiword \
    arandr \
    atril \
    dwm \
    feh \
    mpv \
    mupdf \
    oneko \
    screenkey \
    surf \
    sxiv \
    wicd \
    xautolock \
    xcowsay \
    xfishtank \
    xorg \
    zathura \
    zathura-cb \

    #xwallpaper \
    #zathura-pdf-mupdf \


}

-package-debian-games(){
    sudo apt-get update
    sudo apt-get install \
    bastet \
    bsdgames \
    eboard \
    greed \
    moon-buggy \
    ninvaders \
    nsnake \
    pacman4console \
    xboard \

}

-package-debian-terminal(){
    sudo apt-get update
    sudo apt-get install \
    acpi \
    aspell \
    bash-completion \
    bb \
    bc \
    cifs-utils \
    cmatrix \
    cmus \
    cowsay \
    curl \
    dnsutils \
    docker-ce \
    dstat \
    espeak \
    git \
    htop \
    iftop \
    iotop \
    ipcalc \
    irssi \
    jq \
    jsonlint \
    lftp \
    libaa-bin \
    links2 \
    lolcat \
    lsof \
    mdp \
    mutt \
    ncmpcpp \
    netcat \
    neofetch \
    nethogs \
    newsbeuter \
    openssh-client \
    p7zip \
    pi \
    pwgen \
    python \
    python-pip \
    ranger \
    rig \
    rsync \
    rtorrent \
    scrot \
    shellcheck \
    sshfs \
    stterm \
    suckless-tools \
    thefuck \
    tig \
    tmux \
    toilet \
    transmission-cli \
    transmission-remote-cli \
    tree \
    tty-clock \
    ttyrec \
    typespeed \
    vim \
    virtualenv \
    weather-util \
    whois \
    xterm \

}

-brightness(){
    echo "$1" | sudo tee --append /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness
}

-package-thirdparty-translate(){
    curl -s -L git.io/trans -o ~/trans
    chmod 755 ~/trans
}

-package-thirdparty-zoom(){
    curl -s -L https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
    sudo dpkg -i /tmp/zoom_amd64.deb
}

-package-thirdparty-kube(){
    if test ! -d ~/bin/ ; then
    mkdir ~/bin
    fi

    # compose
    if test ! -f ~/bin/docker-compose ; then
        curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose
    fi

    # minikube
    if test ! -f ~/bin/minikube ; then
    curl -s -L --url https://storage.googleapis.com/minikube/releases/v1.3.0/minikube-linux-amd64 --output ~/bin/minikube
    fi

    # kops
    if test ! -f ~/bin/kops ; then
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/1.13.0/kops-linux-amd64 --output ~/bin/kops
    fi

    # helm
    if test ! -f ~/bin/helm ; then
    curl -s -L --url https://storage.googleapis.com/kubernetes-helm/helm-v2.14.2-linux-amd64.tar.gz | gunzip | tar xv
    mv linux-amd64/helm ~/bin/helm ; rm -rf linux-amd64
    fi

    # helmfile
    if test ! -f ~/bin/helmfile ; then
    curl -s -L --url https://github.com/roboll/helmfile/releases/download/v0.80.2/helmfile_linux_amd64 --output ~/bin/helmfile
    fi

    # kubectl
    if test ! -f ~/bin/kubectl ; then
    curl -s -L --url https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl --output ~/bin/kubectl
    fi

    # kind
    if test ! -f ~/bin/kind ; then
    curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/v0.4.0/kind-linux-amd64 --output ~/bin/kind
    fi

    # kpoof
    if test ! -d ~/bin/kpoof ; then
    git clone https://github.com/farmotive/kpoof
    fi

    # kubectx
    if test ! -d /opt/kubectx/ ; then
    #sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    #sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
    #sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
    echo fix
    fi

    # rakkess
    if test ! -f ~/bin/rakkess ; then
    curl -s -L --url https://github.com/corneliusweig/rakkess/releases/download/v0.4.1/rakkess-linux-amd64.gz --output ~/bin/rakkess-linux-amd64.gz
    gunzip ~/bin/rakkess-linux-amd64.gz ; mv ~/bin/rakkess-linux-amd64 ~/bin/rakkess
    fi

    chmod 755 ~/bin/*
}

-kterminate(){
    echo enter pod:
    echo
    read -r POD
    kubectl delete pod -n jenkins "$POD" --grace-period=0 --force &
    kubectl patch pod -n jenkins "$POD" -p '{"metadata":{"finalizers":null}}'
}

ds(){
    echo stop all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then docker stop $(docker ps -aq) ; fi
}

dk(){
    echo kill all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then docker kill $(docker ps -aq) ; fi
}

-kops-create(){
    VERSION=1.15.1
    echo domain:
    read -r domain
    echo bucket:
    read -r bucket
    kops create cluster --name test."$domain" --state s3://"$bucket" --cloud aws  --zones us-east-1a,us-east-1b --kubernetes-version "$VERSION" --node-size m5.large
    kops update --state s3://"$bucket" cluster --name test."$domain" --yes
}

-kops-get(){
    echo bucket:
    read -r bucket
    kops get cluster --state s3://"$bucket"
}

-kops-delete(){
    echo domain:
    read -r domain
    echo bucket:
    read -r bucket
    echo kops delete cluster  --name test."$domain" --state s3://"$bucket" --yes
}

-aws-records(){
    echo domain:
    read -r domain
    ZONE=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$domain.']".Id --output text | sed 's/\/hostedzone\///g')
    aws route53 list-resource-record-sets --hosted-zone-id "$ZONE"

}

-aws-certs(){
    aws acm list-certificates --region us-east-1
}

awsc(){
    if [ -z "$1" ] ; then echo enter profile ; fi
    export AWS_DEFAULT_PROFILE=$1
}

-is-someone-using-my-webcam(){
    if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
    echo no
    else
    echo yes
    fi

}

kc(){
    if [ -z "$1" ] ; then echo enter region ; fi
    if [ -z "$2" ] ; then echo enter cluster ; fi
    aws eks update-kubeconfig --region "$1" --name "$2"

}

kl(){
    REGIONS=(us-east-1 us-west-2)
    for i in "${REGIONS[@]}" ; do
    echo "$i"
    aws eks list-clusters --region "$i"
    echo
    done

}

-package-debian-prereqs(){
    # suckless
    sudo apt-get update
    sudo apt-get install pkg-config libfreetype6-dev libfontconfig1-dev libx11-dev libxft-dev  libxinerama-dev

    # docker
    sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common

    # firefox
    sudo apt-get install libgtk-3-0 pulseaudio

    # zoom
    sudo apt-get install libnss3

    # docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

    # backports for fzf
    echo 'deb http://http.debian.net/debian stretch-backports main contrib non-free' | sudo tee /etc/apt/sources.list.d/stretch-backports.list > /dev/null

    # trans
    sudo apt-get install gawk

}

-package-source-st(){
    curl -s -L https://dl.suckless.org/st/st-0.8.2.tar.gz | gunzip -c | tar xv
    cd st-0.8.2 || exit
    export DESTDIR="$HOME"
    make clean install

}

-package-source-st-lukesmith(){
    git clone https://github.com/LukeSmithxyz/st st-lukesmith
    cd st-lukesmith || exit
    export DESTDIR="$HOME"
    make clean install

}

-package-source-dwm(){
    curl -s -L https://dl.suckless.org/dwm/dwm-6.2.tar.gz -c | tar xv
    cd dwm-6.2 || exit
    export DESTDIR="$HOME"
    make clean install

}

-package-language-go(){
    VERSION=1.12.7
    curl -s -L https://dl.google.com/go/go"$VERSION".linux-amd64.tar.gz | gunzip -c | tar xv

}

-dwmscript(){
    pgrep -u "$USER" -a | grep dwm | grep -v grep | awk '{print $1}' | xargs kill
    find ~/ -name dwm.sh -print0 | xargs bash &

}

-lockauto(){
    pkill xautolock
    xautolock -time 1 -locker slock & disown ; exit

}

-lock(){
    slock

}

-package-thirdparty-slack(){
    curl -s -L --url https://github.com/erroneousboat/slack-term/releases/download/v0.4.1/slack-term-linux-amd64 --output ~/bin/slack-term
    chmod 755 ~/bin/slack-term

}

-kind(){
    kind create cluster
    export KUBECONFIG="$(kind get kubeconfig-path)"

}
