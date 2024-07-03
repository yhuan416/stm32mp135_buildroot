if [[ "$(pidof rtk_hciattach)" != "" ]] 
then
    kill -9 $(pidof rtk_hciattach)
fi
echo 26 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio26/direction
echo 0 > /sys/class/gpio/gpio26/value
sleep 2
echo 1 > /sys/class/gpio/gpio26/value
rtk_hciattach -n -s 115200 /dev/ttySTM2 rtk_h5 > /tmp/.bluetooth.log 2>&1 &
sleep 4
result=$(cat /tmp/.bluetooth.log | grep "finished")
if test "$result" != ""
then
    rfkill unblock all
    echo "bluetooth init finished!"
else
    echo "bluetooth init error!"
fi
echo 26 > /sys/class/gpio/unexport
hciconfig hci0 up

