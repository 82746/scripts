#!/bin/sh
xrandr -q | sed -rn /\ connected/p | sed -rn 's/.*\ ([0-9]*x[0-9]*\+[0-9]*\+[0-9]*).*/\1/p'

