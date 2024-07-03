export LANG=en_US.UTF-8
export LS_OPTIONS='--color=auto'
# Useful aliases
alias ls='ls $LS_OPTIONS -h'
alias ll='ls $LS_OPTIONS -lhF'
alias l='ls $LS_OPTIONS -lAhF'
#audio
/usr/sbin/alsactl -f /var/lib/alsa/asound.state restore  >/dev/null 2>&1
export HOME=/root
export DBUS_SESSION_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"
