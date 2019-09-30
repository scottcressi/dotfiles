#!/usr/bin/env bash

parse_git_branch_and_add_brackets(){
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
    python3 -m venv ~/python
    # shellcheck source=/dev/null
    source ~/python/bin/activate
    pip3 install --upgrade \
    awscli \
    bpython \
    doge \
    dotfiles \
    flake8 \
    ipython \
    modernize \
    s-tui \
    socli \
    speedtest-cli \
    youtube-dl \


}

-package-thirdparty-vagrant(){
    VERSION="$(curl -s https://releases.hashicorp.com/vagrant/ | grep vagrant | head -1 | sed 's/.*vagrant_//g' | sed 's/<.*//g')"
    curl -s -L https://releases.hashicorp.com/vagrant/"$VERSION"/vagrant_"$VERSION"_x86_64.deb -o /tmp/vagrant_"$VERSION"_x86_64.deb
    sudo dpkg -i /tmp/vagrant_"$VERSION"_x86_64.deb

}

-package-thirdparty-virtualbox(){
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
    sudo apt update
    sudo apt install virtualbox-6.0

}

-package-debian(){
    # docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

    # backports for fzf
    echo 'deb http://http.debian.net/debian stretch-backports main contrib non-free' | sudo tee /etc/apt/sources.list.d/stretch-backports.list > /dev/null

    # update
    sudo apt-get update

    # packages
    cat "$HOME"/repos/personal/dotfiles/packages.txt | awk '{print $1}' | xargs sudo apt-get install -y

    # not working
    ##xwallpaper
    ##zathura-pdf-mupdf
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

    if test ! -f ~/bin/docker-compose ; then
        curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose
    fi

    if test ! -f ~/bin/minikube ; then
    curl -s -L --url https://storage.googleapis.com/minikube/releases/v1.4.0/minikube-linux-amd64 --output ~/bin/minikube
    fi

    if test ! -f ~/bin/kops ; then
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/1.13.2/kops-linux-amd64 --output ~/bin/kops
    fi

    if test ! -f ~/bin/helm ; then
    curl -s -L --url https://storage.googleapis.com/kubernetes-helm/helm-v2.14.3-linux-amd64.tar.gz | gunzip | tar xv
    mv linux-amd64/helm ~/bin/helm ; rm -rf linux-amd64
    helm plugin install https://github.com/futuresimple/helm-secrets
    helm plugin install https://github.com/databus23/helm-diff --version master
    fi

    if test ! -f ~/bin/helmfile ; then
    curl -s -L --url https://github.com/roboll/helmfile/releases/download/v0.85.3/helmfile_linux_amd64 --output ~/bin/helmfile
    fi

    if test ! -f ~/bin/kubectl ; then
    curl -s -L --url https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl --output ~/bin/kubectl
    fi

    if test ! -f ~/bin/kind ; then
    curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-linux-amd64 --output ~/bin/kind
    fi

    if test ! -f ~/bin/sops ; then
    curl -s -L --url https://github.com/mozilla/sops/releases/download/3.4.0/sops-3.4.0.linux --output ~/bin/sops
    fi

    if test ! -d ~/bin/kpoof ; then
    git clone https://github.com/farmotive/kpoof
    fi

    if test ! -d ~/kubectx/ ; then
    git clone https://github.com/ahmetb/kubectx ~/kubectx
    ln -sf ~/kubectx/kubectx ~/bin/kubectx
    ln -sf ~/kubectx/kubens ~/bin/kubens
    fi

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
    echo enter namespace:
    echo
    read -r NAMESPACE
    kubectl delete pod -n "$NAMESPACE" "$POD" --grace-period=0 --force &
    kubectl patch pod -n "$NAMESPACE" "$POD" -p '{"metadata":{"finalizers":null}}'
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
    echo domain:
    echo ex. foo.com
    read -r domain
    echo name:
    echo ex. asdf
    read -r name
    kops create cluster \
        --node-count 1 \
        --name "$name"."$domain" \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        --cloud aws  \
        --zones us-east-1a,us-east-1b \
        --node-size m5.xlarge
    kops update \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        cluster \
        --name "$name"."$domain"\
        --yes
}

-kops-get(){
    kops get cluster \
        --state s3://"$(aws sts get-caller-identity \
        --output text \
        --query 'Account')"-kops-test
}

-kops-delete(){
    echo domain:
    echo ex. foo.com
    read -r domain
    echo name:
    echo ex. sdf
    read -r name
    echo delete cluster "$name"."$domain"? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then kops delete cluster \
        --name "$name"."$domain" \
        --state s3://"$(aws sts get-caller-identity \
        --output text \
        --query 'Account')"-kops-test \
        --yes ; fi
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
    if [ -z "$1" ] ; then echo enter profile ; echo ; grep "\\[" ~/.aws/credentials ; fi
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
    curl -s -L https://dl.suckless.org/dwm/dwm-6.2.tar.gz | gunzip -c | tar xv
    cd dwm-6.2 || exit
    export DESTDIR="$HOME"
    make clean install

}

-package-source-dwm-lukesmith(){
    git clone https://github.com/LukeSmithxyz/dwm.git dwm-lukesmith
    cd dwm-lukesmith || exit
    export DESTDIR="$HOME"
    make clean install

}

-package-language-go(){
    VERSION=1.13.1
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
    KUBECONFIG="$(kind get kubeconfig-path)"
    export KUBECONFIG

}

dogecoin(){
    doge --shibe "$(find ~/python/lib/python3.5/site-packages/doge/static/ -type f | sort -R  | head -1 | xargs basename)"
}

hmm(){
    echo "
    ⠰⡿⠿⠛⠛⠻⠿⣷
    ⠀⠀⠀⠀⠀⠀⣀⣄⡀⠀⠀⠀⠀⢀⣀⣀⣤⣄⣀⡀
    ⠀⠀⠀⠀⠀⢸⣿⣿⣷⠀⠀⠀⠀⠛⠛⣿⣿⣿⡛⠿⠷
    ⠀⠀⠀⠀⠀⠘⠿⠿⠋⠀⠀⠀⠀⠀⠀⣿⣿⣿⠇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁

    ⠀⠀⠀⠀⣿⣷⣄⠀⢶⣶⣷⣶⣶⣤⣀
    ⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠈⠙⠻⠗
    ⠀⠀⠀⣰⣿⣿⣿⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⡄
    ⠀⣠⣾⣿⣿⣿⣥⣶⣶⣿⣿⣿⣿⣿⠿⠿⠛⠃
    ⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄
    ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡁
    ⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁
    ⠀⠀⠛⢿⣿⣿⣿⣿⣿⣿⡿⠟
    ⠀⠀⠀⠀⠀⠉⠉⠉
    "
}

rms(){
    echo "
    I'd just like to interject for a moment.  What you're referring to as Linux,
    is in fact, GNU/Linux, or as I've recently taken to calling it, GNU plus Linux.
    Linux is not an operating system unto itself, but rather another free component
    of a fully functioning GNU system made useful by the GNU corelibs, shell
    utilities and vital system components comprising a full OS as defined by POSIX.

    Many computer users run a modified version of the GNU system every day,
    without realizing it.  Through a peculiar turn of events, the version of GNU
    which is widely used today is often called 'Linux', and many of its users are
    not aware that it is basically the GNU system, developed by the GNU Project.

    There really is a Linux, and these people are using it, but it is just a
    part of the system they use.  Linux is the kernel: the program in the system
    that allocates the machine's resources to the other programs that you run.
    The kernel is an essential part of an operating system, but useless by itself;
    it can only function in the context of a complete operating system.  Linux is
    normally used in combination with the GNU operating system: the whole system
    is basically GNU with Linux added, or GNU/Linux.  All the so-called 'Linux'
    distributions are really distributions of GNU/Linux.

    WWWWWWWWWWMWN0kl..... .'',;:;';dKXNWWWWWWWWWWWWW
    WWWWWWWWWWWNOl,.... . .:dk000KOo'c0XWWWWWWWWWWWWW
    WWWWWWWMWNXx:.. .,:oxO0KKKXXKKk';kKNWWWWWWWWWWW
    WWWWWWWWWXKo.. . ;oxOO00KKKKKKKXk.;dOKNWWWWWWWWW
    WWWWWWWWX0d;. .'cdkOOOO00KKKKKXXc.;lxKNWWWWWWWW
    WWWWWWNOo;.. .,:ooc;;;:dk0Oo:co0x..':kXWWWWWWWW
    WWWWWKko:'. .;clc;;',:,,dKc,;;okK;..,x0NWWWWWWW
    WWWWXko;'. 'codlcllcl;cOXOccoO0X0. .cOXNWWWWWW
    WWWNKo;.. 'cxkkkxxdookOKXX0O0XNN;..,xKXWWWWWW
    WWNK0c'. ..cdxxxkOkdcolxO00XNWMWd..:dKWWWWWWM
    WNNXOc,. .';lodxkOOko:',':k0NMWXd',ld0NNWWWWW
    NNX0oc,. ...';codxdoc,'..':xXW0x:,,xx0XWWWWWW
    NXO:,. ....',cc:;,,,;';;lkOd;,'.ldOKWWWWWW
    Oko'.. .. ...''''',;;cl:ol;'',cOKKXNNWWWW
    l;.... . . .........';,;coxkkO0kdkOKXNWW
    ;.. . . .. .....'',cxOKKK0kxxk0xdxxOXWW
    ...........','... .'cldxxkO0KKKO0OddddxOO00loOXWW
    .'''....',',,,;,,''',oO000000OOOkxdodooldoccxkkkoxKWW
    '.. ..,,,,;::::clldxkkkkkkkkxxxdoolcclllcllcodkKNWWWW
    ...';.,,',,:;clox0Oxdxxxxxxddooollc;,:lcc:cclxXNNWWWW
    "
}

random_cowsay(){
    fortune | cowsay -f "$(find /usr/share/cowsay/cows/ | shuf -n1 | xargs basename)"
}

-sudo(){
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$(whoami)"
}

-brightness(){
sudo brightnessctl s "$1"%
}

-record-screen(){
RESOLUTION=$(xrandr | grep \* | awk '{print $1}')
ffmpeg -f x11grab -s "$RESOLUTION" -i :0.0 out.mkv
}

-record-me(){
ffmpeg -i /dev/video0 out.mkv
}
