#!/bin/sh
mpv --speed=1 --scale=nearest --keepaspect=no --no-audio --no-border --no-config --no-window-dragging --no-input-default-bindings --no-osd-bar --no-sub --loop --wid=$1 "$2" 
