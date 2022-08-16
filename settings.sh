#!/bin/sh

#
# set some arbitrary values / settings for different programs
#

# keyboard
xset r rate 300 50
setxkbmap fi

# disable pointer acceleration for every pointer in xinput list
for id in $(xinput list | grep "pointer" | cut -d "=" -f 2 | cut -f 1); do xinput --set-prop $id 'libinput Accel Profile Enabled' 0, 1 ; done

# mic volume and mute on
pactl set-source-volume @DEFAULT_SOURCE@ 0%
$(xdg-user-dir SCRIPTS)/mic-volume.sh mute

# set volume to something that wont permanently damage hearing
pactl set-sink-volume @DEFAULT_SINK@ 10%

# xroot parameters
xsetroot -cursor_name left_ptr

# load loopbackmodule for listening to mic input
#pactl load-module module-loopback lantency_msec=0

# change caps to an escape key and unbind esc
setxkbmap -option  
setxkbmap -option caps:escape 
setxkbmap -option escape:none

# load nvidia settings
nvidia-settings --load-config-only

# tablet settings
$(xdg-user-dir SCRIPTS)/tablet.sh -p desktop

# rgb keyboard
openrgb --profile wmhighlights
