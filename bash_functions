#!/bin/bash

_clone-repos(){
cd ~/repos/ ; \
git clone https://github.com/colszowka/linux-typewriter.git ; \
git clone https://github.com/alexdantas/yetris ; \
git clone https://github.com/drwetter/testssl.sh ; \
git clone https://github.com/jarun/buku/ ; \
git clone https://github.com/jarun/googler/ ; \
git clone https://github.com/narenaryan/Govie ; \
echo done
}

# git branch for PS1
parse_git_branch_and_add_brackets() {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}

parse_kube_context() {
kubectl config view | grep current-context | awk '{print $2}'
}

parse_kube_namespace() {
kubectl config view | grep namespace | awk '{print $2}'
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
rm -f firefox.tar
}

_package-firefox_prereqs(){
sudo apt-get install -y bzip2 libasound2 libdbus-glib-1-2 libgtk2.0-0
sudo apt-get install -y pepperflashplugin-nonfree # flashplugin-nonfree
}

_package-wm(){
sudo apt-get install -y \
dwm \
xorg
}

_package-daemons(){
sudo apt-get update
sudo apt-get install -y \
cifs-utils \
dictd \
dict-gcide \
dict-moby-thesaurus \
nfs-common \
openssh-server
}

_package-pip3-packages(){
sudo pip3 install --upgrade \
cl-chess \

}

_package-pip-packages(){
sudo pip install --upgrade \
pip \
awscli \
bpython \
consoletetris \
demjson \
doge \
dotfiles \
glances \
kube-shell \
modernize \
monica \
moviemon \
flake8 \
rtv \
socli \
s-tui \
speedtest-cli \
thefuck \
youtube-dl
}

_package-intellij(){
wget -P ~/ https://download.jetbrains.com/idea/ideaIC-2018.1.1.tar.gz
tar zxvf ideaIC-2018.1.1.tar.gz
rm -f ideaIC-2018.1.1.tar.gz
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

_information-package_size(){
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n
}

_start-sonar(){
mono --debug /opt/NzbDrone/NzbDrone.exe
}

_start-radarr(){
cd ~/Radarr.develop.0.2.0.596.linux ; mono Radarr.exe
}

_package-sonarr(){
sudo apt-get install -y dirmngr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
sudo apt-get update
sudo apt-get install -y nzbdrone
}

_package-radarr(){
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-get update
sudo apt-get install mono-devel mediainfo sqlite3 libmono-cil-dev -y
wget https://github.com/Radarr/Radarr/releases/download/v0.2.0.596/Radarr.develop.0.2.0.596.linux.tar.gz
tar zxvf Radarr.develop.0.2.0.596.linux.tar.gz
}

_package-debian-gui(){
sudo apt-get update
sudo apt-get install \
eboard \
arandr \
atril \
feh \
mcomix \
mpv \
mupdf \
sxiv \
wicd \
xboard \
xcowsay \
xfishtank \

}

_package-debian-terminal(){
sudo apt-get update
sudo apt-get install \
alsa-utils \
aspell \
bash-completion \
bb \
bsdgames \
cmatrix \
cmus \
cowsay \
curl \
dnsutils \
dstat \
git \
htop \
iftop \
ipcalc \
irssi \
lftp \
libaa-bin \
links2 \
lolcat \
mdp \
mutt \
neofetch \
nethogs \
newsbeuter \
oneko \
p7zip \
pacman4console \
pwgen \
python \
python3 \
python-pip \
python3-pip \
ranger \
rsync \
rtorrent \
scrot \
sshfs \
stterm \
suckless-tools \
tig \
tmux \
toilet \
tree \
tty-clock \
typespeed \
unrar \
vim \
weather-util \
whois \
xterm \

}

_brightness(){
echo $1 | sudo tee --append /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness
}

_package-jdk(){
wget -P ~/ https://download.java.net/java/GA/jdk10/10.0.1/fb4372174a714e6b8c52526dc134031e/10/openjdk-10.0.1_linux-x64_bin.tar.gz
tar zxvf openjdk-10.0.1_linux-x64_bin.tar.gz
rm -f openjdk-10.0.1_linux-x64_bin.tar.gz
}

_package-visualvm(){
wget https://java.net/projects/visualvm/downloads/download/release138/visualvm_138.zip
}

_package-translate(){
wget git.io/trans
}

_package-go(){
cd /var/tmp
curl -LO https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar zxvf go1.11.4.linux-amd64.tar.gz
}

kjenkins(){
POD=`kubectl get pods -n jenkins | grep Running | awk '{print $1}'`
OUTPUT=`kubectl exec -n jenkins $POD -- bash -c "ps axuf | grep java | grep -v grep"`
echo $OUTPUT | awk '{print $15}' | sed 's/.*=//g'
}

kterminate(){
echo enter pod:
echo
read POD
kubectl delete pod -n jenkins $POD --grace-period=0 --force &
kubectl patch pod -n jenkins $POD -p '{"metadata":{"finalizers":null}}'
}

k(){
cp ~/.kube/configs/$1 ~/.kube/config
}

docker_cleanup(){
docker container prune -f
docker image prune -a -f
}

s(){
echo "DATE  :  `date '+%l:%M%P   %A   %m/%d/%y'`"
echo "BATT  :  `acpi | grep 1: | awk '{print $4}' | sed s/,//g`"
echo "VOL   :  `amixer get Master | grep "  Front Left" | awk '{print $5}'`"
echo "DISK  :  `df -h | grep mapper | awk '{print $5}'`"
}

docker_prereqs(){
sudo apt-get -y install nfs-common cifs-utils
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated docker-ce
}

docker_jackett(){
docker pull linuxserver/jackett
docker stop jackett
docker rm jackett
docker run -d \
-p 9117:9117 \
--name jackett \
-v /var/tmp/jackett/config:/config \
linuxserver/jackett
}

docker_firefox(){
docker pull jlesage/firefox
docker stop firefox
docker rm firefox
docker run -d \
-p 5800:5800 \
--name firefox \
jlesage/firefox
}

docker_plex(){
docker pull plexinc/pms-docker
docker stop plex
docker rm plex
docker run \
-d \
--name plex \
--network=host \
-e TZ="<timezone>" \
-e PLEX_CLAIM="<claimToken>" \
-v /var/tmp/plex/config:/config \
-v /var/tmp/plex/transcode:/transcode \
-v /var/tmp/plex/data:/data \
-v /mnt/videos:/videos \
plexinc/pms-docker
}

kopst(){
echo domain:
read domain
echo bucket:
read bucket
kops create cluster --name test.$domain --state s3://$bucket --cloud aws  --zones us-east-1a,us-east-1b --kubernetes-version 1.13.2 --node-size m5.large
kops update --state s3://$bucket cluster --name test.$domain --yes
}

kopsd(){
echo domain:
read domain
echo bucket:
read bucket
echo kops delete cluster  --name test.$domain --state s3://$bucket --yes
}

list_records(){
echo domain:
read domain
ZONE=`aws route53 list-hosted-zones --query "HostedZones[?Name=='$domain.']".Id --output text | sed 's/\/hostedzone\///g'`
aws route53 list-resource-record-sets --hosted-zone-id $ZONE
}

ac(){
aws acm list-certificates --region us-east-1
}

kpfkibana(){
POD=`kubectl get pods -n logging | grep kibana | awk '{print $1}'`
kubectl port-forward -n logging $POD 5601
}

kpfcerebro(){
POD=`kubectl get pods -n logging | grep cerebro | awk '{print $1}'`
kubectl port-forward -n logging $POD 9000
}

kpfjenkins(){
POD=`kubectl get pods -n jenkins | grep jenkins | awk '{print $1}'`
kubectl port-forward -n jenkins $POD 8080
}

kpfgrafana(){
POD=`kubectl get pods -n monitoring | grep grafana | awk '{print $1}'`
kubectl port-forward -n monitoring $POD 3000
}

awsc(){
cp ~/.aws/credentials.$1 ~/.aws/credentials
}
