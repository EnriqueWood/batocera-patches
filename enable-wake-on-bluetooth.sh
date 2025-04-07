#!/bin/bash

# This script enables wake from suspension capabilities to every device (useful for bluetooth controllers)

mount -o remount,rw /boot
cat <<EOF >> /boot/postshare.sh
#!/bin/bash
for d in /sys/bus/usb/devices/*/power/wakeup; do
  echo 'enabled' > "\$d"
done
EOF

