#!/bin/bash

WALLPAPERS=$HOME/.wallpapers
CONFIG_FILE=$HOME/.config/hypr/hyprpaper.conf

if [ ! -f $CONFIG_FILE ] ;then
    touch $CONFIG_FILE
    echo "preload = $WALLPAPERS/default.jpg" > $CONFIG_FILE
    echo "wallpaper = ,$WALLPAPERS/default.jpg" >> $CONFIG_FILE
fi

if [[ $1 == "init" ]]; then
    exit 0
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

echo "preload = $wallpaper" > $CONFIG_FILE
echo "wallpaper = ,$wallpaper" >> $CONFIG_FILE

hyprctl hyprpaper unload all > /dev/null
hyprctl hyprpaper preload "$wallpaper" > /dev/null
hyprctl hyprpaper wallpaper ",$wallpaper" > /dev/null

notify-send "Colors and wallpaper updated" "$wallpaper_name"
