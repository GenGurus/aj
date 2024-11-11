#!/bin/sh

notify_volume() {
	if [ "$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //' | awk '{print ($1*100)}')" = "true" ]; then
    notify-send -a System \
                -h string:wired-tag:System \
                -h int:value:$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //' | awk '{print ($1*100)}') \
                "Volume" \
                "$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //' | awk '{print ($1*100)}')"
	else

		notify-send -a System \
                -h string:wired-tag:System \
                -h int:value:$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //' | awk '{print ($1*100)}') \
                "Volume" \
                "$(wpctl get-volume @DEFAULT_SINK@ | sed 's/Volume: //' | awk '{print ($1*100)}')"
	fi
}

notify_brightness() {

    brightnessctl "$@" > /dev/null

    brightnow="$(brightnessctl g)"
    brightmax="$(brightnessctl m)"
    brightpercent=$(awk "BEGIN {print ${brightnow}/${brightmax}*100}")
    
    notify-send -a System \
                -h string:wired-tag:System \
                -h int:value:$brightpercent\
                "Lights" \
                "$brightpercent%"
}


notify_track() {
	# wait for mpris to update
	art_url="$(playerctl metadata -f '{{mpris:artUrl}}' | sed 's/file:\/\///')"
	if [ -z "$art_url" ]; then
		notify-send -h 'string:wired-tag:player' -t 10000 'Player' "$(playerctl metadata -f '{{artist}} —  {{title}}')"
	else
		notify-send -h 'string:wired-tag:player' -t 10000 -h "string:image-path:$art_url" 'Player' "$(playerctl metadata -f '{{artist}} —  {{title}}')"
	fi
}

case "$1" in
	vol_up)
     	wpctl set-volume @DEFAULT_SINK@ 2%+
		notify_volume
	;;

	vol_down)
    	wpctl set-volume @DEFAULT_SINK@ 2%-
		notify_volume
	;;

	mutetoggle)
	wpctl set-mute @DEFAULT_SINK@ toggle
		notify_volume
	;;

	light_up)
		brightnessctl s +1%
    notify_brightness
	;;

	light_down)
		brightnessctl s 1%-
    notify_brightness
  ;;
	play_pause)
		playerctl play-pause
		notify_track
		;;

	next)
		playerctl next
		notify_track
		;;
	
	previous)
		playerctl previous
		notify_track
		;;
esac
