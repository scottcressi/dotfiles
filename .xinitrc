#!/usr/bin/env sh

cd || exit

if [ "$(xrandr | grep -c 4096x2160)" = 1 ] ; then
    xrandr -s 1360x768
fi

exec dwm
