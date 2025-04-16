#!/bin/bash
DEST="/etc/udev/rules.d/99joystick_events.rules"
URL="https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/extras$DEST"

mkdir -p "$(dirname "$DEST")"
wget -q -O "$DEST" "$URL"
batocera-save-overlay
udevadm control --reload-rules
udevadm trigger
