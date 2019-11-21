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

-packages(){

    # download dir
    if test ! -d ~/Downloads ; then
    mkdir ~/Downloads
    fi

    # bin dir
    if test ! -d ~/bin/ ; then
    mkdir ~/bin
    fi

    # wallpaper dir
    if test ! -d ~/wallpapers/ ; then
    mkdir ~/wallpapers
    fi

    # st
    version=0.8.2
    if test ! -d ~/st-${version} ; then
    cd || exit
    curl -s -L https://dl.suckless.org/st/st-"${version}".tar.gz | gunzip -c | tar xv
    cd ~/st-${version} || exit
    make clean install
    fi

    # dwm
    version=6.2
    if test ! -d ~/dwm-${version} ; then
    cd || exit
    curl -s -L https://dl.suckless.org/dwm/dwm-"${version}".tar.gz | gunzip -c | tar xv
    cd ~/dwm-"${version}" || exit
    export DESTDIR="$HOME"
    make clean install
    fi

    # dwm slstatus
    if test ! -d "$HOME"/slstatus ; then
    git clone https://git.suckless.org/slstatus "$HOME"/slstatus
    cd "$HOME"/slstatus || exit
    export DESTDIR="$HOME"
    make clean install
    fi

    # docker compose
    version=1.24.1
    if test ! -f ~/bin/docker-compose ; then
    curl -L https://github.com/docker/compose/releases/download/${version}/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose
    fi

    # skaffold
    version=v1.0.1
    if test ! -f ~/bin/skaffold ; then
        curl -s -L --url https://github.com/GoogleContainerTools/skaffold/releases/download/${version}/skaffold-linux-amd64 --output ~/bin/skaffold
    fi

    # minikube
    version=v1.5.2
    if test ! -f ~/bin/minikube ; then
    curl -s -L --url https://storage.googleapis.com/minikube/releases/${version}/minikube-linux-amd64 --output ~/bin/minikube
    fi

    # kops
    version=1.14.1
    if test ! -f ~/bin/kops ; then
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/${version}/kops-linux-amd64 --output ~/bin/kops
    fi

    # helm
    version=v2.16.1
    if test ! -f ~/bin/helm ; then
        curl -s -L --url https://storage.googleapis.com/kubernetes-helm/helm-"${version}"-linux-amd64.tar.gz | gunzip | tar xv
    mv linux-amd64/helm ~/bin/helm ; rm -rf linux-amd64
    helm plugin install https://github.com/futuresimple/helm-secrets
    helm plugin install https://github.com/databus23/helm-diff --version master
    fi

    # helmfile
    version=v0.90.8
    if test ! -f ~/bin/helmfile ; then
    curl -s -L --url https://github.com/roboll/helmfile/releases/download/${version}/helmfile_linux_amd64 --output ~/bin/helmfile
    fi

    # kubectl
    if test ! -f ~/bin/kubectl ; then
    curl -s -L --url https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl --output ~/bin/kubectl
    fi

    # k9s
    version=0.9.3
    if test ! -f ~/bin/k9s ; then
        curl -s -L --url https://github.com/derailed/k9s/releases/download/${version}/k9s_"${version}"_Linux_x86_64.tar.gz | gunzip | tar xv
        mv k9s ~/bin/k9s ; rm -f README.md LICENSE k9s_"${version}"_Linux_x86_64.tar
    fi

    # kind
    version=v0.6.0
    if test ! -f ~/bin/kind ; then
    curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-linux-amd64 --output ~/bin/kind
    fi

    # sops
    version=3.4.0
    if test ! -f ~/bin/sops ; then
        curl -s -L --url https://github.com/mozilla/sops/releases/download/${version}/sops-"${version}".linux --output ~/bin/sops
    fi

    # rakkess
    version=v0.4.2
    if test ! -f ~/bin/rakkess ; then
    curl -s -L --url https://github.com/corneliusweig/rakkess/releases/download/${version}/rakkess-amd64-linux.tar.gz | gunzip | tar xv
    mv rakkess-amd64-linux ~/bin/rakkess ; rm -f LICENSE
    fi

    # slack term
    version=v0.4.1
    if test ! -f ~/bin/slack-term ; then
    curl -s -L --url https://github.com/erroneousboat/slack-term/releases/download/${version}/slack-term-linux-amd64 --output ~/bin/slack-term
    chmod 755 ~/bin/slack-term
    fi

    # translate
    if test ! -f ~/bin/trans ; then
    curl -s -L git.io/trans -o ~/bin/trans
    chmod 755 ~/bin/trans
    fi

    # permissions
    chmod 755 ~/bin/*

    # debian
    if [ -f /etc/debian_version ] ; then
        echo debian based

        if grep ID=ubuntu /etc/os-release ; then
        echo actually ubuntu
        OS=ubuntu
        fi

        if grep ID=debian /etc/os-release ; then
        echo actually debian
        OS=debian
        fi

        # firefox
        if test ! -d ~/firefox ; then
        cd || exit
        wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O - | bunzip2 | tar xv
        fi

        # vagrant
        version=2.2.6
        if test ! -f ~/Downloads/vagrant_"${version}"_x86_64.deb ; then
            curl -s -L https://releases.hashicorp.com/vagrant/${version}/vagrant_${version}_x86_64.deb -o ~/Downloads/vagrant_"${version}"_x86_64.deb
            sudo dpkg -i ~/Downloads/vagrant_"${version}"_x86_64.deb
        fi

        # zoom
        if test ! -f ~/Downloads/zoom_amd64.deb ; then
        curl -s -L https://zoom.us/client/latest/zoom_amd64.deb -o ~/Downloads/zoom_amd64.deb
        sudo dpkg -i ~/Downloads/zoom_amd64.deb
        fi

        # virtalbox
        if ! grep -qF virtualbox /etc/apt/sources.list ; then
        wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
        wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
        sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/$OS bionic contrib"
        fi

        # docker
        if ! grep -qF docker /etc/apt/sources.list ; then
        curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo apt-key add -
        sudo apt-key fingerprint 0EBFCD88
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$OS $(lsb_release -cs) stable"
        fi

        # backports for fzf
        if ! grep -qF backports /etc/apt/sources.list.d/stretch-backports.list ; then
        echo "deb http://http.$OS.net/$OS stretch-backports main contrib non-free" | sudo tee /etc/apt/sources.list.d/stretch-backports.list > /dev/null
        sudo apt-key adv --recv-key 8B48AD6246925553 && sudo apt-key adv --recv-key 7638D0442B90D010
        fi

        # update
        echo "# updating repos"
        sudo apt-get update --quiet --quiet

        # packages
        echo "# installing packages"
        awk '{print $1}' "$HOME"/repos/personal/dotfiles/packages.txt | xargs sudo apt-get install -y --quiet --quiet

        # not working
        ##zathura-pdf-mupdf

    fi

    echo "# installing python packages"

    # python
    python3 -m venv ~/python
    # shellcheck source=/dev/null
    source ~/python/bin/activate
    yes | pip3 install --upgrade \
    awscli \
    bpython \
    ddgr \
    doge \
    dotfiles \
    flake8 \
    ipython \
    modernize \
    s-tui \
    sphinxcontrib-shellcheck \
    socli \
    speedtest-cli \
    youtube-dl \
    --quiet

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
    if [ "$confirm" == "y" ] ; then
        for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
        docker stop "$i"
        done
    fi

}

dk(){
    echo kill all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
        for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
        docker kill "$i"
        done
    fi
}

-kops-create(){
    version=1.15.0
    aws route53 list-hosted-zones --query HostedZones[].Name[]
    echo
    echo enter domain, ex. foo.com:
    read -r domain
    echo enter cluster name, ex. asdf:
    read -r name
    kops create cluster \
        --node-count 1 \
        --name "$name"."$domain" \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        --cloud aws  \
        --zones us-east-1a,us-east-1b \
        --node-size m5.xlarge \
        --kubernetes-version ${version}
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
    echo
    echo enter cluster name ex. foo.example.com:
    read -r cluster
    echo delete cluster "$cluster"? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
        kops delete cluster \
        --name "$cluster" \
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

-is-webcam-on(){
    if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
    echo no
    else
    echo yes
    fi

}

keksc(){
    if [ -z "$1" ] ; then echo enter region ; fi
    if [ -z "$2" ] ; then echo enter cluster ; fi
    aws eks update-kubeconfig --region "$1" --name "$2"

}

keksl(){
    echo region:
    read -r region
    aws eks list-clusters --region "$region"

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

-kind(){
    if [ "$(systemctl show --property ActiveState docker)" == "ActiveState=active" ] ; then
        kind create cluster
        helm init
        kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
        kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
        kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false", "storageclass.beta.kubernetes.io/is-default-class":"false"}}}'
        kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true", "storageclass.beta.kubernetes.io/is-default-class":"true"}}}'
    else
        echo please start docker
    fi

}

-dogecoin(){
    DOGE="$(find ~/python/lib/python3.7/site-packages/doge/static/ -type f -exec basename {} ';' | sort -R  | head -1 )"
    doge --shibe "$DOGE"

}

-hmm(){
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

-rms(){
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

-random_cowsay(){
    fortune | cowsay -f "$(find /usr/share/cowsay/cows/ | shuf -n1 | xargs basename)"
}

-sudo(){
    echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$(whoami)"
}

-brightness(){
    brightness=$1
    if [ "$brightness" -gt 1 ] ; then
        echo please enter 1 or less
        brightness=1
    fi
    screenname=$(xrandr | grep " connected" | cut -f1 -d" ")
    xrandr --output "$screenname" --brightness "$brightness";
}

-record-screen(){
    RESOLUTION=$(xrandr | grep "\\*" | awk '{print $1}')
    ffmpeg -f x11grab -s "$RESOLUTION" -i :0.0 out.mkv
}

-record-me(){
    ffmpeg -i /dev/video0 out.mkv
}

-minikube(){
    version=v1.15.0
    MEMORY=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    USEMEM=$(echo "$MEMORY/1024/1024-2" | bc)
    CPU=$(nproc)
    USECPU=$(echo "$CPU-1" | bc)
    minikube start --memory "$USEMEM"g --cpus "$USECPU" --kubernetes-version "${version}"
}

-kpeee(){
    kubectl get pods --all-namespaces -o wide --show-labels | awk '{print $11}'
}

-kforward(){
    echo port:
    read -r port
    echo namespace:
    read -r namespace
    echo pod:
    read -r pod
    kubectl port-forward --address 0.0.0.0 --namespace "$namespace" pod/"$pod" "$port":"$port"
}
