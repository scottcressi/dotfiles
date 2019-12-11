#!/usr/bin/env bash

sudo apt-get install -y --quiet --quiet stow
stow --verbose --stow --target ~/ .
