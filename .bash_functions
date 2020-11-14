#!/usr/bin/env bash

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

BIN=~/bin
TMP=~/tmp
REPOS=~/repos

# directories
mkdir -p ~/Downloads
mkdir -p $BIN
mkdir -p ~/wallpapers
mkdir -p ~/.bash_completion.d
mkdir -p $TMP

# directories storage
for i in "${DIRS[@]}" ; do
mkdir -p ~/mnt/"$i"
done

# shellcheck source=/dev/null
[ -f ~/python/bin/activate ] && source ~/python/bin/activate

parse_git_branch_and_add_brackets(){
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

-packages(){
    echo virtualbox key
    [[ ! -f /etc/apt/sources.list.d/virtualbox.list ]] && \
    echo "deb http://download.virtualbox.org/virtualbox/debian buster contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list && \
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

    echo signal key
    [[ ! -f /etc/apt/sources.list.d/signal-xenial.list ]] && \
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list && \
    curl https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -

    echo docker key
    [[ ! -f /etc/apt/sources.list.d/docker.list ]] && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    sudo apt-key fingerprint 0EBFCD88 && \
    echo "deb [arch=amd64] https://download.docker.com/linux/$(grep ^ID /etc/os-release | sed 's/ID=//g') $(grep VERSION_CODENAME /etc/os-release | sed 's/.*=//g') stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    echo venv
    [ ! -f ~/python/bin/activate ] && python3 -m venv ~/python

    echo updating repos
    sudo apt-get update --quiet --quiet

    echo installing packages
    awk '/debian/ {print $1}' $REPOS/personal/dotfiles/packages.txt | awk '{print $1}' | xargs sudo apt-get install -y --quiet --quiet

    echo installing drivers
    if [ "$(lspci | grep VGA | awk '{print $5}')" == "NVIDIA" ] ; then
        sudo apt-get install -y --quiet --quiet nvidia-driver
    fi

    echo installing docker
    if ! pgrep docker$ > /dev/null ; then
    sudo apt-get install -y --quiet --quiet containerd.io docker-ce docker-ce-cli
    fi
    sudo usermod -a -G docker "$USER"

    echo installing signal
    sudo apt-get install -y --quiet --quiet signal-desktop
    sudo chmod 4755 /opt/Signal/chrome-sandbox

    echo installing virtualbox
    sudo apt-get install -y --quiet --quiet virtualbox-6.1

    echo installing pip
    [ "$VIRTUAL_ENV" != "" ] && \
    python3 -m pip install --upgrade --quiet \
    awscli \
    bpython \
    pgcli \
    ipython \
    pylint \

    echo youtube-dl
    version_youtube_dl=2020.11.12
    [[ ! -f $BIN/youtube-dl ]] && \
    curl -L https://youtube-dl.org/downloads/latest/youtube-dl-${version_youtube_dl}.tar.gz | tar xz youtube-dl/youtube-dl && \
    mv youtube-dl/youtube-dl $BIN/ && \
    rmdir youtube-dl

    echo terraform
    version_terraform=0.13.5
    [[ ! -f $BIN/terraform ]] && \
    curl -L -O https://releases.hashicorp.com/terraform/${version_terraform}/terraform_${version_terraform}_linux_amd64.zip && \
    unzip terraform_${version_terraform}_linux_amd64.zip && \
    mv terraform $BIN/
    rm -f terraform_${version_terraform}_linux_amd64.zip

    echo vagrant
    version_vagrant=2.2.10
    [[ "$(dpkg -l vagrant | grep vagrant | awk '{print $3}' | sed s/1://g)" != "$version_vagrant" ]] && \
    curl -L https://releases.hashicorp.com/vagrant/${version_vagrant}/vagrant_${version_vagrant}_x86_64.deb --output vagrant_${version_vagrant}_x86_64.deb && \
    sudo dpkg -i vagrant_${version_vagrant}_x86_64.deb && \
    rm -f vagrant_${version_vagrant}_x86_64.deb

    echo vault
    version_vault=1.5.5
    [[ ! -f $BIN/vault ]] && \
    curl -L -O https://releases.hashicorp.com/vault/${version_vault}/vault_${version_vault}_linux_amd64.zip && \
    unzip vault_${version_vault}_linux_amd64.zip && \
    mv vault $BIN/
    rm -f vault_${version_vault}_linux_amd64.zip

    echo aws-iam-authenticator
    [[ ! -f $BIN/aws-iam-authenticator ]] && \
    curl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator --output $BIN/aws-iam-authenticator

    echo docker compose
    version_docker_compose=1.27.4
    [[ ! -f $BIN/docker-compose ]] && \
    curl -L https://github.com/docker/compose/releases/download/${version_docker_compose}/docker-compose-"$(uname -s)"-"$(uname -m)" -o $BIN/docker-compose

    echo pluto
    version_pluto=3.4.1
    [[ ! -f $BIN/pluto ]] && \
    curl -L --url https://github.com/FairwindsOps/pluto/releases/download/v${version_pluto}/pluto_${version_pluto}_linux_amd64.tar.gz | tar zx -C $BIN/ pluto

    echo skaffold
    version_skaffold=v1.16.0
    [[ ! -f $BIN/skaffold ]] && \
    curl -L --url https://github.com/GoogleContainerTools/skaffold/releases/download/${version_skaffold}/skaffold-linux-amd64 --output $BIN/skaffold

    echo kops
    version_kops=1.18.0
    [[ ! -f $BIN/kops ]] && \
    curl -L --url https://github.com/kubernetes/kops/releases/download/v${version_kops}/kops-linux-amd64 --output $BIN/kops

    echo helm
    version_helm=v3.4.1
    [[ ! -f $BIN/helm ]] && \
    curl -L --url https://get.helm.sh/helm-"${version_helm}"-linux-amd64.tar.gz | tar zx linux-amd64/helm && \
    mv linux-amd64/helm $BIN && \
    rmdir linux-amd64

    echo kubectl
    version_kubectl=v1.18.2
    [[ ! -f $BIN/kubectl ]] && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/"${version_kubectl}"/bin/linux/amd64/kubectl --output $BIN/kubectl

    echo k9s
    version_k9s=0.23.1
    [[ ! -f $BIN/k9s ]] && \
    curl -L --url https://github.com/derailed/k9s/releases/download/v${version_k9s}/k9s_Linux_x86_64.tar.gz | tar zxv k9s && \
    mv k9s $BIN

    echo kind
    version_kind=v0.9.0
    [[ ! -f $BIN/kind ]] && \
    curl -L --url https://github.com/kubernetes-sigs/kind/releases/download/${version_kind}/kind-linux-amd64 --output $BIN/kind

    echo rakkess
    version_rakkess=v0.4.4
    [[ ! -f $BIN/rakkess ]] && \
    curl -L --url https://github.com/corneliusweig/rakkess/releases/download/${version_rakkess}/rakkess-amd64-linux.tar.gz | tar zxv rakkess-amd64-linux && \
    mv rakkess-amd64-linux $BIN/rakkess

    echo istioctl
    version_istioctl=1.5.2
    [[ ! -f $BIN/istioctl ]] && \
    curl -L --url https://github.com/istio/istio/releases/download/${version_istioctl}/istio-${version_istioctl}-linux.tar.gz | tar zxv istio-${version_istioctl}/bin/istioctl && \
    mv istio-${version_istioctl}/bin/istioctl $BIN/istioctl && \
    rmdir -p istio-${version_istioctl}/bin

    echo slack term
    version_slack_term=v0.5.0
    [[ ! -f $BIN/slack-term ]] && \
    curl -L --url https://github.com/erroneousboat/slack-term/releases/download/${version_slack_term}/slack-term-linux-amd64 --output $BIN/slack-term

    echo dwarf fortress
    version_dwarf_fortress=47_04
    [[ ! -d $REPOS/thirdparty/df_linux ]] && \
    curl -L --url http://www.bay12games.com/dwarves/df_${version_dwarf_fortress}_linux.tar.bz2 --output $REPOS/thirdparty/df_${version_dwarf_fortress}_linux.tar.bz2 && \
    tar xvf $REPOS/thirdparty/df_${version_dwarf_fortress}_linux.tar.bz2 --directory $REPOS/thirdparty/ && \

    echo completions
    [[ ! -f ~/.bash_completion.d/kubectl ]] && kubectl completion bash | sudo tee ~/.bash_completion.d/kubectl
    [[ ! -f ~/.bash_completion.d/docker-compose ]] && \
    sudo curl -L https://raw.githubusercontent.com/docker/compose/1.26.0/contrib/completion/bash/docker-compose -o ~/.bash_completion.d/docker-compose

    echo stocks
    [[ ! -d $REPOS/thirdparty/ticker.sh ]] && git clone https://github.com/pstadler/ticker.sh.git $REPOS/thirdparty/ticker.sh

    echo firefox
    version_firefox=82.0.3
    [[ ! -d ~/firefox ]] && \
    curl -L --url https://ftp.mozilla.org/pub/firefox/releases/"${version_firefox}"/linux-x86_64/en-US/firefox-"${version_firefox}".tar.bz2 | tar -xj && \
    mv firefox ~/

    echo firefox profile
    ~/firefox/firefox -headless -CreateProfile default
    profile_default=$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)
    profile_default_extensions=$profile_default/extensions
    mkdir -p "$profile_default_extensions"

    echo ghacks repo
    version_ghacks=81.0
    [[ ! -f $REPOS/thirdparty/user.js ]] && \
    curl -L --url https://github.com/arkenfox/user.js/archive/${version_ghacks}.tar.gz | tar xz user.js-${version_ghacks}/user.js && \
    mv user.js-${version_ghacks}/user.js $REPOS/thirdparty/user.js && \
    rmdir user.js-${version_ghacks}

    echo ghacks settings
    echo > "$profile_default"/user.js
    #grep ^user_pref $REPOS/thirdparty/ghacks-user.js/user.js | sed 's/.*user_pref/user_pref/g' > "$profile_default"/user.js

    echo user.js settings
    echo '''
    user_pref("browser.ctrlTab.recentlyUsedOrder", false); // tabs with tabbing
    user_pref("extensions.autoDisableScopes", 0); // auto enable addons
    user_pref("app.update.auto", false); // disable updates
    ''' >> "$profile_default"/user.js

    echo addons default
    [[ ! -f $profile_default_extensions/uBlock0@raymondhill.net.xpi ]] && \
        curl -L \
        --url https://addons.mozilla.org/firefox/downloads/file/3579401/ublock_origin-1.27.10-an+fx.xpi \
        --output "$profile_default_extensions"/uBlock0@raymondhill.net.xpi
    [[ ! -f $profile_default_extensions/\{446900e4-71c2-419f-a6a7-df9c091e268b\}.xpi ]] && \
        curl -L \
        --url https://addons.mozilla.org/firefox/downloads/file/3582922/bitwarden_free_password_manager-1.44.3-an+fx.xpi \
        --output "$profile_default_extensions"/\{446900e4-71c2-419f-a6a7-df9c091e268b\}.xpi
    [[ ! -f $profile_default_extensions/\{e6e36c9a-8323-446c-b720-a176017e38ff\}.xpi ]] && \
        curl -L \
        --url https://addons.mozilla.org/firefox/downloads/file/3566579/torrent_control-0.2.18-fx.xpi \
        --output "$profile_default_extensions"/\{e6e36c9a-8323-446c-b720-a176017e38ff\}.xpi
    [[ ! -f $profile_default_extensions/2341n4m3@gmail.com.xpi ]] && \
        curl -L \
        --url https://addons.mozilla.org/firefox/downloads/file/717262/ageless_for_youtube-1.3-an+fx.xpi \
        --output "$profile_default_extensions"/2341n4m3@gmail.com.xpi
    [[ ! -f $profile_default_extensions/\{e4a8a97b-f2ed-450b-b12d-ee082ba24781\}.xpi ]] && \
        curl -L \
        --url https://addons.mozilla.org/firefox/downloads/file/3024171/greasemonkey-4.9-an+fx.xpi \
        --output "$profile_default_extensions"/\{e4a8a97b-f2ed-450b-b12d-ee082ba24781\}.xpi

    echo permissions
    chmod 755 $BIN/*

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

-aws-set-credentials(){
    [[ -z "$1" ]] && echo enter profile ; echo ; grep "\\[" ~/.aws/credentials
    export AWS_DEFAULT_PROFILE=$1
}

-is-webcam-on(){
    if [ "$(find /dev/ -maxdepth 1 | grep -c video)" -gt 0 ] ; then
        if [ "$(lsmod | grep ^uvcvideo | awk '{print $3}')" == "0" ] ; then
            echo no
        else
            echo yes
        fi
    fi

}

-aws-set-eks(){
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
    echo """
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
    - role: worker
    - role: worker
    - role: worker
    """ > kind-config.yaml
    kind create cluster --config kind-config.yaml
    rm -f kind-config.yaml

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
    ffmpeg -f x11grab -s "$RESOLUTION" -i :0.0 $TMP/ffmpeg-screen-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-camera(){
    ffmpeg -i /dev/video0 $TMP/ffmpeg-camera-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
}

-record-security(){
    ffmpeg -i /dev/video0 \
        -vf "select=gt(scene\\,0.0003),setpts=N/(10*TB)" $TMP/ffmpeg-security-"$(date +"%Y-%m-%d-%I-%m-%S")".mkv
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
    echo credentials file check
    if [ ! -f ~/.smbpasswd ] ; then
        echo ~/.smbpasswd does not exist, format is password=foo
    else
        smbpasswd_status=1
    fi

    echo freenas check

    status=$(nc -z freenas 80 ; echo $?)
    if [ "$status" != "0" ] ; then
        echo freenas down or not in hosts file
    else
        freenas_status=1
    fi

    echo mount
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
    curl https://isitdown.site/api/v3/"$1" | jq

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

-covid-stats(){
    curl 'https://corona-stats.online?top=10&minimal=true'
}

-packages-prereqs(){

    echo updating repos
    sudo apt-get update --quiet --quiet

    echo installing base prereqs
    awk '/prereq/ {print $1}' $REPOS/personal/dotfiles/packages.txt | xargs sudo apt-get install -y --quiet --quiet

    export DESTDIR="$HOME"

    echo compile dwm
    echo "exec dwm" > ~/.xinitrc
    version_dwm=6.2
    [[ ! -f $REPOS/thirdparty/dwm-${version_dwm}.tar.gz ]] && \
    curl -L --url https://dl.suckless.org/dwm/dwm-${version_dwm}.tar.gz --output $REPOS/thirdparty/dwm-${version_dwm}.tar.gz
    [[ ! -d $REPOS/thirdparty/dwm-${version_dwm} ]] && \
    tar zxf $REPOS/thirdparty/dwm-${version_dwm}.tar.gz -C $REPOS/thirdparty/
    [[ -d $REPOS/thirdparty/dwm-${version_dwm} ]] && \
    make clean install --quiet -C $REPOS/thirdparty/dwm-${version_dwm} && \
    rm -rf $REPOS/thirdparty/dwm-${version_dwm}

    echo compile st
    version_st=0.8.4
    [[ ! -f $REPOS/thirdparty/st-${version_st}.tar.gz ]] && \
    curl -L --url https://dl.suckless.org/st/st-${version_st}.tar.gz --output $REPOS/thirdparty/st-${version_st}.tar.gz
    [[ ! -d $REPOS/thirdparty/st-${version_st} ]] && \
    tar zxf $REPOS/thirdparty/st-${version_st}.tar.gz -C $REPOS/thirdparty/
    [[ ! -f $REPOS/thirdparty/st-scrollback-20200419-72e3f6c.diff ]] && \
    curl -L --url https://st.suckless.org/patches/scrollback/st-scrollback-20200419-72e3f6c.diff --output $REPOS/thirdparty/st-scrollback-20200419-72e3f6c.diff
    [[ -d $REPOS/thirdparty/st-${version_st} ]] && \
    cp -rp $REPOS/thirdparty/st-*.diff $REPOS/thirdparty/st-${version_st}/ && \
    patch --merge --quiet -i $REPOS/thirdparty/st-*.diff -d $REPOS/thirdparty/st-${version_st} && \
    make clean install --quiet -C $REPOS/thirdparty/st-${version_st} && \
    rm -rf $REPOS/thirdparty/st-${version_st}

    echo compile dwmblocks
    [[ ! -d $REPOS/thirdparty/dwmblocks ]] && \
    git clone https://github.com/torrinfail/dwmblocks $REPOS/thirdparty/dwmblocks
    pkill dwmblocks
    cp $REPOS/personal/dwmblocks/dwmblocks.blocks.h $REPOS/thirdparty/dwmblocks/blocks.h
    make clean install -C $REPOS/thirdparty/dwmblocks --quiet && \
    if pgrep startx > /dev/null ; then
    dwmblocks & disown
    fi
}

-cowsay-normal(){
    fortune | cowsay -f "$(find /usr/share/cowsay/cows/ | shuf | head -1)"
}

-cowsay-custom(){
    fortune | cowsay -f "$(find $REPOS/personal/cowsay-files/cows | shuf | head -1)"
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
    curl -o $TMP/person https://thispersondoesnotexist.com/image && sxiv $TMP/person
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
    if [ ! -d /sys/module/battery ] ; then
        7z a -p"$(cat ~/.bookmarkspasswd)" $REPOS/personal/buku/places.sqlite.7z "$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)"/places.sqlite
    fi
}

-bookmarks-restore(){
    7z x -p"$(cat ~/.bookmarkspasswd)" $REPOS/personal/buku/places.sqlite.7z
    mv places.sqlite "$(find ~/.mozilla/firefox/*.default/ -maxdepth 0)"/places.sqlite
}

-ip(){
    ip -oneline -f inet a | grep dynamic | awk '{print $4}' | sed 's/\/.*//g'
}

-wallpaper(){
    find ~/wallpapers/ -type f | shuf | head -1 | xargs xwallpaper --maximize
}

-weather(){
    curl http://wttr.in/"$1"
}
