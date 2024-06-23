#!/bin/bash

# Find the top panel's window ID based on the _NET_WM_STRUT_PARTIAL property
TOP_PANEL_WINDOW_ID=$(xprop -root | awk '/_NET_WM_STRUT_PARTIAL/ {print $5}' | head -n 1)

# Apply the effect using wmctrl
wmctrl -i -r $TOP_PANEL_WINDOW_ID -b add,below
