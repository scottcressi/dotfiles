sudo apt-get install -y python-pip
sudo pip install --upgrade dotfiles
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dotfiles --repo $DIR -C $DIR/.dotfilessrc --sync
