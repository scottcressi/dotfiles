#!/usr/bin/env bash

dir=$(basename "$PWD")
if [ "$dir" != "dotfiles" ] ; then
    echo please enter dotfiles dir
    exit 0
fi

sudo apt-get install -y --quiet --quiet stow curl
stow --verbose --stow --target ~/ .
