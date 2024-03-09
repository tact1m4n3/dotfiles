#!/bin/bash

set -e
set -o pipefail

if [[ $1 == "all" ]]; then
    grim -t png - | wl-copy -t image/png
elif [[ $1 == "screen" ]]; then
    grim -g "$(slurp -o)" -t png - | wl-copy -t image/png
elif [[ $1 == "rect" ]]; then
    grim -g "$(slurp)" -t png - | wl-copy -t image/png
else
    echo "usage: $0 all|screen|rect"
    exit 1
fi

notify-send "Screenshot taken" "Saved to clipboard"
