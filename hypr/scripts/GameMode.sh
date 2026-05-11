#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/bell.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:passes 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    swww kill 
    notify-send -e -u low -i "$notif" "gamemode enabled. All animations off"
    exit
else
	pgrep -x awww-daemon >/dev/null || awww-daemon &
	sleep 0.3
	monitor=$(hyprctl -j monitors | jq -r '.[0].name')
	wallpaper=$(tr '\0' '\n' < "$HOME/.cache/swww/$monitor" 2>/dev/null | grep -m1 '^/')
	[ -n "$wallpaper" ] && awww img "$wallpaper"
	sleep 0.3
	${SCRIPTSDIR}/Refresh.sh
    notify-send -e -u normal -i "$notif" "gamemode disabled. All animations normal"
    exit
fi
hyprctl reload
