#!/bin/bash
## This script enables wake from suspension capabilities to every device (useful for bluetooth controllers)

cat <<EOF2 > /userdata/system/services/wake_on_bluetooth
#!/bin/bash

LOG_FILE="/userdata/system/logs/wake-on-bluetooth-service.log"

log() {
  echo "\$(date '+%Y-%m-%d %H:%M:%S') \$@" >> "\$LOG_FILE"
}

start() {
  cat <<EOF1 > /etc/pm/sleep.d/99enable_wake_on_bluetooth
#!/bin/bash
for dev in /sys/class/bluetooth/*; do
  [[ -f /sys/bus/usb/devices/\\\$(readlink -f "\\\$dev" | grep -Po "(?<=usb\d/)[^/]+")/power/wakeup ]] && echo 'enabled' > "/sys/bus/usb/devices/\\\$(readlink -f "\\\$dev" | grep -Po "(?<=usb\d/)[^/]+")/power/wakeup"
done
EOF1
  chmod +x /etc/pm/sleep.d/99enable_wake_on_bluetooth
  batocera-save-overlay
  /etc/pm/sleep.d/99enable_wake_on_bluetooth && log "wake on bluetooth enabled"
}

stop() {
  for dev in /sys/class/bluetooth/*; do
      [[ -f "/sys/bus/usb/devices/\$(readlink -f "\$dev" | grep -Po "(?<=usb\d/)[^/]+")/power/wakeup" ]] && echo 'disabled' > "/sys/bus/usb/devices/\$(readlink -f "\$dev" | grep -Po "(?<=usb\d/)[^/]+")/power/wakeup"
  done
  rm /etc/pm/sleep.d/99enable_wake_on_bluetooth
  batocera-save-overlay
  log "wake on bluetooth disabled"
}

check_enabled() {
  local all_enabled=true

  for dev in /sys/class/bluetooth/*; do
    wakeup_file="/sys/bus/usb/devices/\$(readlink -f "\$dev" | grep -Po "(?<=usb\d/)[^/]+")/power/wakeup"
    if [[ -f "\$wakeup_file" ]] && ! grep -q '^enabled\$' "\$wakeup_file"; then
      if ! grep -q '^enabled$' "\$wakeup_file"; then
        log "Device \$wakeup_file is NOT enabled for wakeup."
        all_enabled=false
      fi
    fi
  done

  if [[ "\$all_enabled" == true ]]; then
    echo 'Wake on bluetooth service is running'
    return 0
  else
    echo "Wake on bluetooth service is not running"
    return 1
  fi
}

case "\$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        check_enabled
        ;;
    *)
        echo "Usage: \$0 {start|stop}"
        exit 1
        ;;
esac
EOF2
chmod +x /userdata/system/services/wake_on_bluetooth
batocera-services start wake_on_bluetooth