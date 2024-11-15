#!/bin/bash
W3M_DIS="/usr/lib/w3m/w3mimgdisplay"
[[ -f "$W3M_DIS" ]] || { echo "I need w3mimgdisplay (w3m-img), exiting." >&2; exit 1; }

if [[ "$TERM" == "xterm" ]]; then
    FONTH=8 # 14 Size of one terminal row
    FONTW=4  # 8 Size of one terminal column
else # assume custom urxvt
    FONTH=8 # 14 Size of one terminal row
    FONTW=4  # 8 Size of one terminal column
    # ^
    # Coresponds to measure of a fullblock char in pixels.
fi

# offsets
xoff="0"; yoff="0"; offset="100"

# slideshow
slidetime="5"

# help 1
help () { 
cat << EOF

zebra *.png                 # png (or anything else)
zebra                       # defaults to all png & jpg
zebra *.png*(om)            # zsh glob by date
zebra *.(jpg|png)*(om)      # zsh glob by date
zebra --quit some.png       # show and quit
EOF
shortkeys
}
# help 2
shortkeys () { 
cat << EOF

Shortkeys
j next                      v set as wall head 0
k previous                  b set as wall head 1
i identify (imagemagick)    1 toggle 100% 
m mediainfo                 w,a,s,d offset
h this help                 r reset view
g goto                      9 toggle slideshow
z open in gimp              0 set slide time
t touch                     q quit
EOF
}
# help 
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    help; exit
fi    

# $1 = file
zebraview () {
    
    # code from https://blog.z3bra.org/2014/01/images-in-terminal.html
    FILE="$1"
    
    COLUMNS="$(tput cols)"
    LINES="$(tput lines)"

    read -r width height <<< "$(echo -e "5;$FILE" | $W3M_DIS)"
    
    # Cringe Buffer
    if [[ $width == ?(-)+([0-9]) ]] && [[ $height == ?(-)+([0-9]) ]] ; then 
    
        max_width=$((FONTW * COLUMNS))
        # Get Suck
        max_height=$((FONTH * ((LINES - 2)))) 

        if ! (( realpixels )); then
            if test "$width" -gt "$max_width"; then
                height=$((height * max_width / width))
                width="$max_width"
            fi
            if test "$height" -gt "$max_height"; then
                width=$((width * max_height / height))
                height="$max_height"
            fi
        fi
        
        # Ignore Offset in 'fit to fill' mode
        if (( realpixels )); then
            xaoff="$xoff" ; yaoff="$yoff"
        else
            xaoff="0" ; yaoff="0"
        fi
        
        w3m_command="0;1;0;0;$width;$height;$xaoff;$yaoff;;;$FILE\n4;\n3;"

        tput cup $((height/FONTH)) 0
        
        echo -e "$w3m_command"|$W3M_DIS
      
    else
        echo
        echo "view error"
        echo
    fi
    
}

# show and quit
if [ "$1" == "--quit" ] || [ "$1" == "-q" ]; then
    clear # screen
    shift
    zebraview "$1"
    zebraview "$1" # alpha fix?
    exit
fi    
# if only 'zebra', search for jpg/png
shopt -s extglob
(( $# )) || set -- *.@(jpg|jpeg|png); [[ -e $1 ]] || { echo "No jpg/png pics found."; stty sane; exit 1; }

n="1"
max="$#"
min="1"

file=("$@") # parameters to array

# $1 = image, $2 = which head
setwall () {
    
    # user select type
    modes=(--set-centered --set-scaled --set-tiled --set-zoom --set-zoom-fill)
    maxkey="${#modes[@]}"

    for key in ${!modes[*]}
    do
        echo -n "${modes[$key]} ($(( key + 1 ))) "
    done
    echo
    unset key

    read -rsn1 key ; key="$(( key - 1 ))" 
    if ! (( key >= 0 && key <= maxkey )); then
        echo "nope"
        return
    fi

    # action
    nitrogen "$1" --set-color="#394A55" "${modes[$key]}" --head="$2" --save || echo "nitrogen failed"
    restart wbar > /dev/null 2>&1
    dostuff # redraw
}

# limit, cycle array
limit () {
    if (( "$n" > "$max" )); then
        n="$min"
    elif (( "$n" < "$min" )); then
        n="$max"
    fi
}

# echopixelstatus
echopixels () {
    if (( realpixels )); then 
        echo " 100%"
    else
        echo 
    fi
}
    
# dostuff
dostuff () {
    
    clear # screen
    
    m=$(( n - 1 )) # because it starts with 0
    zebraview "${file[$m]}"
    echo -n "($n/$max) " ; echo -n "${file[$m]}"
    echopixels

}
dostuff     # 1st time
shortkeys   # 1st time

# slideshow
slideshow () {
    
    clear # screen
    
    m=$(( n - 1 )) # because it starts with 0
    zebraview "${file[$m]}"
    echo -n "($n/$max) " ; echo -n "${file[$m]} ▶"
    echopixels
    n=$(( n + 1 ))
    limit
    
}

# restart wbar
restart() {
if pgrep -x "$1" > /dev/null
then
    (echo "$1 running, restarting"
    killall -w "$1"
    "${1}" &) &
else
    echo "$1 wasn't running"
fi
}

# user input
readOneKey () {
    
    read -rsn1 key
    
    if  [[ "$key" == "j" ]]; then
        n=$(( n + 1 ))
    elif  [[ "$key" == "k" ]]; then
        n=$(( n - 1 ))
    elif  [[ "$key" == "g" ]]; then # goto
        read -rp "goto " n
    elif  [[ "$key" == "t" ]]; then # touch
        touch "${file[$m]}" 
    elif  [[ "$key" == "z" ]]; then # gimp
        dostuff "$n" >/dev/null 2>&1 && gimp "${file[$m]}" >/dev/null 2>&1 &
    elif  [[ "$key" == "v" ]]; then
        dostuff "$n" && setwall "${file[$m]}" 0 # head 0
        return
    elif  [[ "$key" == "b" ]]; then
        dostuff "$n" && setwall "${file[$m]}" 1 # head 1
        return
    elif  [[ "$key" == "1" ]]; then # toggle 100 %
        if ! (( realpixels )); then
            realpixels="1"
        else
            realpixels=""
        fi
    # wasd offsets, should only change in 100% mode
    elif  [[ "$key" == "d" ]]; then # xoff bigger
        (( realpixels )) && xoff=$(( xoff + offset ))
    elif  [[ "$key" == "a" ]]; then # xoff smaller
        (( realpixels )) && xoff=$(( xoff - offset )); (( xoff < 0 )) && xoff="0"
    elif  [[ "$key" == "w" ]]; then # yoff bigger
        (( realpixels )) && yoff=$(( yoff + offset ))
    elif  [[ "$key" == "s" ]]; then # yoff smaller
        (( realpixels )) && yoff=$(( yoff - offset )); (( yoff < 0 )) && yoff="0"
    # end offsets
    elif  [[ "$key" == "r" ]]; then # reset view
        yoff="0"; xoff="0"; realpixels=""
    elif  [[ "$key" == "9" ]]; then # slideshow
        while true; do
        
            slideshow
        
            read -t "$slidetime" -N 1 input
            if [[ $input = "9" ]]; then
                n=$(( n - 1 )) # hmm
                break
            fi
            
        done
    elif  [[ "$key" == "0" ]]; then # slide time
        read -rp "slidetime " slidetime
    elif  [[ "$key" == "i" ]]; then
        identify "${file[$m]}"
        return
    elif  [[ "$key" == "m" ]]; then
        mediainfo "${file[$m]}"
        return
    elif  [[ "$key" == "h" ]]; then
        shortkeys
        return
    elif  [[ "$key" == "q" ]]; then
        exit
    fi
    
    limit # array
        
    # dostuff
    dostuff "$n"
    
}

while true; do readOneKey ; done
