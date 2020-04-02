#!/usr/bin/env bash

if [ "$(find /sys/class/power_supply/* -type l | grep -c BAT)" -ge 1 ] ; then
    MACHINE=laptop
fi

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

# shellcheck source=/dev/null
[[ -d ~/python/ ]] && source ~/python/bin/activate

DIRS=(
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

    # distro packages
    if [ "$package_manager" == "apt-get" ] ; then

        # repos
        echo "deb [arch=amd64] https://download.docker.com/linux/$ID $(grep VERSION_CODENAME /etc/os-release | sed 's/.*=//g') stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list > /dev/null

        # key docker
        if [ ! -f /var/tmp/docker.gpg ] ; then
        curl -s -L --url https://download.docker.com/linux/$ID/gpg --output /var/tmp/docker.gpg
        sudo apt-key add /var/tmp/docker.gpg
        sudo apt-key fingerprint 0EBFCD88
        sudo usermod -a -G docker "$USER"
        fi

        # key signal
        if [ ! -f /var/tmp/keys.asc ] ; then
        curl -s -L --url https://updates.signal.org/desktop/apt/keys.asc --output /var/tmp/keys.asc
        sudo apt-key add /var/tmp/keys.asc
        fi

        # update
        echo "# updating repos"
        sudo $package_manager update --quiet --quiet

    fi

    echo "# installing packages"
    grep $ID_LIKE ~/repos/personal/dotfiles/packages.txt | awk '{print $1}' | xargs sudo $package_manager install -y --quiet --quiet

    # docker
    if [ "$(docker ps | grep -cv CONTAINER)" == "0" ] ; then
        echo "# installing docker"
        sudo $package_manager install -y --quiet --quiet containerd.io docker-ce docker-ce-cli
    else
        echo please stop all containers
    fi

    # directories storage
    for i in "${DIRS[@]}" ; do
    mkdir -p ~/mnt/"$i"
    done

    # directories other
    mkdir -p ~/Downloads
    mkdir -p ~/bin
    mkdir -p ~/wallpapers

    # venv
    if [ ! -d ~/python/ ] ; then
    python3 -m venv ~/python
    fi

    # statusbar
    [[ ! -d ~/repos/personal/dwmblocks ]] && git clone https://github.com/torrinfail/dwmblocks ~/repos/personal/dwmblocks

    # terraform
    version=0.12.21
    if [ "$(terraform version | grep "v[0-9]" | awk '{print $2}' | sed 's/v//g')" != "$version" ] ; then
    curl -s -L https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip --output ~/bin/terraform_${version}_linux_amd64.zip
    unzip -d ~/bin -o ~/bin/terraform_${version}_linux_amd64.zip
    rm -f ~/bin/terraform_${version}_linux_amd64.zip
    fi

    # terragrunt
    version=v0.21.8
    if [ "$(terragrunt --version | awk '{print $3}')" != "$version" ] ; then
    curl -s -L https://github.com/gruntwork-io/terragrunt/releases/download/${version}/terragrunt_linux_amd64 --output ~/bin/terragrunt
    fi

    # docker compose
    version=1.25.4
    if test ! -f ~/bin/docker-compose ; then
    curl -s -L https://github.com/docker/compose/releases/download/${version}/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose
    fi

    # skaffold
    version=v1.6.0
    if [ "$(skaffold version)" != "$version" ] ; then
        curl -s -L --url https://github.com/GoogleContainerTools/skaffold/releases/download/${version}/skaffold-linux-amd64 --output ~/bin/skaffold
    fi

    # kops
    version=1.16.0
    if [ "$(kops version | awk '{print $2}')" != "$version" ] ; then
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/v${version}/kops-linux-amd64 --output ~/bin/kops
    fi

    # helm
    version=v2.16.5
    if [ "$(helm version --client | awk '{print $2}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ] ; then
    curl -s -L --url https://get.helm.sh/helm-"${version}"-linux-amd64.tar.gz | gunzip | tar xv
    mv linux-amd64/helm ~/bin/helm
    rm -rf linux-amd64
    helm plugin install https://github.com/databus23/helm-diff --version master
    fi

    # helmfile
    version=v0.106.2
    if [ "$(helmfile --version | awk '{print $3}')" != "$version" ] ; then
    curl -s -L --url https://github.com/roboll/helmfile/releases/download/${version}/helmfile_linux_amd64 --output ~/bin/helmfile
    fi

    # kubectl
    version=v1.17.2
    if [ "$(kubectl version --client | awk '{print $5}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ] ; then
    curl -s -L --url curl -LO https://storage.googleapis.com/kubernetes-release/release/"${version}"/bin/linux/amd64/kubectl --output ~/bin/kubectl
    fi

    # k9s
    version=0.18.1
    if [ "$(k9s version --short | grep Version | awk '{print $2}')" != "$version" ] ; then
    curl -s -L --url https://github.com/derailed/k9s/releases/download/v${version}/k9s_Linux_x86_64.tar.gz | gunzip | tar xv
    mv k9s ~/bin/k9s ; rm -f README.md LICENSE k9s_"${version}"_Linux_x86_64.tar
    fi

    # kind
    version=v0.7.0
    if [ "$(kind version | awk '{print $2}')" != "$version" ] ; then
    curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-linux-amd64 --output ~/bin/kind
    fi

    # rakkess
    version=v0.4.2
    if [ "$(rakkess version)" != "$version-dirty" ] ; then
    curl -s -L --url https://github.com/corneliusweig/rakkess/releases/download/${version}/rakkess-amd64-linux.tar.gz | gunzip | tar xv
    mv rakkess-amd64-linux ~/bin/rakkess ; rm -f LICENSE
    fi

    # istioctl
    version=1.5.0
    if [ "$(istioctl version --remote=false)" != "$version" ] ; then
    curl -s -L --url https://github.com/istio/istio/releases/download/${version}/istio-${version}-linux.tar.gz | gunzip | tar xv
    mv istio-${version}/bin/istioctl ~/bin/istioctl
    rm -rf istio-${version}
    fi

    # slack term
    version=v0.4.1
    if test ! -f ~/bin/slack-term ; then
    curl -s -L --url https://github.com/erroneousboat/slack-term/releases/download/${version}/slack-term-linux-amd64 --output ~/bin/slack-term
    fi

    # translate
    [[ ! -f ~/bin/trans ]] && curl -s -L git.io/trans -o ~/bin/trans

    # permissions
    chmod 755 ~/bin/*

    # firefox
    version=74.0
    current_version=$(grep ^Version ~/firefox/application.ini | sed 's/Version=//g')
    if [ "$version" != "$current_version" ] ; then
        if [ "$(pgrep firefox | wc -l)" -ge 1 ] ; then
            echo close firefox to update to "$version"
        else
            rm -rf  ~/firefox
            curl -s -L --url https://ftp.mozilla.org/pub/firefox/releases/"${version}"/linux-x86_64/en-US/firefox-"${version}".tar.bz2 --output ~/firefox-"${version}".tar.bz2
            bunzip2 ~/firefox-"${version}".tar.bz2
            tar xvf ~/firefox-"${version}".tar -C "${HOME}"
            rm -f ~/firefox-"${version}".tar
            fi
    fi

    # dwarf fortress
    version=47_04
    if test ! -d ~/df_linux ; then
    curl -s -L --url http://www.bay12games.com/dwarves/df_${version}_linux.tar.bz2 --output ~/df_${version}_linux.tar.bz2
    bunzip2 ~/df_${version}_linux.tar.bz2
    tar xvf ~/df_${version}_linux.tar -C "${HOME}"
    rm -f ~/df_${version}_linux.tar
    fi

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
    if [ "$MACHINE" == "laptop" ] ; then
        if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
            echo no
        else
            echo yes
        fi
    fi

}

-aws-eks-config(){
    if [ -z "$1" ] ; then echo enter region ; fi
    if [ -z "$2" ] ; then echo enter cluster ; fi
    aws eks update-kubeconfig --region "$1" --name "$2"

}

-aws-eks-list(){
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
            sudo mount -t cifs //freenas/drop ~/repos/personal/docker-compose/data/transmission/data -o credentials=~/.smbpasswd -v
    fi
}

-umount(){
    for i in "${DIRS[@]}" ; do
    sudo umount -l ~/mnt/"$i"
    done
    sudo umount -l ~/repos/personal/docker-compose/data/transmission/data
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
ip -oneline -f inet a | grep -v docker | grep -v " lo " | awk '{print $4}' | sed 's/\/.*//g'
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
curl 'https://corona-stats.online?top=10&minimal=true&emojis=true'
}

-corona-news(){
curl 'https://corona-stats.online/updates'
}

-dwmblocks(){
if pgrep dwmblocks; then pkill dwmblocks; fi
cp ~/repos/personal/suckless/dwmblocks.blocks.h ~/repos/personal/dwmblocks/blocks.h
cd ~/repos/personal/dwmblocks && make clean install ; ./dwmblocks &
}

-cowsay-normal(){
fortune | `ls /usr/games/cow* | shuf -n 1` -f `ls /usr/share/cowsay/cows/ | shuf -n 1`
}

-cowsay-custom(){
fortune | cowsay -f "$(find ~/repos/personal/cowsay-files/cows | shuf | head -1)"
}
