#!/usr/bin/env bash

# execution
if [ -f ~/.bash_execution ]; then
    source ~/.bash_execution
fi

# functions
if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi

# aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# exports
if [ -f ~/.bash_exports ]; then
    source ~/.bash_exports
fi

# completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# completion kubectl
if [ -f ~/.bash_completion_kubectl ]; then
    source ~/.bash_completion_kubectl
fi
