#!/bin/sh
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export DRI_PRIME=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export MANGOHUD=1

xrandr --output eDP-1 --mode 1920x1080 --rate 60

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if ! df --output=target | grep -q "$HOME/Extra"; then
  # If not mounted, proceed with the mount command
  mount $HOME/Extra
fi

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

. "$HOME/scripts/sound"
. "$HOME/scripts/mouse"

# MPD daemon start (if no other user instance exists)
# [ ! -s ~/.config/mpd/pid ] && mpd

/usr/bin/prime-offload &
wal -R &
picom --config ~/.config/picom/light.conf &
redshift &
#numen &
#buckle &
exec bspwm
