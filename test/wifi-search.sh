#!/bin/bash

WLAN=$(ls /sys/class/net | grep 'wlp\|wlan\|wifi' | head -1)

sudo echo "Monitoring over $WLAN ..."

while true; do
    i=$(cat /sys/class/net/$WLAN/carrier)
    if [ $i -ne 1 ]; then
        echo "Wi-Fi disconnected, searching ..."
        sudo killall wpa_supplicant
        sudo wpa_supplicant -i $WLAN -c wpa_supplicant.conf -B
        sudo dhclient $WLAN
        echo "Wi-Fi reconnected."
    fi
    sleep 1
done
