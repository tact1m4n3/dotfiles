#!/bin/bash

option=$(echo "Lock
Suspend
Shutdown
Reboot
" | tofi)

if [[ "$option" == "Lock" ]]; then
    sleep 0.5 && loginctl lock-session
elif [[ "$option" == "Suspend" ]]; then
    systemctl suspend
elif [[ "$option" == "Shutdown" ]]; then
    systemctl poweroff
elif [[ "$option" == "Reboot" ]]; then
    systemctl reboot
fi
