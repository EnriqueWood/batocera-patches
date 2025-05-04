#!/bin/bash
# Enable joystick user scripts
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-controller-connected-and-disconnected-script-hooks | bash

# Add script to suspend system on last controller disconnected
DEST="/userdata/system/configs/emulationstation/scripts/controller-disconnected/suspend-on-last-disconnected.sh"
URL="https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/extras$DEST"

mkdir -p "$(dirname "$DEST")"
wget -q -O "$DEST" "$URL"
chmod +x "$DEST"

# Add service
DEST="/userdata/system/services/suspend_after_last_controller_disconnected"
URL="https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/extras$DEST"
mkdir -p "$(dirname "$DEST")"
wget -q -O "$DEST" "$URL"
chmod +x "$DEST"
batocera-services enable suspend_after_last_controller_disconnected
