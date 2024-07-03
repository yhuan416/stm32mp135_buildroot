#!/bin/sh

ls /var/lib/connman/wifi_*/settings > /dev/null 2>&1 &
if [ $? -ne 0 ]; then
    echo "You do not need to disconnect wifi"
    exit 0
else
    echo ""
fi

for modules in `ls /var/lib/connman/wifi_*/settings`; do
if [[ "$1" == "false" ]]
then
    echo "Auto connection is not allowed"
    sed -i "s/AutoConnect=true/AutoConnect=false/g" $modules
else
    echo "Auto connection is allowed"
    sed -i "s/AutoConnect=false/AutoConnect=true/g" $modules
fi

done
