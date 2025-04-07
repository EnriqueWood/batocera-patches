#!/bin/bash
## Add hooks for all user-defined scripts located in /userdata/system/configs/emulationstation/scripts/suspend and /userdata/system/configs/emulationstation/resume directories upon system suspend and resume (wake-up from suspension) events

mount -o remount,rw /boot
cat <<EOF >> /etc/pm/sleep.d/99user_scripts_runner
#!/bin/bash
## Execute all user-defined scripts located in the EmulationStation sleep and wake directories upon system suspend and resume events

SCRIPTS_BASE_PATH=/userdata/system/configs/emulationstation/scripts
case "\$1" in
    suspend)
        for script in \$SCRIPTS_BASE_PATH/suspend/*; do
            /bin/bash \$script;
        done	       
    ;;
    resume|thaw)
        for script in \$SCRIPTS_BASE_PATH/resume/*; do
            /bin/bash \$script;
        done	       
    ;;
esac
EOF
chmod +x /etc/pm/sleep.d/99user_scripts_runner
batocera-save-overlay
