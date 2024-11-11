#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias s='sudo'
alias v='nvim'
alias sv='sudo nvim'
alias sp='sudo pacman'
alias ytp='pipe-viewer'
alias work='sh ~/scripts/mux.sh'
alias smtp='simple-mtpfs'
alias whp='sudo create_ap wlp0s20f3 wlp0s20f3'
alias waifu2x='waifu2x-ncnn-vulkan'
alias clean='sudo pacman -Rs $(pacman -Qqtd)'

#Define some colors...
NON='\e[0m'  #normal
BLD='\e[01m' #bold
ITL='\e[03m' #italics
ULN='\e[04m' #underline
INV='\e[07m' #inverted
RED='\e[31m' #red
GRN='\e[32m' #green
YEL='\e[33m' #yellow
BLU='\e[34m' #blue
PRP='\e[35m' #purple
TEL='\e[36m' #teal

#Define data sources
BATTERY_DIR="/sys/class/power_supply/BAT1"
BATTERY_CHARGE="charge_now"
BATTERY_FULL="charge_full"
BATTERY_STATUS="status"

battery_percent() {
  REM_CAP=$(cat $BATTERY_DIR/$BATTERY_CHARGE)
  FULL_CAP=$(cat $BATTERY_DIR/$BATTERY_FULL)
  CHARGE=$(echo $(($REM_CAP * 100 / $FULL_CAP)))
  if [ "$CHARGE" -gt "99" ]; then
    CHARGE=100
  fi
  echo -e $CHARGE
}

battery_status() {
  BATT_STATUS=$(cat $BATTERY_DIR/$BATTERY_STATUS)
  case $BATT_STATUS in
  "Charging")
    BATT_STATUS="+"
    ;;
  "Discharging")
    BATT_STATUS="-"
    ;;
  "Full")
    BATT_STATUS="."
    ;;
  "Unknown")
    BATT_STATUS="."
    ;;
  *)
    BATT_STATUS="x"
    ;;
  esac
  echo -e $BATT_STATUS
}

battery_color() {
  CHARGE="$(battery_percent)"
  COLOR="$RED"
  if [ "$CHARGE" -gt "15" ]; then
    COLOR="$YEL"
  fi
  if [ "$CHARGE" -gt "30" ]; then
    COLOR="$PRP"
  fi
  echo -e $COLOR
}

PS1="\n \[\033[0;34m\]┌─<\[\033[1;35m\]<$(battery_status)$(battery_percent)% >\[\033[0;34m\]>──<\[\033[1;35m\]<\[\033[1;32m\]\w\[\033[1;35m\]>\[\033[0;34m\]> \n └> \[\033[1;36m\]\$ \[\033[0m\]"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
. "$HOME/.cargo/env"

#source /home/RenderHam/.local/share/lscolors.sh
