#!/usr/bin/env bash

# shellcheck source=/dev/null
[[ $(type -P "python3") ]] && [[ -d ~/python ]] && source ~/python/bin/activate

DIRS=(
SORT
_misc
books
comics
documents
drop
emulators
games
music
pictures
sheet_music
software
videos
)

parse_git_branch_and_add_brackets(){
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

-packages(){

    if grep --quiet ID=ubuntu /etc/os-release ; then
        ID=ubuntu
        ID_LIKE=debian
        package_manager=apt-get
    fi

    if grep --quiet ID=debian /etc/os-release ; then
        ID=debian
        ID_LIKE=debian
        package_manager=apt-get
    fi

    if grep --quiet ID=\"centos\" /etc/os-release ; then
        ID=centos
        ID_LIKE=centos
        package_manager=yum
    fi

    # distro packages
    if [ "$package_manager" == "apt-get" ] ; then

        # repos
        echo "deb [arch=amd64] https://download.docker.com/linux/$ID $(grep VERSION_CODENAME /etc/os-release | sed 's/.*=//g') stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list > /dev/null

        # keys
        [[ ! -f /var/tmp/docker.gpg ]] && \
        curl -s -L --url https://download.docker.com/linux/$ID/gpg --output /var/tmp/docker.gpg && \
        sudo apt-key add /var/tmp/docker.gpg && \
        sudo apt-key fingerprint 0EBFCD88

        [[ ! -f /var/tmp/keys.asc ]] && \
        curl -s -L --url https://updates.signal.org/desktop/apt/keys.asc --output /var/tmp/keys.asc && \
        sudo apt-key add /var/tmp/keys.asc

        # update
        echo "# updating repos"
        sudo $package_manager update --quiet --quiet

    fi

    echo "# installing packages"
    grep $ID_LIKE ~/repos/personal/dotfiles/packages.txt | awk '{print $1}' | xargs sudo $package_manager install -y --quiet --quiet

    # docker
    [[ "$(docker ps -a | grep -c 'Up ')" == 0 ]] && \
    echo "# installing docker" && \
    sudo $package_manager install -y --quiet --quiet containerd.io docker-ce docker-ce-cli && \
    sudo usermod -a -G docker "$USER"

    # directories storage
    for i in "${DIRS[@]}" ; do
    mkdir -p ~/mnt/"$i"
    done

    # directories other
    mkdir -p ~/Downloads
    mkdir -p ~/bin
    mkdir -p ~/wallpapers

    # venv
    [[ ! -d ~/python/ ]] && python3 -m venv ~/python

    # statusbar
    [[ ! -d ~/repos/personal/dwmblocks ]] && git clone https://github.com/torrinfail/dwmblocks ~/repos/personal/dwmblocks

    # terraform
    version=0.12.21
    [[ "$(terraform version | grep "v[0-9]" | awk '{print $2}' | sed 's/v//g')" != "$version" ]] && \
    curl -s -L https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip --output ~/bin/terraform_${version}_linux_amd64.zip && \
    unzip -d ~/bin -o ~/bin/terraform_${version}_linux_amd64.zip && \
    rm -f ~/bin/terraform_${version}_linux_amd64.zip

    # terragrunt
    version=v0.21.8
    [[ "$(terragrunt --version | awk '{print $3}')" != "$version" ]] && curl -s -L https://github.com/gruntwork-io/terragrunt/releases/download/${version}/terragrunt_linux_amd64 --output ~/bin/terragrunt

    # docker compose
    version=1.25.4
    [[ ! -f ~/bin/docker-compose ]] && curl -s -L https://github.com/docker/compose/releases/download/${version}/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose

    # skaffold
    version=v1.10.1
    [[ "$(skaffold version)" != "$version" ]] && curl -s -L --url https://github.com/GoogleContainerTools/skaffold/releases/download/${version}/skaffold-linux-amd64 --output ~/bin/skaffold

    # kops
    version=1.16.2
    [[ "$(kops version | awk '{print $2}')" != "$version" ]] && curl -s -L --url https://github.com/kubernetes/kops/releases/download/v${version}/kops-linux-amd64 --output ~/bin/kops

    # helm
    version=v2.16.7
    [[ "$(helm version --client | awk '{print $2}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ]] && \
    curl -s -L --url https://get.helm.sh/helm-"${version}"-linux-amd64.tar.gz | gunzip | tar xv && \
    mv linux-amd64/helm ~/bin/helm && \
    rm -rf linux-amd64 && \
    helm plugin install https://github.com/databus23/helm-diff --version master

    # helmfile
    version=v0.116.0
    [[ "$(helmfile --version | awk '{print $3}')" != "$version" ]] && curl -s -L --url https://github.com/roboll/helmfile/releases/download/${version}/helmfile_linux_amd64 --output ~/bin/helmfile

    # kubectl
    version=v1.18.2
    [[ "$(kubectl version --client | awk '{print $5}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ]] && curl -s -L --url curl -LO https://storage.googleapis.com/kubernetes-release/release/"${version}"/bin/linux/amd64/kubectl --output ~/bin/kubectl

    # k9s
    version=0.19.7
    [[ "$(k9s version --short | grep Version | awk '{print $2}')" != "$version" ]] && \
    curl -s -L --url https://github.com/derailed/k9s/releases/download/v${version}/k9s_Linux_x86_64.tar.gz | gunzip | tar xv && \
    mv k9s ~/bin/k9s ; rm -f README.md LICENSE k9s_"${version}"_Linux_x86_64.tar

    # kind
    version=v0.8.1
    [[ "$(kind version | awk '{print $2}')" != "$version" ]] && curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-linux-amd64 --output ~/bin/kind

    # rakkess
    version=v0.4.4
    [[ "$(rakkess version)" != "$version" ]] && \
    curl -s -L --url https://github.com/corneliusweig/rakkess/releases/download/${version}/rakkess-amd64-linux.tar.gz | gunzip | tar xv && \
    mv rakkess-amd64-linux ~/bin/rakkess ; rm -f LICENSE

    # istioctl
    version=1.5.2
    [[ "$(istioctl version --remote=false)" != "$version" ]] && \
    curl -s -L --url https://github.com/istio/istio/releases/download/${version}/istio-${version}-linux.tar.gz | gunzip | tar xv && \
    mv istio-${version}/bin/istioctl ~/bin/istioctl && \
    rm -rf istio-${version}

    # slack term
    version=v0.4.1
    [[ ! -f ~/bin/slack-term ]] && curl -s -L --url https://github.com/erroneousboat/slack-term/releases/download/${version}/slack-term-linux-amd64 --output ~/bin/slack-term

    # translate
    [[ ! -f ~/bin/trans ]] && curl -s -L git.io/trans -o ~/bin/trans

    # permissions
    chmod 755 ~/bin/*

    # firefox
    version=76.0.1
    [[ ! -d ~/firefox ]] && \
    cd ~/ && curl -s -L --url https://ftp.mozilla.org/pub/firefox/releases/${version}/linux-x86_64/en-US/firefox-${version}.tar.bz2 | tar -xj && \
    ./firefox/firefox -CreateProfile default

    # dwarf fortress
    version=47_04
    [[ ! -d ~/df_linux ]] && \
    curl -s -L --url http://www.bay12games.com/dwarves/df_${version}_linux.tar.bz2 | tar -xj

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
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        --yes ; fi
}

-aws-route53-records(){
    echo domain:
    read -r domain
    ZONE=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$domain.']".Id --output text | sed 's/\/hostedzone\///g')
    aws route53 list-resource-record-sets --hosted-zone-id "$ZONE"

}

-aws-credentials(){
    if [ -z "$1" ] ; then echo enter profile ; echo ; grep "\\[" ~/.aws/credentials ; fi
    export AWS_DEFAULT_PROFILE=$1
}

-is-webcam-on(){
    if [ "$(find /sys/class/power_supply/* -type l | grep -c BAT)" -ge 1 ] ; then
        if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
            echo no
        else
            echo yes
        fi
    fi

}

-aws-eks-config(){
    echo region:
    read -r region
    echo cluster name:
    read -r cluster
    aws eks update-kubeconfig --region "$region" --name "$cluster"

}

-aws-eks-list(){
    echo region:
    read -r region
    aws eks list-clusters --region "$region"

}

-aws-certs(){
    echo region:
    read -r region
    aws acm list-certificates --region "$region"
}

-aws-test(){
    aws sts get-caller-identity ; aws s3 ls

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
    else
        echo please start docker
    fi

}

-brightness(){
    if [ -z "$1" ] ; then
        brightness=1
    else
        brightness=$1
    fi
    screenname=$(xrandr | grep " connected" | cut -f1 -d" ")
    xrandr --output "$screenname" --brightness "$brightness";
}

-record-screen(){
    RESOLUTION=$(xrandr | grep "\\*" | awk '{print $1}')
    ffmpeg -f x11grab -s "$RESOLUTION" -i :0.0 /var/tmp/ffmpeg-screen-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-camera(){
    ffmpeg -i /dev/video0 /var/tmp/ffmpeg-camera-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-security(){
    ffmpeg -i /dev/video0 \
        -vf "select=gt(scene\\,0.0003),setpts=N/(10*TB)" /var/tmp/ffmpeg-security-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-kpeee(){
    kubectl get pods --all-namespaces -o wide --show-labels | awk '{print $11}'
}

-kforward(){
    echo pod:
    read -r pod
    namespace=$(kubectl get pod --all-namespaces | grep "$pod" | awk '{print $1}')
    echo namespace: "$namespace"
    port=$(kubectl describe pod -n "$namespace" "$pod" | grep Port | grep -v Host)
    echo "$port"
    echo enter port to forward
    read -r port
    kubectl port-forward --address 0.0.0.0 --namespace "$namespace" pod/"$pod" 12345:"$port"
}

-mount(){
    # credentials file check
    if [ ! -f ~/.smbpasswd ] ; then
        echo ~/.smbpasswd does not exist, format is password=foo
    else
        smbpasswd_status=1
    fi

    # freenas check

    status=$(nc -z freenas 80 ; echo $?)
    if [ "$status" != "0" ] ; then
        echo freenas down or not in /etc/hosts
    else
        freenas_status=1
    fi

    # mount
    if [ "$smbpasswd_status" == 1 ] && [ "$freenas_status" == 1 ] ; then
        for i in "${DIRS[@]}" ; do
            sudo mount -t cifs //freenas/"$i" ~/mnt/"$i" -o credentials=~/.smbpasswd -v
        done
            sudo mount freenas:/mnt/data/drop/incomplete ~/repos/personal/docker-compose/data/transmission/incomplete
            sudo mount freenas:/mnt/data/drop/completed ~/repos/personal/docker-compose/data/transmission/completed
    fi
}

-umount(){
    for i in "${DIRS[@]}" ; do
    sudo umount -l ~/mnt/"$i"
    done
    sudo umount -l ~/repos/personal/docker-compose/data/transmission/incomplete
    sudo umount -l ~/repos/personal/docker-compose/data/transmission/completed

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

-webserver() {
    ip -oneline -f inet a | grep dynamic | awk '{print $4}' | sed 's/\/.*//g'
    echo
    python3 -m http.server 3333

}

-nonfree() {
    dpkg-query -W -f='${Section}\t${Package}\n' | grep non-free

}

-disable-suspend() {
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

}

-videochat(){
    docker run --rm --name spreed-webrtc -p 8000:8080 -p 8443:8443 -i -t spreed/webrtc
}

-corona(){
    curl 'https://corona-stats.online?top=10&minimal=true'
}

-corona-news(){
    curl 'https://corona-stats.online/updates'
}

-dwmblocks(){
    [[ "$(pgrep dwmblocks)" ]] && pkill dwmblocks
    cp ~/repos/personal/suckless/dwmblocks.blocks.h ~/repos/personal/dwmblocks/blocks.h
    cd ~/repos/personal/dwmblocks && make clean install ; ./dwmblocks &
}

-cowsay-normal(){
    fortune | cowsay -f "$(find /usr/share/cowsay/cows/ | shuf | head -1)"
}

-cowsay-custom(){
    fortune | cowsay -f "$(find ~/repos/personal/cowsay-files/cows | shuf | head -1)"
}

-camera-web-html(){
    docker run --device=/dev/video0:/dev/video0 -p56000:56000 -it gen2brain/cam2ip -bind-addr 0.0.0.0:56000
}

-camera-web-rtsp(){
    docker run --net host --device=/dev/video0 -p 8000:8000 -it mpromonet/webrtc-streamer
}

-packages-st(){
    version=0.8.3
    [[ ! -f ~/st-${version}.tar.gz ]] && curl -s -L --url https://dl.suckless.org/st/st-${version}.tar.gz --output ~/st-${version}.tar.gz
    export DESTDIR="$HOME"
    cd && \
    rm -rf st-${version} && \
    tar zxvf ~/st-${version}.tar.gz && \
    cp -rp ~/repos/personal/suckless/st-* ~/st-${version}/ && \
    cd ~/st-${version} && \
    patch --merge -i st-* && \
    make clean install
}
