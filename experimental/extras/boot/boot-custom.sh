#!/bin/bash

AVOID_AUTO_RESTART_FLAG='/boot/noautorestart'

MAX_BOOT_TIME_SECONDS=40
SAMPLE_IMAGE_WIDTH=100
SAMPLE_IMAGE_HEIGHT=100
LOG_FILE="/tmp/boot-reboot.log"

log() {
  echo "$@"
  echo "$(date "+%F %H-%M-%S.%3N") [boot-custom] $@" >> "$LOG_FILE"
}

(
  log "Started" >> "$LOGFILE"

  sleep $MAX_BOOT_TIME_SECONDS

  export DISPLAY=:0
  RGB_FILE="/tmp/screen.rgb"
  rm -f "$RGB_FILE"

  log 'Capturing screenshot'

  ffmpeg -f x11grab -video_size ${SAMPLE_IMAGE_WIDTH}x${SAMPLE_IMAGE_HEIGHT} -i :0 -frames:v 1 \
         -f rawvideo -pix_fmt rgb24 "$RGB_FILE" -loglevel error

  if [ ! -f "$RGB_FILE" ]; then
    log 'ERROR: Screen could not be captured'
    exit 2
  fi

  log 'Screenshot captured'

  found_color=0
  while IFS= read -r -n3 -d '' pixel; do
    R=$(printf "%d" "'${pixel:0:1}")
    G=$(printf "%d" "'${pixel:1:1}")
    B=$(printf "%d" "'${pixel:2:1}")

    if ! { [ "$R" -eq 0 ] && [ "$G" -eq 0 ] && [ "$B" -eq 0 ]; } && # it's not a black pixel
       ! { [ "$R" -eq 255 ] && [ "$G" -eq 255 ] && [ "$B" -eq 255 ]; }; then # or a white pixel
      found_color=1
      log "Non B/W color detected: R=$R G=$G B=$B"
      break
    else
      log "Processed color: R=$R G=$G B=$B"
    fi
  done < "$RGB_FILE"

  if [ "$found_color" -eq 1 ]; then
    log 'Boot process ok!'
    exit 0
  else
    # if the file defined in AVOID_AUTO_RESTART_FLAG is found, auto-restarts will be inhibited
    if [ ! -f "$AVOID_AUTO_RESTART_FLAG" ]; then
      log "Boot was unsuccessful, restarting system (create a file in $AVOID_AUTO_RESTART_FLAG to avoid auto-restarting)"
      reboot
    else
      log "Boot was unsuccessful, but auto-restarting mechanism inhibited by the presence of $AVOID_AUTO_RESTART_FLAG file"
    fi
  fi
) &
