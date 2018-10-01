#!/bin/bash

# set resolution
xrandr -s 800x600

# set screen to lock idle machine
xscreensaver -nosplash &

# dwm info bar
bash ~/repos/code/bash/dwm_script.sh &

exec dwm
