#!/bin/bash

WALLPAPERS=$HOME/.wallpapers
CACHE_FILE=$HOME/.cache/current_wallpaper

if [ ! -f $cache_file ] ;then
    touch $CACHE_FILE
    echo $WALLPAPERS/default.jpg > $CACHE_FILE
fi
prev_wallpaper=$(cat $CACHE_FILE)
prev_wallpaper_name=$(echo "$wallpaper" | sed "s|$WALLPAPERS/||g")

if [[ $1 == "init" ]]; then
    wallpaper_name="$prev_wallpaper_name"
    wallpaper="$prev_wallpaper"

    hyprctl hyprpaper preload "$wallpaper" > /dev/null
    hyprctl hyprpaper wallpaper ",$wallpaper" > /dev/null
elif [[ $1 == "picker" ]]; then
    wallpaper_name=$(ls -1 $WALLPAPERS | tofi)
    if [[ ! "$wallpaper_name" ]]; then
        exit 1
    fi
    wallpaper=$WALLPAPERS/"$wallpaper_name"
elif [[ $1 == "random" ]]; then
    wallpaper_name=$(ls -1 $WALLPAPERS | shuf | head -1)
    wallpaper=$WALLPAPERS/"$wallpaper_name"
else
    echo "usage: $0 init|picker|random"
    exit 1
fi

echo "$wallpaper" > $CACHE_FILE

if [[ "$wallpaper" != "$prev_wallpaper" ]]; then
    hyprctl hyprpaper preload "$wallpaper" > /dev/null
    hyprctl hyprpaper wallpaper ",$wallpaper" > /dev/null
    hyprctl hyprpaper unload "$prev_wallpaper" > /dev/null
fi

notify-send "Colors and wallpaper updated" "$wallpaper_name"
