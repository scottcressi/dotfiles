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

    # downloads
    if test ! -d ~/Downloads ; then
    mkdir ~/Downloads
    fi

    # bin
    if test ! -d ~/bin/ ; then
    mkdir ~/bin
    fi

    # wallpaper
    if test ! -d ~/wallpapers/ ; then
    mkdir ~/wallpapers
    fi

    # newsboat
    if test ! -d ~/.newsboat/ ; then
    mkdir ~/.newsboat
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
    curl -s -L https://github.com/docker/compose/releases/download/${version}/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose
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
    version=1.15.0
    if test ! -f ~/bin/kops ; then
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/${version}/kops-linux-amd64 --output ~/bin/kops
    fi

    # helm
    version=v2.16.2
    if test ! -f ~/bin/helm ; then
        curl -s -L --url https://storage.googleapis.com/kubernetes-helm/helm-"${version}"-linux-amd64.tar.gz | gunzip | tar xv
    mv linux-amd64/helm ~/bin/helm ; rm -rf linux-amd64
    helm plugin install https://github.com/futuresimple/helm-secrets
    helm plugin install https://github.com/databus23/helm-diff --version master
    fi

    # helmfile
    version=v0.94.1
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
    version=v0.6.1
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
    fi

    # translate
    if test ! -f ~/bin/trans ; then
    curl -s -L git.io/trans -o ~/bin/trans
    fi

    # permissions
    chmod 755 ~/bin/*

    # firefox
    if test ! -d ~/firefox ; then
    cd || exit
    wget --quiet "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O - | bunzip2 | tar xv
    fi

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
        if [ -z "$(find /var/cache/apt/pkgcache.bin -mmin -1440)" ]; then
        sudo apt-get update --quiet --quiet
        fi

        # packages
        echo "# installing packages"
        awk '{print $1}' "$HOME"/repos/personal/dotfiles/packages.txt | xargs sudo apt-get install -y --quiet --quiet

        # not working
        ##zathura-pdf-mupdf

    fi

}

-packages-python(){
    # python
    python3 -m venv ~/python
    # shellcheck source=/dev/null
    source ~/python/bin/activate
    yes | pip3 install --upgrade \
    awscli \
    botocore==1.12.240 \
    bpython \
    doge \
    dotfiles \
    flake8 \
    ipython \
    modernize \
    socli \
    s-tui \
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

-ds(){
    echo stop all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
        for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
        docker stop "$i"
        done
    fi
}

-dk(){
    echo kill all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
        for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
        docker kill "$i"
        done
    fi
}

-kops-create(){
    aws route53 list-hosted-zones --query HostedZones[].Name[]
    echo
    echo enter domain, ex. foo.com:
    read -r domain
    echo enter cluster name, ex. asdf:
    read -r name
    echo create cluster "$name"."$domain"? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
    kops create cluster \
        --node-count 4 \
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
    fi
}

-kops-get(){
    kops get cluster \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test
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

-awsc(){
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

-keksc(){
    if [ -z "$1" ] ; then echo enter region ; fi
    if [ -z "$2" ] ; then echo enter cluster ; fi
    aws eks update-kubeconfig --region "$1" --name "$2"

}

-keksl(){
    echo region:
    read -r region
    aws eks list-clusters --region "$region"

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
        kubectl patch storageclass standard   -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false", "storageclass.beta.kubernetes.io/is-default-class":"false"}}}'
        kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true",  "storageclass.beta.kubernetes.io/is-default-class":"true" }}}'
    else
        echo please start docker
    fi

}

-dogecoin(){
    DOGE="$(find ~/python/lib/python*/site-packages/doge/static/ -type f -exec basename {} ';' | sort -R  | head -1 )"
    doge --shibe "$DOGE"

}

-random_cowsay(){
    fortune | cowsay -f "$(find /usr/share/cowsay/cows/ | shuf -n1 | xargs basename)"
}

-sudo(){
    echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$(whoami)"
}

-brightness(){
    if (( $(echo "$1 > 1" | bc -l) )); then
        echo please enter 1 or less
        brightness=1
    else
        brightness=$1
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
    MEMORY=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    USEMEM=$(echo "$MEMORY/1024/1024-2" | bc)
    CPU=$(nproc)
    USECPU=$(echo "$CPU-1" | bc)
    minikube start --memory "$USEMEM"g --cpus "$USECPU"
    helm init
    kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
}

-kpeee(){
    kubectl get pods --all-namespaces -o wide --show-labels | awk '{print $11}'
}

-kforward(){
    echo pod:
    read -r pod
    namespace=$(kubectl get pod --all-namespaces | grep "$pod" | awk '{print $1}')
    echo "$namespace"
    port=$(kubectl get pods -n "$namespace" "$pod" --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}')
    echo "$port"
    kubectl port-forward --address 0.0.0.0 --namespace "$namespace" pod/"$pod" 12345:"$port"
}
