# batocera-patches

This repo is to test new ideas or patch functionalities in Batocera.

Everything here is tested in v41 stable, but should work in butterfly/beta and lower versions as well

---
## Wake on bluetooth functionality

This allows you to wake up your console from sleep/suspension by turning on your bluetooth controller.

To enable this functionality in your system, just run on f1/xterm or via ssh to your Batocera machine the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/enable-wake-on-bluetooth | bash
```

This will create a service in `Main Menu -> System Settings -> Services -> WAKE_ON_BLUETOOTH`, where you can toggle it on or off. 

> 💡 Your system must be in Suspend Mode (Main Menu -> Quit -> Suspend System) to be woken up. 
> ⚠️ Power-off won't work.

#### The service is enabled by default.

✅ Tested with Ps4, Ps5 (DualSense) and Xbox One controllers.

Note: To be able to wake your system, it has to be in Suspension mode `Main Menu -> Quit -> Suspend System` instead of powered off.

---

## Hooks for suspend and resume events (Already merged in Batocera v42+)

Enable hooks for custom scripts located in:

* `/userdata/system/configs/emulationstation/scripts/suspend`

* `/userdata/system/configs/emulationstation/scripts/resume`

> Scripts must be executable to be triggered.


Install with:

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/enable-suspend-resume-user-script-hooks | bash
```

This hook is very useful to do something like calling a wakeonlan/poweroff service from your home assistant to turn on or off your TV, making the experience more console-like.

> ⚠️ These hooks do not receive any arguments.

---

## Hooks for joystick added or removed

Enable user scripts when a controller is connected or disconnected:

* `/userdata/system/configs/emulationstation/scripts/controller-connected`

* `/userdata/system/configs/emulationstation/scripts/controller-disconnected`

Scripts **must** be executable.

Install with:

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/enable-controller-connected-and-disconnected-script-hooks | bash
```

---

## Suspend system when last controller disconnects

Automatically suspends the system when the last connected controller is turned off or disconnected.


Install with:

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/suspend-system-on-last-controller-disconnected | bash
```

This functionality will be enabled by default, you can disable it under Main Menu -> System Settings -> Services -> suspend_after_last_controller_disconnected

Enabled by default.

You can disable it in: `Main Menu -> System Settings -> Services -> suspend_after_last_controller_disconnected`

---

## Add Failsafe mechanism

This will automatically restart your system if EmulationStation fails to start within 50 seconds of boot.

Helpful when the boot process hangs or crashes, leaving the screen stuck or showing only logs.

⚠️ Warning: This patch is not recommended if you're debugging, as it can cause automatic reboots.

To enable it, run this script in F1/xterm or via SSH:
```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/enable-failsafe | bash
```

## Prevent automatic reboots
To temporarily disable the failsafe auto-reboot behavior, create an empty file named `noautorestart` inside the `/userdata` folder.

### Option 1: Using another computer
If you remove the Batocera USB or drive and connect it to another machine, create an empty file named  `noautorestart`  in the root of the SHARE partition:


### Option 2: Using SSH

If Batocera is reachable over SSH, you can run:

```bash
touch noautorestart && scp noautorestart root@batocera:/userdata/noautorestart && rm noautorestart
```

Once this file exists, the system will no longer reboot automatically on failed boots.

To re-enable the failsafe, simply delete the file via Batocera's file manager or via ssh:

```bash
ssh root@batocera rm /userdata/noautorestart
```

---

## Turn off Bluetooth controllers with a double-tap

This patch allows you to quickly power off your Bluetooth controller by double-tapping the power button, without needing to navigate any menu.

Install it with:

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/quick-power-off-bt-controller | bash
```

Once installed, you’ll find the service in
`Main Menu -> System Settings -> Services -> DOUBLE_TAP_TURNOFF`

✅ Compatible with PS4, PS5 (DualSense), and most generic Bluetooth controllers.
❌ Not compatible with Xbox One controllers — they automatically reconnect right after being powered off, making this feature ineffective.

The service is enabled by default. You can disable it anytime from the Services menu.


⚠️i WARNING: The system will automatically reboot once after installation to apply the changes.


---

## Install/Update all patches at once

If you want to install or update all available patches in one step, you can use the all installer script. 

This includes:

* Wake on Bluetooth
* Suspend/Resume hooks
* Controller connect/disconnect hooks
* Suspend on last controller disconnect 
* Failsafe boot mechanism

Run this command via SSH/Xterm or in Batocera's file manager (F1):

```bash
curl -fsSL https://raw.githubusercontent.com/EnriqueWood/batocera-patches/main/all | bash
```
### Your feedback is always welcome.
