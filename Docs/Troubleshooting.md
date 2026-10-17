# Troubleshooting

| Symptom | What to check or try | Details |
|---|---|---|
| Shutdown/restart stops after launchd quiesce completed | Make sure SSDT-PMC is enabled. | [ACPI](ACPI-and-Patches.md) |
| Display image exists but the backlight is off | Check the root SSDT-PNLF, PNLF-to-XNLF rename and backlight boot arguments. | [Configuration](Configuration.md) |
| Keyboard backlight does not work | Check AsusSMC, SSDT-ASUS-SMC-NATIVE and its four DSDT definition renames. | [ASUS wrapper](ACPI-and-Patches.md#asus-keyboard-backlight) |
| Trackpad is listed but gives no input | Check the Goodix I2C/HID stack and OEM I2C1/ETPD path. Fn+F6 toggles the trackpad. | [Hardware](Hardware.md) |
| No audio devices | Check VoodooHDA_BL and its A348 personality edits. | [Dependencies](Dependencies.md) |
| Wi-Fi or Bluetooth causes a boot regression | Restore the last working EFI, then compare the exact Tahoe Wi-Fi and paired Bluetooth builds. | [Dependencies](Dependencies.md) |
| Location/time-zone detection is unavailable | Check AirportItlwm attachment and macOS location permissions. | [Compatibility](Compatibility.md) |
| SD reader detects a card but cannot initialize it | Check the A375 personality, matching properties and native AppleSDXC block. | [SD workaround](ACPI-and-Patches.md#sd-controller-workaround) |
| SD remains mounted after removal following sleep | Check the CtlnaSDXC 1.9.0 PCI save/restore patch and IOPMPCIConfigSpaceVolatile property. | [SD workaround](ACPI-and-Patches.md#sd-controller-workaround) |
| OpenCanopy falls back to text | Check version-matched OpenCanopy, images, fonts and labels, including FirmwareSettings and NetworkBoot. | [Resources](Dependencies.md#opencanopy-resources) |
| An extra EFI Boot entry opens OpenCore again | Optionally add the documented `.contentVisibility` markers. | [Configuration](Configuration.md#optional-hide-opencores-own-picker-entries) |
| Resume shows an old frozen image or reopens apps after a fresh boot | Reopened apps after a fresh boot do not prove image resume worked. Check the memory reservation. | [Hibernation](Hibernation.md) |
| Normal sleep works but never transitions to hibernation | Having the kext enabled is not enough: check `hbfx-ahbm=1` and native standby settings. | [Hibernation](Hibernation.md) |
| Immediate wake after S4 on AC with a USB mouse | Check the shared-GPE S4 wake patch and whether the wake was a scheduled RTC event. | [Hibernation](Hibernation.md) |
| Windows time shifts after macOS use | Use the documented shared UTC-clock settings. | [Firmware](Firmware.md) |

## Missing macOS installer or system entry

Check the target's APFS container and Preboot state in Recovery before altering partitions. Installation stages use different boot entries. Windows starting between installation stages does not itself erase an APFS volume.

## Reading boot logs

- This firmware reports MAT support 0. See [Configuration](Configuration.md) for its memory quirks.
- Messages about optional protocols, missing optional NVRAM variables and successful patch fallbacks can be normal.
- A log ending at EXITBS does not show a later kernel failure. Collect panic or verbose output for that stage.
- For delayed idle sleep, check active power assertions after downloads and audio sessions finish.
- Share minimal redacted excerpts. Complete system reports can reveal device names, network details and unique identifiers.

## Hibernation diagnosis

First identify the symptom: frozen image resume, no sleep-to-hibernation transition, or an unwanted wake after S4. Application reopening after a fresh boot is not proof of successful image resume. Check active assertions and scheduled wakes with `pmset -g assertions` and `pmset -g sched`; see [Hibernation](Hibernation.md) for the documented configuration.
