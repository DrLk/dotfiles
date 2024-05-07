#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##


if [ $XDG_CURRENT_DESKTOP == "sway" ]; then
    swaylock --daemonize --color "$selection-color" --inside-color "$selection-color" --inside-clear-color "$text-color" --ring-color "$color2" --ring-clear-color "$color11" --ring-ver-color "$color13" --show-failed-attempts --fade-in 0.2 --grace 2 --effect-vignette 0.5:0.5 --effect-blur 7x5 --ignore-empty-password --screenshots --clock
else
    # For Hyprlock
    hyprlock -q
fi
