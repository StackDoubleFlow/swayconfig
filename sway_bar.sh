#!/usr/bin/env bash

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | grep -E "state" | awk '{print $2}')

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='⚠'
else
    battery_pluggedin='⚡'
fi

# Audio and multimedia
audio_volume=$(pamixer --get-volume)
audio_is_muted=$(pamixer  --get-mute)
media_artist=$(playerctl metadata artist)
media_song=$(playerctl metadata title)
player_status=$(playerctl status)

if [ $player_status = "Playing" ]
then
    song_status='▶'
elif [ $player_status = "Paused" ]
then
    song_status='⏸'
else
    song_status='⏹'
fi

if [ $audio_is_muted = "true" ]
then
    audio_active='🔇'
else
    audio_active='🔊'
fi

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
# interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
# ping=$(ping -c 1 www.google.es | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

date_and_time=$(date +'%Y-%m-%d %I:%M:%S %p')

echo "$network_active $interface_easyname | $audio_active $audio_volume% | $battery_pluggedin $battery_charge | $date_and_time"
