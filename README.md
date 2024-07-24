![screenshot](./widget_screen.png)

Now shows actual dates.

Exclude main panel round corners in picom.conf:\
"0:class_g = 'Xfce4-panel' && _NET_WM_STRUT_PARTIAL@:c",\
"30:class_g = 'Xfce4-panel' && !_NET_WM_STRUT_PARTIAL@:c",
