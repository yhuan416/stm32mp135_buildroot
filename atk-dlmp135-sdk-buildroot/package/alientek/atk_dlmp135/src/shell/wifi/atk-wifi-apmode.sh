if [[ "$(pidof dnsmasq)" != "" ]]
then
    kill -9 $(pidof dnsmasq)
fi

if [[ "$(pidof hostapd)" != "" ]]
then
    kill -9 $(pidof hostapd)
fi
connmanctl disable wifi
rfkill unblock all
ifconfig wlan0 down
sleep 1
ifconfig wlan0 up
sleep 1
dnsmasq -C dnsmasq.conf
ifconfig wlan0 192.168.1.3
hostapd hostapd.conf -B

