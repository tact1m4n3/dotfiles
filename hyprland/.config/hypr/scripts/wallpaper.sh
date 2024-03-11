#!/bin/bash

WALLPAPERS=$HOME/.wallpapers
CACHE_FILE=$HOME/.cache/current_wallpaper

if [[ $1 == "init" ]]; then
    if [ ! -f $cache_file ] ;then
        touch $CACHE_FILE
        echo $WALLPAPERS/default.jpg > $CACHE_FILE
    fi
    wallpaper=$(cat $CACHE_FILE)
    wallpaper_name=$(echo "$wallpaper" | sed "s|$WALLPAPERS/||g")
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

swww img "$wallpaper" \
    --transition-bezier=.33,1,.68,1 \
    --transition-duration=3 \
    --transition-fps=60 \
    --transition-type="wipe" \
    --transition-angle=60

notify-send "Colors and wallpaper updated" "$wallpaper_name"
