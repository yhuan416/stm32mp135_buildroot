#!/bin/sh

echo "---------出厂部分硬件测试---------"
echo "开始测试"
echo "音频测试开始"
echo "请不要打开音乐应用，否则音频被占用"
echo "请观察喇叭是否有声音..."
/root/shell/bluetooth/atk-bluetooth-init.sh &
gst-play-1.0 /opt/qtapp/src/audio/0.mp3  > /dev/null &

echo 1 > /sys/class/leds/beep/brightness
sleep 1
echo 0 > /sys/class/leds/beep/brightness
echo "Result 音频请听喇叭有没有声音"
echo "Result 蜂鸣器听蜂鸣器是否鸣叫"
echo "Result 按键测试请手动按下按键，按下会打印"
echo "WIFI 测试开始"
ifconfig wlan0 down
ifconfig wlan0 up
if [ $? -ne 0 ]; then
    wifi="WIFI is failed"
else
    wifi="WIFI is ok"
fi
echo "Result $wifi"
sleep 2
connmanctl enable wifi
connmanctl scan wifi
connmanctl services
echo "WIFI 测试结束"

echo "蓝牙开始测试"
sleep 2
hciconfig hci0 up
if [ $? -ne 0 ]; then
    bluetooth="bluetooth is failed"
else
    bluetooth="bluetooth is ok"
fi
echo "Result $bluetooth"
hciconfig hci0 -a
echo "蓝牙结束测试"
echo "PCF8563RTC硬件时钟测试,请观察硬件时钟是否被设置为2023-1-1 00:00:00"
date -s "2023-1-1 00:00:00" > /dev/null
hwclock -w
echo "硬件时钟的时间为："
hwclock
if [ $? -ne 0 ]; then
    pcf8563="pcf8563 is failed"
else
    pcf8563="pcf8563 is ok"
fi
echo "Result $pcf8563"
echo "PCF8563RTC硬件时钟测试结束"
sleep 1
eeprom-rw
if [ $? -ne 0 ]; then
    eeprom="eeprom is failed"
else
    eeprom="eeprom is ok"
fi
echo "Result $eeprom"
ip link set can0 up type can bitrate 1000000  loopback on
canbusutil -c socketcan can0 1#1a2b3c
if [ $? -ne 0 ]; then
    can0="can0 is failed"
else
    can0="can0 is ok"
fi
echo "Result $can0"

ip link set can1 up type can bitrate 1000000  loopback on
canbusutil -c socketcan can1 1#1a2b3c
if [ $? -ne 0 ]; then
    can1="can1 is failed"
else
    can1="can1 is ok"
fi
echo "Result $can1"

if [ ! -e "/dev/mtd0" ]; then
    spiflash="spiflash is failed"
else
    spiflash="spiflash is ok"
fi
echo "Result $spiflash"

echo "网络一测试开始，请插网线，并且能联网，否则测试不通过"
ping www.baidu.com -I eth0 -c 5 -i 0.5
if [ $? -ne 0 ]; then
    eth0="eth0 is failed"
else
    eth0="eth0 is ok"
fi
echo "Result $eth0"

echo "网络二测试开始，请插网线，并且能联网，否则测试不通过"
ping www.baidu.com -I eth1 -c 5 -i 0.5
if [ $? -ne 0 ]; then
    eth1="eth1 is failed"
else
    eth1="eth1 is ok"
fi
echo "Result $eth1"
echo "网络测试结束"

killall gst-play-1.0 &
echo "音频结束测试"

echo "----------------------------------"
echo "测试结果参考"
echo "音频请聆听喇叭是否有声音"
echo $wifi
echo $eth0
echo $eth1
echo $bluetooth
echo $pcf8563
echo $eeprom
echo $can0
echo $can1
sleep 1
echo "----------------------------------"
sleep 1
echo ""
echo ""
echo ""


