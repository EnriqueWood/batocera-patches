#!/bin/bash

START_TIME=$(date +%s)
LOG_FILE="/tmp/boot-failsafe.log"
AVOID_AUTO_RESTART_FLAG='/userdata/noautorestart'
REBOOT_COUNT_FILE="/userdata/system/boot-failsafe-reboot-count"
REBOOT_LIMIT=10
MAX_BOOT_TIME=50
ES_READY_FILE=/tmp/emulationstation.ready
rm $ES_READY_FILE

mkdir -p /userdata/system/logs
# remove old logs
LOGS=(/userdata/system/logs/boot-failsafe-*.log)
if [ -e "${LOGS[0]}" ]; then
  ls -t "${LOGS[@]}" | tail -n +2 | xargs rm -f
fi

log() {
  local now=$(date +%s)
  local elapsed=$((now - START_TIME))
  echo "[${elapsed}s] $@"
  echo "$(date "+%F %H-%M-%S.%3N") [${elapsed}s] [boot-custom] $@" >> "${LOG_FILE}"
}

# Get a count of consecutive automatic reboots
count=0
if [ -f "$REBOOT_COUNT_FILE" ]; then
  value=$(cat "$REBOOT_COUNT_FILE")
  if [[ "$value" =~ ^[0-9]+$ ]]; then
    count=$value
  else
    log "Invalid reboot count found ('$value'), resetting to 0"
    rm -f "$REBOOT_COUNT_FILE"
  fi
fi

# If system has rebooted more than limit, do not reboot anymore
if [ "$count" -ge "$REBOOT_LIMIT" ]; then
  log "Reboot limit ($REBOOT_LIMIT) reached, system will NOT reboot anymore."
  exit 1
fi

if [ -f "$AVOID_AUTO_RESTART_FLAG" ]; then
  log "Boot failsafe inhibited by the presence of $AVOID_AUTO_RESTART_FLAG file"
  exit 0
fi

log "/boot/boot-custom.sh execution started"

(
  while [ ! -f "$ES_READY_FILE" ]; do
    sleep 1

    now_seconds=$(date +%s)
    elapsed=$((now_seconds - START_TIME))

    if [ "$elapsed" -gt "$MAX_BOOT_TIME" ]; then
      log "Boot was unsuccessful, restarting system (create $AVOID_AUTO_RESTART_FLAG to avoid auto-restart)"
      new_log_file="/userdata/system/logs/boot-failsafe-$(date "+%F_%H-%M-%S.%3N").log"
      count=$((count + 1))
      echo "$count" > "$REBOOT_COUNT_FILE"
      log "Reboot attempt #$count"
      cp "$LOG_FILE" "$new_log_file"
      reboot &

      sleep 10

      log "System did not reboot in time, forcing reboot now..."
      cp "$LOG_FILE" "$new_log_file"
      reboot -f
    fi
  done

  log "$ES_READY_FILE appeared $elapsed seconds after booting"
  rm -f "$REBOOT_COUNT_FILE"
  exit 0
) &
