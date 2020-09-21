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
    # venv
    [[ ! -d ~/python/ ]] && python3 -m venv ~/python

    # update
    echo updating repos
    sudo apt-get update --quiet --quiet

    # install
    echo installing debian packages
    grep "$(grep ^ID /etc/os-release | sed 's/ID=//g')" ~/repos/personal/dotfiles/packages.txt | awk '{print $1}' | xargs sudo apt-get install -y --quiet --quiet

    # drivers
    echo installing drivers
    if [ "$(lspci | grep VGA | awk '{print $5}')" == "NVIDIA" ] ; then
        sudo apt-get install -y --quiet --quiet nvidia-driver
    fi

    # docker
    echo installing docker
    if ! pgrep docker$ > /dev/null ; then
    [[ ! -f /etc/apt/sources.list.d/docker.list ]] && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    sudo apt-key fingerprint 0EBFCD88 && \
    echo "deb [arch=amd64] https://download.docker.com/linux/$(grep ^ID /etc/os-release | sed 's/ID=//g') $(grep VERSION_CODENAME /etc/os-release | sed 's/.*=//g') stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get install -y --quiet --quiet containerd.io docker-ce docker-ce-cli
    sudo usermod -a -G docker "$USER"
    fi

    # signal
    echo installing signal
    [[ ! -f /etc/apt/sources.list.d/signal-xenial.list ]] && \
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list && \
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    sudo apt-get install -y --quiet --quiet signal-desktop
    sudo chmod 4755 /opt/Signal/chrome-sandbox

    # pip
    echo installing pip
    [[ -d ~/python/ ]] && pip install --upgrade --quiet \
    bpython \
    ipython \
    pylint \

    # directories storage
    for i in "${DIRS[@]}" ; do
    mkdir -p ~/mnt/"$i"
    done

    # directories other
    mkdir -p ~/Downloads
    mkdir -p ~/bin
    mkdir -p ~/wallpapers
    mkdir -p ~/.bash_completion.d
    mkdir -p ~/tmp

    # aws cli
    [[ ! -f ~/awscli-bundle.zip ]] && \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" --output ~/awscli-bundle.zip && \
    cd && unzip awscli-bundle.zip && \
    ./awscli-bundle/install -b ~/bin/aws
    cd ~/bin && ln -sf ~/.local/lib/aws/bin/aws_completer aws_completer
    sudo cp ~/.local/lib/aws/bin/aws_bash_completer ~/.bash_completion.d/aws_bash_completer

    # youtube-dl
    version=2020.07.28
    [[ ! -f ~/bin/youtube-dl ]] && \
    curl -s -L https://github.com/ytdl-org/youtube-dl/releases/download/${version}/youtube-dl --output ~/bin/youtube-dl

    # terraform
    version=0.13.3
    [[ "$(terraform version | grep "v[0-9]" | awk '{print $2}' | sed 's/v//g')" != "$version" ]] && \
    curl -s -L https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip --output ~/tmp/terraform_${version}_linux_amd64.zip && \
    unzip -d ~/bin -o ~/tmp/terraform_${version}_linux_amd64.zip

    # aws-iam-authenticator
    [[ ! -f ~/bin/aws-iam-authenticator ]] && \
    curl -s https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator --output ~/bin/aws-iam-authenticator

    # docker compose
    version=1.26.2
    [[ ! -f ~/bin/docker-compose ]] && \
    curl -s -L https://github.com/docker/compose/releases/download/${version}/docker-compose-"$(uname -s)"-"$(uname -m)" -o ~/bin/docker-compose

    # octant
    version=0.15.0
    [[ "$(octant version | grep Version | awk '{print $2}')" != "$version" ]] && \
    curl -s -L --url https://github.com/vmware-tanzu/octant/releases/download/v${version}/octant_${version}_Linux-64bit.tar.gz --output ~/tmp/octant_${version}_Linux-64bit.tar.gz && \
    tar xvf ~/tmp/octant_${version}_Linux-64bit.tar.gz --directory ~/tmp/ && \
    cp -rp ~/tmp/octant_${version}_Linux-64bit/octant ~/bin/

    # pluto
    version=3.4.1
    cd ~/bin || exit
    [[ "$(pluto version | awk '{print $1}' | sed 's/Version://g')" != "$version" ]] && \
    curl -s -L --url https://github.com/FairwindsOps/pluto/releases/download/v3.4.1/pluto_3.4.1_linux_amd64.tar.gz | tar zx

    # octant plugin
    [[ ! -d ~/.config/octant/plugins/ ]] && \
    mkdir -p ~/.config/octant/plugins/ && \
    curl -s -L https://github.com/bloodorangeio/octant-helm/releases/download/v0.1.0/octant-helm_0.1.0_linux_amd64.tar.gz | tar zx -C ~/.config/octant/plugins/ octant-helm

    # skaffold
    version=v1.14.0
    [[ "$(skaffold version)" != "$version" ]] && \
    curl -s -L --url https://github.com/GoogleContainerTools/skaffold/releases/download/${version}/skaffold-linux-amd64 --output ~/bin/skaffold

    # kops
    version=1.18.0
    [[ "$(kops version | awk '{print $2}')" != "$version" ]] && \
    curl -s -L --url https://github.com/kubernetes/kops/releases/download/v${version}/kops-linux-amd64 --output ~/bin/kops

    # helm
    version=v3.3.3
    [[ "$(helm version --client | awk '{print $1}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ]] && \
    curl -s -L --url https://get.helm.sh/helm-"${version}"-linux-amd64.tar.gz --output ~/tmp/helm-"${version}"-linux-amd64.tar.gz && \
    tar xvf ~/tmp/helm-"${version}"-linux-amd64.tar.gz --directory ~/tmp/ && \
    cp -rp ~/tmp/linux-amd64/helm ~/bin/helm

    # kubectl
    version=v1.18.2
    [[ "$(kubectl version --client | awk '{print $5}' | sed 's/.*:"//g' | sed 's/",//g')" != "$version" ]] && \
    curl -s -LO https://storage.googleapis.com/kubernetes-release/release/"${version}"/bin/linux/amd64/kubectl --output ~/bin/kubectl

    # k9s
    version=0.22.1
    [[ "$(k9s version --short | grep Version | awk '{print $2}')" != "$version" ]] && \
    curl -s -L --url https://github.com/derailed/k9s/releases/download/v${version}/k9s_Linux_x86_64.tar.gz --output ~/tmp/k9s_Linux_x86_64.tar.gz && \
    tar xvf ~/tmp/k9s_Linux_x86_64.tar.gz --directory ~/tmp/ && \
    cp -rp ~/tmp/k9s ~/bin/

    # kind
    version=v0.9.0
    [[ "$(kind version | awk '{print $2}')" != "$version" ]] && \
    curl -s -L --url https://github.com/kubernetes-sigs/kind/releases/download/${version}/kind-linux-amd64 --output ~/bin/kind

    # rakkess
    version=v0.4.4
    [[ "$(rakkess version)" != "$version" ]] && \
    curl -s -L --url https://github.com/corneliusweig/rakkess/releases/download/${version}/rakkess-amd64-linux.tar.gz --output ~/tmp/rakkess-amd64-linux.tar.gz && \
    tar xvf ~/tmp/rakkess-amd64-linux.tar.gz --directory ~/tmp/ && \
    cp -rp ~/tmp/rakkess-amd64-linux ~/bin/rakkess

    # istioctl
    version=1.5.2
    [[ "$(istioctl version --remote=false)" != "$version" ]] && \
    curl -s -L --url https://github.com/istio/istio/releases/download/${version}/istio-${version}-linux.tar.gz --output ~/tmp/istio-${version}-linux.tar.gz && \
    tar xvf ~/tmp/istio-${version}-linux.tar.gz --directory ~/tmp/ && \
    cp -rp ~/tmp/istio-${version}/bin/istioctl ~/bin/

    # slack term
    version=v0.5.0
    [[ ! -f ~/bin/slack-term ]] && \
    curl -s -L --url https://github.com/erroneousboat/slack-term/releases/download/${version}/slack-term-linux-amd64 --output ~/bin/slack-term

    # dwarf fortress
    version=47_04
    [[ ! -d ~/repos/thirdparty/df_linux ]] && \
    curl -s -L --url http://www.bay12games.com/dwarves/df_${version}_linux.tar.bz2 --output ~/repos/thirdparty/df_${version}_linux.tar.bz2 && \
    tar xvf ~/repos/thirdparty/df_${version}_linux.tar.bz2 --directory ~/repos/thirdparty/ && \

    # completions
    [[ ! -f ~/.bash_completion.d/kubectl ]] && kubectl completion bash | sudo tee ~/.bash_completion.d/kubectl
    [[ ! -f ~/.bash_completion.d/docker-compose ]] && \
    sudo curl -s -L https://raw.githubusercontent.com/docker/compose/1.26.0/contrib/completion/bash/docker-compose -o ~/.bash_completion.d/docker-compose

    # if wm
    if pgrep startx > /dev/null ; then

        # firefox
        version=$(curl -s https://www.mozilla.org/en-US/firefox/releases/| grep data-latest | awk '{print $7}' | sed 's/.*=//g' | sed 's/"//g')
        [[ ! -d ~/firefox ]] && \
        cd ~/ && curl -s -L --url https://ftp.mozilla.org/pub/firefox/releases/"${version}"/linux-x86_64/en-US/firefox-"${version}".tar.bz2 | tar -xj

        # firefox profile
        ~/firefox/firefox -CreateProfile default
        ~/firefox/firefox -CreateProfile guest
        profile=$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)
        profile_dir=$profile/extensions
        [[ ! -d $profile_dir ]] && mkdir "$profile_dir"

        # ghacks + overrides
        version=80.0
        [[ ! -d ~/repos/thirdparty/ghacks-user.js ]] && \
        git clone https://github.com/ghacksuserjs/ghacks-user.js.git ~/repos/thirdparty/ghacks-user.js
        [[ $(cd ~/repos/thirdparty/ghacks-user.js && git branch | awk '{print $5}' | sed s/\)//g | head -1) != "$version" ]] && \
        cd ~/repos/thirdparty/ghacks-user.js && git checkout $version
        [[ ! -f $profile/user.js ]] && grep ^user_pref ~/repos/thirdparty/ghacks-user.js/user.js ~/repos/personal/firefox/user-overrides.js | sed 's/.*user_pref/user_pref/g' > "$profile"/user.js

        # stocks
        [[ ! -d ~/repos/thirdparty/ticker.sh ]] && \
        git clone https://github.com/pstadler/ticker.sh.git ~/repos/thirdparty/ticker.sh

        # addons
        [[ ! -f $profile_dir/uBlock0@raymondhill.net.xpi ]] && \
        curl -s -L --url https://addons.mozilla.org/firefox/downloads/file/3579401/ublock_origin-1.27.10-an+fx.xpi?src=search --output "$profile_dir"/uBlock0@raymondhill.net.xpi
        [[ ! -f $profile_dir/\{446900e4-71c2-419f-a6a7-df9c091e268b\}.xpi ]] && \
        curl -s -L --url https://addons.mozilla.org/firefox/downloads/file/3582922/bitwarden_free_password_manager-1.44.3-an+fx.xpi?src=search --output "$profile_dir"/\{446900e4-71c2-419f-a6a7-df9c091e268b\}.xpi
        [[ ! -f $profile_dir/\{e6e36c9a-8323-446c-b720-a176017e38ff\}.xpi ]] && \
        curl -s -L --url https://addons.mozilla.org/firefox/downloads/file/3566579/torrent_control-0.2.18-fx.xpi?src=search --output "$profile_dir"/\{e6e36c9a-8323-446c-b720-a176017e38ff\}.xpi
        [[ ! -f $profile_dir/2341n4m3@gmail.com.xpi ]] && \
        curl -s -L --url https://addons.mozilla.org/firefox/downloads/file/717262/ageless_for_youtube-1.3-an+fx.xpi?src=search --output "$profile_dir"/2341n4m3@gmail.com.xpi

    fi

    # permissions
    chmod 755 ~/bin/*

    # return
    cd || return

}

-docker-stop-all(){
    echo stop all containers? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
        for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
        docker stop "$i"
        done
    fi
}

-docker-kill-all(){
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
    echo enter cluster name, ex. test.example.com:
    read -r cluster
    echo create cluster "$cluster"? y/n
    read -r confirm
    if [ "$confirm" == "y" ] ; then
    kops create cluster \
        --node-count 4 \
        --name "$cluster" \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        --cloud aws  \
        --zones us-east-1a,us-east-1b \
        --node-size m5.xlarge
    kops update \
        --state s3://"$(aws sts get-caller-identity --output text --query 'Account')"-kops-test \
        cluster \
        --name "$cluster"\
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

-aws-get-route53-records(){
    echo domain:
    read -r domain
    ZONE=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='$domain.']".Id --output text | sed 's/\/hostedzone\///g')
    aws route53 list-resource-record-sets --hosted-zone-id "$ZONE"

}

-aws-config-credentials(){
    [[ -z "$1" ]] && echo enter profile ; echo ; grep "\\[" ~/.aws/credentials
    export AWS_DEFAULT_PROFILE=$1
}

-is-webcam-on(){
if [ "$(find /dev/ | grep -c video)" -gt 0 ] ; then
        if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
            echo no
        else
            echo yes
        fi
    fi

}

-aws-config-eks(){
    echo region:
    read -r region
    aws eks list-clusters --region "$region"
    echo cluster name:
    read -r cluster
    aws eks update-kubeconfig --region "$region" --name "$cluster"

}

-aws-get-certs(){
    echo region:
    read -r region
    aws acm list-certificates --region "$region"
}

-aws-test(){
    aws sts get-caller-identity ; aws s3 ls

}

-lock-auto(){
    pkill xautolock
    xautolock -time 1 -locker slock & disown

}

-lock(){
    slock

}

-kind(){
    kind create cluster

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
    ffmpeg -f x11grab -s "$RESOLUTION" -i :0.0 ~/tmp/ffmpeg-screen-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-camera(){
    ffmpeg -i /dev/video0 ~/tmp/ffmpeg-camera-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-security(){
    ffmpeg -i /dev/video0 \
        -vf "select=gt(scene\\,0.0003),setpts=N/(10*TB)" ~/tmp/ffmpeg-security-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-kpeee(){
    kubectl get pods --all-namespaces -o wide --show-labels | awk '{print $11}'
}

-kforward(){
    random_port=$(( ( RANDOM % 12345 )  + 1024 ))
    echo $random_port
    echo pod:
    read -r pod
    namespace=$(kubectl get pod --all-namespaces | grep "$pod" | awk '{print $1}')
    echo namespace: "$namespace"
    port=$(kubectl describe pod -n "$namespace" "$pod" | grep Port | grep -v Host)
    echo "$port"
    echo enter port to forward
    read -r port
    kubectl port-forward --address 0.0.0.0 --namespace "$namespace" pod/"$pod" $random_port:"$port"
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
        echo freenas down or not in hosts file
    else
        freenas_status=1
    fi

    # mount
    if [ "$smbpasswd_status" == 1 ] && [ "$freenas_status" == 1 ] ; then
        for i in "${DIRS[@]}" ; do
            sudo mount -t cifs //freenas/"$i" ~/mnt/"$i" -o credentials=~/.smbpasswd -v
        done
            sudo mount freenas:/mnt/data/drop/incomplete ~/data/transmission/incomplete
            sudo mount freenas:/mnt/data/drop/completed ~/data/transmission/completed
    fi
}

-umount(){
    for i in "${DIRS[@]}" ; do
    sudo umount -l ~/mnt/"$i"
    done
    sudo umount -l ~/data/transmission/incomplete
    sudo umount -l ~/data/transmission/completed

}

-extract(){
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       7z x "$1"         ;;
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
    docker run --name spreed-webrtc -p 8000:8080 -p 8443:8443 -i -t spreed/webrtc
}

-corona-stats(){
    curl 'https://corona-stats.online?top=10&minimal=true'
}

-corona-news(){
    curl 'https://corona-stats.online/updates'
}

-suckless(){
    # dwm
    version=6.2
    [[ ! -d ~/repos/thirdparty/dwm ]] && \
    git clone https://git.suckless.org/dwm ~/repos/thirdparty/dwm
    export DESTDIR="$HOME" && \
    cd ~/repos/thirdparty/dwm && \
    make clean install --quiet && \
    git checkout ${version} && git clean -df

    # dwmblocks
    [[ ! -d ~/repos/thirdparty/dwmblocks ]] && \
    git clone https://github.com/torrinfail/dwmblocks ~/repos/thirdparty/dwmblocks
    [[ "$(pgrep dwmblocks)" ]] && pkill dwmblocks
    cp ~/repos/personal/dwmblocks/dwmblocks.blocks.h ~/repos/thirdparty/dwmblocks/blocks.h
    cd ~/repos/thirdparty/dwmblocks && make clean install ; ./dwmblocks & disown
    cd ~/repos/thirdparty/dwmblocks && git checkout .

    # st
    version=0.8.4
    [[ ! -d ~/repos/thirdparty/st ]] && \
    git clone https://git.suckless.org/st ~/repos/thirdparty/st
    cd ~/repos/thirdparty/st && git checkout ${version} && \
    export DESTDIR="$HOME" && \
    curl -s -L --url https://st.suckless.org/patches/scrollback/st-scrollback-20200419-72e3f6c.diff --output ~/repos/thirdparty/st/st-scrollback-20200419-72e3f6c.diff && \
    patch --quiet --merge -i st-* && \
    make clean install --quiet && \
    cd ~/repos/thirdparty/st && git clean -df && git checkout .
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

-translate(){
    docker run -ti soimort/translate-shell
}

-generate-person(){
    curl -s -o ~/tmp/person https://thispersondoesnotexist.com/image && sxiv ~/tmp/person
}

-git-push-all-remotes(){
    if [ "$(pwd | grep personal && echo $?)" == "0" ] ; then
        git remote | xargs -L1 git push --all
    else
        echo nope
    fi
}

-ssh-port-forward(){
    echo port:
    read -r port
    echo host:
    read -r host
    ssh -L "$port":localhost:"$port" "$host"
}

-bookmarks-backup(){
    if [ -d /sys/module/battery ] ; then
        echo not allowed from this machine
    else
        7z a -p"$(cat ~/.bookmarkspasswd)" ~/repos/personal/buku/places.sqlite.7z "$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)"/places.sqlite
    fi
}

-bookmarks-restore(){
    cd ~/repos/personal/buku/ || exit
    7z x -p"$(cat ~/.bookmarkspasswd)" ~/repos/personal/buku/places.sqlite.7z
    mv ~/repos/personal/buku/places.sqlite "$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)"/places.sqlite
}

-ip(){
    ip -oneline -f inet a | grep dynamic | awk '{print $4}' | sed 's/\/.*//g'
}

-wallpaper(){
    find ~/wallpapers/ -type f | shuf | head -1 | xargs xwallpaper --maximize
}
