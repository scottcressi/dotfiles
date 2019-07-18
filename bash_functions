#!/bin/bash

# git branch for PS1
parse_git_branch_and_add_brackets() {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

# tunnelkill
_tunnel-kill() {
tunnel_kill_list=`ps axuf \
| grep " ssh " \
| grep "\-f" \
| awk '{print $2}'`
echo killing $tunnel_kill_list
kill $tunnel_kill_list
}

# tunnelmake
_tunnel-manual() {
echo enter remote machine
read remotemachine
echo enter remote port
read remoteport
echo enter env dev or prod
read env

port=$(( ( RANDOM % 1024 )  + 60000 ))
if [ $env == "prod" ] ;then
jump=
elif [ $env == "corp" ] ;then
jump=$jump_corp
fi

echo localport is $port
echo jump is $jump
echo remotemachine is $remotemachine
echo remoteport is $remoteport

ssh -f -A ec2-user@$jump -L $port:$remotemachine:$remoteport -N
_tunnel-list
}

_tunnel-list() {
ps axuf | grep " ssh " | grep -v grep | grep "\-f"
}

_tunnel-example() {
echo ssh -f -A youruser@jump -L localport:remotemachine:remoteport -N
}

_tunnel-db(){
if [ $1 == "sandbox" ] || [ $1 == "qa" ] || [ $1 == "staging" ] ; then
jump=jump-dev.$organization.com
db=dbrw.$1.$organization.com
elif [ $1 == "prod" ] || [ $1 == "production" ] ; then
jump=jump-prod.$organization.com
db=dbrw.$organization.com
fi
port=$(( ( RANDOM % 1024 )  + 60000 ))
ssh -f -A ec2-user@$jump -L $port:$db:5432 -N
_tunnel-list
}

# Extract
_extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

_down() {
wget -qO - "http://www.downforeveryoneorjustme.com/$1" | sed "/just you/!d;s/<[^>]*>//g";
}

_cert-remote() {
openssl s_client -showcerts -connect $1:443 </dev/null | openssl x509 -noout -text  | grep DNS
}

_cert-local() {
openssl x509 -in $1 -text -noout
}

_package-firefox() {
wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
bunzip2 firefox.tar.bz2
tar xvf firefox.tar
mv firefox firefox-$(date +%Y-%m-%d-%H-%M-%S)
rm -f firefox.tar
}

_package-firefox_prereqs(){
sudo apt-get install -y libgtk-3-0 pulseaudio
}

_package-wm(){
sudo apt-get install -y \
dwm \
xorg
}

_package-pip-packages(){
sudo pip install --upgrade \
pip \
awscli \
doge \
dotfiles \
modernize \
socli \
s-tui \

}

_wallpaper(){
while true
do
feh --bg-scale --randomize ~/desktops
sleep 60
done
}

_wallpaper_reddit(){
wget -q -O - -- $(wget -q -O - http://www.reddit.com/r/wallpaper | grep -Eo 'https?://\w+\.imgur\.com[^"&]+(jpe?g|png|gif)' | shuf -n 1) | feh --bg-fill -
}

_wallpaper_imgur(){
wget -q -O- https://imgur.com/a/EYCTw | grep jpg | grep thumb | sed 's/.*src="\/\///g' | sed 's/" alt="" \/>//g' | shuf -n 1 | xargs wget -q -O- | feh --bg-fill -
}

_wallpaper_hubblesite(){
IMAGE=$(wget -q -O- http://hubblesite.org/gallery/wallpaper/ | grep imgsrc.hubblesite.org | sed 's/^.*imgsrc/imgsrc/g' | sed 's/-wallpaper_thumb.jpg.*$//g' | sed 's/imgsrc.hubblesite.org\/hu\/db\/images\///g' | shuf -n 1)
wget -q -O- http://imgsrc.hubblesite.org/hu/db/images/$IMAGE-2560x1024_wallpaper.jpg | feh --bg-fill -
}

_package-vagrant(){
wget -P /tmp/ https://releases.hashicorp.com/vagrant/1.8.7/vagrant_1.8.7_x86_64.deb
sudo dpkg -i /tmp/vagrant_1.8.7_x86_64.deb
}

_package-virtualbox(){
VERSION=`curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT`
PACKAGE=`curl -s https://download.virtualbox.org/virtualbox/$VERSION/ | grep rpm | grep el7 | sed 's/rpm.*/rpm/g' | sed 's/.*Virt/Virt/g'`
sudo yum install https://download.virtualbox.org/virtualbox/$VERSION/$PACKAGE
}

_psql_list(){
_tunnel-list | awk '{print $16}'
}

_psql_env(){
echo ex. psql_env ro
ENV=$1
USER=$2
port=`_tunnel-list | grep $ENV | sed s/.*ssh/ssh/g | awk '{print $6}' | sed 's/:.*//g'`
echo command is psql -h localhost -U $organization_$USER -d $organization_db -p $port
psql -h localhost -U $organization_$USER -d $organization_db -p $port
}

_package-debian-gui(){
sudo apt-get update
sudo apt-get install \
arandr \
atril \
galternatives \
mcomix \
mpv \
mupdf \
oneko \
screenkey \
surf \
sxiv \
xcowsay \
xfishtank \
zathura \

}

_package-debian-games(){
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

_package-laptop(){
sudo apt-get update
sudo apt-get install \
acpi \
wicd \

}

_package-debian-terminal(){
sudo apt-get update
sudo apt-get install \
alsa-utils \
aspell \
bash-completion \
bb \
bc \
bpython \
cifs-utils \
cmatrix \
cmus \
cowsay \
curl \
dnsutils \
dstat \
espeak \
flake8 \
git \
htop \
iftop \
iotop \
ipcalc \
ipython \
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
speedtest-cli \
sshfs \
stterm \
suckless-tools \
thefuck \
tig \
tmux \
toilet \
tree \
tty-clock \
ttyrec \
typespeed \
vim \
weather-util \
whois \
xterm \
youtube-dl \

}

_brightness(){
echo $1 | sudo tee --append /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness
}

_package-translate(){
wget git.io/trans
}

_package-zoom(){
sudo apt-get install -y libnss3
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo dpkg -i zoom_amd64.deb
}

_package-kube(){
mkdir ~/bin
curl -s --url https://storage.googleapis.com/kubernetes-helm/helm-v2.14.2-linux-amd64.tar.gz --output ~/bin/helm.tar.gz
cd ~/bin ; tar zxvf helm.tar.gz ; mv ~/bin/linux-amd64/helm ~/bin/helm ; rm -rf ~/bin/linux-amd64 ~/bin/helm.tar.gz
curl -s -L --url https://github.com/roboll/helmfile/releases/download/v0.80.1/helmfile_linux_amd64 --output ~/bin/helmfile
curl -s --url https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl --output ~/bin/kubectl
chmod 755 ~/bin/*
git clone https://github.com/farmotive/kpoof
}

kterminate(){
echo enter pod:
echo
read POD
kubectl delete pod -n jenkins $POD --grace-period=0 --force &
kubectl patch pod -n jenkins $POD -p '{"metadata":{"finalizers":null}}'
}

_package-docker-prereqs(){
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated docker-ce
}

_docker-python(){
docker run -v "$PWD":/usr/src/myapp -w /usr/src/myapp python python
}

_docker-java(){
docker run -v "$PWD":/usr/src/myapp -w /usr/src/myapp openjdk:7 java
}

ds(){
echo kill all containers? y/n
read confirm
if [ $confirm == "y" ] ; then docker kill $(docker ps -aq) ; fi
}

kopst(){
echo domain:
read domain
echo bucket:
read bucket
kops create cluster --name test.$domain --state s3://$bucket --cloud aws  --zones us-east-1a,us-east-1b --kubernetes-version 1.15.0 --node-size m5.large
kops update --state s3://$bucket cluster --name test.$domain --yes
}

kopsg(){
echo bucket:
read bucket
kops get cluster --state s3://$bucket
}

kopsd(){
echo domain:
read domain
echo bucket:
read bucket
echo kops delete cluster  --name test.$domain --state s3://$bucket --yes
}

_aws_records(){
echo domain:
read domain
ZONE=`aws route53 list-hosted-zones --query "HostedZones[?Name=='$domain.']".Id --output text | sed 's/\/hostedzone\///g'`
aws route53 list-resource-record-sets --hosted-zone-id $ZONE
}

_aws_certs(){
aws acm list-certificates --region us-east-1
}

awsc(){
grep "\[" ~/.aws/credentials
if [ -z $1 ] ; then echo enter profile ; fi
export AWS_DEFAULT_PROFILE=$1
}

_is-someone-using-my-webcam(){
if [ `lsmod | grep ^uvcvideo | awk '{print $3}'` == "0" ] ; then
echo no
else
echo yes
fi
}

kc(){
if [ -z $1 ] ; then echo enter region ; fi
if [ -z $2 ] ; then echo enter cluster ; fi
aws eks update-kubeconfig --region $1 --name $2
}

kl(){
for i in `echo us-east-1 us-west-2` ; do
echo $i
aws eks list-clusters --region $i
echo
done
}

_package-st(){
wget https://dl.suckless.org/st/st-0.8.2.tar.gz
gunzip st-0.8.2.tar.gz
tar xvf st-0.8.2.tar
cd st-0.8.2
make clean install
}

_package-go(){
wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz
gunzip go1.12.7.linux-amd64.tar.gz
tar xvf go1.12.7.linux-amd64.tar
}

_repos-debian-backports(){
cat <<EOF | sudo tee /etc/apt/sources.list.d/stretch-backports.list
deb http://http.debian.net/debian stretch-backports main contrib non-free
EOF
}

dwmscript(){
ps axuf | grep dwm.sh | grep -v grep | awk '{print $2}' | xargs kill
find ~/ -name dwm.sh | xargs bash &
}
