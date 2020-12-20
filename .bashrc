#!/usr/bin/env sh

if [ -f ~/.bash_functions ]; then
    # shellcheck source=/dev/null
    . ~/.bash_functions
fi

if [ -f ~/.bash_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_aliases
fi

if [ -f ~/.bash_exports ]; then
    # shellcheck source=/dev/null
    . ~/.bash_exports
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
fi
