#!/bin/bash
DEST="/boot/boot-custom.sh"
URL="https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/experimental/extras$DEST"

mount -o remount,rw /boot
wget -q -O "$DEST" "$URL"