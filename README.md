## How to use

For instance if you like to build variant `licheepizero-dock`, you can start with the following bash script:

```bash
export TEMPLATECONF=$PWD/sources/meta-chai/conf/variant/licheepizero-dock
source sources/poky/oe-init-build-env build

bitbake chai-image
```

## how to use zero-dock mic

First of all, the v3s audio coded has no MIC1 bias. Instead, it looks to me like an differential input. I was able to get the mic working by changing the MIC setting from single ended to Left/Right within `alsamixer`.

![ALSA settings](./docu/assets/alsa-settings.png)

For easy verification, use the _chai-audio-image_ with the alsa-tools. Just plugin your headphone, setup ALSA like the picture above and run `alsaloop` and verify the microphone 😎️

## shutdown / reboot

The Zero and Zero-Dock uses an __EA3036__ PMIC with routed __enable__ pins to 5V. As a result, the power consumption will not drop to _zero_ on a `shutdown`. A possible workaround could be using a pin to drive a _self-holding circuit_.  
`reboot` instead works as expected.
