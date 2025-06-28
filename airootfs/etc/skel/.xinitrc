#!/usr/bin/env bash


systemctl --user import-environment DISPLAY

# Dbus fix
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# create user directories
/usr/bin/xdg-user-dirs-update

# Start Window Manager based on boot cheat code wm=i3
[ "$(grep -o 'wm=i3' /proc/cmdline)" ] && WM=i3 || WM=openbox-session
exec $WM


