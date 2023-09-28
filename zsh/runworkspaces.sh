

 runapp() {
    workspaceNumber=$1
    application=$2

    echo "workspace number $workspaceNumber"
    swaymsg "workspace number $workspaceNumber"
    echo "workspace number $application"
    swaymsg "exec $application"
}

runapp 1 kitty
runapp 1 kitty

runapp 2 "firefox"

runapp 3 kitty
runapp 3 kitty

runapp 4 "/usr/share/code/code --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"

runapp 5 "/opt/sublime_text/sublime_text"

runapp 7 "/opt/Obsidian/obsidian --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --disable-gpu"


runapp 8 "/opt/Mattermost/mattermost-desktop --ozone-platform-hint=auto -f"
sleep 1
swaymsg "fullscreen"

#runapp 10 "firefox -new-window https://localhost:8888/gui/"
