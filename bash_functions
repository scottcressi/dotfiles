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
mv firefox firefox-$(date +%Y-%m-%d-%H-%M-%S)
rm -f firefox.tar
}

_package-firefox_prereqs(){
sudo apt-get install -y bzip2 libdbus-glib-1-2 libgtk-3-0
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
bpython \
consoletetris \
doge \
dotfiles \
glances \
ipython \
modernize \
flake8 \
socli \
s-tui \
speedtest-cli \
thefuck \
youtube-dl
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
netsurf \
sxiv \
xboard \
xcowsay \

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
bsdgames \
cifs-utils \
cmatrix \
cmus \
cowsay \
curl \
dnsutils \
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
netcat \
neofetch \
nethogs \
newsbeuter \
oneko \
openssh-client \
p7zip \
pacman4console \
pi \
pwgen \
python \
python-pip \
ranger \
rig \
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
ttyrec \
typespeed \
vim \
weather-util \
whois \
xfishtank \
xterm \

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
curl -s --url https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz --output ~/bin/helm.tar.gz
cd ~/bin ; tar zxvf helm.tar.gz ; mv ~/bin/linux-amd64/helm ~/bin/helm ; rm -rf ~/bin/linux-amd64 ~/bin/helm.tar.gz
curl -s -L --url https://github.com/roboll/helmfile/releases/download/v0.73.0/helmfile_linux_amd64 --output ~/bin/helmfile
curl -s --url https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl --output ~/bin/kubectl
chmod 755 ~/bin/*
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

dc(){
sudo docker container prune -f
sudo docker image prune -a -f
sudo docker volume rm $(docker volume ls -qf dangling=true)
}

_docker_prereqs(){
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated docker-ce
}

_docker_jackett(){
sudo docker pull linuxserver/jackett
sudo docker stop jackett
sudo docker rm jackett
sudo docker run -d \
-p 9117:9117 \
--name jackett \
-v /var/tmp/jackett/config:/config \
linuxserver/jackett
}

_docker_plex(){
sudo docker pull plexinc/pms-docker
sudo docker stop plex
sudo docker rm plex
sudo docker run \
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

_docker_python(){
docker run -v "$PWD":/usr/src/myapp -w /usr/src/myapp python python
}

_docker_go(){
docker run -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang go
}

_docker_java(){
docker run -v "$PWD":/usr/src/myapp -w /usr/src/myapp openjdk:7 java
}

kopst(){
echo domain:
read domain
echo bucket:
read bucket
kops create cluster --name test.$domain --state s3://$bucket --cloud aws  --zones us-east-1a,us-east-1b --kubernetes-version 1.14.2 --node-size m5.large
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

kpfdashboard(){
kubectl proxy &
chromium http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:https/proxy/#!/login
}

awsc(){
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
echo region
read REGION
aws eks update-kubeconfig --region $REGION --name $1
}

kl(){
for i in `echo us-east-1 us-west-2` ; do
echo $i
aws eks list-clusters --region $i
echo
done
}
