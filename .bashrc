#!/usr/bin/env bash

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_exports ]; then
    source ~/.bash_exports
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
