swaync pamixer pavucontrol blueman-manager wlogout wal swww cava gnome-system-monitor btop nvtop notification-daemon


Alternatively, making the notification server as a D-Bus service, the notification server can be launched automatically on the first call to it. For example, after installing the notification-daemon package, add the following configuration to D-Bus services directory (/usr/share/dbus-1/services or $XDG_DATA_HOME/dbus-1/services):

org.freedesktop.Notifications.service
```
[D-BUS Service]
Name=org.freedesktop.Notifications
Exec=/usr/lib/notification-daemon-1.0/notification-daemon
```


### Themes
https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme
