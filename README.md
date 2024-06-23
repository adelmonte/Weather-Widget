Create new panel.
Use xprop to find window ID property.
Edit/Apply wmctrl start_weather script to keep behind windows.

Exclude main panel round corners in picom.conf:\
"0:class_g = 'Xfce4-panel' && _NET_WM_STRUT_PARTIAL@:c",\
"30:class_g = 'Xfce4-panel' && !_NET_WM_STRUT_PARTIAL@:c",
