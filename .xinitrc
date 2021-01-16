#!/usr/bin/env sh

cd || exit

if [ "$( grep -c "LG Electronics LG TV" /var/log/Xorg.0.log)" -gt 1 ] ; then
    echo lg tv found
    if [ "$(xrandr | grep -c 4096x2160)" = 1 ] ; then
        echo 4096x2160 found
        xrandr -s 1360x768
    fi
fi

exec dwm
