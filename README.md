# batocera-patches

This repo is to test new ideas or patch functionalities in batocera.

Everything here is tested in v41 stable, but should work in butterfly/beta and lower versions as well

## Wake on bluetooth functionality

You can test the wake on bluetooth functionality by running on f1/xterm or via ssh to your batocera machine the following command:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-wake-on-bluetooth.sh | bash
```

This will create a service in `Main Menu -> System Settings -> Services -> WAKE_ON_BLUETOOTH`, where you can toggle it on or off. 

The service is enabled by default

✔️ Tested with Ps4, Ps5 (DualSense) and Xbox One controllers.

To be able to wake your system, it has to be in Suspension mode `Main Menu -> Quit -> Suspend System` instead of powered off.

## Hooks for suspend and resume events

You can test the wake on bluetooth functionality by running on f1/xterm or via ssh to your batocera machine the following command:

```bash
wget -O- https://raw.githubusercontent.com/EnriqueWood/batocera-patches/refs/heads/main/enable-suspend-resume-user-script-hooks.sh bash
```

This hook is very useful to do something like calling a wakeonlan/poweroff service from your home assistant to turn on or off your TV, making the experience more console-like.


## NOTE: 

The -O- part in the wget command is **the vowel O in uppercase**, it's not a zero or a lowercase o.

### Your feedback is always welcomed.
