#!/usr/bin/env bash

dir=$(basename "$PWD")
if [ "$dir" != "dotfiles" ] ; then
    echo please enter dotfiles dir
    exit 0
fi

if [ -f /etc/debian_version ] ; then
    package_manager=apt-get
else
    package_manager=yum
fi

sudo $package_manager install -y --quiet --quiet stow sudo
echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$(whoami)"
stow --verbose --stow --target ~/ .
