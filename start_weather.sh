#!/bin/bash

# Find the window ID by name and size, 
# CHANGE DIMENTIONS ACCORDINGLY!!
WINDOW_ID=$(xdotool search --name "xfce4-panel" | while read id; do
    if xdotool getwindowgeometry $id | grep -q "924x208"; then
        echo $id
        break
    fi
done)

xdotool windowstate --add below $WINDOW_ID
