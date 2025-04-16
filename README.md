# batocera-patches

This repo is to test new ideas or patch functionalities in batocera.

Everything here is tested in v41 stable, but should work in butterfly/beta and lower versions as well

---
## Wake on bluetooth functionality

This allows you to wake up your console from sleep/suspension by turning on your bluetooth controller.

To enable this functionality in your system, just run on f1/xterm or via ssh to your batocera machine the following command:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-wake-on-bluetooth.sh | bash
```

This will create a service in `Main Menu -> System Settings -> Services -> WAKE_ON_BLUETOOTH`, where you can toggle it on or off. 

#### The service is enabled by default.

✔️ Tested with Ps4, Ps5 (DualSense) and Xbox One controllers.

Note: To be able to wake your system, it has to be in Suspension mode `Main Menu -> Quit -> Suspend System` instead of powered off.

---

## Hooks for suspend and resume events (this patch is already included in the official repo for Batocera v42)

Enable hooks for scripts placed in /userdata/system/configs/emulationstation/scripts/suspend and /userdata/system/configs/emu
lationstation/scripts/resume, the scripts must be executable (execution bit should be set for them to be triggered)

Enable this functionality by running:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-suspend-resume-user-script-hooks.sh | bash
```

This hook is very useful to do something like calling a wakeonlan/poweroff service from your home assistant to turn on or off your TV, making the experience more console-like.

Note: these hooks pass no arguments to the scripts

---

## Hooks for joystick added or removed

Enable hooks for scripts placed in /userdata/system/configs/emulationstation/scripts/controller-connected and /userdata/system/configs/emulationstation/scripts/controller-disconnected, the scripts must be executable (execution bit should be set for them to be triggered)

Enable this functionality by running:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-controller-connected-and-disconnected-script-hooks.sh | bash
```

---

## Suspend system after last connected joystick is disconnected/turned off

To get the functionality, run this script in F1/xterm or via ssh:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/suspend-system-on-last-controller-disconnected.sh | bash
```

This functionality will be enabled by default, you can disable it under Main Menu -> System Settings -> Services -> suspend_after_last_controller_disconnected
---


## Add Failsafe mechanism

This will restart your system if it is not showing any colors in the screen after 40 seconds of boot.
Helpful when the boot process fails and you are left with a black screen of with a terminal full infinite logs.

> Warning: This patch is not recommended as it can cause boot loop issues.

To get the functionality, run this script in F1/xterm or via ssh:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-failsafe.sh | bash
```
---

## NOTE: 

The -O- part in the wget command is **the vowel O in uppercase**, it's not a zero or a lowercase o.

### Your feedback is always welcomed.
