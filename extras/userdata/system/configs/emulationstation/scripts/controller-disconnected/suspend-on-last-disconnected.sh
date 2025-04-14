#!/bin/bash
SERVICE_NAME=suspend_after_last_controller_disconnected
LOG_FILE="/userdata/system/logs/service-$SERVICE_NAME.log"

log() {
  echo "$@"
  echo "$(date "+%F %H-%M-%S.%3N") $@" >> "$LOG_FILE"
}

if [[ "$(batocera-services list | grep -Po "(?<=${SERVICE_NAME};)[*-]")" != '*' ]]; then
  log "$SERVICE_NAME is not running, not evaluating possible suspension"
  exit 0
fi

# Suspend system if this was the only one controller connected
count=0
for js in /dev/input/js*; do
  [[ -e "$js" ]] || continue
  if udevadm info --query=env --name="$js" | grep -q "ID_INPUT_JOYSTICK=1"; then
    count=$((count + 1))
  fi
done

log "Controller disconnected, new controller count is now $count"

if [[ $count -eq 0 ]]; then
  log "Last controller disconnected, suspending system"
  pm-suspend
fi

