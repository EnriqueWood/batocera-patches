#!/bin/bash

#Only execute this in the boot, not in the shutdown
[[ "$1" != "start" ]] && exit 0

AVOID_AUTO_RESTART_FLAG='/userdata/noautorestart'
SAMPLE_IMAGE_WIDTH=10
SAMPLE_IMAGE_HEIGHT=10
LOG_FILE="/tmp/boot-failsafe.log"
START_BOOT_CHECK_TIME=50
MAX_BOOT_TIME=180
INTERVAL_SLEEP_TIME=10
START_TIME=$(date +%s)
RGB_FILE="/tmp/screen.rgb"
export DISPLAY=:0

log() {
  local now=$(date +%s)
  local elapsed=$((now - START_TIME))
  echo "[${elapsed}s] $@"
  echo "$(date "+%F %H-%M-%S.%3N") [${elapsed}s] [boot-custom] $@" >> "${LOG_FILE}"
}

screenshot() {
  rm -f "$RGB_FILE"
  timeout --signal=SIGTERM --kill-after=1s 2s ffmpeg -f x11grab -video_size ${SAMPLE_IMAGE_WIDTH}x${SAMPLE_IMAGE_HEIGHT} -i $DISPLAY -frames:v 1 \
             -f rawvideo -pix_fmt rgb24 "$RGB_FILE" -loglevel error >> "$LOG_FILE" 2>&1
}

(
  log "/boot/boot-custom.sh execution started"

  sleep $START_BOOT_CHECK_TIME

  for ((t=$START_BOOT_CHECK_TIME; t<=$MAX_BOOT_TIME; t+=$INTERVAL_SLEEP_TIME)); do
    rm -f "$RGB_FILE"
    sleep $INTERVAL_SLEEP_TIME

    log "Attempting new screenshot with DISPLAY=:0"
    screenshot

    if [ ! -f "$RGB_FILE" ]; then
      log "ERROR: Screenshot could not be captured, attempting with DISPLAY=:0.0"
      export DISPLAY=:0.0
      screenshot
      if [ ! -f "$RGB_FILE" ]; then
        sleep 2
        log "ERROR: Screenshot could not be captured with DISPLAY=:0.0"
        continue
      fi
    fi

    log "Screenshot captured"

    found_color=0
    while IFS= read -r -n3 -d '' pixel; do
      R=$(printf "%d" "'${pixel:0:1}")
      G=$(printf "%d" "'${pixel:1:1}")
      B=$(printf "%d" "'${pixel:2:1}")

      if ! { [ "$R" -eq 0 ] && [ "$G" -eq 0 ] && [ "$B" -eq 0 ]; } &&
         ! { [ "$R" -eq 255 ] && [ "$G" -eq 255 ] && [ "$B" -eq 255 ]; }; then
        found_color=1
        log "Colored pixel detected: R=$R G=$G B=$B"
        break
      fi
    done < "$RGB_FILE"

    if [ "$found_color" -eq 1 ]; then
      log "Boot process successful. Exiting failsafe check."
      exit 0
    else
      log "No color detected, continuing checks..."
    fi
  done

  if [ ! -f "$AVOID_AUTO_RESTART_FLAG" ]; then
    log "Boot was unsuccessful, restarting system (create $AVOID_AUTO_RESTART_FLAG to avoid auto-restart)"
    cp "$LOG_FILE" "/userdata/system/logs/boot-failsafe-$(date "+%F_%H-%M-%S.%3N").log"
    reboot
  else
    log "Boot was unsuccessful, but auto-restart inhibited by presence of $AVOID_AUTO_RESTART_FLAG"
  fi
) &
