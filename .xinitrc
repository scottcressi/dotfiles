#!/usr/bin/env sh

cd || exit

if [ "$( grep -c "LG Electronics LG TV" /var/log/Xorg.0.log)" -gt 1 ] && [ "$(xrandr | grep -c 4096x2160)" = 1 ] ; then
    xrandr -s 1360x768
fi

exec dwm
