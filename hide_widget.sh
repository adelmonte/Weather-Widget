#!/bin/bash

# Get screen width
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions:/ {print $2}' | cut -d'x' -f1)

# Find the window ID of xfce4-panel with width less than screen width
WINDOW_ID=$(xdotool search --name "xfce4-panel" | while read -r id; do
    GEOMETRY=$(xdotool getwindowgeometry "$id")
    WIDTH=$(echo "$GEOMETRY" | awk '/Geometry:/ {split($2, a, "x"); print a[1]}')
    if [ "$WIDTH" -lt "$SCREEN_WIDTH" ] && [ "$WIDTH" -gt 100 ]; then
        echo "$id"
        break
    fi
done)

# Apply the effect if a suitable window was found
if [ -n "$WINDOW_ID" ]; then
    xdotool windowstate --add BELOW "$WINDOW_ID"
else
    echo "No suitable xfce4-panel window found" >&2
fi
