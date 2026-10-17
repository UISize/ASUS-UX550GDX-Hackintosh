# Compatibility

Results below apply to the test hardware and versions listed in [Hardware](Hardware.md) and the README.

## Working

| Feature | Tested behavior |
|---|---|
| Boot and dual boot | macOS starts through OpenCore; Windows remains bootable |
| Restart and shutdown | Both work with SSDT-PMC enabled |
| Intel UHD 630 | Metal 3 reported; acceleration and practical 3D operation tested |
| Internal display | Image, backlight and manual brightness control work |
| Keyboard backlight | Four-state brightness cycle works |
| Trackpad | Pointer input, gestures and Fn+F6 enable/disable work |
| Audio | Speakers, headphones and microphone work |
| Apple Music | Lossless playback tested with unfairgva=4 |
| Wi-Fi | Native network selection, location services and automatic time zone work with AirportItlwm d695c97 |
| Bluetooth headphones | Pairing, music playback and operation after normal sleep/wake and shutdown/startup confirmed |
| Sleep and lid | Normal sleep, wake and lid behavior work; transition to sleep can take a short time |
| Hibernation | Direct and automatic sleep-to-hibernate resume work. Normal S3 mouse wake still works after the S4 wake fix; see [Hibernation](Hibernation.md) for tests and settings |
| SD reader | Reading, ejecting and reinserting work, including after sleep, with the documented CtlnaSDXC patch |
| Webcam and battery | Camera output and battery indication work |
| Right-hand USB-A | USB 2 and USB 3 devices work in macOS |

AirPlay Screen Mirroring from an iPhone to the macOS display works, using Screen Mirroring in the iPhone Control Center. AirDrop remains unsupported by the selected Wi-Fi fork.

## Limited or unsupported

| Feature | Limitation |
|---|---|
| Left-hand USB-C | Not tested (no USB 3 device available for these ports). The included map enables USB 2 only on USB-C. |
| GTX 1050 | No Tahoe acceleration support |
| HDMI and ScreenPad display | Routed through unsupported NVIDIA graphics in this configuration |
| AirDrop | No support in the selected Intel Wi-Fi fork |

## Untested

- USB Ethernet adapters, including use in Recovery
- USB-C SuperSpeed
- Thunderbolt
- USB-C display output
- FileVault
- Apple Watch unlock
- General DRM beyond the stated playback test
- Hardware codecs beyond the stated playback test

The installed system reports SIP enabled. Supply your own SMBIOS identifiers before use; see [Installation](Installation.md).
