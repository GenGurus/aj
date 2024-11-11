#!/bin/sh

. "$HOME/scripts/alpha"

[[ -f ~/.bashrc ]] && . ~/.bashrc
. "$HOME/.cargo/env"

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx &>/dev/null
fi
export PATH=$PATH:/path/to/driver
