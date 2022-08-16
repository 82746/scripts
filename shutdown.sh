#!/bin/sh
python $(xdg-user-dir SCRIPTS)/lifx.py -p off &> /dev/null
ddcutil -d 1 setvcp D6 05 # power off display 1
shutdown -h now
